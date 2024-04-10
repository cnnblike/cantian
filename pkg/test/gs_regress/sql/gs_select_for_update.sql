--DTS2018100906402
drop procedure if exists init_respooldb;
drop table if exists tbl_inv_allocidresource;
CREATE OR REPLACE PROCEDURE init_respooldb()
AS 
sql_init varchar(1024);
BEGIN

    IF object_id('TBL_INV_ALLOCIDRESOURCE', 'table', 'RESPOOLDB') IS NULL
    THEN
    BEGIN
        sql_init := 'CREATE TABLE tbl_inv_allocidresource
        (
            idres decimal(16,0) DEFAULT NULL COMMENT ''ID resource'',
            poolname varchar(255) DEFAULT NULL COMMENT ''Name of a resource pool'',
            userlabel varchar(255) DEFAULT NULL COMMENT ''User label'',
            agingtime int DEFAULT NULL COMMENT ''Aging time (UTC time in seconds)'',
            uuid varchar(36) NOT NULL COMMENT ''ID that uniquely identifies the resource'',
            createtime int DEFAULT NULL COMMENT ''Creation time of the resource record (UTC time in seconds)'',
            updatetime int DEFAULT NULL COMMENT ''Update time of the resource record (UTC time in seconds)'',
            PRIMARY KEY (uuid)
        )';
        execute immediate sql_init;

        sql_init := 'COMMENT ON TABLE tbl_inv_allocidresource IS ''Table to store information about occupied ID resources''';
        execute immediate sql_init;

        sql_init := 'CREATE UNIQUE INDEX idx_resource_uniqueid ON tbl_inv_allocidresource(poolname,idres)';
        execute immediate sql_init;

        sql_init := 'CREATE INDEX idx_agingtime ON tbl_inv_allocidresource(agingtime)';
        execute immediate sql_init;
    END;
    END IF;
END;
/
CALL init_respooldb;
insert into tbl_inv_allocidresource values('1','testPool','testLabel2',NULL,'c71c103d-075e-4c2a-bc29-36761d2133fc','1539000904',NULL);
insert into tbl_inv_allocidresource values('2','testPool','testLabel2',NULL,'4fa86c33-768f-437b-afab-1e8bb7008d0f','1539000904',NULL);
insert into tbl_inv_allocidresource values('3','testPool','testLabel2',NULL,'7f097109-d462-4f22-a049-cc5aaab77856','1539000904',NULL);
insert into tbl_inv_allocidresource values('4','testPool','testLabel2',NULL,'506b0ddf-d488-404d-9e19-60d020b63e07','1539000904',NULL);
insert into tbl_inv_allocidresource values('5','testPool','testLabel2',NULL,'eb48cfe8-26ed-43a9-b8c1-28b95e4e2f20','1539000904',NULL);
insert into tbl_inv_allocidresource values('6','testPool','testLabel2',NULL,'3c08a13b-40d0-44a4-992b-a7d1d5f2b461','1539000904',NULL);
insert into tbl_inv_allocidresource values('7','testPool','testLabel2',NULL,'390d9d5a-9fb2-4837-86db-7f3ae21bb795','1539000904',NULL);
insert into tbl_inv_allocidresource values('8','testPool','testLabel2',NULL,'d4dc68ac-3d4a-4cb2-ab91-d07df6f458b0','1539000904',NULL);
insert into tbl_inv_allocidresource values('9','testPool','testLabel2',NULL,'38fb85ee-39cd-4ab5-b060-a1e8671c68ba','1539000904',NULL);
insert into tbl_inv_allocidresource values('10','testPool','testLabel2',NULL,'42a023de-e857-41d4-a51b-42b6f8cb617a','1539000904',NULL);
insert into tbl_inv_allocidresource values('11','testPool','testLabel2',NULL,'57bc3d86-4045-4c4f-95c5-e19180d9a7b6','1539000904',NULL);
insert into tbl_inv_allocidresource values('12','testPool','testLabel2',NULL,'63c09ac0-2d84-4673-a06a-9ec1b972da5e','1539000904',NULL);
insert into tbl_inv_allocidresource values('13','testPool','testLabel2',NULL,'de11db3d-ea07-4aa7-a2b1-56724ce312ac','1539000904',NULL);
insert into tbl_inv_allocidresource values('14','testPool','testLabel2',NULL,'8bf16c80-e59b-4e45-8c6e-4414c18e36c7','1539000904',NULL);
insert into tbl_inv_allocidresource values('15','testPool','testLabel2',NULL,'e552cd97-40c3-4574-9594-b6d780cae618','1539000904',NULL);
insert into tbl_inv_allocidresource values('16','testPool','testLabel2',NULL,'4c81bca0-3e88-4c5f-abd3-d96c0857da3e','1539000904',NULL);
insert into tbl_inv_allocidresource values('17','testPool','testLabel2',NULL,'db0576f7-63b7-48ec-9dda-9df6c8d660da','1539000904',NULL);
insert into tbl_inv_allocidresource values('18','testPool','testLabel2',NULL,'b606d5a6-87ff-4d4e-9eb0-4df59e4cf7a6','1539000904',NULL);
insert into tbl_inv_allocidresource values('19','testPool','testLabel2',NULL,'153e6f47-7e8a-4bb7-978e-88891c10b163','1539000904',NULL);
insert into tbl_inv_allocidresource values('20','testPool','testLabel2',NULL,'61b14d40-e808-4607-9370-7dccaf6d43f8','1539000904',NULL);
insert into tbl_inv_allocidresource values('21','testPool','testLabel2',NULL,'22bc3da6-59d7-465e-9cde-6cd76c6401bb','1539000904',NULL);
insert into tbl_inv_allocidresource values('22','testPool','testLabel2',NULL,'b76a2932-7306-4a42-b280-b01ff99c5dbe','1539000904',NULL);
insert into tbl_inv_allocidresource values('23','testPool','testLabel2',NULL,'60df2c4a-4af3-49a6-9f1c-d3749be8bfc0','1539000904',NULL);
insert into tbl_inv_allocidresource values('24','testPool','testLabel2',NULL,'fa8be305-8096-4fc1-9d3e-32642fafaf8d','1539000904',NULL);
insert into tbl_inv_allocidresource values('25','testPool','testLabel2',NULL,'5e206a87-93f4-49e4-8f04-36934053324a','1539000904',NULL);
insert into tbl_inv_allocidresource values('26','testPool','testLabel2',NULL,'b3ccca64-a370-42c3-b1ba-a1b1086dbac4','1539000904',NULL);
insert into tbl_inv_allocidresource values('27','testPool','testLabel2',NULL,'e8d49d1d-edfc-4ced-8794-9b28a63a2e37','1539000904',NULL);
insert into tbl_inv_allocidresource values('28','testPool','testLabel2',NULL,'d22d0ee3-e7df-4b0a-94c2-e1b16bca39b3','1539000904',NULL);
insert into tbl_inv_allocidresource values('29','testPool','testLabel2',NULL,'8dd39536-f4b9-4010-966d-e11a56b2b2c4','1539000904',NULL);
insert into tbl_inv_allocidresource values('30','testPool','testLabel2',NULL,'8f0039de-819d-469f-a940-6f15c90296d2','1539000904',NULL);
insert into tbl_inv_allocidresource values('31','testPool','testLabel2',NULL,'0a526116-48d7-4038-8935-b5708d8d8386','1539000904',NULL);
insert into tbl_inv_allocidresource values('32','testPool','testLabel2',NULL,'7b298b5e-45d4-470b-a927-9b8cf2363ab1','1539000904',NULL);
insert into tbl_inv_allocidresource values('33','testPool','testLabel2',NULL,'a0f77202-f41d-4dc8-a2af-6f3ae66b2125','1539000904',NULL);
insert into tbl_inv_allocidresource values('34','testPool','testLabel2',NULL,'7be911c8-56a5-4be5-9719-d3a6ae2c26ed','1539000904',NULL);
insert into tbl_inv_allocidresource values('35','testPool','testLabel2',NULL,'58bb7084-b553-46a7-8d25-0b4c59d287c1','1539000904',NULL);
insert into tbl_inv_allocidresource values('36','testPool','testLabel2',NULL,'3672d985-066e-486d-b0f3-dd7ce739640b','1539000904',NULL);
insert into tbl_inv_allocidresource values('37','testPool','testLabel2',NULL,'3b72d474-6554-4933-99b7-eadf112de564','1539000904',NULL);
insert into tbl_inv_allocidresource values('38','testPool','testLabel2',NULL,'6fe23dff-83f7-4d84-ad1d-26a14507e92e','1539000904',NULL);
insert into tbl_inv_allocidresource values('39','testPool','testLabel2',NULL,'8a12ea20-ead1-4db3-b2bd-ab50963eac8a','1539000904',NULL);
insert into tbl_inv_allocidresource values('40','testPool','testLabel2',NULL,'9b50cec9-d7c9-498c-886e-0242fc3282e3','1539000904',NULL);
insert into tbl_inv_allocidresource values('41','testPool','testLabel2',NULL,'cdac5e35-c6c5-4651-86c5-dca6e49b390c','1539000904',NULL);
insert into tbl_inv_allocidresource values('42','testPool','testLabel2',NULL,'bbaf1cf6-e804-44fe-b93e-a0476f42bc65','1539000904',NULL);
insert into tbl_inv_allocidresource values('43','testPool','testLabel2',NULL,'dc7134fb-e8cc-4f87-a87c-61d3bb407358','1539000904',NULL);
insert into tbl_inv_allocidresource values('44','testPool','testLabel2',NULL,'25c900ce-9434-4d29-bf90-720646a7a43d','1539000904',NULL);
insert into tbl_inv_allocidresource values('45','testPool','testLabel2',NULL,'5e0c991d-374d-4754-b05d-aa42761a24ac','1539000904',NULL);
insert into tbl_inv_allocidresource values('46','testPool','testLabel2',NULL,'15591422-6194-436b-94c0-38ecbdaf2170','1539000904',NULL);
insert into tbl_inv_allocidresource values('47','testPool','testLabel2',NULL,'c5603a6e-5f5b-41d9-9a37-84746e80887f','1539000904',NULL);
insert into tbl_inv_allocidresource values('48','testPool','testLabel2',NULL,'7d958cc0-4f23-46ba-bcba-27ffbfa3017e','1539000904',NULL);
insert into tbl_inv_allocidresource values('49','testPool','testLabel2',NULL,'ec7d439a-74c7-4b4f-8c73-113da0dbb155','1539000904',NULL);
insert into tbl_inv_allocidresource values('50','testPool','testLabel2',NULL,'fad0e168-a640-48d3-a912-2db0589ed2d1','1539000904',NULL);
insert into tbl_inv_allocidresource values('52','testPool','testLabel2',NULL,'8c589ca4-c085-4a4f-940f-15f14e8e6b3a','1539002111',NULL);
insert into tbl_inv_allocidresource values('53','testPool','testLabel2',NULL,'796b45fa-8980-4c29-b115-ed357ab62908','1539002111',NULL);
insert into tbl_inv_allocidresource values('54','testPool','testLabel2',NULL,'c77f2081-3c53-4306-95d4-747ff89efe4f','1539002111',NULL);
insert into tbl_inv_allocidresource values('55','testPool','testLabel2',NULL,'2c42d948-5cee-4ffe-8d5a-7b74e528f009','1539002111',NULL);
insert into tbl_inv_allocidresource values('56','testPool','testLabel2',NULL,'40da2f8d-7854-41ea-b564-bae450677cc6','1539002111',NULL);
SELECT MAX(idres) AS usedmaxid FROM tbl_inv_allocidresource WHERE poolname='testPool' for update;
SELECT idres AS usedmaxid FROM tbl_inv_allocidresource WHERE poolname='testPool' for update;

-- 查询系统动态视图带for update子句产生core
create user user_test_for_update identified by Cantian_234;
grant dba to user_test_for_update;
conn user_test_for_update/Cantian_234@127.0.0.1:1611
select * from all_tables for update;
select * from user_users for update;
conn / as sysdba
drop user user_test_for_update cascade;
