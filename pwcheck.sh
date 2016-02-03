#!/bin/bash

#DO NOT REMOVE THE FOLLOWING TWO LINES
git add $0 >> .local.git.out
git commit -a -m "Lab 2 commit" >> .local.git.out

#Your code here
POINTS=0
PASSWORD=$(cat $1)
ERR="Error: Password length invalid."
COUNT=${#PASSWORD}
SPECIAL=$(egrep -c '[\#\$\+\%\@]' $1)
NUMBER=$(egrep -c '[0-9]' $1)
ALPHA=$(egrep -c '[A-Za-z]' $1)

echo $COUNT
if [ "$COUNT" -lt "6" ] || [ "$COUNT" -gt "32" ] ; then
    echo $ERR
fi
let POINTS=POINTS+COUNT
echo $POINTS

if [ "$SPECIAL" -gt "0" ] ; then    #password contains special characters
    let POINTS=POINTS+5
fi
echo $POINTS

if [ "$NUMBER" -gt "0" ] ; then    #password contains a number
    let POINTS=POINTS+5
fi
echo $POINTS

if [ "$ALPHA" -gt "0" ] ; then    #password contains an alpha character
    let POINTS=POINTS+5
fi
echo $POINTS
