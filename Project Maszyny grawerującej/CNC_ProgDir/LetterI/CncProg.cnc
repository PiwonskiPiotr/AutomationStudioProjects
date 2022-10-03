
%001 (CncProgram Letter Upper "I")

( --- Set Main parameters --- )
N10 G90 				(set absolute direct)
N20 F FeedFast   		(set  fast feed rate)
N30 S SPINDLE_SPEED 	(set spindle speed)
		
(--- Engraving part of code ---)
N40 G01 Z120 			(go to sefty position in Z axis)
N45 F FeedSlow				(set slow feed rate)
N50 M03 				(start spindle)
N51 M40					(Turn off visiability of trajectory in paper widget)

(--- Make Letter "I" ---)
N60 G91 				(change to relative move)
N70 G01 Y50 			(go to starting position)
N80 G01 Z-21 			(go down to make dot)
N81 M41					(Turn on visiability of trajectory in paper widget)
N85 G04 1				(wait 1s to make clear dot)
N120 G01 Y-100			(engraving line)
N125 G04 1 				(wait 1s to smooth end of engraving )
N130 G01 Z21 			(go to safe position)
N131 M40				(Turn off visiability of trajectory in paper widget)

(--- Ending program ---)
N140 M05 				(stop spindle)
N145 F FeedFast 		(set fast feed rate)
N150 G90 G01 Y0 Z300 	(go to home positon)

N999 M30