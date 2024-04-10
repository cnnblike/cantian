 drop table if exists call_center_test_tab1;
create table call_center_test_tab1
(
    cc_call_center_sk         integer               not null,
    cc_call_center_id         char(16)              not null,
    cc_rec_start_date         date                          ,
    cc_rec_end_date           date                          ,
    cc_closed_date_sk         integer                       ,
    cc_open_date_sk           integer                       ,
    cc_name                   varchar(50)                   ,
    cc_class                  varchar(50)                   ,
    cc_employees              integer                       ,
    cc_sq_ft                  integer                       ,
    cc_hours                  char(20)                      ,
    cc_manager                varchar(40)                   ,
    cc_mkt_id                 integer                       ,
    cc_mkt_class              char(50)                      ,
    cc_mkt_desc               varchar(100)                  ,
    cc_market_manager         varchar(40)                   ,
    cc_division               integer                       ,
    cc_division_name          varchar(50)                   ,
    cc_company                integer                       ,
    cc_company_name           char(50)                      ,
    cc_street_number          char(10)                      ,
    cc_street_name            varchar(60)                   ,
    cc_street_type            char(15)                      ,
    cc_suite_number           char(10)                      ,
    cc_city                   varchar(60)                   ,
    cc_county                 varchar(30)                   ,
    cc_state                  char(2)                       ,
    cc_zip                    char(10)                      ,
    cc_country                varchar(20)                   ,
    cc_gmt_offset             decimal(5,2)                  ,
    cc_tax_percentage         decimal(5,2)
 );
 
drop table if exists web_site_test_tab2;
create table web_site_test_tab2
(
    web_site_sk               integer               not null,
    web_site_id               char(16)              not null,
    web_rec_start_date        date                          ,
    web_rec_end_date          date                          ,
    web_name                  varchar(50)                   ,
    web_open_date_sk          integer                       ,
    web_close_date_sk         integer                       ,
    web_class                 varchar(50)                   ,
    web_manager               varchar(40)                   ,
    web_mkt_id                integer                       ,
    web_mkt_class             varchar(50)                   ,
    web_mkt_desc              varchar(100)                  ,
    web_market_manager        varchar(40)                   ,
    web_company_id            integer                       ,
    web_company_name          char(50)                      ,
    web_street_number         char(10)                      ,
    web_street_name           varchar(60)                   ,
    web_street_type           char(15)                      ,
    web_suite_number          char(10)                      ,
    web_city                  varchar(60)                   ,
    web_county                varchar(30)                   ,
    web_state                 char(2)                       ,
    web_zip                   char(10)                      ,
    web_country               varchar(20)                   ,
    web_gmt_offset            decimal(5,2)                  ,
    web_tax_percentage        decimal(5,2)
 )
 partition by range(web_rec_start_date)
(
        partition p1 values less than('1990-01-01'),
        partition p2 values less than('1995-01-01'),
        partition p3 values less than('2000-01-01'),
        partition p4 values less than('2005-01-01'),
        partition p5 values less than('2010-01-01'),
        partition p6 values less than('2015-01-01'),
        partition p7 values less than(maxvalue)
);

drop table if exists store_test_tab3;
create table store_test_tab3
(
    s_store_sk                integer               not null,
    s_store_id                char(16)              not null,
    s_rec_start_date          date                          ,
    s_rec_end_date            date                          ,
    s_closed_date_sk          integer                       ,
    s_store_name              varchar(50)                   ,
    s_number_employees        integer                       ,
    s_floor_space             integer                       ,
    s_hours                   char(20)                      ,
    s_manager                 varchar(40)                   ,
    s_market_id               integer                       ,
    s_geography_class         varchar(100)                  ,
    s_market_desc             varchar(100)                  ,
    s_market_manager          varchar(40)                   ,
    s_division_id             integer                       ,
    s_division_name           varchar(50)                   ,
    s_company_id              integer                       ,
    s_company_name            varchar(50)                   ,
    s_street_number           varchar(10)                   ,
    s_street_name             varchar(60)                   ,
    s_street_type             char(15)                      ,
    s_suite_number            char(10)                      ,
    s_city                    varchar(60)                   ,
    s_county                  varchar(30)                   ,
    s_state                   char(2)                       ,
    s_zip                     char(10)                      ,
    s_country                 varchar(20)                   ,
    s_gmt_offset              decimal(5,2)                  ,
    s_tax_precentage          decimal(5,2)
 );

drop table if exists customer_test_tab4;
create table customer_test_tab4
(
    c_customer_sk             integer               not null,
    c_customer_id             char(16)              not null,
    c_current_cdemo_sk        integer                       ,
    c_current_hdemo_sk        integer                       ,
    c_current_addr_sk         integer                       ,
    c_first_shipto_date_sk    integer                       ,
    c_first_sales_date_sk     integer                       ,
    c_salutation              char(10)                      ,
    c_first_name              char(20)                      ,
    c_last_name               char(30)                      ,
    c_preferred_cust_flag     char(1)                       ,
    c_birth_day               integer                       ,
    c_birth_month             integer                       ,
    c_birth_year              integer                       ,
    c_birth_country           varchar(20)                   ,
    c_login                   char(13)                      ,
    c_email_address           char(50)                      ,
    c_last_review_date        char(10)
);

insert into customer_test_tab4 values(1,'AAAAAAAABAAAAAAA',980124,7135,32946,2452238,2452208,'Mr. '      ,'Javier '             ,'Lewis'                         ,'Y',9,12,1936,'CHILE','','Javier.Lewis@VFAxlnZEvOx.org'                      ,'2452508');   

insert into store_test_tab3 values(1,'AAAAAAAABAAAAAAA','1997-03-13 00:00:00','',2451189,'ought',245,5250760,'8AM-4PM'             ,'William Ward',2,'Unknown','Enough high areas stop expectations. Elaborate  local is','Charles Bartley',1,'Unknown',1,'Unknown',767,'Spring','Wy '            ,'Suite 250' ,'Midway','Williamson County','TN',31904     ,'United States',-5.00,.03);

insert into web_site_test_tab2 values(5,'AAAAAAAAEAAAAAAA','1999-08-17 00:00:00','2001-08-15 00:00:00','site_0',2450781,2448956,'Unknown','Harold Wilson',5,'Wide  final representat','Deeply small books cannot extend all similar  clear historians. Free  new camp','Edward George',1,'ought'                                             ,805       ,'2nd 3rd','Road '          ,'Suite R '  ,'Fairview','Williamson County','TN',31904     ,'United States',-5.00,.08);

insert into call_center_test_tab1 values(1,'AAAAAAAABAAAAAAA','1998-01-01 00:00:00','','',2450952,'NY Metro','large',2,1138,'8AM-4PM'            ,'Bob Belcher',6,'More than other authori'                           ,'Shared others could not count fully dollars. New members ca','Julius Tran',3,'pri',6,'cally'                                            ,730       ,'Ash Hill','Boulevard '     ,'Suite 0   ','Midway','Williamson County','TN',31904     ,'United States',-5.00,.11);

select count(1), cc_mkt_id from call_center_test_tab1 
where cc_mkt_id in (select (select trunc(avg(c_birth_day)) from customer_test_tab4 where c_birth_country like '%J%') - 10  from store_test_tab3 left join web_site_test_tab2 on s_market_id = length(web_company_name) where s_store_sk < 100) 
group by cc_mkt_id order by 1, 2;