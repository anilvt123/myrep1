DDLOPTIONS ADDTRANDATA RETRYOP RETRYDELAY 10 MAXRETRIES 10
DBOPTIONS SUPPRESSTRIGGERS DEFERREFCONST
ADD TRANDATA acct ALLCOLS

truncate table c022427.exceptions;
drop database link SOAUAT1
create database link SOAUAT1 connect to c022427 identified by S0a2016$1 using 'SOAUAT1';

select count(*) from oggadm1.exceptions; --uat1 715954

drop database link SOAUAT2
create database link SOAUAT2 connect to c022427 identified by S0a2016$1 using 'SOAUAT2';
drop database link SOAUAT1
create database link SOAUAT1 connect to c022427 identified by S0a2016$1 using 'SOAUAT1';



 select * from v$nls_parameters where parameter like '%NLS_CHARACTERSET%'
 SELECT * from NLS_DATABASE_PARAMETERS; 
 select * from v$spparameter where name like '%process%'
   select * from v$spparameter where name like '%target%'
      select * from v$spparameter where name like '%cache%'
            select * from v$spparameter where name like '%comp%'

select component, oper_type, parameter, initial_size, target_size, final_size from v$sga_resize_ops where component like '%streams%'
select * from v$sga_resize_ops where component like '%streams%' order by start_time desc
SELECT NAME, BYTES   FROM   v$sgainfo where name like '%Streams%';
-- First make sure there is enough free space to increase the Streams pool
 SELECT CURRENT_SIZE/1024/1024 FREESPACE_MB FROM V$SGA_DYNAMIC_FREE_MEMORY; 
 Select current_size from v$sga_dynamic_components where component = 'streams pool';
 select name, thread#, sequence# from v$archived_log order by 3 desc; 
 select name, thread#, sequence# from v$archived_log  where 1855798 between first_change# and next_change#; 

http://docs.oracle.com/goldengate/c1221/gg-winux/GWUAD/wu_adminops.htm#GWUAD982

select START_DATE, LAST_START_DATE, NEXT_RUN_DATE from dba_scheduler_jobs  Where job_name ='GG_UPDATE_HEARTBEATS';

Configuration Views
select * from   DBA_GOLDENGATE_PRIVILEGES
select * from   DBA_GOLDENGATE_SUPPORT_MODE

select * from   DBA_CAPTURE
select * from     DBA_CAPTURE_PARAMETERS
select * from    DBA_APPLY_PARAMETERS

select * from   DBA_GOLDENGATE_INBOUND
select * from   DBA_GG_INBOUND_PROGRESS
select * from   DBA_APPLY

select * from   DBA_APPLY_REPERROR_HANDLERS
select * from   DBA_APPLY_HANDLE_COLLISIONS
select * from   DBA_APPLY_DML_CONF_HANDLERS


Run Time Views

select * from   V$GOLDENGATE_CAPTURE
select * from   V$GG_APPLY_RECEIVER
select * from   V$GG_APPLY_READER
select * from  V$GG_APPLY_COORDINATOR
select * from  V$GG_APPLY_SERVER

select * from   V$GOLDENGATE_TABLE_STATS
select * from  V$GOLDENGATE_CAPABILITIES

Configuration Views
– DBA_GOLDENGATE_PRIVILEGES
– DBA_GOLDENGATE_SUPPORT_MODE
– DBA_CAPTURE, DBA_CAPTURE_PARAMETERS
– DBA_GOLDENGATE_INBOUND
– DBA_GG_INBOUND_PROGRESS
– DBA_APPLY, DBA_APPLY_PARAMETERS
– DBA_APPLY_REPERROR_HANDLERS
– DBA_APPLY_HANDLE_COLLISIONS
– DBA_APPLY_DML_CONF_HANDLERS


Run Time Views
– V$GOLDENGATE_CAPTURE
– V$GG_APPLY_RECEIVER
– V$GG_APPLY_READER
– V$GG_APPLY_COORDINATOR
– V$GG_APPLY_SERVER
– V$GOLDENGATE_TABLE_STATS
– V$GOLDENGATE_CAPABILITIES

REGISTER EXTRACT eicx LOGRETENTION
SELECT capture_name, start_scn, required_checkpoint_scn, capture_type FROM dba_capture
https://community.oracle.com/thread/2476622?tstart=0
INFO eicx, SHOWCH
SELECT sequence#, first_change#, next_change# FROM v$archived_log ORDER BY sequence# DESC;
http://oradbatips.blogspot.com/2012/09/tip-101-goldengate-and-archivelog.html

select 'arch',sequence#,first_time,next_time,RESETLOGS_TIME from v$archived_log where &your_scn between first_change# and next_change#
union all
select 'log-hist',sequence#,first_time,null,RESETLOGS_TIME from v$log_history where &your_scn between first_change# and next_change#
union all
select 'log-current',sequence#,first_time,next_time,null from v$log where &your_scn between first_change# and next_change#

select session_restart_scn from v$streams_capture;

select 'arch',sequence#,first_time,next_time,RESETLOGS_TIME from v$archived_log order by 2 desc
union all
select 'log-hist',sequence#,first_time,null,RESETLOGS_TIME from v$log_history order by 2 desc
union all
select 'log-current',sequence#,first_time,next_time,null from v$log order by 2 desc

http://www.redstk.com/goldengate-bounded-recovery-and-log-retention/




