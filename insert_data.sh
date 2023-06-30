#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    #get opponent_id 
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name= '$OPPONENT'")"
    #if not found 
    if [[ -z $OPPONENT_ID ]]
    then
      #enter opponent
      INSERT_TEAM_RESULT="$($PSQL "INSERT into teams(name) VALUES('$OPPONENT')")"
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
    #get new opponent ID
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name= '$OPPONENT'")"

    #get winner ID
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name= '$WINNER'")"
    #if not found 
    if [[ -z $WINNER_ID ]]
    then
      #enter WINNER in teams
      INSERT_TEAM_RESULT="$($PSQL "INSERT into teams(name) VALUES('$WINNER')")"
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi
    #get new winner Id
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name= '$WINNER'")"

    INSERT_GAMES_RESULT="$($PSQL "INSERT into games(year,round,winner_id,opponent_id,
    opponent_goals,winner_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$OPPONENT_GOALS,$WINNER_GOALS)")"
    if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
    then 
      echo Insert into games , $WINNER VS $OPPONENT
    fi
  fi
done