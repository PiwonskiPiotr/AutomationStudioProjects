
%001 (CncProgram Letter "X")

( --- Set Main parameters --- )
N10 G90 				(set absolute direct)
N20 F FeedFast   		(set  fast feed rate)
N30 S SPINDLE_SPEED  	(set spindle speed)
		
(--- Engraving part of code ---)
N40 G01 Z120 			(go to sefty position in Z axis)
N45 F FeedSlow			(set slow feed rate)
N50 M03 				(start spindle)
N51 M40					(Turn off visiability of trajectory in paper widget)

(--- Make firts part of "X" ---)
N60 G91 				(change to relative move)
N70 G01 X-37.5 Y50 		(go to starting position)
N80 G01 Z-21 			(go down)
N81 M41					(Turn off visiability of trajectory in paper widget)
N85 G04 1				(wait 1s to enter a material )
N90 G01 X75 Y-100		(go to end of first part of "X")
N110 G04 1				(wait 1s to smooth end of engraving )
N100 G01 Z21			(go to safe position in Z axis)
N101 M40				(Turn off visiability of trajectory in paper widget)

(--- Make second part of "X" ---)
N110 G01 X-75			(go to position above starting point second part of "X")
N120 G01 Z-21			(Go down to material)
N121 M41				(Turn on visiability of trajectory in paper widget)
N130 G04 1				(wait 1s to enter a material)
N140 G01 X75 Y100		(engraving line, go to end of second part of "X")
N150 G04 1				(wait 1s to smooth end of engraving )
N160 G01 Z21			(go to safe position in Z axis)
N161 M40				(Turn off visiability of trajectory in paper widget)

(--- Ending program ---)
N170 M05 				(stop spindle)
N180 F FeedFast  		(set fast feed rate)
N190 G90 G01 Y0 Z300 	(go to home positon)

N999 M30
