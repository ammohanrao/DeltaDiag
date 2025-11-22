#!/bin/bash

SOURCE_DATA="./data1/diag/"
SOURCE_DATA1="./data1/ndiag/"

>data_diagck.txt
while read -r NUMNR 
do
#	NUMNR=1
	echo "$NUMNR"
	DATA_FILE=$SOURCE_DATA$NUMNR".txt"
	cp $DATA_FILE data_diag.txt
	DATA_FILE1=$SOURCE_DATA1$NUMNR".txt"
	cp $DATA_FILE1 data_ndiag.txt

	DIAG_VAL=$(gawk -F'\t' '{printf("%s\n",$0)}' data_diag.txt)	
	
	gawk -F'\t' -v VAR=$NUMNR -v VAR1=$DIAG_VAL '{printf("%s\t%s\t%s\n",$0,VAR,VAR1)}' data_ndiag.txt >>data_diagck.txt
	

done <col_134.txt

gawk -F'\t' '{if($2 > $4 && $4 > 0)printf("%s\n",$0)}' data_diagck.txt >data_diagck1.txt

#rectify ftr-dis wts

gawk -F'\t' '{printf("%s\n",$3)}' data_diagck1.txt | sort -u | sort -n -k1,1 >data_dis.txt
