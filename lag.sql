select * from tab
select * from gg_lag
SELECT * FROM identity_test_tab;
select * from  C022427.HEARTBEAT;
select * from  C022427.GGS_HEARTBEAT;
select * from  C022427.GGS_HEARTBEAT_HISTORY;

select * from  oggadm1.GG_HEARTBEAT_SEED;
select * from  oggadm1."GG_HEARTBEAT";
select * from  oggadm1.GG_HEARTBEAT_HISTORY
select * from all_tables where table_name like '%FLOW_INSTANCE%'

select count(*) from fmw1221_soainfra.cube_instance order by creation_date desc; --284620
select count(*) from soainternal.soa_ack order by creation_ts desc ; --90001
select count(*) from soainternal.soa_trans_log  ; --204
select count(*) from fmw1221_soainfra.SCA_FLOW_INSTANCE  ; --139941


select count(*) from fmw1221_soainfra.SCA_FLOW_INSTANCE; --139941
select count(*) from fmw1221_soainfra.CUBE_INSTANCE; --284620
select count(*) from Soainternal.SOA_TRANS_LOG ; --204
select count(*) from Soainternal.SOA_request_status ; --204


select count(*) from soainternal.soa_ack order by creation_ts desc ; --39768,39770
select count(*) from tlogs.TLOG_WLS_SOACT1_WLSTORE  
select count(*) from Soainternal.SOA_TRANS_LOG 
select * from soainternal.Test56 order by 1 desc

select count(*) from soainternal.soa_trans_log  ; --204


select count(*) from oggadm1.EXCEPTIONS
select * from oggadm1.EXCEPTIONS order by 1 desc
--truncate table oggadm1.EXCEPTIONS;

grant select on 

select * from TestAk1
insert into TestAk1 values (3,'anil','ak');
commit;
rollback
select * from TestAk1


select * from Test1_2 order by 1 desc

select * from TLOGS.Test1_2 order by 1 desc

select * from Test1_3 order by 1 desc
select * from Test1_4 order by 1 desc


select count(*) from test_table_for_replication2;

select count(*) from test_table_for_replication3;


select * from TLOGS.Test1_3 order by 1 desc

select *  from soainternal.soa_ack order by creation_ts desc

select count(*) from fmw1221_soainfra.cube_instance order by creation_date desc; --64612 ,65653,66183,66187

select count(*) from soainternal.soa_ack order by creation_ts desc ; --39768,39770


select count(*) from test_table_for_replication4;

drop table test_table_for_replication3 purge;
 
 CREATE SEQUENCE SEQ_GGS_UD_HEARTBEAT_ID INCREMENT BY 1 START WITH 1 ORDER;


 select * from C022427.GGS_UD_HEARTBEAT_HISTORY
 SELECT * FROM C022427.GGS_UD_HEARTBEAT;   
SELECT CAPLAG,PMPLAG, DELLAG FROM C022427.GGS_UD_HEARTBEAT;   
 
  CREATE SEQUENCE C022427.SEQ_GGS_UD_HEARTBEAT_HIST INCREMENT BY 1 START WITH 1 ORDER ;
  
   CREATE TABLE C022427.GGS_UD_HEARTBEAT_HISTORY
 (
 ID NUMBER ,
SRC_DB VARCHAR2(30),
EXTRACT_NAME varchar2(8),
SOURCE_COMMIT TIMESTAMP,
TARGET_COMMIT TIMESTAMP, 
CAPTIME TIMESTAMP, 
CAPLAG NUMBER,
PMPTIME TIMESTAMP,
PMPGROUP VARCHAR2(8 BYTE),
PMPLAG NUMBER, 
DELTIME TIMESTAMP, 
DELGROUP VARCHAR2(8 BYTE),
DELLAG NUMBER, 
TOTALLAG 	NUMBER,
thread number,
update_timestamp timestamp,
EDDLDELTASTATS	number, 
EDMLDELTASTATS	number,
RDDLDELTASTATS	number, 
RDMLDELTASTATS	number, 
CONSTRAINT GGS_UD_HEARTBEAT_HIST_PK PRIMARY KEY (ID) ENABLE );


select * from c022427.HEARTBEAT

select db_unique_name from V$database;

CREATE TABLE c022427.GGS_HEARTBEAT
( ID NUMBER ,
SRC_DB VARCHAR2(30),
EXTRACT_NAME varchar2(8),
SOURCE_COMMIT TIMESTAMP,
TARGET_COMMIT TIMESTAMP,
CAPTIME TIMESTAMP,
CAPLAG NUMBER,
PMPTIME TIMESTAMP,
PMPGROUP VARCHAR2(8 BYTE),
PMPLAG NUMBER,
DELTIME TIMESTAMP,
DELGROUP VARCHAR2(8 BYTE),
DELLAG NUMBER,
TOTALLAG NUMBER,
thread number,
update_timestamp timestamp,
EDDLDELTASTATS number,
EDMLDELTASTATS number,
RDDLDELTASTATS number,
RDMLDELTASTATS number,
CONSTRAINT GGS_HEARTBEAT_PK PRIMARY KEY (DELGROUP) ENABLE
);

select * from c022427.GGS_HEARTBEAT


CREATE SEQUENCE c022427.SEQ_GGS_HEARTBEAT_ID INCREMENT BY 1 START WITH 1 ORDER ;

CREATE OR REPLACE TRIGGER c022427.GGS_HEARTBEAT_TRIG
BEFORE INSERT OR UPDATE ON GGS_HEARTBEAT
FOR EACH ROW
BEGIN
select seq_ggs_HEARTBEAT_id.nextval
into :NEW.ID
from dual;
select systimestamp
into :NEW.target_COMMIT
from dual;
select trunc(to_number(substr((:NEW.CAPTIME - :NEW.SOURCE_COMMIT ),1,
instr(:NEW.CAPTIME - :NEW.SOURCE_COMMIT,' ')))) * 86400
+ to_number(substr((:NEW.CAPTIME - :NEW.SOURCE_COMMIT), instr((:NEW.CAPTIME -
:NEW.SOURCE_COMMIT),' ')+1,2)) * 3600
+ to_number(substr((:NEW.CAPTIME - :NEW.SOURCE_COMMIT), instr((:NEW.CAPTIME -
:NEW.SOURCE_COMMIT),' ')+4,2) ) * 60
+ to_number(substr((:NEW.CAPTIME - :NEW.SOURCE_COMMIT), instr((:NEW.CAPTIME -
:NEW.SOURCE_COMMIT),' ')+7,2))
+ to_number(substr((:NEW.CAPTIME - :NEW.SOURCE_COMMIT), instr((:NEW.CAPTIME -
:NEW.SOURCE_COMMIT),' ')+10,6)) / 1000000
into :NEW.CAPLAG
from dual;
select trunc(to_number(substr((:NEW.PMPTIME - :NEW.CAPTIME),1,
instr(:NEW.PMPTIME - :NEW.CAPTIME,' ')))) * 86400
+ to_number(substr((:NEW.PMPTIME - :NEW.CAPTIME), instr((:NEW.PMPTIME -
:NEW.CAPTIME),' ')+1,2)) * 3600
+ to_number(substr((:NEW.PMPTIME - :NEW.CAPTIME), instr((:NEW.PMPTIME -
:NEW.CAPTIME),' ')+4,2) ) * 60
+ to_number(substr((:NEW.PMPTIME - :NEW.CAPTIME), instr((:NEW.PMPTIME -
:NEW.CAPTIME),' ')+7,2))
+ to_number(substr((:NEW.PMPTIME - :NEW.CAPTIME), instr((:NEW.PMPTIME -
:NEW.CAPTIME),' ')+10,6)) / 1000000
into :NEW.PMPLAG
from dual;
select trunc(to_number(substr((:NEW.DELTIME - :NEW.PMPTIME),1,
instr(:NEW.DELTIME - :NEW.PMPTIME,' ')))) * 86400
+ to_number(substr((:NEW.DELTIME - :NEW.PMPTIME), instr((:NEW.DELTIME -
:NEW.PMPTIME),' ')+1,2)) * 3600
+ to_number(substr((:NEW.DELTIME - :NEW.PMPTIME), instr((:NEW.DELTIME -
:NEW.PMPTIME),' ')+4,2) ) * 60
+ to_number(substr((:NEW.DELTIME - :NEW.PMPTIME), instr((:NEW.DELTIME -
:NEW.PMPTIME),' ')+7,2))
+ to_number(substr((:NEW.DELTIME - :NEW.PMPTIME), instr((:NEW.DELTIME -
:NEW.PMPTIME),' ')+10,6)) / 1000000
into :NEW.DELLAG
from dual;
select trunc(to_number(substr((:NEW.TARGET_COMMIT - :NEW.SOURCE_COMMIT),1,
instr(:NEW.TARGET_COMMIT - :NEW.SOURCE_COMMIT,' ')))) * 86400
+ to_number(substr((:NEW.TARGET_COMMIT - :NEW.SOURCE_COMMIT),
instr((:NEW.TARGET_COMMIT - :NEW.SOURCE_COMMIT),' ')+1,2)) * 3600
+ to_number(substr((:NEW.TARGET_COMMIT - :NEW.SOURCE_COMMIT),
instr((:NEW.TARGET_COMMIT - :NEW.SOURCE_COMMIT),' ')+4,2) ) * 60
+ to_number(substr((:NEW.TARGET_COMMIT - :NEW.SOURCE_COMMIT),
instr((:NEW.TARGET_COMMIT - :NEW.SOURCE_COMMIT),' ')+7,2))
+ to_number(substr((:NEW.TARGET_COMMIT - :NEW.SOURCE_COMMIT),
instr((:NEW.TARGET_COMMIT - :NEW.SOURCE_COMMIT),' ')+10,6)) / 1000000
into :NEW.TOTALLAG
from dual;
end ;
/

CREATE SEQUENCE c022427.SEQ_GGS_HEARTBEAT_HIST INCREMENT BY 1 START WITH 1 ORDER ;


CREATE TABLE c022427.GGS_HEARTBEAT_HISTORY
( ID NUMBER ,
SRC_DB VARCHAR2(30),
EXTRACT_NAME varchar2(8),
SOURCE_COMMIT TIMESTAMP,
TARGET_COMMIT TIMESTAMP,
CAPTIME TIMESTAMP,
CAPLAG NUMBER,
PMPTIME TIMESTAMP,
PMPGROUP VARCHAR2(8 BYTE),
PMPLAG NUMBER,
DELTIME TIMESTAMP,
DELGROUP VARCHAR2(8 BYTE),
DELLAG NUMBER,
TOTALLAG NUMBER,
thread number,
update_timestamp timestamp,
EDDLDELTASTATS number,
EDMLDELTASTATS number,
RDDLDELTASTATS number,
RDMLDELTASTATS number
);

C022427.HEARTBEAT, TARGET C022427.GGS_HEARTBEAT,
MAP C022427.HEARTBEAT, TARGET C022427.GGS_HEARTBEAT_HISTORY,

select * from  C022427.HEARTBEAT;
select * from  C022427.GGS_HEARTBEAT;
select * from  C022427.GGS_HEARTBEAT_HISTORY;

select * from user_triggers

select * from GGS_HEARTBEAT;
select src_db, extract_name, Caplag, pmplag, dellag, totallag, UPDATE_TIMESTAMP from GGS_HEARTBEAT;
