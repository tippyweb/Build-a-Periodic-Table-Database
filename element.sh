#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

# initial message to the user
if [[ -z $1 ]]
then
  echo -e "\nPlease provide an element as an argument.\n"
fi