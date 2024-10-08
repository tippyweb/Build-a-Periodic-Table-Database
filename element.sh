#! /bin/bash
#############################################################################
# Periodic Table Database - 2024-09-29 - Submitted on 2024-09-29
#############################################################################

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MAIN() {

# trim the element dataq
  TRIMMED_ARG=$(echo $1 | sed -E 's/^ *| *$//g')

# user input is an atomic number
  if [[ $TRIMMED_ARG =~ ^[0-9][0-9]?$ ]]
  then
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$TRIMMED_ARG;")

    # if element is not found
    if [[ -z $ELEMENT_NAME ]]
    then
      ERROR

    # element found
    else
      ELEMENT_DATA=$($PSQL "SELECT * FROM elements
                            INNER JOIN properties USING(atomic_number)
                            INNER JOIN types USING(type_id)
                            WHERE atomic_number=$TRIMMED_ARG;")
      DISPLAY_DATA $ELEMENT_DATA

    fi

# user input is an element symbol
  elif [[ $TRIMMED_ARG =~ ^[A-Z][a-z]?$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$TRIMMED_ARG';")

    # if element is not found
    if [[ -z $ATOMIC_NUMBER ]]
    then
      ERROR

    # element found
    else
      ELEMENT_DATA=$($PSQL "SELECT * FROM elements
                            INNER JOIN properties USING(atomic_number)
                            INNER JOIN types USING(type_id)
                            WHERE atomic_number=$ATOMIC_NUMBER;")
      DISPLAY_DATA $ELEMENT_DATA

    fi

# user input is an element name
  elif [[ $TRIMMED_ARG =~ ^[A-Z][a-z]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$TRIMMED_ARG';")

    # if element is not found
    if [[ -z $ATOMIC_NUMBER ]]
    then
      ERROR

    # element found
    else
      ELEMENT_DATA=$($PSQL "SELECT * FROM elements
                            INNER JOIN properties USING(atomic_number)
                            INNER JOIN types USING(type_id)
                            WHERE atomic_number=$ATOMIC_NUMBER;")
      DISPLAY_DATA $ELEMENT_DATA

    fi
  
# invalid argument
  else
    ERROR

  fi

}

DISPLAY_DATA() {
  ELEMENT_DATA=$1
  IFS="|"

  echo "$ELEMENT_DATA" | while read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done

}

ERROR() {
  echo "I could not find that element in the database."

}

# initial message to the user
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."

# user enters element info
else
  MAIN $1
fi
