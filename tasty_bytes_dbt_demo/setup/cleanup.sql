  use role sysadmin;
  use database TASTY_BYTES_DBT_DB;
  use schema dev;

  show views;

  drop view RAW_CUSTOMER_CUSTOMER_LOYALTY;
  drop view RAW_POS_COUNTRY;
  drop view RAW_POS_FRANCHISE;
  drop view RAW_POS_LOCATION;
  drop view RAW_POS_MENU;
  drop view RAW_POS_ORDER_DETAIL;
  drop view RAW_POS_ORDER_HEADER;
  drop view RAW_POS_TRUCK;

  show tables;

drop table CUSTOMER_LOYALTY_METRICS;
drop table ORDERS;
drop table SALES_DATA_BY_TRUCK;
drop table SALES_METRICS_BY_LOCATION;