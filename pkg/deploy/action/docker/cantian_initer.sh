#!/bin/bash
set +x
CURRENT_PATH=$(dirname $(readlink -f $0))
SCRIPT_PATH=${CURRENT_PATH}/..
PKG_PATH=${CURRENT_PATH}/../..
CONFIG_PATH=${CURRENT_PATH}/../../config
OPT_CONFIG_PATH="/opt/cantian/config"
INIT_CONFIG_PATH=${CONFIG_PATH}/container_conf/init_conf
DORADO_CONFIG_PATH=${CONFIG_PATH}/container_conf/dorado_conf
KMC_CONFIG_PATH=${CONFIG_PATH}/container_conf/kmc_conf
CERT_CONFIG_PATH=${CONFIG_PATH}/container_conf/cert_conf
CERT_PASS="certPass"
CONFIG_NAME="deploy_param.json"
START_STATUS_NAME="start_status.json"
MOUNT_FILE="mount.sh"
VERSION_FILE="versions.yml"
PRE_INSTALL_PY_PATH=${CURRENT_PATH}/../pre_install.py
WAIT_TIMES=100
LOGICREP_HOME='/opt/software/tools/logicrep'
USER_FILE="${LOGICREP_HOME}/create_user.json"

source ${CURRENT_PATH}/../log4sh.sh

cp -rf ${INIT_CONFIG_PATH}/${CONFIG_NAME} ${CONFIG_PATH}/${CONFIG_NAME}
cp -rf ${INIT_CONFIG_PATH}/${CONFIG_NAME} ${OPT_CONFIG_PATH}/${CONFIG_NAME}

ulimit -c unlimited
ulimit -l unlimited

storage_share_fs=`python3 ${CURRENT_PATH}/get_config_info.py "storage_share_fs"`
storage_archive_fs=`python3 ${CURRENT_PATH}/get_config_info.py "storage_archive_fs"`
storage_metadata_fs=`python3 ${CURRENT_PATH}/get_config_info.py "storage_metadata_fs"`
node_id=`python3 ${CURRENT_PATH}/get_config_info.py "node_id"`
cms_ip=`python3 ${CURRENT_PATH}/get_config_info.py "cms_ip"`
cantian_user=`python3 ${CURRENT_PATH}/get_config_info.py "deploy_user"`
cantian_group=`python3 ${CURRENT_PATH}/get_config_info.py "deploy_group"`
deploy_user=`python3 ${CURRENT_PATH}/../get_config_info.py "deploy_user"`
deploy_group=`python3 ${CURRENT_PATH}/../get_config_info.py "deploy_group"`
mes_ssl_switch=`python3 ${CURRENT_PATH}/get_config_info.py "mes_ssl_switch"`
cantian_in_container=`python3 ${CURRENT_PATH}/get_config_info.py "cantian_in_container"`
primary_keystore="/opt/cantian/common/config/primary_keystore_bak.ks"
standby_keystore="/opt/cantian/common/config/standby_keystore_bak.ks"
VERSION_PATH="/mnt/dbdata/remote/metadata_${storage_metadata_fs}"

if [ ${node_id} -eq 0 ]; then
    node_domain=`echo ${cms_ip} | awk '{split($1,arr,";");print arr[1]}'`
else
    node_domain=`echo ${cms_ip} | awk '{split($1,arr,";");print arr[2]}'`
fi

touch /opt/cantian/healthy

function change_mtu() {
    ifconfig net1 mtu 5500
    ifconfig net2 mtu 5500
}

function wait_config_done() {
    # 等待pod网络配置完成
    logAndEchoInfo "Begin to wait network done. if block here, please check it."
    resolve_times=1
    ping ${node_domain} -c 1 -w 1
    while [ $? -ne 0 ]
    do
        let resolve_times++
        sleep 5
        if [ ${resolve_times} -eq ${WAIT_TIMES} ]; then
            logAndEchoError "timeout for resolving cms domain name!"
            exit 1
        fi
        ping ${node_domain} -c 1 -w 1
    done
}

function mount_fs() {
    logAndEchoInfo "Begin to mount file system. [Line:${LINENO}, File:${SCRIPT_NAME}]"
    if [ ! -f ${CURRENT_PATH}/${MOUNT_FILE} ]; then
        logAndEchoError "${MOUNT_FILE} is not exist. [Line:${LINENO}, File:${SCRIPT_NAME}]"
        exit 1
    fi

    sh ${CURRENT_PATH}/${MOUNT_FILE}
    if [ $? -ne 0 ]; then
        logAndEchoError "mount file system failed. [Line:${LINENO}, File:${SCRIPT_NAME}]"
        exit 1
    fi
    logAndEchoInfo "mount file system success. [Line:${LINENO}, File:${SCRIPT_NAME}]"
}

function check_init_status() {
    # 对端节点的cms会使用旧ip建链60s，等待对端节点cms解析新的ip
    if [ -f ${VERSION_PATH}/${VERSION_FILE} ]; then
        sleep 60
        logAndEchoInfo "The cluster has been initialized, no need create database. [Line:${LINENO}, File:${SCRIPT_NAME}]"
        sed -i "s/\"db_create_status\": \"default\"/\"db_create_status\": \"done\"/g" /opt/cantian/cantian/cfg/${START_STATUS_NAME}
        rm -rf ${USER_FILE}
    fi

    resolve_times=1
    # 等待节点0启动成功
    while [ ! -f ${VERSION_PATH}/${VERSION_FILE} ] && [ ${node_id} -ne 0 ]
    do
        logAndEchoInfo "wait for node 0 pod startup..."
        if [ ${resolve_times} -eq ${WAIT_TIMES} ]; then
            logAndEchoError "timeout for wait node 0 startup!"
            exit 1
        fi
        let resolve_times++
    done
    # TODO
    if [ -f ${VERSION_PATH}/${VERSION_FILE} ] || [ ${node_id} -ne 0 ]; then
        return 0
    fi
    rm -rf /mnt/dbdata/remote/share_${storage_share_fs}/*
    rm -rf /mnt/dbdata/remote/archive_${storage_archive_fs}/*
}

function prepare_kmc_conf() {
    cp -arf ${KMC_CONFIG_PATH}/standby_keystore.ks /opt/cantian/common/config/
    cp -arf ${KMC_CONFIG_PATH}/primary_keystore.ks /opt/cantian/common/config/
    cp -arf ${KMC_CONFIG_PATH}/standby_keystore.ks /opt/cantian/common/config/standby_keystore_bak.ks
    cp -arf ${KMC_CONFIG_PATH}/primary_keystore.ks /opt/cantian/common/config/primary_keystore_bak.ks
    chown -R ${cantian_user}:${cantian_group} /opt/cantian/common/config/*
}

function prepare_certificate() {
    if [[ ${mes_ssl_switch} == "False" ]]; then
        return 0
    fi

    local certificate_dir="/opt/cantian/common/config/certificates"
    mkdir -m 700 -p  "${certificate_dir}"
    local ca_path
    ca_path="${CERT_CONFIG_PATH}"/ca.crt
    local crt_path
    crt_path="${CERT_CONFIG_PATH}"/mes.crt
    local key_path
    key_path="${CERT_CONFIG_PATH}"/mes.key
    cp -arf "${ca_path}" "${certificate_dir}"/ca.crt
    cp -arf "${crt_path}" "${certificate_dir}"/mes.crt
    cp -arf "${key_path}" "${certificate_dir}"/mes.key 
    chown -hR "${cantian_user}":"${cantian_group}" "${certificate_dir}"
    su -s /bin/bash - "${cantian_user}" -c "chmod 600 ${certificate_dir}/*"

    cert_password=`cat ${CERT_CONFIG_PATH}/${CERT_PASS}`
    export LD_LIBRARY_PATH=/opt/cantian/dbstor/lib:${LD_LIBRARY_PATH}
    python3 -B "${CURRENT_PATH}"/resolve_pwd.py "resolve_check_cert_pwd" "${cert_password}"
    if [ $? -ne 0 ]; then
        logAndEchoError "Cert file or passwd check failed."
        exit 1
    fi
}

function set_version_file() {
    if [ ! -f ${PKG_PATH}/${VERSION_FILE} ]; then
        logAndEchoError "${VERSION_FILE} is not exist!"
        exit 1
    fi
    cp -rf ${PKG_PATH}/${VERSION_FILE} ${VERSION_PATH}/${VERSION_FILE}
}

function init_start() {
    # Cantian启动前先执行升级流程
    sh ${CURRENT_PATH}/container_upgrade.sh
    if [ $? -ne 0 ]; then
        rm -rf /opt/cantian/healthy
        exit 1
    fi

    # Cantian启动前执行init流程，更新各个模块配置文件，初始化cms
    sh ${SCRIPT_PATH}/appctl.sh init_container
    if [ $? -ne 0 ]; then
        rm -rf /opt/cantian/healthy
        exit 1
    fi

    # Cantian启动前参数预检查
    logAndEchoInfo "Begin to pre-check the parameters."
    python3 ${PRE_INSTALL_PY_PATH} 'override' ${INIT_CONFIG_PATH}/${CONFIG_NAME}
    if [ $? -ne 0 ]; then
        logAndEchoError "parameters pre-check failed."
        exit 1
    fi
    logAndEchoInfo "pre-check the parameters success."

    # Cantian启动
    sh ${SCRIPT_PATH}/appctl.sh start
    if [ $? -ne 0 ]; then
        rm -rf /opt/cantian/healthy
        exit 1
    fi

    # 拉起MySQL
    if [[ "${cantian_in_container}" == "1" ]]; then
        logAndEchoInfo "Begin to start mysqld. [Line:${LINENO}, File:${SCRIPT_NAME}]"
        su -s /bin/bash - ${deploy_user} -c "python3 -B \
            /opt/cantian/image/cantian_connector/CantianKernel/Cantian-DATABASE-CENTOS-64bit/install.py \
            -U ${deploy_user}:${deploy_group} -l /home/${deploy_user}/logs/install.log \
            -M mysqld -m /opt/cantian/image/cantian_connector/cantian-connector-mysql/scripts/my.cnf -g withoutroot"
        if [ $? -ne 0 ]; then
            rm -rf /opt/cantian/healthy
            logAndEchoError "start mysqld failed. [Line:${LINENO}, File:${SCRIPT_NAME}]"
            exit 1
        fi
        logAndEchoInfo "start mysqld success. [Line:${LINENO}, File:${SCRIPT_NAME}]"
    fi
    

    if [ ! -f ${VERSION_PATH}/${VERSION_FILE} ]; then
        set_version_file
    fi
    logAndEchoInfo "cantian container init success. [Line:${LINENO}, File:${SCRIPT_NAME}]"
}

function main() {
    #change_mtu
    wait_config_done
    mount_fs
    check_init_status
    prepare_kmc_conf
    prepare_certificate
    init_start
}

main

touch /opt/cantian/readiness