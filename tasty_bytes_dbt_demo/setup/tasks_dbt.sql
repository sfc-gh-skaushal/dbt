USE WAREHOUSE tasty_bytes_dbt_wh;
USE ROLE sysadmin;

CREATE OR REPLACE TASK tasty_bytes_dbt_db.raw.dbt_deps_task
	WAREHOUSE=TASTY_BYTES_DBT_WH
	SCHEDULE='60 MINUTES'
	AS EXECUTE DBT PROJECT TASTY_BYTES_DBT_DB.RAW.DBT_TRUCK_SALES args='deps --target dev' external_access_integrations = (DBT_ACCESS_INTEGRATION);


CREATE OR REPLACE TASK tasty_bytes_dbt_db.raw.dbt_run_task
	WAREHOUSE=TASTY_BYTES_DBT_WH
	AFTER tasty_bytes_dbt_db.raw.dbt_deps_task
	AS EXECUTE DBT PROJECT TASTY_BYTES_DBT_DB.RAW.DBT_TRUCK_SALES args='run --target dev';


CREATE OR REPLACE TASK tasty_bytes_dbt_db.raw.dbt_test_task
	WAREHOUSE=TASTY_BYTES_DBT_WH
	AFTER tasty_bytes_dbt_db.raw.dbt_run_task
	AS
        DECLARE 
            dbt_success BOOLEAN;
            dbt_exception STRING;
            my_exception EXCEPTION (-20002, 'My exception text');
        BEGIN
            EXECUTE DBT PROJECT TASTY_BYTES_DBT_DB.RAW.DBT_TRUCK_SALES args='test --target dev';
            SELECT SUCCESS, EXCEPTION into :dbt_success, :dbt_exception FROM TABLE(result_scan(last_query_id()));
            IF (NOT :dbt_success) THEN
              raise my_exception;
            END IF;
        END;

-- Run the tasks once
ALTER TASK tasty_bytes_dbt_db.raw.dbt_run_task RESUME;
ALTER TASK tasty_bytes_dbt_db.raw.dbt_test_task RESUME;
EXECUTE TASK tasty_bytes_dbt_db.raw.dbt_deps_task;

