#!/bin/bash 

#barker_code="1111100110101"
#barker_code="bbbbbaabbabab"
barker_code="cccccaaccacac"
num_sampxcod=$1
for (( i = 0; i < ${#barker_code}; i++ ))     
do

    for (( j = 0 ; j < $num_sampxcod; j++ )) 
    do
          echo -n ${barker_code:$i:1} >> barker13_repetido\(sps$1\).bin
    done
done


