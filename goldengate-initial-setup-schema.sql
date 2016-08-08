
-- In the Source, make sure all the tables to replicate have key constraint:
select t.owner ,t.table_name from dba_tables t where t.owner in
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
'JMS'
)
--='HR' and
--t.table_name in
--('COUNTRIES','DEPARTMENTS','EMPLOYEES','JOB_HISTORY','JOBS','LOCATIONS','REGIONS')
minus
select c.owner ,c.table_name from dba_constraints c where c.owner in 
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
'JMS'
)
--='HR' 
and
c.constraint_type in ('P','U') order by 1,2;


2.

-- the LOGGING option in the table level should be ENABLED
select owner,table_name from dba_tables where owner in
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
'JMS'
)
--='HR' 
and logging='NO'  order by 1,2
--and
--table_name in
--('COUNTRIES','DEPARTMENTS','EMPLOYEES','JOB_HISTORY','JOBS','LOCATIONS','REGIONS')



-- to enable it:
begin
for r in 
( select owner,table_name from dba_tables where owner in
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
'JMS'
)
and logging='NO' order by 1,2
) loop
execute immediate 'alter table '||r.owner ||'.'|| r.table_name ||' LOGGING';
end loop;
end;


-- to enable it:
begin
for r in ( select table_name from dba_tables where owner='HR' and logging='NO'
and table_name in
('COUNTRIES','DEPARTMENTS','EMPLOYEES','JOB_HISTORY','JOBS','LOCATIONS','REGIO
NS')) loop
execute immediate 'alter table hr.'|| r.table_name ||' LOGGING';
end loop;
end;


3.

-- to generate the script for a group of tables:
set echo off
set verify off
set pagesize 2000
set linesize 250
set trim on
set heading off
set feedback off
spool &&SCHEMA..add_trandata.obey
select 'add trandata &SCHEMA..'||table_name
from dba_tables where owner = '&SCHEMA' ;
spool off
-- to run the script in gg:
GGSCI (WIN11SRC) 1> dblogin userid ggs_owner password g
GGSCI (WIN11SRC) 2> obey diroby/HR.add_trandata.obey

-- to generate the script for a group of tables:
set echo off
set verify off
set pagesize 2000
set linesize 250
set trim on
set heading off
set feedback off
spool &&SCHEMA..add_trandata.obey
select 'add trandata &SCHEMA..'||table_name
from dba_tables where owner = '&SCHEMA' ;
spool off
-- to run the script in gg:
GGSCI (WIN11SRC) 1> dblogin userid ggs_owner password g
GGSCI (WIN11SRC) 2> obey diroby/HR.add_trandata.obey


4.

-- in gg: to confirm the table logging is enabled:
dblogin userid ggs_owner password g
info trandata hr.EMPLOYEES
Page 21 Oracle GoldenGate Hands-on Tutorial
-- in db: to confirm the table logging is enabled:
select owner, log_group_name, table_name
from dba_log_groups where owner = 'HR';
-- to know which column values are being logged:
select * from DBA_LOG_GROUP_COLUMNS where owner = 'HR';
Note: If you use ADD SCHEMATRANDATA command to add the supplement logging, the
information should be obtained from logmnr$always_suplog_columns.
eg: select * from table(logmnr$always_suplog_columns('SCHEMAUSER','T'));
Note: If you find out GG is logging ALL the columns because of the absence of
a key column, adding a key column is not enough to resolve the issue. You need
to do the following as well:
GGSCI> delete trandata hr.EMPLOYEES
GGSCI> add trandata hr.EMPLOYEES


5. 
--In Target: disable triggers and cascade-delete constraints. Use either SUPPRESSTRIGGERS
--option of the Replicate DBOPTIONS parameter or the SQL commands as follows:
-- in Target: disable cascade-delete constraints
select 'alter table '||owner||'.'||table_name||
' disable constraint '||constraint_name||';'
from all_constraints
where delete_rule = 'CASCADE'
 and owner = 'HR';
 
 
-- disable triggers:
select 'alter trigger '||owner||'.'||trigger_name||
' disable ;'
from all_triggers
where owner = 'HR';

select 'alter table '||owner||'.'||table_name||
' disable constraint '||constraint_name||';'
from all_constraints
where delete_rule = 'CASCADE'
 and owner in 
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
'JMS'
)
order by owner,table_name;


6.
--Handling conflicts using CDR feature

-- to confirm in the db side:
SELECT LOG_GROUP_NAME, TABLE_NAME,
DECODE(ALWAYS, 'ALWAYS', 'Unconditional', 'CONDITIONAL', 'Conditional') ALWAYS, LOG_GROUP_TYPE
FROM DBA_LOG_GROUPS;


-- If the type of log group is USER LOG GROUP, then
-- you can list the columns in the log group by:
select OWNER, LOG_GROUP_NAME, TABLE_NAME, COLUMN_NAME, POSITION,LOGGING_PROPERTY
from DBA_LOG_GROUP_COLUMNS
where owner in
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
'JMS'
);


7.

DDLOPTIONS ADDTRANDATA RETRYOP RETRYDELAY 10 MAXRETRIES 10

ADD TRANDATA acct ALLCOLS

select 'info trandata '||owner||'.'||table_name
from dba_tables where 
where owner in
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
'JMS'
) order by 1,2 ;


ADD TRANDATA acct ALLCOLS

select 'ADD TRANDATA '||owner||'.'||table_name||'  ALLCOLS '
from dba_tables  
where owner in
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
'JMS'
) order by owner,table_name ;



select  'ADD SCHEMATRANDATA '||owner||' '||'  ALLCOLS '
from dba_tables  
where owner in
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
'JMS'
) order by owner ;



select 'info trandata '||owner||'.'||table_name||' ALLCOLS '
from dba_tables  
where owner in
(
'SOAINTERNAL'
) order by 1,2 ;


spool &&SCHEMA..add_trandata.obey
select 'add trandata &SCHEMA..'||table_name
from dba_tables where owner = '&SCHEMA' ;
spool off

9.
SELECT supplemental_log_data_min "Minimum",
            supplemental_log_data_pk  "Primary key",
            supplemental_log_data_ui  "Unique Key",
            supplemental_log_data_fk  "Foregin Key",
            supplemental_log_data_all "All"
     FROM   v$database;
     
    SELECT * FROM dba_log_groups  WHERE owner='SOAINTERNAL' ORDER BY owner, table_name,log_group_type;

     SELECT supplemental_log_data_min FROM v$database;



 --ALTER DATABASE ADD SUPPLEMENTAL LOG DATA(ALL) COLUMNS;
  
--Enable primary keys system-generated unconditional supplemental log group.
  ALTER DATABASE ADD SUPPLEMENTAL LOG DATA(PRIMARY KEY) COLUMNS;
  
--Enable unique keys system-generated unconditional supplemental log group.
  ALTER DATABASE ADD SUPPLEMENTAL LOG DATA(UNIQUE) COLUMNS;
  
--Enable foreign keys system-generated unconditional supplemental log group.
  ALTER DATABASE ADD SUPPLEMENTAL LOG DATA(FOREIGN KEY) COLUMNS;
 
truncate table c022427.exceptions;
