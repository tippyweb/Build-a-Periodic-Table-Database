#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MAIN() {
# initial message to the user
  if [[ -z $1 ]]
  then
    echo -e "\nPlease provide an element as an argument.\n"

# user enters element info
  else

# trim the element dataq
    TRIMMED_ARG=$(echo $1 | sed -E 's/^ *| *$//g')

# element is an atomic number
    if [[ $TRIMMED_ARG =~ ^[0-9][0-9]?$ ]]
    then
      echo "Element by atomic number"

# element is an element symbol
    elif [[ $TRIMMED_ARG =~ ^[A-Z][a-z]?$ ]]
    then
      echo "Element by element symbol"


# element is an element name
    elif [[ $TRIMMED_ARG =~ ^[A-Z][a-z]+$ ]]
    then
      echo "Element by element name"
  
# invalid argument
    else
      ERROR

    fi  

  fi

}

ERROR() {
  echo -e "\nI could not find that element in the database.\n"
}

MAIN
