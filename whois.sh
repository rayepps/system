#!/bin/bash

regex="Admin Email: (.+)"

while :
do

  whois_data=`whois raykrow.com | grep 'Admin Email'`

  if [[ $whois_data =~ $regex ]]
  then
      email="${BASH_REMATCH[1]}"
      echo "Email: "$email
      if [ email == "raymondkrow@gmail.com" ]; then
        echo "ALERT!!!!!!!!!"
      fi
  fi

  sleep 5

done
