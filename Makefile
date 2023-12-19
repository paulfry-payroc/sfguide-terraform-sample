SHELL = /bin/sh

#================================================================
# Usage
#================================================================
# make all	# install the package for the first time, managing dependencies & performing a housekeeping cleanup too
# make deps		# just install the dependencies
# make install		# perform the end-to-end install
# make clean		# perform a housekeeping cleanup

#=======================================================================
# Variables
#=======================================================================
.EXPORT_ALL_VARIABLES:

include src/make/variables.mk # load variables from a separate makefile file
include src/make/setup.mk # store setup targets in a separate makefile
#=======================================================================
# Targets
#======================================================================
all: deps install clean

deps: validate_env_vars
	@echo && echo "${INFO}Called makefile target 'deps'. Create virtualenv with required Python libs.${COLOUR_OFF}" && echo
	@echo "${DEBUG}1. Install Terraform${COLOUR_OFF}"
	@./src/sh/install_terraform.sh
	@echo && echo "${DEBUG}2. Create the required Snowflake user 'SVC_USER' and role 'CICD_ALL_ROLE'${COLOUR_OFF}" && echo
	@make -s create_svc_cicd_user_and_role

install:
	@echo && echo "${INFO}Called makefile target 'install'. Set up GX (Great Expectations) project.${COLOUR_OFF}" && echo
	@make terraform init

b:
	terraform plan

test:
	@echo && echo "${INFO}Called makefile target 'test'. Set up GX (Great Expectations) project.${COLOUR_OFF}" && echo

clean:
	@echo && echo "${INFO}Called makefile target 'clean'. Restoring the repository to its initial state.${COLOUR_OFF}" && echo

# Phony targets
.PHONY: all deps install test clean

# .PHONY tells Make that these targets don't represent files
# This prevents conflicts with any files named "all" or "clean"
