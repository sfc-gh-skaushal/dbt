  use role sysadmin;
  use database TASTY_BYTES_DBT_DB;
  use schema public;


 CREATE DBT PROJECT TASTY_BYTES_DBT_DB.public.tastybytes_truck_demo
  FROM 'snow://workspace/USER$SKAUSHAL.PUBLIC."tasty_truck_roll"/versions/live';

 

show dbt projects;

  EXECUTE DBT PROJECT TASTY_BYTES_DBT_DB.public.tastybytes_truck_demo
  ARGS = 'compile  --target dev';

    EXECUTE DBT PROJECT TASTY_BYTES_DBT_DB.public.tastybytes_truck_demo
  ARGS = 'test  --target dev';

      EXECUTE DBT PROJECT TASTY_BYTES_DBT_DB.public.tastybytes_truck_demo
  ARGS = 'run  --target dev';

  

  

