
%001 (CncProgram Letter "W")

( --- Set Main parameters --- )
N10 G90 				(set absolute direct)
N20 F FeedFast  		(set  fast feed rate)
N30 S SPINDLE_SPEED  	(set spindle speed)
		
(--- Engraving part of code ---)
N40 G01 Z120 			(go to sefty position in Z axis)
N45 F FeedSlow			(set slow feed rate)
N50 M03 				(start spindle)
N51 M40					(Turn off visiability of trajectory in paper widget)
		
(--- Make firts part of "W" ---)
N60 G91 				(change to relative move)
N70 G01 X-50 Y50 		(go to starting position)
N80 G01 Z-21 			(go down)
N81 M41					(Turn on visiability of trajectory in paper widget)
N85 G04 1				(wait 1s to enter a material )
N90 G01 X25 Y-100		(Make first line of "W")
N100 G01 X25 Y50		(Make 2-nd line of "W")
N110 G01 X25 Y-50		(Make 3-th line of "W")
N120 G01 X25 Y100		(Make 4-th line of "W")
N130 G04 1				(wait 1s to smooth end of engraving )
N140 G01 Z21			(go to safe position in Z axis)
N141 M40				(Turn off visiability of trajectory in paper widget)

(--- Ending program ---)
N170 M05 				(stop spindle)
N180 F FeedFast 		(set fast feed rate)
N190 G90 G01 Y0 Z300 	(go to home positon)

N999 M30