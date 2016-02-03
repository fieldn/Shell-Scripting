#!/bin/bash

#DO NOT REMOVE THE FOLLOWING TWO LINES
git add $0 >> .local.git.out
git commit -a -m "Lab 2 commit" >> .local.git.out

POINTS=0
PASSWORD=$(cat $1)
PWDSCORE="Password Score: "
ERR="Error: Password length invalid."
COUNT=${#PASSWORD}
SPECIAL=$(grep -Ec '[\#\$\+\%\@]' $1)
NUMBER=$(grep -Ec '[0-9]' $1)
ALPHA=$(grep -Ec '[A-Za-z]' $1)
REPCHAR=$(grep -Ec '([A-Za-z])(\1)+' $1)
REPUPPER=$(grep -Ec '[A-Z]{3,}' $1)
REPLOWER=$(grep -Ec '[a-z]{3,}' $1)
REPNUM=$(grep -Ec '[0-9]{3,}' $1)

#password length is between 6 and 32
if [ "$COUNT" -lt "6" ] || [ "$COUNT" -gt "32" ] ; then
    echo $ERR
    exit 0
fi
let POINTS=POINTS+COUNT

#password contains special characters
[[ "$SPECIAL" -gt "0" ]] && ((POINTS+=5))

#password contains a number
[[ "$NUMBER" -gt "0" ]] && ((POINTS+=5))

#password contains an alpha character
[[ "$ALPHA" -gt "0" ]] && ((POINTS+=5))

#password contains an the same alpha character in a row
[[ "$REPCHAR" -gt "0" ]] && ((POINTS-=10))

#password contains 3 uppercase characters
[[ "$REPUPPER" -gt "0" ]] && ((POINTS-=3))

#password contains 3 lowercase characters in a row
[[ "$REPLOWER" -gt "0" ]] && ((POINTS-=3))

#password contains 3 numbers in a row
[[ "$REPNUM" -gt "0" ]] && ((POINTS-=3))

echo $PWDSCORE $POINTS
