# G4


The ```runG4Hunter.sh``` script allows the ```G4Hunter.py``` script released in 2015 by A.Bedrat, to be run for multiple sequence files in FASTA format. 

Before running the script, a number of things haveto be installed first:
- 
```G4Hunter.py``` is written in python 2.7, and requires Biopython dependencies to run. Although the new version do Biopython only support python 3.6 or higher. Thus you need to make sure that you have biopython version 1.76, or older installed. You can find the source packages here:

https://biopython.org/wiki/Download 

If running on macOS, you need to have xcode installed. 

After you download and unzip a Biopython source code release, or get their code from GitHub. Then run the following making sure to use python2
```
$ python2 setup.py build
$ python2 setup.py test
$ python2 setup.py install 
```
or 
``` pip2 install .```


About the outputs:
-

The outputs of the original script are conserved. Meaning that for each sequence two files are created by ```G4Hunter.py``` as follows: 

- ```{sequence}-Merged.txt```: contains the fused sequences of the individual overlapping windows whose G4 propensity score was above the given threshold. START and END positions of the said sequences are also given, along with the sequence in itself, it's length and the G4 propensity score. All potential G4 sequences may not have the same overall length. This is due to the algorithm extending the overlapping regions in case G or C bases are found near any one of the ends, to avoid "cutting" into a motif. Additionnally, the scores for these regions will often be below that of the scoring threshold. This is due to some regions sometimes having "bad ends" in terms of base score. Which naturally will decrease the overall score average of the region, consisting in the G4 propensity score.

- ```{sequence}-W-S.txt```: contains all sliding windows for the entire input sequence. START and END positions are given for each window, along with the window sequence and the window's individual G4 propensity score. Only the windows with a score > threshold will be kept for the -merged file. 
Let's note that the region with the highest individual sliding window score may NOT result in the top G4 score region in the merged file. Once again, this is due to the scoring of the flanking regions of the G4. 

In addition to those two files wich are output for each input sequence, ```runG4Hunter.sh``` gnerates a third file as output for ALL input sequences. 
this file is called ```{output name}_sorted.txt``` to keep track of which parameters were used for the analysis. It combines to top scores G4 regions for each input sequence, in a descending order. (AKA: the sequence with the best G4 overall will have it's best G4 rgeion displayed at the top of this file) 

The script ```runG4Hunter.sh``` is run from the command line as follows: 

```$ bash runG4hunter.sh {/PATH/to/input_sequences/} {Window size} {Score Threshold} {output name}```

Make sure of the following before running the script:
-
- Have ```G4Hunter.py``` and ```runG4Hunter.sh``` within the same directory. Or alternatively put them both on  ```$PATH```. NOTE: due to some structural incongruencies from the original python script, which, have not been fixed yet, it is best to put both program within the same directory before running. ALSO, all outputs directories and file are directed to ```./```. Hnece make sure to have a dedicated folder for the results and ideally have both scripts in there before running. (The ```Reuslts_{sequence}/``` directories will be updated for every new run of the program. 
- All input files need to be in FASTA format, within a dedicated directory 
- Results files for each sequence will each be stored within an indepedent directory called ```Results_{sequence}/```. 
- Main results file ```{output name}_sorted.txt``` will be stored in the main directory. Name updated eachh round so you'd have as many files as runs of ```runG4Hunter.sh```
