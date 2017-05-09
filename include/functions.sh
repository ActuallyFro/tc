#!/bin/bash

function function_CheckForEvenEntries(){
  cat -n $1 | grep "\`\`\`~~~" | wc -l | awk '{print $1"%2"}' | bc

  IsOdd=$(cat -n $1 | grep "\`\`\`~~~" | wc -l | awk '{print $1"%2"}' | bc)

  if [ "$IsOdd" == "0" ]; then
     echo "The Value is EVEN!"
  else
     echo "The Value is ODD!"
  fi
}
