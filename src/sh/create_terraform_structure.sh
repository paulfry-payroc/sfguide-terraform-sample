#!/bin/bash

# Function to check if a directory exists
dir_exists() {
  [ -d "$1" ]
}

# Function to check if a file exists
file_exists() {
  [ -f "$1" ]
}

# Directories and files to create
environments=("dev" "staging" "prod")
files=("main.tf" "variables.tf" "terraform.tfvars")

# Create 'tbc' directory at the root if it doesn't exist
tbc_dir="tbc"
if ! dir_exists "$tbc_dir"; then
  mkdir "$tbc_dir"
fi

# Create files in the 'tbc' directory
for file in "${files[@]}"; do
  file_path="$tbc_dir/$file"
  if ! file_exists "$file_path"; then
    touch "$file_path"
  fi
done

# Create directories and files for each environment
for environment in "${environments[@]}"; do
  dir_path="environments/$environment"

  # Create environment directory if it doesn't exist
  if ! dir_exists "$dir_path"; then
    mkdir "$dir_path"
    touch "$dir_path/.gitkeep"
  fi

  # Create files in the environment directory
  for file in "${files[@]}"; do
    file_path="$dir_path/$file"
    if ! file_exists "$file_path"; then
      touch "$file_path"
    fi
  done
done

echo "Terraform project structure created successfully!"
