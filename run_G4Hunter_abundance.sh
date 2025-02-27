#! /bin/bash 
mkdir ./"$2"
while read line
do
    if [[ ${line:0:1} == '>' ]]
    then
        outfile=./"$2"/${line#>}.fasta
        echo "$line" > "$outfile"
    else
        echo "$line" >> "$outfile"
    fi
done < "$1"		

for f in ./"$2"/*.fasta; do
	python2 G4Hunter.py -i "$f" -o ./ -w "$3" -s "$4" 
    FILENAME=$(basename "${f}" .fasta)
    if [ "$(wc -l < Results_"${FILENAME}"/"${FILENAME}"-Merged.txt)" -gt 2 ]
    then 
        awk 'NR > 2 { print }' Results_"${FILENAME}"/"${FILENAME}"-Merged.txt | awk 'END {print $NF}' >> abundance.txt
        awk 'BEGIN {FS=OFS=" "}{print "'$FILENAME'" OFS $0}' Results_"${FILENAME}"/"${FILENAME}"-Merged.txt |awk 'NR > 2 { print }'| sort -n -r -k6 | awk 'NR==1{print $1, $2, $3, $4, $5, $6}'>> g4.txt  
        awk 'BEGIN {FS=OFS=" "}{print "'$FILENAME'" OFS $0}' Results_"${FILENAME}"/"${FILENAME}"-Merged.txt |awk 'NR > 2 { print }'| sort -n -k6 | awk 'NR==1{print $1, $2, $3, $4, $5, $6}'>> c4.txt 
    else
        echo "$Results_"${FILENAME}"" >> no_g4.txt
    fi 
done 


paste g4.txt abundance.txt > G4_abundance.txt 
sort -n -r -k6 G4.txt > G4_sorted.txt


#awk -F "_" '{print $7, $8}' G4_sorted.txt | sed 's,-, ,g' | sed 's, ,_,g' | awk -F "_" '{print $1, $2, $3, $5, $6, $7}' | sed 's,_, ,g'

awk 'BEGIN{printf("%-4s%-35s%-8s%-8s%-60s%-8s%-8s%-8s\n","#","ACCESSION","START","END","SEQ","LENGTH","SCORE","ABUNDANCE")}{printf("%-4s%-35s%-8s%-8s%-60s%-8s%-8s%-8s\n",NR,$1,$2,$3,$4,$5,$6,§7)}' G4_abundance.txt > "$3"_"$4"_sorted.txt
#rm G4.txt
#rm G4_sorted.txt 

rm -r ./"$2"  