#!/bin/bash

SOURCE_FILE="./dbmi_report2.txt"
SOURCE_FILE1="./dbmi_pts.txt"
SOURCE_FILE2="./col_ftrs_diagvec_pmcver3.txt"
OUT_DATA1="./data/col/diag/"
OUT_DATA2="./data/col/ndiag/"
OUT_DATA3="./data/pmc/diag/"
OUT_DATA4="./data/pmc/ndiag/"

while read -r NUMNR 
do
	echo "$NUMNR"
	
	gawk -F'\t' -v VAR=$NUMNR '{if($3 == VAR)printf("%s\n",$1)}' $SOURCE_FILE1 >data_pts.txt
	
	>data_pts1.txt
	while read -r NUMNR1 
	do		
		while read -r NUMNR2 
		do
			if (( $NUMNR1 != $NUMNR2 ))
			then
				if (( $NUMNR1 > $NUMNR2 ))
				then
					echo -e "$NUMNR1\t$NUMNR2" >>data_pts1.txt
				fi				
			fi

		done <data_pts.txt

	done <data_pts.txt


	gawk -F'\t' 'NR==FNR{a[$1]++;next}a[$1]>0{printf("%s\n",$0)}' data_pts1.txt $SOURCE_FILE >data_col.txt
	
	gawk -F'\t' '{printf("%s\t%s\n",$1,$4)}' data_col.txt >data_ftrdis.txt
	gawk -F'\t' '{printf("%s\t%s\n",$2,$4)}' data_col.txt >>data_ftrdis.txt
	sort -u data_ftrdis.txt | sort -n -k1,1 -k2,2 >data_ftrdis1.txt

	gawk -F'\t' 'NR==FNR{a[$1$2]++;next}a[$1$2]>0{printf("%s\n",$0)}' data_ftrdis1.txt $SOURCE_FILE2 >data_pmc.txt
	
	>data_col11.txt
	>data_col21.txt
	>data_pmc11.txt
	>data_pmc21.txt
	while read -r NUMNR3 NUMNR4
	do	
		gawk -F'\t' -v VAR=$NUMNR3 -v VAR1=$NUMNR4 -v VAR2=$NUMNR '{if(($1 == VAR || $1 == VAR1)&&($2 == VAR2))printf("%s\n",$0)}' data_pmc.txt >data_pmc1.txt
		gawk -F'\t' -v VAR=$NUMNR3 -v VAR1=$NUMNR4 -v VAR2=$NUMNR '{if(($1 == VAR || $2 == VAR1)&&($4 == VAR2))printf("%s\n",$0)}' data_col.txt >data_col1.txt
		gawk -F'\t' -v VAR=$NUMNR3 -v VAR1=$NUMNR4 -v VAR2=$NUMNR '{if(($1 == VAR || $1 == VAR1)&&($2 != VAR2))printf("%s\n",$0)}' data_pmc.txt >data_pmc2.txt
		gawk -F'\t' -v VAR=$NUMNR3 -v VAR1=$NUMNR4 -v VAR2=$NUMNR '{if(($1 == VAR || $2 == VAR1)&&($4 != VAR2))printf("%s\n",$0)}' data_col.txt >data_col2.txt
		
		gawk '$3 > max[$1$2] { max[$1$2]=$3; row[$1]=$0 }END { for (i in row) print row[i] }' data_col1.txt >>data_col11.txt 

		gawk '{key = $1 OFS $2; if (!(key in min_values) || $3 < min_values[key]) {min_values[key] = $3}} END {for (key in min_values) {printf("%s\t%s\n",key, min_values[key])}}' data_col2.txt | tr ' ' '\t' >>data_col21.txt

		gawk '$3 > max[$1$2] { max[$1$2]=$3; row[$1]=$0 }END { for (i in row) print row[i] }' data_pmc1.txt >>data_pmc11.txt 

		gawk '{key = $1 OFS $2; if (!(key in min_values) || $3 < min_values[key]) {min_values[key] = $3}} END {for (key in min_values) {printf("%s\t%s\n",key, min_values[key])}}' data_pmc2.txt | tr ' ' '\t' >>data_pmc21.txt

	done <data_pts1.txt
	
	DATA_FILE=$OUT_DATA1$NUMNR".txt"
	gawk -F'\t' -v VAR=$NUMNR '{printf("%s\t%s\n",$0,VAR)}' data_col11.txt >$DATA_FILE 
	DATA_FILE1=$OUT_DATA2$NUMNR".txt" 
	gawk -F'\t' -v VAR=$NUMNR '{printf("%s\t%s\n",$0,VAR)}' data_col21.txt >$DATA_FILE1
	DATA_FILE2=$OUT_DATA3$NUMNR".txt"
	gawk -F'\t' -v VAR=$NUMNR '{printf("%s\t%s\n",$0,VAR)}' data_pmc11.txt >$DATA_FILE2 
	DATA_FILE3=$OUT_DATA4$NUMNR".txt" 
	gawk -F'\t' -v VAR=$NUMNR '{printf("%s\t%s\n",$0,VAR)}' data_pmc21.txt >$DATA_FILE3

done <col_134.txt
