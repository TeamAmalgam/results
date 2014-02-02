#!/bin/bash

expdirs="igia igia_constants_only_with_formula_changes igia_with_cm_univ igia_with_cm_univ_and_formulas"
cd igia
explist=`ls -d */`
cd ..
#echo $expdirs
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

logylist[0]="log(calls)"
logylist[1]="log(calls)"
logylist[2]="log10(ms)"
logylist[3]="log10(ms)"
logylist[4]="log10(ms)"
logylist[5]="log10(ms)"
logylist[6]="log10(ms)"
logylist[7]="log10(ms)"
logylist[8]="log10(ms)"

ylist[0]="calls"
ylist[1]="calls"
ylist[2]="ms"
ylist[3]="ms"
ylist[4]="ms"
ylist[5]="ms"
ylist[6]="ms"
ylist[7]="ms"
ylist[8]="ms"

titlelist[0]="#Sat Calls"
titlelist[1]="#Unsat Calls"
titlelist[2]="Time in Sat Calls"
titlelist[3]="Time in Sat Calls Solving"
titlelist[4]="Time in Sat Calls Translating"
titlelist[5]="Time in Unsat Calls"
titlelist[6]="Time in Unsat Calls Solving"
titlelist[7]="Time in Unsat Calls Translating"
titlelist[8]="Time in Sat and Unsat Calls"

for i in `seq 0 7`
do
    rm extracted_results/${vallist[i]}
done

l=0
rm extracted_results/experiment_numbers
for m in $explist
do
    l=`expr $l + 1`
    echo $l $m >> extracted_results/experiment_numbers
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
	    newNum=`grep "${idlist[$h]}" stderr.out  | sed 's/[^0-9]//g'`
	    if [ "$newNum" = "" ]
	    then
		echo $i
	    fi
	    line+=$newNum
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
vallist[8]="time_in_sat_and_unsat"
rm temp
cd extracted_results
#gnuplot loglinesplot
for i in `seq 0 8`
do
    #echo ${logylist[$i]}
    gnuplot -e "myylabel='${logylist[$i]}'" -e "mytitle='${titlelist[$i]}'" -e "file='${vallist[$i]}'" -e "outfile='log10_${vallist[$i]}.png'" loglinesplot
    gnuplot -e "myylabel='${ylist[$i]}'" -e "mytitle='${titlelist[$i]}'" -e "file='${vallist[$i]}'" -e "outfile='${vallist[$i]}.png'" linesplot
    gnuplot -e "myylabel='${logylist[$i]}'" -e "mytitle='${titlelist[$i]}'" -e "file='${vallist[$i]}'" -e "outfile='log10_${vallist[$i]}_withMOO.png'" loglinesplotwithMOO
    gnuplot -e "myylabel='${ylist[$i]}'" -e "mytitle='${titlelist[$i]}'" -e "file='${vallist[$i]}'" -e "outfile='${vallist[$i]}_withMOO.png'" linesplotwithMOO
done

#vallist[0]="satcall"
#vallist[1]="unsatcall"
#vallist[2]="time_in_sat"
#vallist[3]="time_in_sat_solving"
#vallist[4]="time_in_sat_translating"
#vallist[5]="time_in_unsat"
#vallist[6]="time_in_unsat_solving"
#vallist[7]="time_in_unsat_translating"


montage satcall.png unsatcall.png time_in_sat.png time_in_unsat.png time_in_sat_solving.png time_in_unsat_solving.png time_in_sat_translating.png time_in_unsat_translating.png time_in_sat_and_unsat.png -geometry +2+4 normal.png

montage log10_satcall.png log10_unsatcall.png log10_time_in_sat.png log10_time_in_unsat.png log10_time_in_sat_solving.png log10_time_in_unsat_solving.png log10_time_in_sat_translating.png log10_time_in_unsat_translating.png log10_time_in_sat_and_unsat.png -geometry +2+4 log10.png

montage satcall_withMOO.png unsatcall_withMOO.png time_in_sat_withMOO.png time_in_unsat_withMOO.png time_in_sat_solving_withMOO.png time_in_unsat_solving_withMOO.png time_in_sat_translating_withMOO.png time_in_unsat_translating_withMOO.png time_in_sat_and_unsat_withMOO.png -geometry +2+4 normal_withMOO.png

montage log10_satcall_withMOO.png log10_unsatcall_withMOO.png log10_time_in_sat_withMOO.png log10_time_in_unsat_withMOO.png log10_time_in_sat_solving_withMOO.png log10_time_in_unsat_solving_withMOO.png log10_time_in_sat_translating_withMOO.png log10_time_in_unsat_translating_withMOO.png log10_time_in_sat_and_unsat_withMOO.png -geometry +2+4 log10_withMOO.png


#plot "satcall" using 1:2 title 'IGIA' with linespoints,"satcall" using 1:3 title 'Red. Consts, Red. Formulas' with linespoints,"satcall" using 1:4 title 'CM Consts' with linespoints, "satcall" using 1:4 title 'CM Consts, Red. Formulas' with linespoints