#!/bin/bash

SOURCE_DATA1="./data/col/diag/"
SOURCE_DATA2="./data/col/ndiag/"
SOURCE_DATA3="./data/pmc/diag/"
SOURCE_DATA4="./data/pmc/ndiag/"
OUT_DATA="./data1/diag/"
OUT_DATA1="./data1/ndiag/"

while read -r NUMNR 
do	
	echo "$NUMNR"

	DATA_FILE=$SOURCE_DATA1$NUMNR".txt"
	cp $DATA_FILE data_coldiag.txt
	DATA_FILE1=$SOURCE_DATA2$NUMNR".txt"
	cp $DATA_FILE1 data_colndiag.txt
	DATA_FILE2=$SOURCE_DATA3$NUMNR".txt"
	cp $DATA_FILE2 data_pmcdiag.txt
	DATA_FILE3=$SOURCE_DATA4$NUMNR".txt"
	cp $DATA_FILE3 data_pmcndiag.txt

	sort -u data_coldiag.txt | sort -nr -k1,1 -k3,3 >msql_tmp.txt
	cat msql_tmp.txt >data_coldiag.txt
	sort -u data_colndiag.txt | sort -n -k1,1 -k3,3 >msql_tmp.txt
	cat msql_tmp.txt >data_colndiag.txt
	sort -u data_pmcdiag.txt | sort -nr -k1,1 -k3,3 >msql_tmp.txt
	cat msql_tmp.txt >data_pmcdiag.txt
	sort -u data_pmcndiag.txt | sort -n -k1,1 -k3,3 >msql_tmp.txt
	cat msql_tmp.txt >data_pmcndiag.txt

	TOT_ROWS=$(wc -l <data_coldiag.txt)	

	if (( $TOT_ROWS > 3 ))
	then
		#1.A
		gawk -F'\t' '{printf("%s\n",$1)}' data_coldiag.txt | sort -u | sort -nr -k1,1 >data_dftrs.txt
		
		#2.coldiag WTS max
		gawk '$3 > max[$1] { max[$1]=$3; row[$1]=$0 }END { for (i in row) print row[i] }' data_coldiag.txt | sort -nr -k1,1 | gawk -F'\t'  '{printf("%s\n",$0)}' >data_coldwts.txt

		#3.coldiag WTS min
		gawk '{key = $1 OFS $2; if (!(key in min_values) || $3 < min_values[key]) {min_values[key] = $3}} END {for (key in min_values) {printf("%s\t%s\n",key, min_values[key])}}' data_colndiag.txt | tr ' ' '\t' >data_colanwts.txt
		gawk -F'\t' 'NR==FNR{a[$1$2$3]=$4;next}a[$1$2$3]>0{printf("%s\t%s\t%s\t%s\n",$1,a[$1$2$3],$3,$2)}' dbmi_report2.txt data_colanwts.txt >data_colanwts1.txt				

		NUM_FTRS=$(wc -l <data_dftrs.txt)
		NUM_WTS=$(wc -l <data_coldnwts.txt)

		if (( $NUM_WTS > $NUM_FTRS ))
		then
			#4.colndiag WTS max
			gawk -F'\t' 'NR==FNR{a[$1]++;next}a[$1]>0{printf("%s\n",$0)}' data_dftrs.txt data_colndiag.txt >data_colndiag1.txt

			#5.colndiag WTS min
			gawk '{key = $1 OFS $2; if (!(key in min_values) || $3 < min_values[key]) {min_values[key] = $3}} END {for (key in min_values) {printf("%s\t%s\n",key, min_values[key])}}' data_colndiag.txt | tr ' ' '\t' >data_colanwts.txt
		fi
		
		#6.pmc WTS max
		gawk '$3 > max[$1] { max[$1]=$3; row[$1]=$0 }END { for (i in row) print row[i] }' data_pmcdiag.txt | sort -nr -k1,1 | gawk -F'\t'  '{printf("%s\n",$0)}' >data_pmcwts.txt

		#7.pmc WTS min
		gawk '{key = $1 OFS $2; if (!(key in min_values) || $3 < min_values[key]) {min_values[key] = $3}} END {for (key in min_values) {printf("%s\t%s\n",key, min_values[key])}}' data_pmcndiag.txt | tr ' ' '\t' >data_pmcanwts.txt

		#8.take 2 & 6
		gawk -F'\t' 'NR==FNR{a[$1]=$3;next}a[$1]>0{printf("%s\t%0.9f\n",$1,($3/a[$1]))}' data_coldwts.txt data_pmcwts.txt >data_colwts.txt
		
		#9.take 3 & 7
		gawk -F'\t' 'NR==FNR{a[$1$2]=$3;next}a[$1$2]>0{printf("%s\t%s\t%0.9f\n",$1,$2,(a[$1$2]/$3))}' data_pmcanwts.txt data_colanwts1.txt | sort -n -k2,2 >data_pmcwts1.txt
		gawk '{key = $1 OFS $2; if (!(key in min_values) || $3 < min_values[key]) {min_values[key] = $3}} END {for (key in min_values) {printf("%s\t%s\n",key, min_values[key])}}' data_pmcwts1.txt | tr ' ' '\t' | sort -n -k2,2 >data_pmcwts2.txt

		#10. sum of DIAG & NDIAG
		gawk '{ sum += $2 } END { printf("%.9f\n",sum)}' data_colwts.txt >data_colwts1.txt
		gawk -F'\t' '{ a[$2] += $3 } END { for (i in a) { printf("%s\t%.9f\n",i, a[i]) } }' data_pmcwts2.txt >data_pmcwts3.txt	

	fi
	
		DATA_FILE=$OUT_DATA$NUMNR".txt"
		cat data_colwts1.txt >$DATA_FILE 
		DATA_FILE1=$OUT_DATA1$NUMNR".txt"
		cat data_pmcwts3.txt >$DATA_FILE1

done <col_134.txt
