use role sysadmin;
  use database TASTY_BYTES_DBT_DB;
  use schema raw;


 CREATE DBT PROJECT TASTY_BYTES_DBT_DB.RAW.DBT_TRUCK_SALES
  FROM 'snow://workspace/USER$SKAUSHAL.PUBLIC."tasty_truck_roll"/versions/live';



show dbt projects;

EXECUTE DBT PROJECT TASTY_BYTES_DBT_DB.RAW.DBT_TRUCK_SALES
args='deps --target dev' external_access_integrations = (DBT_ACCESS_INTEGRATION);

  EXECUTE DBT PROJECT TASTY_BYTES_DBT_DB.RAW.DBT_TRUCK_SALES
  ARGS = 'compile  --target dev';

    EXECUTE DBT PROJECT TASTY_BYTES_DBT_DB.RAW.DBT_TRUCK_SALES
  ARGS = 'test  --target dev';

      EXECUTE DBT PROJECT TASTY_BYTES_DBT_DB.RAW.DBT_TRUCK_SALES
  ARGS = 'run  --target dev';

  

  

  

