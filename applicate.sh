#!/bin/bash

wn cat -hmern | grep '=' | gawk -F'=' '{printf("%s\t%s\n",$2,NR)}' >msql_tmp.txt
wn bus -hmern | grep '=' | gawk -F'=' '{printf("%s\t%s\n",$2,NR)}' >msql_tmp1.txt
gawk -F'\t' 'NR==FNR{a[$1]++;next}a[$1]>0{printf("%s\n",$0)}' msql_tmp1.txt msql_tmp.txt | sort -n -k2,2 >msql_tmp2.txt


