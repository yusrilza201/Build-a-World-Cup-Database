#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != winner ]]
  then
    #get winner_team_id
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    #if not found
    if [[ -z $WINNER_TEAM_ID ]]
    then
      #insert winner_team_name
      INSERT_WINNER_TEAM_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_TEAM_NAME_RESULT = "INSERT 0 1" ]]
      then
        echo Inserted into teams name, $WINNER
      fi

      #get new winner_team_id
      WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $OPPONENT != opponent ]]
  then
    #get opponent_team_id
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #if not found
    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      #insert opponent_team_name
      INSERT_OPPONENT_TEAM_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_TEAM_NAME_RESULT = "INSERT 0 1" ]]
      then
        echo Inserted into teams name, $OPPONENT
      fi
    
    #get new opponent_team_id
      OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    #get winner_id
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    #if not found
    if [[ -z $WINNER_TEAM_ID ]]
    then
      #set to null
      WINNER_TEAM_ID=null
    fi

    #get opponent_id
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #if not found
    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      #set to null
      OPPONENT_TEAM_ID=null
    fi

    #insert games
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAMES_RESULT = "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR $ROUND
    fi
  fi
done