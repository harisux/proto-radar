#!/bin/bash 

num_samp_alta=$1
num_samp_baja=$2

for (( i = 0 ; i < $num_samp_alta; i++ ))
do
  echo -n "b" >> pulso_repetido\(son$1_soff$2\).bin
done

for (( i = 0 ; i < $num_samp_baja; i++ ))
do
  echo -n "a" >> pulso_repetido\(son$1_soff$2\).bin
done



