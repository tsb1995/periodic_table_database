#!/bin/bash


PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument." 
else

  if [[ "$1" =~ ^[0-9]+$ ]]
  then
    GET_ELEMENT_RESULTS=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
  else
    GET_ELEMENT_RESULTS=$($PSQL "SELECT name FROM elements WHERE symbol='$1' OR name='$1'")
  fi


  if [[ -z $GET_ELEMENT_RESULTS ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT=$(echo $GET_ELEMENT_RESULTS | sed 's/ |/"/')
    GET_ELEMENT_INFO_RESULTS=$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$ELEMENT';")

    echo "$GET_ELEMENT_INFO_RESULTS" | while read TYPE_ID BAR ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR SYMBOL BAR NAME BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi