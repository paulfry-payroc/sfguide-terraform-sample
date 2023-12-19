#=======================================================================
# Variables
#=======================================================================
# ANSI escape codes for color formatting
DEBUG := \033[0;36m # cyan (for debug messages)
INFO := \033[0;32m # green (for informational messages)
WARNING := \033[0;33m # yellow (for warning messages)
ERROR := \033[0;31m # red (for error messages)
CRITICAL := \033[1;31m # bold red (for critical errors)
COLOUR_OFF := \033[0m # reset text color

# snowflake script and file path
SNOWFLAKE_CLIENT_SCRIPT=src/py/snowflake_client/snowflake_client.py
CREATE_USER_ROLE_DIR=src/sql/setup_user_svc_cicd

# schemachange file paths
ROLES_GRANTS_DIR=schemachange/1_users_roles_and_grants
ACCOUNT_OBJS_DIR=schemachange/2_account_level_objects
SCHEMA_OBJS_DIR=schemachange/3_schema_level_objects
