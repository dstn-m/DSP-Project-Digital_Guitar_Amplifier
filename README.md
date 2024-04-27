# DSP-Project-Digital_Guitar_Amplifier

'Dr. dB' - Final Project for Digital Signal Processing elective course, undertaken with a lab partner. 
Designed and implemented code to simulate a generic guitar amplifier on the OMAP-L138 DSP chip with user controllable 
* distortion, 
* EQ, modulation effects,
* master volume. 
A technical report is provided for more details on the design. Basic setup code provided by Welch, Write, &amp; Morrow. 
Software run on the OMAP-L138 originally developed in Code Composer Studio (CCS) V12, ported over to CCS V6 to utilize GUI Composer. The GUI for this project was designed by my lab partner, Lucas V. 

The Filter-Distortion-Modulation-Scripts folder contains scripts that can be run in Octave,
or, with some modification, MATLAB. The distortion and modulation folders particularly
contain a sample guitar .wav file that is processed by the scripts and played back both
with and without processing to illustrate the efficacy of the processing algorithms.

If running the CCS-code in CCSv12, the EQKnobs.gel file can be used to control all 
user-selectable variables. 

If running the code in CCS V6, add the DrdBGUI folder to CCS's webapps folder to use the GUI.