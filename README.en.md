# Cantian Storage Engine

Data storage acceleration engine

# 一、Project description

- Programming language: C
- Compile project: cmake or make, it is recommended to use cmake
-  Catalog description:
  - Cantian: main directory, CMakeLists.txt is the main project entrance;
  - build: compile the build script;
  - common: management control plane script;
  - ct_om: Installation and deployment script;
  - pkg: source code directory, divided into subdirectories for module decoupling;

# 二、Compilation guidance<a name="ZH-CN_TOPIC_0000001801512341"></a>

## 2.1 Overview<a name="ZH-CN_TOPIC_0000001801631373"></a>

This document describes how to compile the Cantian engine source code and  generate the Cantian engine software package. Figure 1 illustrates the  compilation process of the Cantian engine. If you need to perform  developer verification and debugging on the computing cloud, please  refer to Chapter 4

Figure 1 Cantian engine compilation process<a name="fig2092784815585"></a> 

![输入图片说明](https://foruda.gitee.com/images/1707301302643678557/8d1658bf_1686238.png "Cantian引擎编译流程.png")

## 2.2 Prepare the compilation environment<a name="ZH-CN_TOPIC_0000001754552768"></a>

**Hardware requirements<a name="section179914360134"></a>**

- Number of hosts: 1
- Recommended host hardware specifications:
  - CPU: 4 cores (64-bit)
  - Memory: 8GB
  - Disk free space: 100GB
- The ARM architecture host compiles to generate the Cantian engine ARM type  software package, and the X86 architecture host compiles to generate the Cantian engine X86 type software package.

**Operating system requirements<a name="section2010693873617"></a>**

The operating systems (Linux 64-bit) supported by the Cantian engine are as follows. It is recommended that the compiling operating system of the  Cantian engine is consistent with the running operating system:

- CentOS 8.2(x86_64)
- OpenEuler-22.03-LTS(aarch64)

**Software requirements<a name="section1912447143612"></a>**

The software that the Cantian engine compilation process depends on is shown in Table 1 Environment Build Dependencies.

Table 1 Software dependencies

| Required software | Recommended version | Explanation                                                  |
| ----------------- | ------------------- | ------------------------------------------------------------ |
| Docker            | >=19.03             | Used to build, manage, and run Cantian engine compiled images and containers. |
| Git               | >=2.18.0            | Used to download source code.                                |

## 2.3 version compilation<a name="ZH-CN_TOPIC_0000001754711680"></a>

### 2.3.1 Download source code<a name="ZH-CN_TOPIC_0000001801512345"></a>

This section describes how to download the Cantian engine source code and other dependent source codes.

**Prerequisites<a name="section17361818184118"></a>**

The Git software has been correctly installed and configured on the host.

**Steps<a name="section16845198174112"></a>**

1. Log in to the host as the root user.

2. Create and enter the source code download directory.

   Here we take downloading the source code to the directory  "/ctdb/cantian_compile" as an example. You can replace it according to  the actual environment.

   ```
   mkdir -p /ctdb/cantian_compile
   cd /ctdb/cantian_compile
   ```

3. Execute the following command to download the Cantian engine source code.

   ```
   git clone https://gitee.com/openeuler/cantian.git
   ```

4. Execute the following command to download the Cantian-Connector-MySQL source  code, which is used to compile the plug-in for Cantian engine to connect to MySQL.

   ```
   git clone https://gitee.com/openeuler/cantian-connector-mysql.git
   ```

5. Enter the Cantian-Connector-MySQL source code directory and execute the  following command to download the MySQL-8.0.26 version source code,  which is used to compile the plug-in for the Cantian engine to connect  to MySQL.

   ```
   cd cantian-connector-mysql
   wget https://github.com/mysql/mysql-server/archive/refs/tags/mysql-8.0.26.tar.gz --no-check-certificate
   tar -zxf mysql-8.0.26.tar.gz
   ```

### 2.3.2 Title

````
mv mysql-server-mysql-8.0.26 mysql-source
```

>![description of image.](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif "icon-note.gif") **explanation：** 
>The root directory of the Cantian engine source code and the Cantian-Connector-MySQL source code must be in the same directory. In this example, the directory structure is as follows:
>ctdb
>---- cantian\_compile
>----------cantian
>----------cantian-connector-mysql
>----------------mysql-source
````

### 2.3.3 Prepare container image<a name="ZH-CN_TOPIC_0000001817435653"></a>

The Cantian engine only supports compilation within the container. This  section introduces two methods of preparing container images: ① Build  the container image by yourself through the Dockerfile in the  Cantian-Connector-MySQL source code; ② Obtain the container image  directly through Docker Hub. If the host performing compilation cannot  connect to the network, you can choose the first method, otherwise  choose one of the two methods.

**Introduction to container image dependent software<a name="section197590130205"></a>**

If the user creates a container image by himself, the image must contain the dependent software in Table 1.

Table 1 Container image dependent software software

| Required software | Version    |
| ----------------- | ---------- |
| CMake             | >=3.14.1   |
| automake          | 1.16.1     |
| libtool           | 2.4.6      |
| g++               | 8.5.0      |
| libaio-devel      | 0.3.109-13 |
| pkgconfig         | 0.29.1-3   |
| rpm-build         | 4.14.3     |

**Prerequisites<a name="section17361818184118"></a>**

- The docker software has been correctly installed and configured on the  host. You can refer to the official Docker documentation for  installation.
- downloaded the source code of Cantian-Connector-MySQL

**Build an image using Dockerfile<a name="section11199345189"></a>**

Introduces how to use Dockerfile to build and compile container images.

1. Log in to the host as the root user.

2. Execute the following command to enter the directory where the Dockerfile file is located.

   ```
   cd /code_dir/cantian/docker
   ```

   Among them, "code_dir" is the directory where the source code is downloaded.

   For example, take the source code downloaded to "/ctdb/cantian_compile" as an example and execute the following command:

   ```
   cd /ctdb/cantian_compile/cantian/docker
   ```

3. Build container images.

   - When the current host environment is x86, execute the following command:

     ```
     docker build -t cantian_dev:latest -f Dockerfile .
     ```

   - When the current host environment is arm, execute the following command:

     ```
     docker build -t cantian_dev:latest -f Dockerfile_ARM64 .
     ```

4. After the build is completed, execute the following command to view the container image.

    "cantian_dev" is the built container image.

   ```
   docker images
   ```

   The echo is similar to the following:

   ![输入图片说明](https://foruda.gitee.com/images/1707302404781499024/f790cdbe_1686238.png)

**Get the image through Docker Hub<a name="section1585783101812"></a>**

Introduces how to obtain compiled container images through Docker Hub.

1. Log in to the host as the root user.

2. Get the compiled container image from Docker Hub.

   ```
   docker pull ykfnxx/cantian_dev:0.1.0
   ```

3. Set the image label.

   ```
   docker tag ykfnxx/cantian_dev:0.1.0 cantian_dev:latest
   ```

4. Execute the following command to view the container image.

   "cantian_dev" is the container image obtained from Docker Hub, as shown in the figure.

   ```
   docker images
   ```

   The echo is similar to the following:

   ![输入图片说明](https://foruda.gitee.com/images/1707301524241624886/575c1997_1686238.png)

### 2.3.4 Compile source code<a name="ZH-CN_TOPIC_0000001754552772"></a>

This section describes how to compile the Cantian engine source code in a  container environment and generate the Cantian engine software package.  As a necessary component for the operation of the Cantian engine,  Cantian-Connector will be compiled together in the automated compilation script of the Cantian engine and packaged into the Cantian engine  software package.

**Introduction to compilation scripts<a name="section18900146174715"></a>**

build_cantian.sh is the entry script in the compilation process, which integrates  software compilation and packaging functions. Run sh build_cantian.sh  [option]. The [option] parameter description is shown in Table 1.

Table 1 Compilation script parameter description

| Parameter options | Functions                                                    |
| ----------------- | ------------------------------------------------------------ |
| debug             | Compile the debug version of the software package, which contains symbol table files for debugging. |
| release           | Compile the release version of the software package. The software package does not contain symbol table files for debugging. |

**Prerequisites<a name="section17361818184118"></a>**

-  Successfully built or obtained the container image.
-  All source code has been prepared.

**Steps<a name="section7362738114918"></a>**

1. Start the container.

   The Cantian engine source code provides the container startup and  initialization script container.sh. This script can automatically  prepare the environment settings required to compile the Cantian engine. It is recommended to use this script to start the compiled container.

   1. Log in to the host as the root user.

   2. Execute the following command to enter the directory where container.sh is located.

      ```
      cd code_dir/cantian/docker
      ```

      Among them, "code_dir" is the directory where the source code is downloaded.

      For example, take the source code downloaded to "/ctdb/cantian_compile" as an example and execute the following command:

      ```
      cd /ctdb/cantian_compile/cantian/docker
      ```

   3. Execute the script to start and enter the compilation container.

      ```
      sh container.sh dev
      ```

2. Enter the compilation script directory.

   ```
   cd /home/regress/CantianKernel/build
   ```

3. Execute the compilation script to generate the Cantian engine software package.

   ```
   sh build_cantian.sh option
   ```

   Among them, "option" is the parameter option in Table 1, which specifies the  compilation of the realase or debug version of the software package.

4. Enter the compilation target directory and obtain the Cantian engine software package.

   ```
   cd /tmp/cantian_output
   ```

   If the echo is similar to the following, the compilation is successful:

   ```
   Packing package_name success
   ```

   The Cantian engine software package name generated by compilation is as  follows, please refer to the actual generated package name:

   - X86: Cantian_xxx_x86_64_DEBUG.tgz or Cantian_xxx_x86_64_RELEASE.tgz
   - ARM: Cantian_xxx_aarch64_DEBUG.tgz or Cantian__xxx_aarch64_RELEASE.tgz

# 三、Install and uninstall the Cantian engine<a name="ZH-CN_TOPIC_0000001754837214"></a>

## 3.1 Pre-installation planning<a name="ZH-CN_TOPIC_0000001779891302"></a>

Before installing the Cantian engine, please complete software and hardware  preparations, as well as related network and storage planning.

### 3.1.1 Network planning

Introduces the principles of Cantian engine planning, basic hardware configuration and software requirements, as well as the file system required for  storage devices.

**Planning Principles<a name="section155871027274"></a>**

When planning, you should ensure that the following two network planes are planned for the Cantian engine:

- Cantian engine heartbeat network: used for communication between different database servers deploying the Cantian engine.
- NAS shared network: NAS shares for storage and database servers read and write storage devices through this network.

Figure 1 Logical networking diagram

![输入图片说明](https://foruda.gitee.com/images/1707301733572311153/567352c2_1686238.png "逻辑组网图.png")

**Hardware & Software Preparation<a name="section1954414863218"></a>**

When planning, be prepared to install the basic hardware configuration and software package of the Cantian engine.

Table 1 Basic hardware configuration table

| Hardware              | Quantity | Remark                 |
| --------------------- | -------- | ---------------------- |
| X86 server/ARM server | 2        | Database server (host) |
| storage device        | 1        | -                      |

For X86 servers/ARM servers, it is recommended to use the following models  or servers with CPU performance no lower than the following models:

- ARM：Kunpeng 920-4826/Kunpeng 920-6426

- X86: Intel Xeon Gold 6248/Intel Xeon Gold 6348/Intel Xeon Gold 5218/Intel Xeon Gold 6230R

  For the X86 server, if you choose another model of CPU, please use the  following command to confirm whether the CPU supports the constant_tsc  feature to avoid not guaranteeing the time accuracy of the database  server due to the CPU not supporting the constant_tsc feature.

  ```
  cat /proc/cpuinfo | grep -o constant_tsc | uniq
  ```

  - If the echo contains the constant_tsc field, the CPU supports the constant_tsc feature.
  - If there is no echo, the CPU does not support the constant_tsc feature.

Table 2 Software configuration table

| Software                  | Matching version                                             |
| ------------------------- | ------------------------------------------------------------ |
| database operating system | X86：CentOS-8.2.2004-x86_64-dvd1.isoARM：openEuler 2203 sp1  |
| Database software         | See the compilation guide to compile and generate database software. |

For ARM's "openEuler 2203 sp1", please log in to the OpenEuler website,  select the "AArch64" architecture and "Server" scenario, and download  the software package with the package type "Offline Standard ISO".

>  ![输入图片说明](https://foruda.gitee.com/images/1707302488160637737/8ec1a8be_1686238.gif) Note:
>
> - When installing the Cantian engine, the Cantian engine will be installed to  the path "/dev/mapper/root directory" (for example:  "/dev/mapper/centos-root"), and requires at least 20GB of space. When  installing the database operating system, please reserve enough space  for this path (for installing the Cantian engine and other software) to  avoid Cantian engine installation failure due to insufficient space.
> - Please confirm that python version 3.6.0 or later is installed on the operating system.

**File system planning<a name="section168254503315"></a>**

When installing the Cantian engine, four file systems of the storage device  are required. Please make relevant capacity planning for each file  system.

Table 3 File system allocation table

| File system classification | File system name | Capacity | Number of items | Functions                                                    |
| -------------------------- | ---------------- | -------- | --------------- | ------------------------------------------------------------ |
| storage_dbstore_fs         | ctdb_dbstore_fs  | 10TB     | 1               | The file system used to store Cantian engine data. The capacity is configured according to the actual business plan. |
| storage_metadata_fs        | ctdb_metadata_fs | 1TB      | 1               | It is used to store MySQL metadata, and the capacity is configured according to actual business planning. |
| storage_share_fs           | ctdb_share_fs    | 2GB      | 1               | Used to store the reserved information of the database server cluster where  the Cantian engine is deployed, with a fixed size of 2GB. |
| storage_archive_fs         | ctdb_archive_fs  | 2TB      | 1               | Used to store archive logs and binlog files. Archive logs and binlog files  each occupy 50% of the space. It is recommended to comprehensively  evaluate the size of the file system based on the archive log retention  period and business volume. |

> ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Note: The file system name and capacity here are only shown as  examples. When planning, please set them according to the actual  situation.

### 3.1.2 Planning sample<a name="ZH-CN_TOPIC_0000001788641304"></a>

If conditions permit, it is recommended to adopt a networking mode with  redundant switch connections to improve network reliability. At the same time, the device also supports direct connection for networking.

#### 3.1.2.1 Planning example (switch networking)<a name="ZH-CN_TOPIC_0000001780380972"></a>

This section uses the networking method of achieving redundant connections  through switches as an example to introduce. Please make adjustments as  needed during actual planning.

**Network planning<a name="section1194324019416"></a>**

Redundant connections are formed by using dual switches to form different loops,  and 10GE ports are used to form the Cantian engine heartbeat network and NAS shared network.

Figure 1 Network planning

![输入图片说明](https://foruda.gitee.com/images/1707301761837148323/cfe7b10c_1686238.png "组网规划.png")

> ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Note: Cable connections between different ports are represented by  icons of different colors and serial numbers. For example, the "eth12"  port of Server 01 and the "1/0/2" port of 10GE Switch 1 are marked with  the serial number "1" in the same color, indicating that the above two  ports should be connected using cables during networking. .

**Hardware preparation**

The hardware equipment used in the network should have a sufficient number of 10GE ports to complete the network.

Table 1 Hardware configuration table

| Hardware category     | Minimum port number requirements | Quantity | Remark                                       |
| --------------------- | -------------------------------- | -------- | -------------------------------------------- |
| X86 server/ARM server | 6 10GE ports                     | 2        | Database host (server)                       |
| storage device        | 2 10GE ports                     | 1        | -                                            |
| Business switch       | 9 10GE ports                     | 2        | Stack deployment, for example: CE6857 switch |

**Server address planning**

The planning of server addresses includes address planning for business  networks, Cantian engine heartbeat networks, and NAS shared networks.

>  ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Description:
>
> - The business network and Cantian engine heartbeat network require cross-interface module group Bond, using Bond4 mode.
> -  The "host" and "physical network port" in Table 2, Table 3 and Table 4 use the device and port names in Figure 1.
> - Please isolate the networks with different VLANs assigned in Table 2, Table 3, and Table 4: Networks with the same VLAN use the same network segment,  and networks with different VLANs must not use the same network segment.
> - The hosts, physical network ports, bound network ports, VLANs, IP  addresses, and masks in Table 2, Table 3, and Table 4 are only examples  for illustration. Please make adjustments as needed during actual  planning. When configuring, please refer to the actual plan.

- Business network: used to provide services to the database server. The address planning of this network is shown in Table 2.

  Table 2 Business network address planning

| Host     | Physical network port | Bind network port | VLAN | IP address   | Subnet mask   |
| -------- | --------------------- | ----------------- | ---- | ------------ | ------------- |
| server01 | eth11eth13            | bussiness_bond    | 10   | 192.168.10.3 | 255.255.255.0 |
| server02 | eth21eth23            | bussiness_bond    | 10   | 192.168.10.4 | 255.255.255.0 |

- Cantian engine heartbeat network: used for communication between database  servers deploying the Cantian engine. The address planning of this  network is shown in Table 3.
  
  Table 3 Cantian engine heartbeat network address planning

| Host     | Physical network port | Bind network port | VLAN | IP address   | Subnet mask   |
| -------- | --------------------- | ----------------- | ---- | ------------ | ------------- |
| server01 | eth12eth14            | cantian_bond      | 20   | 192.168.20.2 | 255.255.255.0 |
| server02 | eth22eth24            | cantian_bond      | 20   | 192.168.20.3 | 255.255.255.0 |

- NAS shared network: used as a shared storage NAS share. The address planning of this network is shown in Table 4.
  
  Table 4 NAS shared network address planning

| Host     | Physical network port | Bind network port | VLAN | IP address  | Subnet mask   |
| -------- | --------------------- | ----------------- | ---- | ----------- | ------------- |
| server01 | eth15eth16            | storage_bond      | 77   | 172.16.77.4 | 255.255.255.0 |
| server01 | eth25eth26            | storage_bond      | 77   | 172.16.77.5 | 255.255.255.0 |

**Storage NAS shared network address planning**

>  ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Description:
>
> - The NAS shared network uses 10GE ports to configure binding within the  interface module and drift groups across interface modules.
> - The physical network port name uses the name in the networking diagram, and the actual network port name shall prevail during configuration.
> - The "physical port" in Table 5 uses the port name in Figure 1.
> - Please perform network isolation on the networks with different VLANs assigned in Table 5: Networks with the same VLAN use the same network segment,  and networks with different VLANs must not use the same network segment.
> - lgc_nas_3和lgc_nas_4挂载到bond_nas_2为例。
>   The four logical ports planned here can be mounted on bonded network ports  bond_nas_1 or bond_nas_2 respectively, but the same logical port cannot  be mounted on two bonded network ports at the same time. Here is an  example of mounting lgc_nas_1 and lgc_nas_2 to bond_nas_1, and mounting  lgc_nas_3 and lgc_nas_4 to bond_nas_2.
> - The physical ports, bound network ports, logical ports, VLANs, IP  addresses, masks, and DNS snooping in Table 5 are only examples for  illustration. Please make adjustments as needed during actual planning.  When configuring, please refer to the actual plan.

Table 5 Storage NAS shared network address planning

| physical port | Bind network port | logical port | VLAN | IP address  | Subnet mask   |
| ------------- | ----------------- | ------------ | ---- | ----------- | ------------- |
| eth31         | bond_nas_1        | lgc_nas_1    | 77   | 172.16.77.2 | 255.255.255.0 |
| eth32         | bond_nas_1        | lgc_nas_2    | 77   | 172.16.77.3 | 255.255.255.0 |
| eth33         | bond_nas_2        | lgc_nas_3    | 77   | 172.16.77.4 | 255.255.255.0 |
| eth34         | bond_nas_2        | lgc_nas_4    | 77   | 172.16.77.5 | 255.255.255.0 |

#### 3.1.2.2 Planning example (direct connection network)

When no switches are deployed, networking can be established through direct connections between different devices.

**Network planning**

Between servers and between servers and storage devices, the Cantian engine  heartbeat network and NAS shared network are formed by connecting the  Ethernet ports of each device.

Figure 1 Network planning

![输入图片说明](https://foruda.gitee.com/images/1707301785078567079/b344583d_1686238.png "组网规划-1.png")

**Hardware preparation**

The hardware devices used in the network should have enough ports to complete the network.

Table 1 Hardware configuration table

| Hardware category     | Minimum number of Ethernet ports required | Quantity | Remark                 |
| --------------------- | ----------------------------------------- | -------- | ---------------------- |
| X86 server/ARM server | 3                                         | 2        | Database host (server) |
| storage device        | 2                                         | 1        | -                      |

**Server address planning**

The planning of server addresses includes address planning for business  networks, Cantian engine heartbeat networks, and NAS shared networks.

>  ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Description:
>
> -  The "host" and "physical network port" in Table 2, Table 3 and Table 4 use the device and port names in Figure 1.
> -  The "host" and "physical network port" in Table 2, Table 3, and Table 4 use the host, physical network port, IP address, and mask in Figure 1  for illustration only. Please make adjustments as needed during actual  planning. . When configuring, please refer to the actual plan.

- Business network: used to provide services to the database server. The address planning of this network is shown in Table 2.

  Table 2 Business network address planning

| Host     | Physical network port | IP address   | Mask          |
| -------- | --------------------- | ------------ | ------------- |
| server01 | eth11                 | 192.168.10.3 | 255.255.255.0 |
| server02 | eth21                 | 192.168.10.4 | 255.255.255.0 |

- Cantian engine heartbeat network: used for communication between database  servers deploying the Cantian engine. The address planning of this  network is shown in Table 3.

  Table 3 Cantian engine heartbeat network address planning

| Host     | Physical network port | IP address   | Mask          |
| -------- | --------------------- | ------------ | ------------- |
| server01 | eth12                 | 192.168.20.2 | 255.255.255.0 |
| server02 | eth22                 | 192.168.20.3 | 255.255.255.0 |

- NAS shared network: used as a shared storage NAS share. The address planning of this network is shown in Table 4.

  Table 4 NAS shared network address planning

| Host     | Physical network port | IP address  | Mask          |
| -------- | --------------------- | ----------- | ------------- |
| server01 | eth13                 | 172.16.77.4 | 255.255.255.0 |
| server01 | eth23                 | 172.16.77.5 | 255.255.255.0 |

**Storage NAS shared network address planning**

>  ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Description:
>
> - The "physical port" in Table 5 uses the port name in Figure 1.
> - The logical ports planned here will be used to mount the four file systems  in Table 3. You can plan 4 logical ports and mount a file system on each logical port; you can also plan only 1 logical port and mount 4 file  systems at the same time. Here, planning four logical ports is used as  an example for explanation.
> -  The physical ports, logical ports, IP addresses, masks, and DNS  snooping in Table 5 are only examples. Please make adjustments as needed during actual planning. When configuring, please refer to the actual  plan.

Table 5 Storage NAS shared network address planning

| physical port | logical port | IP address  | Mask          |
| ------------- | ------------ | ----------- | ------------- |
| eth31         | lgc_nas_1    | 172.16.77.2 | 255.255.255.0 |
| eth31         | lgc_nas_2    | 172.16.77.3 | 255.255.255.0 |
| eth31         | lgc_nas_3    | 172.16.77.4 | 255.255.255.0 |
| eth31         | lgc_nas_4    | 172.16.77.5 | 255.255.255.0 |
| eth32         | lgc_nas_5    | 172.16.77.6 | 255.255.255.0 |
| eth32         | lgc_nas_6    | 172.16.77.7 | 255.255.255.0 |
| eth32         | lgc_nas_7    | 172.16.77.8 | 255.255.255.0 |
| eth32         | lgc_nas_8    | 172.16.77.9 | 255.255.255.0 |

## 3.2 Install Cantian engine

Please configure the network based on the actual hardware conditions and  network planning, and install the Cantian engine software.

### 3.2.1 Configure 10GE switch

If a switch is planned, please connect the business network, Cantian  engine heartbeat network, and NAS shared network to the 10GE switch  according to the plan. Here we take the planning sample (switch  networking) as an example and use the CE6857 switch for configuration  introduction.

**Prerequisites**

Before configuring, make sure that the port being used has no other  configurations. You can use the clear configuration interface command to clear the configuration under the interface with one click.

**Configure dynamic LACP mode for switch ports connected to the business network and Cantian engine heartbeat network**

Here we take the two ports "10GE 1/0/2" and "10GE 2/0/2" as examples:

Configure Trunk21 and dynamic LACP mode, configure the VLAN of the two ports to  20 and join Trunk21. Once completed, save the configuration information.

```
<SwitchA>system-view 
[~SwitchA]vlan 20 
[*SwitchA]interface Eth-Trunk 21 
[*SwitchA-Eth-Trunk21]port link-type trunk 
[*SwitchA-Eth-Trunk21]port trunk allow-pass vlan 20 
[*SwitchA-Eth-Trunk21]mode lacp-dynamic 
[*SwitchA-Eth-Trunk21]trunkport 10GE 1/0/2 
[*SwitchA-Eth-Trunk21]trunkport 10GE 2/0/2 
[*SwitchA-Eth-Trunk21]commit 
[~SwitchA-Eth-Trunk21]quit 
[~SwitchA]quit 
<SwitchA>save 
Warning: The current configuration will be written to the device. Continue? [Y/N]:y 
Now saving the current configuration to the slot 1 .... 
Info: Save the configuration successfully. 
Now saving the current configuration to the slot 2 ........... 
Info: Save the configuration successfully.
```

>  ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Note: All planned switch ports that are to be connected to the business network and Cantian engine heartbeat network need to perform the above  configuration and add the planned VLAN. For the VLAN planning of the  peer database server port, see Table 2 and Table 3.

**Configure static/dynamic LACP mode for switch ports sharing network connections with NAS**

- The peer is a storage device. Configure the static LACP mode of the switch port connected to the storage device.

  Here we take the two ports "10GE 1/0/8" and "10GE 2/0/8" as examples:

  Configure Trunk30 and static LACP mode, and configure the VLAN of Trunk30 port to 77.

  ```
  <SwitchA>system-view 
  [~SwitchA]vlan 77 
  [*SwitchA]interface Eth-Trunk 30 
  [*SwitchA-Eth-Trunk30]port link-type trunk 
  [*SwitchA-Eth-Trunk30]port trunk allow-pass vlan 77 
  [*SwitchA-Eth-Trunk30]mode lacp-static 
  [*SwitchA-Eth-Trunk30]trunkport 10GE 1/0/5 
  [*SwitchA-Eth-Trunk30]trunkport 10GE 2/0/5 
  [*SwitchA-Eth-Trunk30]commit 
  [~SwitchA-Eth-Trunk30]quit 
  [~SwitchA]quit 
  <SwitchA>save 
  Warning: The current configuration will be written to the device. Continue? [Y/N]:y 
  Now saving the current configuration to the slot 1 .... 
  Info: Save the configuration successfully. 
  Now saving the current configuration to the slot 2 ........... 
  Info: Save the configuration successfully.
  ```

  >  ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Note: All switch ports that are planned to be connected to the shared  network of the storage device NAS need to perform the above  configuration and add the planned VLAN. For the VLAN planning of the  peer storage device port, see Table 5.

- The opposite end is a database server. Configure the dynamic LACP mode of the switch port connected to the database server.

  Here we take the two ports "10GE 1/0/6" and "10GE 2/0/6" as examples:

  Configure Trunk31 and static LACP mode, and configure the VLAN of Trunk31 port to 77.

  ```
  <SwitchA>system-view 
  [~SwitchA]vlan 77 
  [*SwitchA]interface Eth-Trunk 31 
  [*SwitchA-Eth-Trunk31]port link-type trunk 
  [*SwitchA-Eth-Trunk31]port trunk allow-pass vlan 77 
  [*SwitchA-Eth-Trunk31]mode lacp-dynamic 
  [*SwitchA-Eth-Trunk31]trunkport 10GE 1/0/1 
  [*SwitchA-Eth-Trunk31]trunkport 10GE 2/0/1 
  [*SwitchA-Eth-Trunk31]commit 
  [~SwitchA-Eth-Trunk31]quit 
  [~SwitchA]quit 
  <SwitchA>save 
  Warning: The current configuration will be written to the device. Continue? [Y/N]:y 
  Now saving the current configuration to the slot 1 .... 
  Info: Save the configuration successfully. 
  Now saving the current configuration to the slot 2 ........... 
  Info: Save the configuration successfully.
  ```

  > ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Note: All switch ports planned to be connected to the shared network of the database server NAS need to be configured as above and the planned  VLAN must be added. For the VLAN planning of the peer database server  port, see Table 4.

### 3.2.2 Configure server network

Before installing the Cantian engine, please configure the ports used for the  business network, Cantian engine heartbeat network, and NAS shared  network on the database server.

#### Configure server network (switch network)

The switch and server configurations involved in this chapter, as well as  the values ​​of parameters such as VLAN and IP address used, are all  from the data planned in the planning sample (switch networking) and are only shown as examples. When configuring the actual configuration,  please refer to the actual hardware configuration and network planning.

##### Configure the port used for the NAS shared network

Each database server NAS shared network uses two 10Gb ports. The two ports  are bonded within the interface module and adopt Bond4 mode.

**Steps**

>  ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Description:
>
> - Please configure according to the VLAN and IP address planning in Table 4.  Here, the eth15 port and eth16 port of the server "server01" are used as an example for configuration: the port names are "eth15" and "eth16"  respectively, and the bound network port name is "storage_bond", the  VLAN used by the port is "77", the IP addresses are "172.16.77.4" and  "172.16.77.5", and the subnet mask is "255.255.255.0".
> - Please repeat the following steps to configure the two ports used for "NAS Shared Network" on another server.

1. Log in to the database server.

2. Execute the following commands in sequence to create a binding port.

   ```
   nmcli connection add type bond ifname bonding mode 802.3ad 
   nmcli connection add type ethernet ifname Port 1 master bonding 
   nmcli connection add type ethernet ifname Port 2 master bonding
   ```

   Take the bound eth15 port and eth16 port named "storage_bond" as an example:
   
   ```
   [root@host ~]# nmcli connection add type bond ifname storage_bond mode 802.3ad 
   [root@host ~]# nmcli connection add type ethernet ifname eth15 master storage_bond 
   [root@host ~]# nmcli connection add type ethernet ifname eth16 master storage_bond
   ```
   
3. Modify the Bond port configuration file "ifcfg-bond-Bind network port" (for  example: ifcfg-bond-storage_bond). The directory where the configuration file is located is /etc/sysconfig/network-scripts/.
   
   Please modify the following parameters and keep other parameters unchanged:
   
   - Set "BOOTPROTO" to "none".
   - Set "IPV6INIT" to "no".
   - Set "IPV6_AUTOCONF" to "no".
   - Invalidate the contents of "IPV4_FAILURE_FATAL=no", "IPV6_DEFROUTE=yes",  "IPV6_FAILURE_FATAL=no" and "IPV6_ADDR_GEN_MODE=stable-privacy" by  adding "#" at the beginning of the sentence.
   
   ```
   BONDING_OPTS=mode=802.3ad 
   TYPE=Bond 
   BONDING_MASTER=yes 
   PROXY_METHOD=none 
   BROWSER_ONLY=no 
   BOOTPROTO=none
   DEFROUTE=yes 
   #IPV4_FAILURE_FATAL=no
   IPV6INIT=no
   IPV6_AUTOCONF=no
   #IPV6_DEFROUTE=yes
   #IPV6_FAILURE_FATAL=no
   #IPV6_ADDR_GEN_MODE=stable-privacy
   NAME=storage_bond 
   UUID=fa3ec34f-1180-4d7b-b537-b3be17916d6c 
   DEVICE=storage_bond 
   ONBOOT=yes
   ```
   
4. In the /etc/sysconfig/network-scripts/ directory, create a new VLAN  configuration file ifcfg-bond-bond network port.VLAN, where "bond  network port" and "VLAN" are the bonded network ports used by the NAS  shared network. Name and VLAN, for example: ifcfg-bond-storage_bond.77.
   
   - Set "TYPE" to "Vlan".
   - Set "PHYSDEV" to the name of the bound network port, where "PHYSDEV" is "storage_bond".
   - Set "VLAN_ID" to the VLAN used by the NAS shared network. The "VLAN_ID" here is "77".
   - Set "BOOTPROTO" to "static".
   - Set "IPV4_FAILURE_FATAL" to "no".
   - Set "NAME" to "Bond network port.VLAN", and "NAME" here is "storage_bond.77".
   - Set "DEVICE" to "Bond network port.VLAN", and "DEVICE" here is "storage_bond.77".
   - Set "ONBOOT" to "yes".
   - Set "VLAN" to "yes".
   - Set "IPADDR" to the planned IP address, where "IPADDR" is "172.16.77.4".
   - Set "NETMASK" as the subnet mask of the planned IP address. "NETMASK" here is "255.255.255.0".
   
   ```
   TYPE=Vlan
   PHYSDEV=storage_bond
   VLAN_ID=77
   BOOTPROTO=static 
   IPV4_FAILURE_FATAL=no 
   NAME=storage_bond.77 
   DEVICE=storage_bond.77 
   ONBOOT=yes 
   VLAN=yes 
   IPADDR=172.16.77.4 
   NETMASK=255.255.255.0
   ```
   
5. Execute the following commands in sequence to restart the network service.

   ```
   nmcli connection reload 
   nmcli connection up bond-bonding 
   nmcli connection up bond-slave-Port 1 
   nmcli connection up bond-slave-Port 2
   nmcli connection up bonding.VLAN
   ```

   Example：

   ```
   [root@host ~]# nmcli connection reload 
   [root@host ~]# nmcli connection up bond-storage_bond 
   [root@host ~]# nmcli connection up bond-slave-eth15 
   [root@host ~]# nmcli connection up bond-slave-eth16
   [root@host ~]# nmcli connection up storage_bond.77
   ```

   After the restart is completed, please ping the storage IP address. If the ping succeeds, the configuration is successful.
   
> ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Note: Taking the eth15 port and the eth16 port as an example, the VLAN  of the port in Table 4 is 77. In the corresponding Table 5, the "NAS  Shared Network" IP addresses of VLAN 77 are 172.16.77.2 and 172.16 .77.3 is the storage IP address for Ping operation.

##### Configure ports for the business network and Cantian engine heartbeat network

The database server business network and Cantian engine heartbeat network  use 10Gb ports. It is recommended to form a Bond between interface  modules and adopt Bond4 mode.

**Steps**

>  ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Description:
>
> - Please configure according to the VLAN and IP address planning in Table 2 and  Table 3. Here, the eth11 port and eth13 port of the "Business Network"  server "server01" are used as an example for configuration: the port  names are "eth11" and "eth13" respectively. , the bound network port  name is "bussiness_bond", the VLAN used by the port is "10", the IP  address and subnet mask are "192.168.10.3" and "255.255.255.0"  respectively.
> - Please repeat the following steps to configure another port for "Business  Network" on the current server, two ports for "Cantian Engine Heartbeat  Network" on the current server, and two ports for "Business Network" and "Cantian Engine" on another server. Configure each port of "Engine  Heartbeat Network".

1. Log in to the database server.

2. Execute the following commands in sequence to create a binding port.

   ```
   nmcli connection add type bond ifname bonding mode 802.3ad 
   nmcli connection add type ethernet ifname Port 1 master bonding 
   nmcli connection add type ethernet ifname Port 2 master bonding
   ```

   Take the binding of the eth11 port and the eth13 port named "bussiness_bond" as an example:
   
   ```
   [root@host ~]# nmcli connection add type bond ifname bussiness_bond mode 802.3ad 
   [root@host ~]# nmcli connection add type ethernet ifname eth11 master bussiness_bond 
   [root@host ~]# nmcli connection add type ethernet ifname eth13 master bussiness_bond
   ```
   
3. Modify the Bond port configuration file "ifcfg-bond-Binding network port" (for example: ifcfg-bond-bussiness_bond). The directory where the  configuration file is located is /etc/sysconfig/network-scripts/.
   
   Please modify the following parameters and keep other parameters unchanged:
   
   - Set "BOOTPROTO" to "none".
   - Set "IPV6INIT" to "no".
   - Set "IPV6_AUTOCONF" to "no".
   - Invalidate the contents of "IPV4_FAILURE_FATAL=no", "IPV6_DEFROUTE=yes",  "IPV6_FAILURE_FATAL=no" and "IPV6_ADDR_GEN_MODE=stable-privacy" by  adding "#" at the beginning of the sentence.
   
   ```
   BONDING_OPTS=mode=802.3ad 
   TYPE=Bond 
   BONDING_MASTER=yes
   PROXY_METHOD=none 
   BROWSER_ONLY=no 
   BOOTPROTO=none 
   DEFROUTE=yes 
   #IPV4_FAILURE_FATAL=no 
   IPV6INIT=no 
   IPV6_AUTOCONF=no 
   #IPV6_DEFROUTE=yes 
   #IPV6_FAILURE_FATAL=no 
   #IPV6_ADDR_GEN_MODE=stable-privacy 
   NAME=bond-bussiness_bond 
   UUID=f4d806b4-66fe-4981-a138-4e0cb1500039 
   DEVICE=bussiness_bond 
   ONBOOT=yes
   ```
   
4. In the /etc/sysconfig/network-scripts/ directory, create a new VLAN  configuration file ifcfg-bond-bond network port.VLAN, where "bond  network port" and "VLAN" are the bond network port name and VLAN planned for the port. , for example: ifcfg-bond-bussiness_bond.10.
   
   - Set "TYPE" to "Vlan".
   - Set "PHYSDEV" to the name of the bound network port, where "PHYSDEV" is "bussiness_bond".
   - Set "VLAN_ID" to the VLAN planned for the port. The "VLAN_ID" here is "10".
   - Set "BOOTPROTO" to "static".
   - Set "IPV4_FAILURE_FATAL" to "no".
   - Set "NAME" to "Bonding network port.VLAN", and "NAME" here is "bussiness_bond.10".
   - Set "DEVICE" to "Bound network port.VLAN", and "DEVICE" here is "bussiness_bond.10".
   - Set "ONBOOT" to "yes".
   - Set "VLAN" to "yes".
   - Set "IPADDR" to the planned IP address, where "IPADDR" is "192.168.10.3".
   - Set "NETMASK" as the subnet mask of the planned IP address. "NETMASK" here is "255.255.255.0".
   
   ```
   TYPE=Vlan
   PHYSDEV=bussiness
   VLAN_ID=10
   BOOTPROTO=static 
   IPV4_FAILURE_FATAL=no 
   NAME=bussiness_bond.10 
   DEVICE=bussiness_bond.10 
   ONBOOT=yes 
   VLAN=yes 
   IPADDR=192.168.10.3 
   NETMASK=255.255.255.0
   ```
   
5. Execute the following commands in sequence, restart the network service, and  ping other configured IPs on the same plane. If the ping succeeds, the  configuration is successful.
   
   ```
   nmcli connection reload 
   nmcli connection up bond-bonding 
   nmcli connection up bond-slave-Port 1 
   nmcli connection up bond-slave-Port 2
   nmcli connection up bonding.VLAN
   ```
   
   Example：
   
   ```
   [root@host ~]# nmcli connection reload 
   [root@host ~]# nmcli connection up bond-bussiness_bond 
   [root@host ~]# nmcli connection up bond-slave-eth11 
   [root@host ~]# nmcli connection up bond-slave-eth13
   [root@host ~]# nmcli connection up bussiness_bond.10
   ```
   
   After the restart is completed, please ping other configured IP addresses on  the same plane. If the ping succeeds, the configuration is successful.
   
   > ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Note: Taking the eth11 port and the eth13 port as an example, in Table  2, the VLAN of the above port is 10, the IP address of the server  "server01" is 192.168.10.3, and the VLAN of the other server "server02"  is 10 The IP address is 192.168.10.4, where 192.168.10.4 is the  same-plane IP address for ping operation.

#### Configure server network (direct connection network)

##### Configure the port used for the NAS shared network

**Steps**

>  ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Description:
>
> - Please configure according to the IP address plan in Table 4. Here, the eth13  port of the server "server01" is used as an example for configuration:  the port name is "eth13", the IP address is "172.16.77.4", and the  subnet mask is "255.255." 255.0".
> - Please repeat the following steps to configure the port used for "NAS Shared Network" on another server.

1. Log in to the database server.

2. In the /etc/sysconfig/network-scripts/ directory, modify the existing VLAN configuration file "ifcfg-port name", where "port name" is the name of  the physical network port used by the NAS shared network, for example:  ifcfg-eth13.
   
   Please modify the following parameters:
   
   - Set "BOOTPROTO" to "none".
   - Set "ONBOOT" to "yes".
   - Set "IPADDR" to the planned IP address, where "IPADDR" is "172.16.77.4".
   - Set "NETMASK" as the subnet mask of the planned IP address. "NETMASK" here is "255.255.255.0".
   
   Other parameters remain unchanged.
   
   ```
   TYPE=Ethernet
   PROXY_METHOD=none
   BROWSER_ONLY=no
   BOOTPROTO=none
   DEFROUTE=yes
   IPV6INIT=no
   IPV6_AUTOCONF=no
   NAME=eth13
   UUID=6974c94d-9cb1-4316-b0c7-865bea8f994a
   DEVICE=eth13
   ONBOOT=yes
   IPADDR=172.16.77.4
   NETWORKMASK=255.255.255.0
   ```
   
3. Execute the following commands in sequence to restart the network service.

   ```
   nmcli connection reload 
   nmcli connection up port number 
   ```

   Example：

   ```
   [root@host ~]# nmcli connection reload 
   [root@host ~]# nmcli connection up eth13
   ```

   After the restart is completed, please ping the storage IP address. If the ping succeeds, the configuration is successful.
   
> ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Note: Take the eth13 port as an example. According to the plan in  Figure 1, the peer port of this port is eth31. In the corresponding  Table 5, the IP address of the eth31 port is the storage IP for the Ping operation. address.

##### Configure ports for the business network and Cantian engine heartbeat network

**Steps**

>  ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Description:
>
> - Please configure according to the IP address plan in Table 2 and Table 3.  Here, the eth11 port of the "Business Network" server "server01" is used as an example for configuration: the port name is "eth11", the IP  address and subnet mask are "192.168" respectively. .10.3" and  "255.255.255.0".
> - Please repeat the following steps to configure the ports used for "Cantian  Engine Heartbeat Network" on the current server and the ports used for  "Business Network" and "Cantian Engine Heartbeat Network" on another  server.

1. Log in to the database server.

2. In the /etc/sysconfig/network-scripts/ directory, modify the existing VLAN configuration file "ifcfg-port name", where "port name" is the physical network port name used by the business network or Cantian engine  heartbeat network, for example: ifcfg-eth11.
   
   Please modify the following parameters:
   
   - Set "BOOTPROTO" to "none".
   - Set "ONBOOT" to "yes".
   - Set "IPADDR" to the planned IP address, where "IPADDR" is "192.168.10.3".
   - Set "NETMASK" as the subnet mask of the planned IP address. "NETMASK" here is "255.255.255.0".
   
   Other parameters remain unchanged.
   
   ```
   TYPE=Ethernet
   PROXY_METHOD=none
   BROWSER_ONLY=no
   BOOTPROTO=none
   DEFROUTE=yes
   IPV6INIT=no
   IPV6_AUTOCONF=no
   NAME=eth11
   UUID=6974c94d-9cb1-4316-b0c7-865bea8f994a
   DEVICE=eth11
   ONBOOT=yes
   IPADDR=192.168.10.3
   NETWORKMASK=255.255.255.0
   ```
   
3. Execute the following commands in sequence to restart the network service.

   ```
   nmcli connection reload 
   nmcli connection up port number 
   ```

   Example：

   ```
   [root@host ~]# nmcli connection reload 
   [root@host ~]# nmcli connection up eth11
   ```

   After the restart is completed, please ping other configured IP addresses on  the same plane. If the ping succeeds, the configuration is successful.
   
> ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Note: Taking the eth11 port as an example, according to the cable  connection in Figure 1, the opposite port of the eth11 port is the eth01 port of the "service delivery device", and the IP address of the eth01  port is used for the Ping operation. The same plane IP address.

### 3.2.3 Configure storage network

Before deploying the Cantian engine, you also need to perform the following configurations on the storage device:

- Enable NFSv4.0 and NFSv4.1 services.
- Create file systems for different purposes planned in Table 3, and create NFS shares for each file system.
- Create logical ports for mounting each file system planned in Table 3.

### 3.2.4 Deploy Cantian engine

**Prerequisites**

- Before deploying the Cantian engine to the database server, please ensure that the time of each database server is consistent. Otherwise, in the event of database server failure, cms process failure, or network failure,  the database server with a larger time will be automatically removed  from the cluster.

- The CRT certificate and CA certificate are ready.

- The directory "/dev/shm" is not created on the server, or the directory  "/dev/shm" already exists on the server and the user has drwxrwxrwt  permissions for the directory and files:

  1. If the directory "/dev/shm" exists, enter the directory and execute the  following command to check whether the user has drwxrwxrwt permissions.

     ```
     ll /dev/ | grep shm
     ```

     The echo sample is as follows:

     ```
     [root@node1 shm]# ll
     drwxrwxrwt    2     root  root                               40   Feb  1  15:10   shm
     ```

  2. If the user does not have drwxrwxrwt permissions, please execute the following command to modify the user directory permissions:

     ```
     chmod 777 /dev/shm
     ```

- Python's dependent libraries pyopenssl and cryptography already exist:

  1. Execute the following command to confirm whether Python's dependent libraries pyopenssl and cryptography exist.

     ```
     pip show pyopenssl
     pip show cryptography
     ```

     If the echo displays "Package(s) not found:", it means that the corresponding dependent library does not exist.

     For example, when the pyopenssl dependent library does not exist, the echo is as follows:

     ```
     [root@node1 shm]# pip show pyopenssl
     WARNING: Package(s) not found: pyopenssl
     ```

  2. If the dependent libraries pyopenssl or cryptography are missing, please  execute the following commands to install them respectively:

     ```
     pip3 install pyopenssl --trusted-host=mirrors.huaweicloud.com -i https://mirrors.huaweicloud.com/repository/pypi/simple/
     pip3 install cryptography --trusted-host=mirrors.huaweicloud.com -i https://mirrors.huaweicloud.com/repository/pypi/simple/
     ```

**Steps**

1. Log in to the first database server.

2. Create new users and groups by executing the following commands, taking  ctdba:ctdba as an example. It is recommended to set up the same user and group for each database server used to install the Cantian engine.

   >  ![输入图片说明](https://foruda.gitee.com/images/1707302488160637737/8ec1a8be_1686238.gif) Note: When using the useradd command, the value of the parameter here  must be consistent with the running user ID of the process "mysqld" in  MySQL. Here, 5000 is used as an example. The specific configuration  shall be based on the actual running user ID.

   ```
   useradd -m -u 5000 -d /home/ctdba ctdba
   ```

3. Execute the following command to set the hostname of the database server.

   >  ![输入图片说明](https://foruda.gitee.com/images/1707302488160637737/8ec1a8be_1686238.gif) Note: When setting the hostname for each database server used to  install the Cantian engine, the hostnames of different database servers  should be set to different values ​​to avoid Cantian engine installation failure due to the same hostname.

   ```
   hostnamectl set-hostname name 
   ```

   Among them, "name" is the set database server hostname.

4. Execute the following command to upload the Cantian engine installation package and decompress it.

   ```
   mkdir path
   chmod 755 path
   cd path
   tar -zxvf Installation Package
   ```

   Among them, "path" is the upload path of the installation package, and  "Installation Package" is the software package compiled and generated in the compilation guide.

   Here, the software package name is "Cantian_24.06_x86_64_RELEASE.tgz" and the package is placed in the directory "/ctdb/cantian_install" as an  example. The final parameter configuration is subject to the software  package compiled and generated in the compilation guide and the actual  installation path.

   ```
   [root@host ~]# mkdir /ctdb/cantian_install
   [root@host ~]# chmod 755 /ctdb/cantian_install
   [root@host ~]# cd /ctdb/cantian_install
   [root@host  ]# tar -zxvf Cantian_24.06_x86_64_RELEASE.tgz
   ```

5. Modify the configuration file config_params_file.json. The relevant parameters are shown in Table 1.

   为：/ctdb/cantian_install/cantian_connector/action/config_params_file.json。
   The path of the configuration file is related to the storage path of the  Cantian engine installation package in 4. Taking the storage path of the installation package as "/ctdb/cantian_install" as an example: the path of the file is:  /ctdb/cantian_install/cantian_connector/action/config_params_file .json.

   Table 1 config_params_file.json file parameter description

| parameter name            | Parameter Description                                        |
| ------------------------- | ------------------------------------------------------------ |
| deploy_mode               | Deployment mode: Please set the deployment mode to "NAS".    |
| deploy_user               | "User:User Group" of the database configuration created in 2, for example: "ctdba:ctdba". |
| node_id                   | Deploy the database server ID of the Cantian engine, and set the two database  servers to 0 and 1 respectively. Please set the node_id of the first  database server you log in to 0 and the node_id of the second database  server you log in to 1. |
| cms_ip                    | The "Cantian engine heartbeat network" IP address planned in the planning  example is the communication IP between database servers. When filling  in parameters, all communication IPs between database servers need to be filled in, such as "192.168.20.2,192.168.20.3". Please first fill in  the database server IP with node_id 0, and then fill in the database  server IP with node_id 1. In the above example, 192.168.20.2 is the  database server IP with node_id 0, and 192.168.20.3 is the database  server IP with node_id 1. . |
| storage_dbstore_fs        | The storage file system name used by the Cantian engine. This file system  should be created when configuring the storage network. Please fill in  the name used when creating the file system. Only one Cantian engine can be deployed per file system. After completing the deployment, do not  modify the name of the file system or the name of the NFS share. |
| storage_share_fs          | The storage file system name used by cms shared data. This file system  should be created when configuring the storage network. Please fill in  the name used when creating the file system. Only one Cantian engine can be deployed per file system. After completing the deployment, do not  modify the name of the file system or the name of the NFS share. |
| storage_archive_fs        | The name of the storage file system used for archiving. This file system  should be created when configuring the storage network. Please fill in  the name used when creating the file system. Only one Cantian engine can be deployed per file system. After completing the deployment, do not  modify the name of the file system or the name of the NFS share. |
| storage_metadata_fs       | The name of the file system used to store MySQL metadata. This file system  should be created when configuring the storage network. Please fill in  the name used when creating the file system. Only one Cantian engine can be deployed per file system. After completing the deployment, do not  modify the name of the file system or the name of the NFS share. |
| mysql_in_container        | Whether MySQL is installed in the container, "0" means installed on the  database server, "1" means installed in the container. The default value is "0". |
| share_logic_ip            | The IP address of the logical port where the storage_share_fs file system  is mounted. The logical IP should be set in the storage network  configuration. Please fill in the set logical IP value. |
| archive_logic_ip          | The IP address of the logical port where the storage_archive_fs file system is mounted. This logical IP should be set in the storage network  configuration. Please fill in the set logical IP value. |
| metadata_logic_ip         | The IP of the logical port where the storage_metadata_fs file system is  mounted. The logical IP should be set in the storage network  configuration. Please fill in the set logical IP value. |
| storage_logic_ip          | The IP address of the logical port where the storage_dbstore_fs file system is mounted. This logical IP should be set in the storage network  configuration. Please fill in the set logical IP value. |
| db_type                   | Database type, "0" indicates performance mode, "1" indicates archive mode is  enabled. The default value is "0". If you need to use the data backup  function of the Cantian engine, please set this parameter to "1". |
| mysql_metadata_in_cantian | Please set this parameter to "false", otherwise it will affect MySQL connection. |
| MAX_ARCH_FILES_SIZE       | The maximum capacity of a single node archive is recommended to be set to  45% of the space used to store archive logs in the storage_archive_fs  file system. If the maximum capacity is exceeded, some archive logs will be automatically deleted in the order in which they are generated. |
| ca_path                   | The location where the CA certificate is stored, for example: "/opt/certificate/ca.crt". |
| crt_path                  | The location where the CRT certificate is stored, for example: "/opt/certificate/mes.crt". |
| key_path                  | The location where the CRT certificate private key is stored, for example: "/opt/certificate/mes.key". |
| redo_num                  | The number of redo files on a single node.                   |
| redo_size                 | The capacity of the redo file of a single node.              |

1. Execute the following command to install the Cantian engine:

   - If this is the first time to install the Cantian engine, or the Cantian  engine was uninstalled through override last time, please execute the  following command to install it:

     ```
     sh path/cantian_connector/action/appctl.sh install path/cantian_connector/action/config_params_file.json
     ```

     Among them, "path" is the upload path of the installation package in 4,  taking the path as "/ctdb/cantian_install" as an example:

     ```
     [root@host ~]# sh /ctdb/cantian_install/cantian_connector/action/appctl.sh install /ctdb/cantian_install/cantian_connector/action/config_params_file.json
     ```

     According to the prompts displayed, enter in sequence:

     1. Create the password for the database system administrator sys user.

     2. Confirm the password created in 6.a.

     3. The password for the CRT certificate private key.

        After the script is completed, "install success" is displayed and the installation is successful.

   - If the Cantian engine was uninstalled through the reserve method last time, please execute the following command to install it:

     ```
     sh path/cantian_connector/action/appctl.sh install reserve
     ```

     Among them, "path" is the upload path of the installation package in 4,  taking the path as "/ctdb/cantian_install" as an example:

     ```
     [root@host ~]# sh /ctdb/cantian_install/cantian_connector/action/appctl.sh install reserve
     ```

     After the script is completed, "install success" is displayed and the installation is successful.

2. Log in to another database server and repeat steps 2 to 6 to install the Cantian engine on the other database server.

3. After both database servers have completed the installation of the Cantian  engine, execute the following commands on the two database services to  start the Cantian engine.

   ```
   sh /opt/cantian/action/appctl.sh start
   ```

   > ![输入图片说明](https://foruda.gitee.com/images/1707302488160637737/8ec1a8be_1686238.gif) Note:
   >
   > - Please first successfully start the Cantian engine on the database server with node_id 0, and then start the Cantian engine on the database server  with node_id 1.
   > - The command used to start the Cantian engine has nothing to do with the upload path of the Cantian engine installation package.

   You can use the following steps to check whether the relevant startup tasks are completed, whether the cluster status is normal, and to determine  whether the Cantian engine is started successfully:

   1. Execute the following command to check whether the system scheduled task of the Cantian engine has been started.

      ```
      systemctl status cantian.timer
      ```

      If the echo content of "Active" is "active", it means that the system scheduled task has been started. For example: 

      ```
      systemctl status cantian.timer
      [root@host ~]# systemctl status cantian.timer
        cantian.timer - Run every 5s and on boot
        Loaded: loaded (/etc/systemd/system/cantian.timer; enabled; vendor preset: disabled)
        Active: active (waiting) since Mon 2024-02-05 05:45:34 EST; 20h ago
      Trigger: Tue 2024-02-06 02:43:37 EST; 3s left
      ```

   2. Execute the following command to check whether the log monitoring task of the Cantian engine has been started.

      ```
      systemctl status cantian_logs_handler.timer
      ```

      If the echo content of "Active" is "active", it means that the log monitoring task has been started. For example:

      ```
      [root@host ~]# systemctl status cantian_logs_handler.timer 
        cantian_logs_handler.timer - Run every 60minutes and on boot
        Loaded: loaded (/etc/systemd/system/cantian_logs_handler.timer; enabled; vendor preset: disabled)
        Active: active (waiting) since Mon 2024-02-05 05:45:35 EST; 20h ago
      Trigger: Tue 2024-02-06 02:45:45 EST; 1min 42s left
      ```

   3. Execute the following commands in sequence, and after switching to the cantian  user, check whether the cluster status of the Cantian engine is normal.

      ```
      su -s /bin/bash - cantian
      cms stat
      ```

      In the echo, if the "STAT" value of the two database servers in the  cluster is "ONLINE", the "WORK_STAT" value is "1", and the "ROLE" value  is "REFORMER", it means that the cluster status is normal. For example: 

      ```
      [root@host ~]# su -s /bin/bash - cantian 
      [cantian@host ~]$ cms stat
      NODE_ID  NAME      STAT    PRE_STAT    TARGET_STAT   WORK_STAT   SESSION_ID   INSTANCE_ID   ROLE     LAST_CHECK              HB_TIME                 STAT_CHANGE
            0  db        ONLINE  UNKNOWN     ONLINE                1            0             0   REFORMER 2024-02-06 02:42:32.753 2024-02-06 02:42:32.753 2024-02-05 05:44:30.578
            1  db        ONLINE  OFFLINE     ONLINE                1            0             1   REFORMER 2024-02-06 02:42:34.599 2024-02-06 02:42:34.599 2024-02-05 05:47:06.742
      ```

## 3.3 Uninstall the Cantian engine

The system supports uninstalling the Cantian engine through override mode  or reserve mode. When uninstalling, please use the same method to  uninstall the Cantian engine on both database servers.

### 3.3.1 Uninstall the Cantian engine through override

If there is no need to back up the data of the database server, please uninstall the Cantian engine through override.

**Precautions**

- Before uninstalling the Cantian engine, make sure that the upper-layer business has stopped.
- After the Cantian engine is uninstalled, all user configurations and database data will be cleared, so please operate with caution.

**Steps**

1. Log in to the database server.

2. Execute the following command to stop the Cantian engine running on the database server.

   ```
   sh /opt/cantian/action/appctl.sh stop
   ```

3. Log in to another database server and repeat step 2 to stop the Cantian engine running on the other database server.

4. Execute the following commands on the two database servers in sequence to  uninstall the Cantian engine installed on the database server.

   ```
   sh /opt/cantian/action/appctl.sh uninstall override
   ```

5. (Optional) If the uninstallation fails, execute the following command to force the uninstallation.

   ```
   sh /opt/cantian/action/appctl.sh uninstall override force
   ```

   If you still cannot uninstall, please contact technical engineers.

### 3.3.2 Uninstall the Cantian engine through the reserve method

If you need to back up the data of the database server, please uninstall the Cantian engine through the reserve method.

**Steps**

1. Log in to the database server.

2. Execute the following command to back up the data of the database server.

   ```
   sh /opt/cantian/action/appctl.sh backup
   ```

3. Execute the following data to stop the Cantian engine running on the database server.

   ```
   sh /opt/cantian/action/appctl.sh stop
   ```

4. Log in to another database server and repeat steps 2 and 3 to stop the Cantian engine running on the other database server.

5. Execute the following commands on the two database servers in sequence to  uninstall the Cantian engine installed on the database server.

   ```
   sh /opt/cantian/action/appctl.sh uninstall reserve
   ```

   If it cannot be uninstalled, please contact technical engineers.

# 四、Connect to MySQL

## 4.1 Install MySQL

Please install version 8.0.26 of MySQL that matches the Cantian engine.

>  ![输入图片说明](https://foruda.gitee.com/images/1707302488160637737/8ec1a8be_1686238.gif) Note: Please install the corresponding version of MySQL according to  the software package version type (realase or debug version) generated  in the compiled source code.

## 4.2 Load plug-in dependent libraries

The Cantian engine supports loading plug-in dependent libraries through physical means and container means.

### 4.2.1 Loading plug-in dependent libraries through physical means

This chapter describes how to load plug-in dependent libraries on the  database server by directly loading or starting the MySQL process.

**Prerequisites**

- Copy the following files to the plugin path respectively.

  - /opt/cantian/mysql/server/plugin/ha_ctc.so
  - /opt/cantian/image/cantian_connector/for_mysql_official/mf_connector_mount_dir/cantian_lib/libctc_proxy.so
  - /opt/cantian/image/cantian_connector/for_mysql_official/mf_connector_mount_dir/cantian_lib/libsecurec.so
  - /opt/cantian/image/cantian_connector/for_mysql_official/mf_connector_mount_dir/cantian_lib/libsecurec.a

  After the copy is completed, please ensure that the read and write  permissions on the above files are the same as the read and write  permissions on other original files in the plug-in directory.

- In the MySQL installation directory of the database server, obtain the  path of the libmysqlclient.so.21 file, and copy the file to the plug-in  path. If libmysqlclient.so.21 does not exist, please install the  relevant MySQL software package corresponding to the operating system.

>  ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Note: The MySQL plug-in path is ".../mysql/lib/plugin". The complete  plug-in path is related to the MySQL installation path. For example, if  MySQL is installed under the path "/usr/local/", the complete plug-in  path is "/usr/local/mysql/lib/plugin"

**Steps**

1. Log in to the first database server.

2. Enter the directory "/dev/shm" and execute the following command to confirm  that the user has rw (read and write) permissions for the directory and  files.

   ```
   ll
   ```

   The echo sample is as follows:

   ```
   [root@node1 shm]# ll
   total 1796964
   -rw-rw---- 1 cantian cantiandba 4003037184 Dec 29 00:53 cantian.0
   -rw-rw---- 1 cantian cantiandba 4003037184 Dec 29 01:14 cantian.1
   -rw-rw---- 1 cantian cantiandba 4003037184 Dec 29 01:14 cantian.2
   -rw-rw---- 1 cantian cantiandba 4003037184 Dec 29 01:10 cantian.3
   -rw-rw---- 1 cantian cantiandba 4003037184 Dec 29 00:40 cantian.4
   -rw-rw---- 1 cantian cantiandba 4003037184 Dec 29 00:37 cantian.5
   -rw-rw---- 1 cantian cantiandba 4003037184 Dec 29 00:43 cantian.6
   -rw-rw---- 1 cantian cantiandba 4003037184 Dec 29 01:09 cantian.7
   -rw-rw---- 1 cantian cantiandba 4003037184 Dec 28 22:45 cantian.8
   -rw-rw---- 1 cantian cantiandba        378 Dec 28 22:39 cantian_shm_config_0.txt
   -rw-rw---- 1 cantian cantiandba        378 Dec 28 22:39 cantian_shm_config_1.txt
   srw-rw---- 1 cantian cantiandba          0 Dec 28 22:39 cantian.shm_unix_sock
   ```

3.  Load the dependent libraries of the plug-in ctc.so.

   >  ![输入图片说明](https://foruda.gitee.com/images/1707302488160637737/8ec1a8be_1686238.gif) Note: Before executing the following command, please confirm that the  users and groups configured in the MySQL configuration file have read  and write permissions. If you do not have read and write permissions,  please modify the configuration file and restart the mysqld process  after modification.

   - Method 1: Open the MySQL client and execute the following commands in order to directly load the dependent library of the plug-in ctc.so.

     ```
     install plugin ctc_ddl_rewriter soname 'ha_ctc.so'
     install plugin CTC soname 'ha_ctc.so'
     ```

   - Method 2: Start the MySQL process and load the dependency library of the plug-in ctc.so.

     1. Execute the following command to initialize MySQL.

        ```
        mysqld_binary_path --defaults-file=configuration_file_path --initialize-insecure --datadir=data_path
        ```

        Parameter Description: 

        - mysqld_binary_path: The binary file path to start MySQL.
        - configuration_file_path: configuration file path.
        - data_path: data path.

        Example：

        ```
        /usr/local/mysql/bin/mysqld --defaults-file=/ctdb/cantian_install/mysql-server/scripts/my.cnf --initialize-insecure --datadir=/data/data
        ```

     2. Execute the following command to start MySQL.

        ```
        mysqld_binary_path --defaults-file=onfiguration_file_path --datadir=data_path --plugin-dir=mysqld_plugin_path --plugin_load="ctc_ddl_rewriter=ha_ctc.so;ctc=ha_ctc.so;" --check_proxy_users=ON --mysql_native_password_proxy_users=ON --default-storage-engine=CTC
        ```

        Parameter Description: 

        - mysqld_binary_path: The binary file path to start MySQL.
        - configuration_file_path: configuration file path.
        - data_path: data path.
        - mysqld_plugin_path: plugin path.

        Example：

        ```
        /usr/local/mysql/bin/mysqld --defaults-file=/ctdb/cantian_install/mysql-server/scripts/my.cnf --datadir=/data/data --plugin-dir=/usr/local/mysql/lib/plugin --plugin_load="ctc_ddl_rewriter=ha_ctc.so;ctc=ha_ctc.so;" --check_proxy_users=ON --mysql_native_password_proxy_users=ON --default-storage-engine=CTC
        ```

4. Log in to another database server and repeat steps 2 and 3 to load the  dependent library of the plug-in ha_ctc.so for the other database  server.

# 五、Health inspection

Use scripts to perform health inspections on the Cantian engine to  understand the running status of each module of the Cantian engine.

**Prerequisites**

The Cantian engine is installed correctly and functioning properly.

**Background Information**

- Perform one-click inspection or specified inspection items for a single node.
- There are differences between physical machine Cantian engine inspection and  MySQL container inspection, and the instructions are different.
- The physical machine Cantian engine inspection is performed by the cantian  user, and the MySQL container inspection is performed by the root user.
- After a successful one-click inspection, an inspection file will be generated to record the inspection results. By default, only the most recent 9  inspection result files will be retained.
- In the scenario of container deployment of MySQL, inspection of the  Cantian engine and MySQL is supported. In the scenario where MySQL is  deployed on a physical machine, only the inspection of the Cantian  engine is supported.

**Inspection of Cantian engine**

1. Use SSH (such as PuTTY) to log in to all Cantian engine nodes in sequence.

2. Execute the following command to switch to the cantian account.

   ```
   su -s /bin/bash cantian
   ```

3. Execute the following commands on all Cantian engine nodes in sequence to perform inspection:

   - Full inspection:

     ```
     python3 /opt/cantian/action/inspection/inspection_task.py all
     ```

   - Partial inspection:

     ```
     python3 /opt/cantian/action/inspection/inspection_task.py [xxx,xxx,…]
     ```

     > ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Description:
     >
     > - _xxx_ represents a specific inspection item, such as "cantian_status".  Inspection items can be viewed through the  "/opt/cantian/action/inspection/inspection_config.json" file, as shown  in Figure 1. Inspection items can be viewed through the  "/opt/cantian/action/inspection/inspection_config.json" file, as shown  in Figure 1.
     > - Each inspection item should be separated by English commas without spaces.

     Figure 1 View inspection items
      ![输入图片说明](https://foruda.gitee.com/images/1707301708579211817/771dd156_1686238.png)

4.  According to the echo prompts, enter the ctsql user name and password.

   ![输入图片说明](https://foruda.gitee.com/images/1707301568720998595/442ea8ba_1686238.png)

   >  ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Description:
   >
   > - When performing full inspection, you need to enter the user name and password of ctsql.
   > - When performing partial inspections, you only need to enter your ctsql  username and password if the echo prompts you to enter them.

5. The execution result is echoed as follows.

   ![输入图片说明](https://foruda.gitee.com/images/1707301593528813341/8279dcf9_1686238.png)

6. View inspection results.

   After the inspection is completed, the inspection results will be saved in  the directory "/opt/cantian/action/inspections_log", named after  "inspection_timestamp", and only the latest 9 inspection result files  will be saved.

   ![输入图片说明](https://foruda.gitee.com/images/1707301610921579766/7192a086_1686238.png)

**Inspecting MySQL (only supported in container deployment MySQL scenarios)**

1. Enter all containers where MySQL is deployed in order and execute the following inspection commands.

   - Full inspection:

     ```
     python3 /mf_connector/inspection/inspection_task.py all
     ```

   - Partial inspection:

     ```
     python3 /mf_connector/inspection/inspection_task.py [xxx,xxx,…]
     ```

     > ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) **说明：** ![输入图片说明](https://foruda.gitee.com/images/1707301851414022105/fc841ea9_1686238.gif) Description:
     >
     > - _xxx_ represents a specific inspection item, such as  "mysql_connection_check". Inspection items can be viewed through the  /mf_connector/inspection/mysql_inspection_config.json file, as shown in  Figure 2.
     > - Each inspection item should be separated by commas without spaces.

     Figure 2 View inspection items
      ![输入图片说明](https://foruda.gitee.com/images/1707301673675665446/88ca9bb0_1686238.png)

2. View inspection results.

   After the inspection is completed, the inspection results will be saved in  the directory "/mf_connector/inspection/inspections_log" and named after "inspection_timestamp". And only the latest 9 inspection result files  are saved.

   Inspection results are as follows:

   ![输入图片说明](https://foruda.gitee.com/images/1707301648920644690/22c0aa8b_1686238.png)

# 六、Cantian cloud host development, compilation and deployment

## 6.1 Environment preparation

### 6.1.1 Download the latest docker image

#### x86 version

```
docker pull ykfnxx/cantian_dev:0.1.0
docker tag ykfnxx/cantian_dev:0.1.0 cantian_dev:latest
```

#### ARM version

```
docker pull ykfnxx/cantian_dev:0.1.1
docker tag ykfnxx/cantian_dev:0.1.1 cantian_dev:latest
```

### 6.1.2 Download cantian source code

1. Execute the following command to download the Cantian engine source code.

```
git clone git@gitee.com:openeuler/cantian.git
```

2. Execute the following command to download the Cantian-Connector-MySQL  source code, which is used to compile the plug-in for Cantian engine to  connect to MySQL.

```
git clone git@gitee.com:openeuler/cantian-connector-mysql.git
```

3. Execute the following command to download the MySQL-8.0.26 version  source code, which is used to compile the plug-in for Cantian engine to  connect to MySQL, and copy the source code to the  cantian-connector-mysql/mysql-source directory.

```
wget --no-check-certificate https://github.com/mysql/mysql-server/archive/refs/tags/mysql-8.0.26.tar.gz
tar -zxf mysql-8.0.26.tar.gz
mv mysql-server-mysql-8.0.26 /home/regress/cantian-connector-mysql/mysql-source
```

4. Create the cantian_data directory at the same level as cantian and cantian-connector-mysql to store related data.

```
mkdir -p cantian_data
```

### 6.1.3 Start container

Enter the cantian directory and start the container.

- one nodes

```
sh docker/container.sh dev
sh docker/container.sh enterdev
```

- two nodes

```
# At present, it only supports two nodes with IDs 0 and 1.
sh docker/container.sh startnode 0
sh docker/container.sh enternode 1
```

 When container.sh is started according to the `startnode` and `dev` parameters, it will perform the code copy operation. For specific operations, please refer to the `sync_mysql_code` function in the script.

## 6.2 Cantian compilation and deployment

### 6.2.1 cantian package

The following commands are used inside the container. If it is a dual node, it only needs to be executed once on one of the nodes. For the  convenience of description, subsequent operations on two nodes that only need to be performed on one node are performed on node0 by default.

```
cd /home/regress/CantianKernel/build
export local_build=true
# If the third-party dependencies have been previously compiled, you can add the --no-deps parameter to skip the compilation of the third-party dependencies
# debug
sh Makefile.sh package
# release
sh Makefile.sh package-release
```

### 6.2.2 cantian deployment

Configure core_pattern (configured on two nodes, used to record core files)

```
echo "/home/core/core-%e-%p-%t" > /proc/sys/kernel/core_pattern
echo 2 > /proc/sys/fs/suid_dumpable
ulimit -c unlimited
```

##### Cantian Deploying Cantian on a single node

```
cd /home/regress/CantianKernel/Cantian-DATABASE-CENTOS-64bit
mkdir -p /home/cantiandba/logs
# -Z SESSIONS=1000 for debugging purposes only, remove this parameter when running MTR
# To deploy a non-metadata-normalized version, add the corresponding parameter-Z MYSQL_METADATA_IN_CANTIAN=FALSE
python3 install.py -U cantiandba:cantiandba -R /home/cantiandba/install -D /home/cantiandba/data -l /home/cantiandba/logs/install.log -Z _LOG_LEVEL=255 -g withoutroot -d -M cantiand -c -Z _SYS_PASSWORD=Huawei@123 -Z SESSIONS=1000
```

##### Cantian Two-node deployment of Cantian

node0

```
cd /home/regress/CantianKernel/Cantian-DATABASE-CENTOS-64bit
mkdir -p /home/cantiandba/logs
python3 install.py -U cantiandba:cantiandba -R /home/cantiandba/install -D /home/cantiandba/data -l /home/cantiandba/logs/install.log -M cantiand_in_cluster -Z _LOG_LEVEL=255 -N 0 -W 192.168.0.1 -g withoutroot -d -c -Z _SYS_PASSWORD=Huawei@123 -Z SESSIONS=1000
```

node1

```
cd /home/regress/CantianKernel/Cantian-DATABASE-CENTOS-64bit
mkdir -p /home/cantiandba/logs
python3 install.py -U cantiandba:cantiandba -R /home/cantiandba/install -D /home/cantiandba/data -l /home/cantiandba/logs/install.log -M cantiand_in_cluster -Z _LOG_LEVEL=255 -N 1 -W 192.168.0.1 -g withoutroot -d -c -Z _SYS_PASSWORD=Huawei@123 -Z SESSIONS=1000
```

#### Verify whether the cantian status is normal

```
su - cantiandba
cms stat
ctsql / as sysdba -q -c 'SELECT NAME, STATUS, OPEN_STATUS FROM DV_DATABASE'
```

### 6.2.3 Uninstall cantian

You need to use the gaussdba user to execute the uninstall command. If  there is a mysqld process connected to cantiand, execute the following  instructions to stop the mysqld process first and then stop cantiand:

```
/usr/local/mysql/bin/mysql -uroot -e "shutdown;"
```

Uninstall instructions:

```
cd /home/cantiandba/install/bin
python3 uninstall.py -U cantiandba -F -D /home/cantiandba/data -g withoutroot -d
```

**If an error occurs and some directories cannot be deleted, you can use the root user to manually clean up the relevant directories.**

```
kill -9 $(pidof mysqld)
kill -9 $(pidof cantiand)
kill -9 $(pidof cms)
rm -rf /home/regress/cantian_data/* /home/regress/install /home/regress/data /home/cantiandba/install/* /data/data/* /home/cantiandba/data
sed -i '/cantiandba/d' /home/cantiandba/.bashrc
```

## 6.3 mysql compilation and deployment

### 6.3.1 mysql compilation

#### 6.3.1.1 Metadata normalization

Metadata normalization requires applying patches and modifying the source code.

```
cd cantian-connector-mysql/mysql-source
patch --ignore-whitespace -p1 < mysql-scripts-meta.patch
patch --ignore-whitespace -p1 < mysql-test-meta.patch
patch --ignore-whitespace -p1 < mysql-source-code-meta.patch
```

Compilation: When deploying two nodes, if manual deployment is used, the two nodes  need to be compiled separately. If you use script deployment, you only  need to compile it on one node.

```
cd /home/regress/CantianKernel/build
sh Makefile.sh mysql
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/regress/cantian-connector-mysql/bld_debug/library_output_directory
rm -rf /home/regress/mydata/*
```

In particular, if the compilation of cantian is completed on node0, you  need to execute the following command before compiling mysql on node1.

```
mkdir /home/regress/cantian-connector-mysql/mysql-source/include/protobuf-c
cp /home/regress/CantianKernel/library/protobuf/protobuf-c/protobuf-c.h /home/regress/cantian-connector-mysql/mysql-source/include/protobuf-c
```

#### 6.3.1.2 Non-normalization

When deploying on two nodes, the non-normalized version only needs to compile mysql on one of the nodes.

```
cd /home/regress/CantianKernel/build
sh Makefile.sh mysql
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/regress/cantian-connector-mysql/bld_debug/library_output_directory
```

### 6.3.2 mysql deployment

#### 6.3.2.1 Metadata normalization (manual pull up)

Initialization: For dual nodes, you only need to execute the initialization command on  one of the nodes, and before initialization, you need to ensure that  there are no files under `/home/regress/mydata` that need to be executed first.

```
rm -rf /home/regress/mydata/*
/usr/local/mysql/bin/mysqld --defaults-file=/home/regress/cantian-connector-mysql/scripts/my.cnf --initialize-insecure --datadir=/home/regress/mydata --early-plugin-load="ha_ctc.so" --core-file
```

Deployment: The two nodes execute deployment commands separately after  initialization. If initialization is completed on node0, node1 needs to  execute the following command first

```
rm -rf /home/regress/mydata/*
mkdir -p /home/regress/mydata/
mkdir -p /home/regress/mydata/mysql
```

The deployment command is:

```
mkdir -p /data/data
/usr/local/mysql/bin/mysqld --defaults-file=/home/regress/cantian-connector-mysql/scripts/my.cnf  --datadir=/home/regress/mydata --user=root --early-plugin-load="ha_ctc.so" --core-file >> /data/data/mysql.log 2>&1 &
```

#### 6.3.2.2 Metadata normalization/non-normalization (script)

Before pulling up the two nodes, you need to execute the following commands respectively:

```
# node0
cd /home/regress/CantianKernel/build
sh Makefile.sh mysql_package_node0

# node1
cd /home/regress/CantianKernel/build
sh Makefile.sh mysql_package_node1
```

The following is the command pulled up using the `install.py` script

```
cd /home/regress/CantianKernel/Cantian-DATABASE-CENTOS-64bit
mkdir -p /home/regress/logs
python3 install.py -U cantiandba:cantiandba -l /home/cantiandba/logs/install.log -d -M mysqld -m /home/regress/cantian-connector-mysql/scripts/my.cnf
```

### 6.3.2.3 Pull-up inspection

```
/usr/local/mysql/bin/mysql -uroot
```

## 6.4 Logging and gdb debugging

Santian log location:

```
/home/cantiandba/data/log/run/cantiand.rlog
```

mysql log location:

```
/data/data/mysql.log
```

Under dual nodes, the heartbeat needs to be synchronized before the gdb attach process.

```
su cantiandba
cms res -edit db -attr HB_TIMEOUT=1000000000
cms res -edit db -attr CHECK_TIMEOUT=1000000000
```