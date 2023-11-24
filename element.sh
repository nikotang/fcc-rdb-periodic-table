#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    OUTPUT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
  else
    OUTPUT=$($PSQL "SELECT * FROM elements WHERE symbol='$1' OR name='$1'")
  fi
  if [[ -z $OUTPUT ]]
  then
    echo I could not find that element in the database.
  else
    echo "$OUTPUT" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME
    do
    PROPERTIES=$($PSQL "SELECT * FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    echo "$PROPERTIES" | while IFS='|' read _ ATOMIC_MASS MELT BOIL TYPE_ID
    do
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
    done
  fi
fi
