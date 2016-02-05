#!/bin/bash
git add $0 >> .local.git.out
git commit -a -m "Lab 2 commit" >> .local.git.out

PASSWORD=$(cat $1)
COUNT=${#PASSWORD}
SPECIAL=$(grep -Ec '[\#\$\+\%\@]' $1)
NUMBER=$(grep -Ec '[0-9]' $1)
ALPHA=$(grep -Ec '[A-Za-z]' $1)
REPCHAR=$(grep -Ec '([A-Za-z])(\1)+' $1)
REPUPPER=$(grep -Ec '[A-Z]{3,}' $1)
REPLOWER=$(grep -Ec '[a-z]{3,}' $1)
REPNUM=$(grep -Ec '[0-9]{3,}' $1)

if [ "$COUNT" -lt "6" ] || [ "$COUNT" -gt "32" ] ; then #check pw length is between 6 and 32
    echo "Error: Password length invalid."
    exit 0
fi
POINTS=COUNT

[[ "$SPECIAL"  -gt "0" ]] && ((POINTS+=5))  #pw contains special characters 
[[ "$NUMBER"   -gt "0" ]] && ((POINTS+=5))  #pw contains a number 
[[ "$ALPHA"    -gt "0" ]] && ((POINTS+=5))  #pw contains an alpha character 
[[ "$REPCHAR"  -gt "0" ]] && ((POINTS-=10)) #pw contains an the same alpha character in a row 
[[ "$REPUPPER" -gt "0" ]] && ((POINTS-=3))  #pw contains 3 uppercase characters 
[[ "$REPLOWER" -gt "0" ]] && ((POINTS-=3))  #pw contains 3 lowercase characters in a row 
[[ "$REPNUM"   -gt "0" ]] && ((POINTS-=3))  #pw contains 3 numbers in a row

echo "Password Score:" $POINTS
