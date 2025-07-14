USE ROLE accountadmin;

CREATE DATABASE IF NOT EXISTS KAZUKI_OTANI_DB;
CREATE OR REPLACE SCHEMA KAZUKI_OTANI_DB.raw;
CREATE OR REPLACE SCHEMA KAZUKI_OTANI_DB.dev;
CREATE OR REPLACE SCHEMA KAZUKI_OTANI_DB.prod;

ALTER SCHEMA KAZUKI_OTANI_DB.dev SET LOG_LEVEL = 'INFO';
ALTER SCHEMA KAZUKI_OTANI_DB.dev SET TRACE_LEVEL = 'ALWAYS';
ALTER SCHEMA KAZUKI_OTANI_DB.dev SET METRIC_LEVEL = 'ALL';

ALTER SCHEMA KAZUKI_OTANI_DB.prod SET LOG_LEVEL = 'INFO';
ALTER SCHEMA KAZUKI_OTANI_DB.prod SET TRACE_LEVEL = 'ALWAYS';
ALTER SCHEMA KAZUKI_OTANI_DB.prod SET METRIC_LEVEL = 'ALL';

CREATE OR REPLACE FILE FORMAT KAZUKI_OTANI_DB.public.csv_ff 
type = 'csv';

CREATE OR REPLACE STAGE KAZUKI_OTANI_DB.public.s3load
COMMENT = 'Quickstarts S3 Stage Connection'
url = 's3://sfquickstarts/frostbyte_tastybytes/'
file_format = KAZUKI_OTANI_DB.public.csv_ff;

/*--
 raw zone table build 
--*/

-- country table build
CREATE OR REPLACE TABLE KAZUKI_OTANI_DB.raw.country
(
    country_id NUMBER(18,0),
    country VARCHAR(16777216),
    iso_currency VARCHAR(3),
    iso_country VARCHAR(2),
    city_id NUMBER(19,0),
    city VARCHAR(16777216),
    city_population VARCHAR(16777216)
) 
COMMENT = '{"origin":"sf_sit-is", "name":"tasty-bytes-dbt", "version":{"major":1, "minor":0}, "attributes":{"is_quickstart":1, "source":"sql"}}';

-- franchise table build
CREATE OR REPLACE TABLE KAZUKI_OTANI_DB.raw.franchise 
(
    franchise_id NUMBER(38,0),
    first_name VARCHAR(16777216),
    last_name VARCHAR(16777216),
    city VARCHAR(16777216),
    country VARCHAR(16777216),
    e_mail VARCHAR(16777216),
    phone_number VARCHAR(16777216) 
)
COMMENT = '{"origin":"sf_sit-is", "name":"tasty-bytes-dbt", "version":{"major":1, "minor":0}, "attributes":{"is_quickstart":1, "source":"sql"}}';

-- location table build
CREATE OR REPLACE TABLE KAZUKI_OTANI_DB.raw.location
(
    location_id NUMBER(19,0),
    placekey VARCHAR(16777216),
    location VARCHAR(16777216),
    city VARCHAR(16777216),
    region VARCHAR(16777216),
    iso_country_code VARCHAR(16777216),
    country VARCHAR(16777216)
)
COMMENT = '{"origin":"sf_sit-is", "name":"tasty-bytes-dbt", "version":{"major":1, "minor":0}, "attributes":{"is_quickstart":1, "source":"sql"}}';

-- menu table build
CREATE OR REPLACE TABLE KAZUKI_OTANI_DB.raw.menu
(
    menu_id NUMBER(19,0),
    menu_type_id NUMBER(38,0),
    menu_type VARCHAR(16777216),
    truck_brand_name VARCHAR(16777216),
    menu_item_id NUMBER(38,0),
    menu_item_name VARCHAR(16777216),
    item_category VARCHAR(16777216),
    item_subcategory VARCHAR(16777216),
    cost_of_goods_usd NUMBER(38,4),
    sale_price_usd NUMBER(38,4),
    menu_item_health_metrics_obj VARIANT
)
COMMENT = '{"origin":"sf_sit-is", "name":"tasty-bytes-dbt", "version":{"major":1, "minor":0}, "attributes":{"is_quickstart":1, "source":"sql"}}';

-- truck table build 
CREATE OR REPLACE TABLE KAZUKI_OTANI_DB.raw.truck
(
    truck_id NUMBER(38,0),
    menu_type_id NUMBER(38,0),
    primary_city VARCHAR(16777216),
    region VARCHAR(16777216),
    iso_region VARCHAR(16777216),
    country VARCHAR(16777216),
    iso_country_code VARCHAR(16777216),
    franchise_flag NUMBER(38,0),
    year NUMBER(38,0),
    make VARCHAR(16777216),
    model VARCHAR(16777216),
    ev_flag NUMBER(38,0),
    franchise_id NUMBER(38,0),
    truck_opening_date DATE
)
COMMENT = '{"origin":"sf_sit-is", "name":"tasty-bytes-dbt", "version":{"major":1, "minor":0}, "attributes":{"is_quickstart":1, "source":"sql"}}';

-- order_header table build
CREATE OR REPLACE TABLE KAZUKI_OTANI_DB.raw.order_header
(
    order_id NUMBER(38,0),
    truck_id NUMBER(38,0),
    location_id FLOAT,
    customer_id NUMBER(38,0),
    discount_id VARCHAR(16777216),
    shift_id NUMBER(38,0),
    shift_start_time TIME(9),
    shift_end_time TIME(9),
    order_channel VARCHAR(16777216),
    order_ts TIMESTAMP_NTZ(9),
    served_ts VARCHAR(16777216),
    order_currency VARCHAR(3),
    order_amount NUMBER(38,4),
    order_tax_amount VARCHAR(16777216),
    order_discount_amount VARCHAR(16777216),
    order_total NUMBER(38,4)
)
COMMENT = '{"origin":"sf_sit-is", "name":"tasty-bytes-dbt", "version":{"major":1, "minor":0}, "attributes":{"is_quickstart":1, "source":"sql"}}';

-- order_detail table build
CREATE OR REPLACE TABLE KAZUKI_OTANI_DB.raw.order_detail 
(
    order_detail_id NUMBER(38,0),
    order_id NUMBER(38,0),
    menu_item_id NUMBER(38,0),
    discount_id VARCHAR(16777216),
    line_number NUMBER(38,0),
    quantity NUMBER(5,0),
    unit_price NUMBER(38,4),
    price NUMBER(38,4),
    order_item_discount_amount VARCHAR(16777216)
)
COMMENT = '{"origin":"sf_sit-is", "name":"tasty-bytes-dbt", "version":{"major":1, "minor":0}, "attributes":{"is_quickstart":1, "source":"sql"}}';

-- customer loyalty table build
CREATE OR REPLACE TABLE KAZUKI_OTANI_DB.raw.customer_loyalty
(
    customer_id NUMBER(38,0),
    first_name VARCHAR(16777216),
    last_name VARCHAR(16777216),
    city VARCHAR(16777216),
    country VARCHAR(16777216),
    postal_code VARCHAR(16777216),
    preferred_language VARCHAR(16777216),
    gender VARCHAR(16777216),
    favourite_brand VARCHAR(16777216),
    marital_status VARCHAR(16777216),
    children_count VARCHAR(16777216),
    sign_up_date DATE,
    birthday_date DATE,
    e_mail VARCHAR(16777216),
    phone_number VARCHAR(16777216)
)
COMMENT = '{"origin":"sf_sit-is", "name":"tasty-bytes-dbt", "version":{"major":1, "minor":0}, "attributes":{"is_quickstart":1, "source":"sql"}}';

/*--
 raw zone table load 
--*/

-- country table load
COPY INTO KAZUKI_OTANI_DB.raw.country
FROM @KAZUKI_OTANI_DB.public.s3load/raw_pos/country/;

-- franchise table load
COPY INTO KAZUKI_OTANI_DB.raw.franchise
FROM @KAZUKI_OTANI_DB.public.s3load/raw_pos/franchise/;

-- location table load
COPY INTO KAZUKI_OTANI_DB.raw.location
FROM @KAZUKI_OTANI_DB.public.s3load/raw_pos/location/;

-- menu table load
COPY INTO KAZUKI_OTANI_DB.raw.menu
FROM @KAZUKI_OTANI_DB.public.s3load/raw_pos/menu/;

-- truck table load
COPY INTO KAZUKI_OTANI_DB.raw.truck
FROM @KAZUKI_OTANI_DB.public.s3load/raw_pos/truck/;

-- customer_loyalty table load
COPY INTO KAZUKI_OTANI_DB.raw.customer_loyalty
FROM @KAZUKI_OTANI_DB.public.s3load/raw_customer/customer_loyalty/;

-- order_header table load
COPY INTO KAZUKI_OTANI_DB.raw.order_header
FROM @KAZUKI_OTANI_DB.public.s3load/raw_pos/order_header/;

-- order_detail table load
insert into KAZUKI_OTANI_DB.raw.order_header
values (1, 1, 1.0, 1, 'DISC', 1, '10:00:00', '18:00:00', 'online', current_timestamp(), 'served', 'USD', 100, '5', '10', 85);

-- order_detail table load
insert into KAZUKI_OTANI_DB.raw.order_detail
values (1, 1, 1, 'DISC', 1, 1, 10, 10, '0');

-- setup completion note
SELECT 'KAZUKI_OTANI_DB setup is now complete' AS note;
