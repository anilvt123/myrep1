drop database link SOAUAT2
create database link SOAUAT2 connect to c022427 identified by S0a2016$1 using 'SOAUAT2';
select * from tab@SOAUAT2

select TABLE_NAME,COLUMN_NAME,GENERATION_TYPE,IDENTITY_OPTIONS from DBA_TAB_IDENTITY_COLS where table_name='FMW1221_MDS';
select TABLE_NAME,COLUMN_NAME,GENERATION_TYPE,IDENTITY_OPTIONS from DBA_TAB_IDENTITY_COLS where owner='FMW1221_MDS';
select owner,TABLE_NAME,COLUMN_NAME,GENERATION_TYPE,IDENTITY_OPTIONS from DBA_TAB_IDENTITY_COLS where owner in
('FMW1221_ESS','FMW1221_IAU','FMW1221_MDS','FMW1221_MFT','FMW1221_OPSS','FMW1221_SOAINFRA','FMW1221_WLS','SOAINTERNAL');
--8 seq for soainternal with identity id
select * from DBA_TAB_IDENTITY_COLS
select sequence_name, last_number from dba_sequences where sequence_owner='SOAINTERNAL' order by 2 desc;
SELECT DBMS_METADATA.GET_DDL(upper('SEQUENCE'), upper('TRANS_SEQ') , upper('SOAINTERNAL'))  ddl_string from dual
select object_name,object_type,object_id from dba_objects where object_id=92697;

select * from dba_sequences where 
sequence_owner  in 
('FMW1221_ESS','FMW1221_IAU','FMW1221_MDS','FMW1221_MFT','FMW1221_OPSS','FMW1221_SOAINFRA','FMW1221_WLS','SOAINTERNAL')
order by sequence_owner,sequence_name;
--8 schemas 67 sequences
FMW1221_ESS
FMW1221_IAU
FMW1221_MDS
FMW1221_MFT
FMW1221_OPSS
FMW1221_SOAINFRA
FMW1221_WLS
SOAINTERNAL


--NOTIN
select 
A.sequence_owner,A.sequence_name  
from 
dba_sequences A, 
dba_sequences@SOAUAT2 B
where 
( A.sequence_name=B.sequence_name AND A.sequence_owner=B.sequence_owner) AND
-- (A.LAST_NUMBER-B.LAST_NUMBER < 0)   AND
--A.sequence_owner in ('SOAINTERNAL');
A.sequence_owner in
('FMW1221_ESS','FMW1221_IAU','FMW1221_MDS','FMW1221_MFT','FMW1221_OPSS','FMW1221_SOAINFRA','FMW1221_WLS','SOAINTERNAL') and
A.sequence_name  NOT IN 
(
select C.sequence_name 
from dba_sequences C 
where 
C.sequence_owner in ('FMW1221_ESS','FMW1221_IAU','FMW1221_MDS','FMW1221_MFT','FMW1221_OPSS','FMW1221_SOAINFRA','FMW1221_WLS','SOAINTERNAL')
);


select 
A.sequence_owner||'.'||A.sequence_name localseq ,
B.sequence_owner||'.'||B.sequence_name remoteseq ,
A.Last_number local_seq_value,
B.Last_number remote_seq_value,
(A.Last_number-B.Last_number) diff1,
(B.Last_number-A.Last_number) diff2
from 
dba_sequences A, 
dba_sequences@SOAUAT2 B
where 
( A.sequence_name=B.sequence_name AND A.sequence_owner=B.sequence_owner) AND
-- (A.LAST_NUMBER-B.LAST_NUMBER < 0)   AND
--A.sequence_owner in ('SOAINTERNAL');
A.sequence_owner in
--('FMW1221_ESS','FMW1221_IAU','FMW1221_MDS','FMW1221_MFT','FMW1221_OPSS','FMW1221_SOAINFRA','FMW1221_WLS','SOAINTERNAL')
(
 'SOAINTERNAL',
'FMW1221_SOAINFRA',
'FMW1221_ESS',
'FMW1221_IAU',
'FMW1221_IAU_APPEND',
'FMW1221_IAU_VIEWER',
'FMW1221_MDS',
'FMW1221_MFT',
'FMW1221_OPSS',
'FMW1221_STB',
'FMW1221_UMS',
'FMW1221_WLS',
'FMW1221_WLS_RUNTIME',
'TLOGS',
'JMS' )
order by B.sequence_owner,B.sequence_name


select 
A.sequence_owner,A.sequence_name,
A.Last_number local_seq_value,
A.Last_number
from 
dba_sequences A
where 
A.sequence_owner in
(
 'SOAINTERNAL',
'FMW1221_SOAINFRA',
'FMW1221_ESS',
'FMW1221_IAU',
'FMW1221_IAU_APPEND',
'FMW1221_IAU_VIEWER',
'FMW1221_MDS',
'FMW1221_MFT',
'FMW1221_OPSS',
'FMW1221_STB',
'FMW1221_UMS',
'FMW1221_WLS',
'FMW1221_WLS_RUNTIME',
'TLOGS',
'JMS' )
order by A.sequence_owner,A.sequence_name

 'SOAINTERNAL',
'FMW1221_SOAINFRA',
'FMW1221_ESS',
'FMW1221_IAU',
'FMW1221_IAU_APPEND',
'FMW1221_IAU_VIEWER',
'FMW1221_MDS',
'FMW1221_MFT',
'FMW1221_OPSS',
'FMW1221_STB',
'FMW1221_UMS',
'FMW1221_WLS',
'FMW1221_WLS_RUNTIME',
'TLOGS',
'JMS' )
 
select 
B.sequence_owner||','||B.sequence_name seq ,
A.Last_number local_seq_value,
B.Last_number remote_seq_value,
(B.Last_number-A.Last_number) diff
from 
dba_sequences A, 
dba_sequences@SOAUAT2 B
where 
( A.sequence_name=B.sequence_name AND A.sequence_owner=B.sequence_owner) AND
-- (A.LAST_NUMBER-B.LAST_NUMBER > 0)   AND
--A.sequence_owner in ('SOAINTERNAL');
--A.sequence_owner in ('FMW1221_SOAINFRA');


select distinct sequence_owner  from dba_sequences where 
sequence_owner not in 
('SYS','SYSTEM','DBSNMP','WMSYS','CTXSYS','XDB','ORDDATA','MDSYS','OLAPSYS','APEX_030200','HR','OE','IX'
,'APEX_040200','GSMADMIN_INTERNAL','OGGADM1','OJVMSYS','OSR','OSR2','SOA1_ESS','SOA1_IAU','SOA1_MDS','SOA1_OPSS','SOA2_MDS',
'SOA2_WLS','MFT1_ESS','MFT1_IAU','MFT1_MDS','MFT1_OPSS','MFT1_OPSS','MFT2_IAU','MFT2_MDS','MFT2_OPSS','SOA1_WLS',
'SOA2_ESS','SOA2_IAU','SOA2_SOAINFRA','MFT2_ESS','SOA1_SOAINFRA')
order by sequence_owner
-- 8 schemas
FMW1221_ESS
FMW1221_IAU
FMW1221_MDS
FMW1221_MFT
FMW1221_OPSS
FMW1221_SOAINFRA
FMW1221_WLS
SOAINTERNAL

select distinct sequence_owner  from dba_sequences where 
sequence_owner not in 
('FMW1221_ESS','FMW1221_IAU','FMW1221_MDS','FMW1221_MFT','FMW1221_OPSS','FMW1221_SOAINFRA','FMW1221_WLS','SOAINTERNAL')
order by sequence_owner;

select count(*) from oggadm1.exceptions; --uat1 715954


