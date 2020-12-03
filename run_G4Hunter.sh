#! /bin/bash 

for f in "$1"*.fasta; do
	python2 G4Hunter.py -i "$f" -o ./ -w "$2" -s "$3" 
	FILENAME=$(basename "${f}" .fasta)
	awk 'BEGIN {FS=OFS= " "}{print "'$FILENAME'" OFS $0}' Results_"${FILENAME}"/"${FILENAME}"-Merged.txt | sort -n -k6 | awk 'NR == 1{print $0}' >> G4.txt
	
done 

sort -n -k6 G4.txt > G4_sorted.txt

awk 'BEGIN{printf("%-4s%-35s%-8s%-8s%-60s%-8s%-8s\n","#","ACCESSION","START","END","SEQ","LENGTH","SCORE")}{printf("%-4s%-35s%-8s%-8s%-60s%-8s%-8s\n",NR,$1,$2,$3,$4,$5,$6)}' G4_sorted.txt > "$4"_sorted.txt

rm G4.txt
rm G4_sorted.txt