Test1_1.

create table c022427.Test_1_1to2 ( a number );
insert into c022427.Test_1_1to2 values(1);
commit;
select * from c022427.Test_1_1to2

select * from c022427.Test_1_2to1

select * from c022427.Test_2_2to1

select * from c022427.Test_3_2to1
select * from c022427.Test_4_2to1

select * from tab


select * from tab
drop table ANIL1TO2 purge
drop table ANIL2TO1 purge
drop table BIG_TABLE purge
drop table BIG_TABLE2 purge
GG_HEARTBEAT
GG_HEARTBEAT_HISTORY
GG_HEARTBEAT_SEED
GG_LAG
GG_LAG_HISTORY
drop table TEST_1_1TO2
drop table TEST_1_2TO1
drop table TEST_TABLE_FOR_REPLICATION1
drop table TRIG_TEST

select * from c022427.j2

------------------------------



 drop table big_table CASCADE CONSTRAINTS PURGE;
 drop table test_table_for_replication1 CASCADE CONSTRAINTS PURGE;
 
 select user from dual;
 SELECT SYS_CONTEXT('USERENV','OS_USER') FROM DUAL;
 
 --step1 
select count(*) from big_table;

create table big_table
as
select rownum id,
               OWNER, OBJECT_NAME, SUBOBJECT_NAME,
               OBJECT_ID, DATA_OBJECT_ID,
               OBJECT_TYPE, CREATED, LAST_DDL_TIME,
               TIMESTAMP, STATUS, TEMPORARY,
               GENERATED, SECONDARY
  from all_objects a
 where 1=0;

alter table big_table nologging;

insert /*+ append */
    into big_table
    select rownum,
               OWNER, OBJECT_NAME, SUBOBJECT_NAME,
               OBJECT_ID, DATA_OBJECT_ID,
               OBJECT_TYPE, CREATED, LAST_DDL_TIME,
               TIMESTAMP, STATUS, TEMPORARY,
               GENERATED, SECONDARY
      from all_objects a
     where rownum <= 100000;
     
     commit;
     
execute dbms_stats.gather_table_stats ( ownname => user,tabname => 'big_table' , cascade => TRUE ); 

select count(*) from big_table;     

--step2
CREATE TABLE test_table_for_replication1 AS
SELECT LEVEL id, SYSDATE+DBMS_RANDOM.VALUE(-1000, 1000) date_value, DBMS_RANDOM.string('A', 20) text_value
FROM dual
CONNECT BY LEVEL <= 100000;

--alter table test_table_for_replication1 add constraint big_table_pk primary key(id)
execute dbms_stats.gather_table_stats ( ownname => user,tabname => 'test_table_for_replication1' , cascade => TRUE ); 
select count(*) from test_table_for_replication1;


--Trigger test from source to target 

CREATE TABLE Trig_test ( info VARCHAR2(100));

--create trigger on both ends
CREATE OR REPLACE TRIGGER big_table_after_insert
AFTER INSERT
   ON big_table
   FOR EACH ROW
DECLARE
BEGIN
   INSERT INTO Trig_test  VALUES ( 'Data Inserted') ;
END;

select count(*) from Trig_test;     
select count(*) from big_table; 

--insert dummy data 
insert /*+ append */
    into big_table
    select rownum,
               OWNER, OBJECT_NAME, SUBOBJECT_NAME,
               OBJECT_ID, DATA_OBJECT_ID,
               OBJECT_TYPE, CREATED, LAST_DDL_TIME,
               TIMESTAMP, STATUS, TEMPORARY,
               GENERATED, SECONDARY
      from all_objects a
     where rownum <= 2;
     
     commit;

select count(*) from Trig_test;     
select count(*) from big_table; 

select count(*) from big_table2;  
select count(*) from big_table22;  

select count(*) from test_table_for_replication2;



create table c022427.anilk1to2 ( a number );
insert into c022427.anilk1to2 values(4);
commit;

select * from c022427.anilk1to2

create table TLOGS.Test1to2 ( a number );
insert into TLOGS.Test1to2 values(1);
commit;
select * from TLOGS.Test1to2;
select count(*) from soainternal.soa_ack; --37832
select count(*) from soainternal.soa_ack; --37833
select count(*) from soainternal.soa_ack; --37838
select count(*) from soainternal.soa_ack; --37847 ran 5 show 9

select count(*) from fmw1221_soainfra.cube_instance; --64602
select count(*) from fmw1221_soainfra.cube_instance; --64612 10 records

select count(*) from fmw1221_soainfra.sca_flow_instance; --31687
select count(*) from fmw1221_soainfra.sca_flow_instance; --31692  5 records


select * from TLOGS.Test2to1;

drop table oggadm1.exceptions purge

CREATE TABLE oggadm1.EXCEPTIONS
(
 excp_date timestamp(6) default systimestamp,
 rep_name varchar2(10),
 table_name varchar2(56),
 errno number,
 dberrmsg varchar2(4000),
 errtype varchar2(6),
 optype varchar2(24),
 transind varchar2(12),
 transimgind varchar2(8),
 committimestamp varchar2(26),
 reccsn number,
 recseqno number,
 recrba number,
 rectranspos number,
 reclength number,
 logrba number,
 logposition number,
 grouptype varchar2(12),
 filename varchar2(50),
 fileno number,
 srcrowid varchar2(40),
 srcdbcharset varchar2(40),
 replag number,
 cnt_cdr_conflicts number,
 cnt_cdr_resolutions number,
 cnt_cdr_failed number 
);

select * from oggadm1.EXCEPTIONS;

select count(*) from oggadm1.EXCEPTIONS;
