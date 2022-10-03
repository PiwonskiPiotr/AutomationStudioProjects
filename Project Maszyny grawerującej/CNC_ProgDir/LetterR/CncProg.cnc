
%001 (CncProgram Letter "R")

( --- Set Main parameters --- )
N10 G90 							(set absolute direct)
N20 F FeedFast  					(set  fast feed rate)
N30 S SPINDLE_SPEED 				(set spindle speed)
					
(--- Engraving part of code ---)
N40 G01 Z120 						(go to sefty position in Z axis)
N45 F FeedSlow						(set slow feed rate)
N50 M03 							(start spindle)
N51 M40								(Turn off visiability of trajectory in paper widget)

(--- Make first part of letter "R" --- )
N60 G91 							(change to relative move)
N70 G01 X-25 Y50 					(go to starting position)
N80 G01 Z-21 						(go down)
N81 M41								(Turn on visiability of trajectory in paper widget)
N85 G04 1							(wait 1s to enter a material )
N90 G01 X25							(Make first upper horizontal line in "R")
N100 G90 G02 Y0 R=25				(Make arch in "R")
N105 G91
N110 G01 X-25						(Make second horizontal line in "R")
N120 G01 X50 Y-50					(Make sloping line in "R")
N130 G04 1							(wait 1s to smooth end of engraving )
N131 M40							(Turn off visiability of trajectory in paper widget)
N140 G01 Z21						(go to safe position in Z axis)

(--- Make vertical line in letter "R" ---)
N150 G01 X-50						(go to starting position)
N160 G01 Z-21 						(go down)
N161 M41							(Turn on visiability of trajectory in paper widget)
N170 G04 1							(wait 1s to enter a material )
N180 G01 Y100						(Make vertical line in "R")
N190 G04 1							(wait 1s to smooth end of engraving )
N191 M40							(Turn off visiability of trajectory in paper widget)
N200 G01 Z21						(go to safe position in Z axis)

(--- Ending program ---)
N210 M05 							(stop spindle)
N220 F FeedFast  					(set fast feed rate)
N230 G90 G01 Y0 Z300 				(go to home positon)

N999 M30