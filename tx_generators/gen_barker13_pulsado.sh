#!/bin/bash 


barker_code="cccccaaccacac"
num_sampxcod=$1
num_samp_baja=$2
for (( i = 0; i < ${#barker_code}; i++ ))     
do

    for (( j = 0 ; j < $num_sampxcod; j++ )) 
    do
          echo -n ${barker_code:$i:1} >> barker13_pulsado\(sps$1_soff$2\).bin
    done
done

for (( i = 0 ; i < $num_samp_baja; i++ ))
do
  echo -n "b" >> barker13_pulsado\(sps$1_soff$2\).bin
done


