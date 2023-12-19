CREATE DATABASE IF NOT EXISTS OPERATIONS COMMENT = "Database for operational tasks, excludes source system data.";
CREATE SCHEMA IF NOT EXISTS OPERATIONS.TERRAFORM WITH MANAGED ACCESS COMMENT = "Schema used by Terraform tool to manage the deployment of version-controlled Snowflake objects";
