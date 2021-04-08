#!/bin/bash 


barker_code="cccccaaccacac"
num_sampxcod=$1
num_samp_baja=$2
num_samp_shift=$3

for (( i = 0 ; i < $num_samp_shift; i++ ))
do
  echo -n "b" >> barker13_pulsado_shifted\(sps$1_soff$2_shft$3\).bin
done

for (( i = 0; i < ${#barker_code}; i++ ))     
do

    for (( j = 0 ; j < $num_sampxcod; j++ )) 
    do
          echo -n ${barker_code:$i:1} >> barker13_pulsado_shifted\(sps$1_soff$2_shft$3\).bin
    done
done

for (( i = 0 ; i < ($num_samp_baja - $num_samp_shift); i++ ))
do
  echo -n "b" >> barker13_pulsado_shifted\(sps$1_soff$2_shft$3\).bin
done


