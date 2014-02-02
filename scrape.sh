#!/bin/bash

expdirs="igia igia_constants_only_with_formula_changes igia_with_cm_univ igia_with_cm_univ_and_formulas"
cd igia
explist=`ls -d */`
cd ..
echo $expdirs
#echo $explist
vallist[0]="satcall"
vallist[1]="unsatcall"
vallist[2]="time_in_sat"
vallist[3]="time_in_sat_solving"
vallist[4]="time_in_sat_translating"
vallist[5]="time_in_unsat"
vallist[6]="time_in_unsat_solving"
vallist[7]="time_in_unsat_translating"

idlist[0]="# Sat Call:"
idlist[1]="# Unsat Call:"
idlist[2]="# Total Time in Sat Calls:"
idlist[3]="# Total Time in Sat Calls Solving:"
idlist[4]="# Total Time in Sat Calls Translating:"
idlist[5]="# Total Time in Unsat Calls:"
idlist[6]="# Total Time in Unsat Calls Solving:"
idlist[7]="# Total Time in Unsat Calls Translating:"

for i in `seq 0 7`
do
    rm extracted_results/${vallist[i]}
done

for h in `seq 0 7`
do
    k=0
    for i in $explist
    do
	k=`expr $k + 1`
	#line="${i%.als/} "
	line="$k "
	for j in $expdirs 
	do
	#echo $i
	    #pwd
	    #echo $j
	    #echo $i
	    cd $j
	    cd $i
	    line+=`grep "${idlist[$h]}" stderr.out  | sed 's/[^0-9]//g'`
	    line+=" "
#echo $satcall
	    cd ..
	    cd ..
	done
	echo $line >> extracted_results/${vallist[$h]}
    done
done
paste extracted_results/time_in_sat extracted_results/time_in_unsat > temp
awk 'BEGIN { }{print $1 " " ($2+$7) " " ($3+$8) " " ($4+$9) " " ($5+$10) ;} END{ }' temp > extracted_results/time_in_sat_and_unsat

rm temp
cd extracted_results
gnuplot linesplot

#plot "satcall" using 1:2 title 'IGIA' with linespoints,"satcall" using 1:3 title 'Red. Consts, Red. Formulas' with linespoints,"satcall" using 1:4 title 'CM Consts' with linespoints, "satcall" using 1:4 title 'CM Consts, Red. Formulas' with linespoints