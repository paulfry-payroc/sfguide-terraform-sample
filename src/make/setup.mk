SHELL = /bin/sh

# load variables from a separate file
include src/make/variables.mk

#=======================================================================
# Targets
#=======================================================================
gen_env_template:
	@echo && echo "Generate the template .env file"
	@j2 src/templates/jinja_templates/.env_template.j2 -o .env

validate_env_vars:
	@echo && echo "${INFO}Called makefile target 'validate_env_vars'. Verify the contents of required env vars.${COLOUR_OFF}" && echo
	@./src/sh/validate_env_vars.sh config.yaml .env

create_svc_cicd_user_and_role:
	@echo && echo "${INFO}Target 'create_svc_cicd_user_and_role': create Snowflake service account user/role.${COLOUR_OFF}" && echo
	@echo "1. Create the Snowflake CICD service account user 'SVC_CICD'"
	@python3 ${SNOWFLAKE_CLIENT_SCRIPT} --sql-file ${CREATE_USER_ROLE_DIR}/1_create_user_svc_cicd.sql
	@echo && echo "2. Create the Snowflake CICD role, 'CICD_ALL_ROLE'"
	@python3 ${SNOWFLAKE_CLIENT_SCRIPT} --sql-file ${CREATE_USER_ROLE_DIR}/2_create_role_cicd_all_role.sql
	@echo && echo "3. Grant the role 'CICD_ALL_ROLE' to the user 'SVC_CICD'"
	@python3 ${SNOWFLAKE_CLIENT_SCRIPT} --sql-file ${CREATE_USER_ROLE_DIR}/3_grant_role_cicd_all_role_to_user_svc_cicd.sql
	@echo && echo "4. Change the ownership of the new user and role"
	@python3 ${SNOWFLAKE_CLIENT_SCRIPT} --sql-file ${CREATE_USER_ROLE_DIR}/4_grant_ownership_cicd_user_and_role.sql
	@echo && echo "5. Grant the required permissions to the role 'CICD_ALL_ROLE'"
	@python3 ${SNOWFLAKE_CLIENT_SCRIPT} --sql-file ${CREATE_USER_ROLE_DIR}/5_grant_permissions_to_role_cicd_all_role.sql --args-json '{"database": "${SNOWFLAKE_CHANGE_HISTORY_DB}"}' && echo
	@echo && echo "Snowflake user 'SVC_CICD' and role 'CICD_ALL_ROLE' created with the required permissions. Next create the 'operations' db." && echo
	@python3 ${SNOWFLAKE_CLIENT_SCRIPT} --sql-file src/sql/create_operations_db.sql && echo
	@python3 ${SNOWFLAKE_CLIENT_SCRIPT} --sql-file src/sql/create_change_history_tbl.sql --args-json '{"database": "${SNOWFLAKE_CHANGE_HISTORY_DB}", "schema": "${SNOWFLAKE_CHANGE_HISTORY_DB_SCHEMA}"}' && echo
	@echo && echo "Finished! Created 'operations' db." && echo

# Phony targets
.PHONY: gen_env_template create_svc_cicd_user_and_role get_ips
# .PHONY tells Make that these targets don't represent files
# This prevents conflicts with any files named "all" or "clean"
