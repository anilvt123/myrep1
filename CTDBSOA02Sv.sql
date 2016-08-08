select * from  schema_version_registry 
select owner from dba_objects where object_name='SCHEMA_VERSION_REGISTRY'
grant select on system.SCHEMA_VERSION_REGISTRY to FMW1221_SOAINFRA;
grant select on system.SCHEMA_VERSION_REGISTRY to FMW1221_MDS;
grant select on system.SCHEMA_VERSION_REGISTRY to FMW1221_IAU_VIEWER;
grant select on system.SCHEMA_VERSION_REGISTRY to FMW1221_OPSS;
grant select on system.SCHEMA_VERSION_REGISTRY to FMW1221_UMS;
