To cite, use: [![DOI](https://zenodo.org/badge/122322703.svg)](https://zenodo.org/badge/latestdoi/122322703)

To access scripts and supporting documents, download the whole repository from [here](https://github.com/JalalAl-Tamimi/Praat-Measurement-points). You can access it by clicking on "View on GitHub" on top.


There are two version of this script:

1) The script "measurement_points_estimation_v4.praat" is to be used if you have a Praat version 6.3.22 or below.
2) The script "measurement_points_estimation_v5.praat" is to be used for any version of Praat above 6.4. These new versions use the updated Praat algorithm for detection of pitch


The two scripts "measurement_points_estimation_v4.praat" and "measurement_points_estimation_v5.praat" provide an automated method to estimate the accurate positions of of frames to 
obtain reliable results for formant, pitch and intensity results. Starting from a current TextGrid, the script uses a combination
of pitch detection, point process estimation, intensity and formant estimations to obtain accurate positions of frames.
The results are saved on two additional tiers, whereby even number are on the first point tier and odd numbers on another one.
An example of original TextGrid and Sound file are provided in addition to a new TextGrid with extension "_MPnt".

See the following references for more details on the method:

* Al-Tamimi, J., & Khattab, G. (2015). "Acoustic cue weighting in the singleton vs geminate contrast in Lebanese Arabic: The case of fricative consonants". Journal of the Acoustical Society of America, 138(1), 344–360.
* Al-Tamimi J. (2017). "Revisiting acoustic correlates of pharyngealization in Jordanian and Moroccan Arabic: Implications for formal representations". Laboratory Phonology: Journal of the Association for Laboratory Phonology, 8(1): 1-40.
* Al-Tamimi, J. and Khattab, G., (2018). Acoustic correlates of the voicing contrast in Lebanese Arabic singleton and geminate stops. Invited manuscript for the special issue of Journal of Phonetics, "Marking 50 Years of Research on Voice Onset Time and the Voicing Contrast in the World’s Languages" (eds., T. Cho, G. Docherty & D. Whalen)." Vol: 71, pp. 306-325. doi.org/10.1016/j.wocn.2018.09.010
