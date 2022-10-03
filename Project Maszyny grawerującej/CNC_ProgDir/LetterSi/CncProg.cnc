
%001 (CncProgram Letter "i")

( --- Set Main parameters --- )
N10 G90 				(set absolute direct)
N20 F FeedFast  		(set  fast feed rate)
N30 S SPINDLE_SPEED 	(set spindle speed)
		
(--- Engraving part of code ---)
N40 G01 Z120 			(go to sefty position in Z axis)
N45 G94 F FeedSlow		(set slow feed rate)
N47 M40					(Turn off visiability of trajectory in paper widget)

		
(--- Make dot in "i" ---)
N50 G91 				(change to relative move)
N60 G01 Y50 			(go to starting position)
N70 M03 				(start spindle)
N75 G04 1				(wait 1s to high spped of spindle)
N79 M41					(Turn on visiability of trajectory in paper widget)
N80 G01 Z-21 			(go down to make dot)
N85 G04 1				(wait 1s to make clear dot)
N86 G01 Y-2				(Make a Dot)
N90 G01 Z21  			(go up to safe position)
N91 M40					(Turn off visiability of trajectory in paper widget)
N92 M05 				(stop spindle)
N95 G04 1				(wait 1s to stop spindle)	
	
(--- Make second part of letter ---)
N100 G01 Y-25 			(go to top of second part of letter)
N102 M03 				(start spindle)
N105 G04 1				(wait 1s to high spped of spindle)
N110 G01 Z-21 			(Go down)
N111 M41				(Turn on visiability of trajectory in paper widget)
N115 G04 1 				(wait 1s to enter a material)
N120 G01 Y-73 			(engraving line)
N125 G04 1 				(wait 1s to smooth end of engraving )
N126 M40				(Turn off visiability of trajectory in paper widget)
N130 G01 Z21 			(go to safe position)

(--- Ending program ---)
N140 M05 				(stop spindle)
N145 F FeedFast  		(set fast feed rate)
N150 G90 G01 Y0 Z300 	(go to home positon)

N999 M30
