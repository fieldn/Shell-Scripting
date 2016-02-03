#!/bin/bash

#DO NOT REMOVE THE FOLLOWING TWO LINES
git add $0 >> .local.git.out
git commit -a -m "Lab 2 commit" >> .local.git.out

#Your code here
POINTS=0
PASSWORD=$(cat $1)
ERR="Error: Password length invalid."
COUNT=${#PASSWORD}
echo $COUNT
if [ "$COUNT" -lt "6" ] || [ "$COUNT" -gt "32" ] ; then
    echo $ERR
fi
let POINTS=POINTS+COUNT
SPECIAL=(egrep -c '[\#\$\+\%\@]' $1)
if [ "$SPECIAL" -gt "0" ] ; then
    let POINTS=POINTS+1
fi
echo $POINTS
