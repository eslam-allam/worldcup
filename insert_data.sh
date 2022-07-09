#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE TABLE games, teams")
# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    #Check if winner exists
    WINNER_CHECK=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
    #if not exists
    if [[ -z $WINNER_CHECK ]]
    then
      #add winner to teams
      ADD_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      #If inserted succesfully
      if [[ $ADD_WINNER = 'INSERT 0 1' ]]
      then
        #print insert message
        echo "Inserted $WINNER into teams"
      fi
    fi
    
    #Check if opponent exists
    OPPONENT_CHECK=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
    #if not exists
    if [[ -z $OPPONENT_CHECK ]]
    then
      #add opponent to teams
      ADD_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      #if inserted succesfully
      if [[ $ADD_OPPONENT = 'INSERT 0 1' ]]
      then
        #print insert message
        echo "Inserted $OPPONENT into teams"
      fi
    fi
    #Grab winner ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    #Grab opponent ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    #insert game into games
    ADD_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    #if inserted succesfully
    if [[ $ADD_GAME = "INSERT 0 1" ]]
    then
      #print insert message
      echo -e "Inserted $WINNER:$OPPONENT into games\n"
    fi
  fi
done

