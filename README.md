# Visibility

This repository contains scripts for intervisibility calculation and prominence assessment in ground truthed burial mounds in the Yambol province. Figures produced through these scripts are published in DigiThrace special issue. 
The scripts need a bit more clean up:

- separate the compute-intense calculations into separate scripts DONE (01, 02)
- check all the interim products are consistently named (IN PROGRESS)


The purpose of current scripts is: 
01 - show different intervisibility calculations with for and foreach() with parallelisation for 1073 mounds within Yambol in bare-earth model as well as 10m vegetation and 20m varied vegetation
02 - extend the foreach() calculation to additional 341 border mounds ( within 5km inner buffer) to 1026 external mounds within 25 km outside Yambol to account for edge effects. And calculate
03 - visualize some of the results of the BOM, 10veg and 20veg models
04 - map the intervisiblity restuls
05 - all the figures for the proceedings
06 - compute the chronological profile of mounds in Yambol