## 30 June 2004: original version. Based on Al-Tamimi (2004), JEP. Using Winsnoori. Max intensity picked in a 10 msec window.
## 1 May 2006: version 1: Adapted to Praat. Using normal pitch tracking and original implementation 
## 06 April 2009: version 2. Using normal pitch tracking, Point Process to estimate mean period duration. 
## 01 April 2011: version 3. A few updates and using To Pitch (ac) (for details, see Al-Tamimi and Khattab, 2015, JASA, 138(1): 344–360).  
## 25 May 2017: version 4. Using cross-correlation pitch estimate rather than autocorrelation (see Al-Tamimi and Khattab, under review, Journal of Phonetics, Special Issue on VOT) 
## 29 June 2022: Minor updates
## 20 October 2024: major update. Uses the latest update in Praat's pitch analysis
## Requires version 6.4 or above!



## The method starts by estimating the mean duration of a complete glottal cycle adapted to each speaker (the two-pass method).
## Then estimation of Intensity is based on Pitch minimum value estimated from the two pass method. The maximum intensity is obtained
## in a window with a length equal to the mean duration of a glottal cycle. 
## To allow for appropriate estimation of frame number, this implementation uses formant tracks to obtain the apporpriate position of frames.
## Two tiers are created, and results for even intervals are added on tier Pntl1 whereas the odd intervals are added on tier Pntl1+ to allow
## for non-overlapping points. 


beginPause: "Estimation of measurement points"
comment: "Where are your sound files and TextGrids?"
sentence: "directory1", ""
comment: "Select your measurements tier"
integer: "Tier", 3
clicked = endPause: "OK", 1

if directory1$ = ""
	directory1$ = chooseDirectory$("Select your directory of sound files and TextGrids")
endif

Create Strings as file list: "list", "'directory1$'/*.wav"

numberOfFiles = Get number of strings

for i from 1 to numberOfFiles
	select Strings list
   	fileName$ = Get string: i

	Read from file: "'directory1$'/'fileName$'"
	name$ = selected$ ("Sound")
	Read from file: "'directory1$'/'name$'.TextGrid"
	select Sound 'name$'
	
	noprogress To Pitch (raw cross-correlation): 0.005, 50, 800, 15, "yes", 0.03, 0.45, 0.01, 0.35, 0.14
	q1 = Get quantile: 0, 0, 0.25, "Hertz"
	q3 = Get quantile: 0, 0, 0.75, "Hertz"
	minPitch = q1*0.75
	maxPitch = q3*1.5
	Remove
	select Sound 'name$'
	noprogress To Pitch (raw cross-correlation): 0.005, minPitch, maxPitch, 15, "yes", 0.03, 0.45, 0.01, 0.35, 0.14
	pitch = selected ("Pitch")
	select Sound 'name$'
	plus 'pitch'
	pointProsess = noprogress To PointProcess (cc)
	meanPeriod = Get mean period: 0, 0, 0.0001, 0.02, 1.3

	select Sound 'name$'
	To Intensity: minPitch, 0.005, "yes"



	select TextGrid 'name$'
	nbTiers = Get number of tiers
	Insert point tier: nbTiers+1, "Pntl1"
	Insert point tier: nbTiers+2, "Pntl1+"

	nb_interval = Get number of intervals: tier

	for j from 1 to nb_interval
		select TextGrid 'name$'
		label$ = Get label of interval: tier, j
		if label$ <> ""
			end = Get end point: tier, j
			start = Get starting point: tier, j
			duration = end - start
			mid = start+(duration/2)

			midBeforeFrame = mid - (meanPeriod/2)
			midAfterFrame = mid + (meanPeriod/2)
			startAfterFrame = start + meanPeriod
			endBeforeFrame = end - meanPeriod

			select Intensity 'name$'
			maxTimeIntensityStart = Get time of maximum: start, startAfterFrame, "Parabolic"
			maxTimeIntensityMid = Get time of maximum: midBeforeFrame, midAfterFrame, "Parabolic"
			maxTimeIntensityEnd = Get time of maximum: endBeforeFrame, end, "Parabolic"

			startCut = start - 0.5
			endCut = end + 0.5
			selectObject: "Sound 'name$'"
			soundpart = Extract part: startCut, endCut, "rectangular", 1, "yes"
			formant = noprogress To Formant (burg): 0.005, 5, 5500, 0.025, 50
			fnStart = Get frame number from time: maxTimeIntensityStart
			fnMid = Get frame number from time: maxTimeIntensityMid
			fnEnd = Get frame number from time: maxTimeIntensityEnd
			fnStartR = round (fnStart)
			fnMidR = round (fnMid)
			fnEndR = round (fnEnd)
		
			startPointFrame = Get time from frame number: fnStartR
			midPointFrame = Get time from frame number: fnMidR
			endPointFrame = Get time from frame number: fnEndR

			select TextGrid 'name$'

			if j mod 2 = 1 
				Insert point: nbTiers+1, startPointFrame, "Ons"
				Insert point: nbTiers+1, midPointFrame, "Mid"
				Insert point: nbTiers+1, endPointFrame, "Off"
			else
				Insert point: nbTiers+2, startPointFrame, "Ons"
				Insert point: nbTiers+2, midPointFrame, "Mid"
				Insert point: nbTiers+2, endPointFrame, "Off"
			endif

		endif
	endfor
	Write to text file: "'directory1$'/'name$'_MPnt.TextGrid"
	select all
	minus Strings list
	Remove
endfor
echo Finished! Check your new TextGrids located in 'directory1$'

