#!/bin/bash

#DO NOT REMOVE THE FOLLOWING TWO LINES
git add $0 >> .local.git.out
git commit -a -m "Lab 2 commit" >> .local.git.out

#Your code here
POINTS=0
PASSWORD=$(cat $1)
PWDSCORE="Password Score: "
ERR="Error: Password length invalid."
COUNT=${#PASSWORD}
SPECIAL=$(grep -Ec '[\#\$\+\%\@]' $1)
NUMBER=$(grep -Ec '[0-9]' $1)
ALPHA=$(grep -Ec '[A-Za-z]' $1)
REPCHAR=$(grep -Ec '([A-Za-z])(\1)+' $1)
REPNUM=$(grep -Ec '[0-9]{3,}?' $1)
REPUPPER=$(grep -Ec '[A-Z]{3,}?' $1)
REPLOWER=$(grep -Ec '[a-z]{3,}?' $1)

#password length is between 6 and 32
if [ "$COUNT" -lt "6" ] || [ "$COUNT" -gt "32" ] ; then
    echo $ERR

fi
let POINTS=POINTS+COUNT
echo $POINTS

#password contains special characters
if [ "$SPECIAL" -gt "0" ] ; then    
    let POINTS=POINTS+5
fi
echo $POINTS

#password contains a number
if [ "$NUMBER" -gt "0" ] ; then    
    let POINTS=POINTS+5
fi
echo $POINTS

#password contains an alpha character
if [ "$ALPHA" -gt "0" ] ; then    
    let POINTS=POINTS+5
fi
echo $POINTS

#password contains an the same alpha character in a row
if [ "$REPCHAR" -gt "0" ] ; then    
    let POINTS=POINTS-10
fi
echo $POINTS

#password contains an alpha character
if [ "$REPUPPER" -gt "0" ] ; then    
    let POINTS=POINTS-3
fi
echo $POINTS

#password contains an alpha character
if [ "$REPLOWER" -gt "0" ] ; then    
    let POINTS=POINTS-3
fi
echo "repupper" $POINTS

#password contains an alpha character
if [ "$REPNUM" -gt "0" ] ; then    
    let POINTS=POINTS-3
fi
echo $POINTS
echo $PWDSCORE $POINTS
