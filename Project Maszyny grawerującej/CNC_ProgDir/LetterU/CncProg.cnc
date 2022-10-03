
%001 (CncProgram Letter "U")

( --- Set Main parameters --- )
N10 G90 							(set absolute direct)
N20 F FeedFast   					(set  fast feed rate)
N30 S SPINDLE_SPEED  				(set spindle speed)
					
(--- Engraving part of code ---)
N40 G01 Z120 						(go to sefty position in Z axis)
N45 F FeedSlow						(set slow feed rate)
N50 M03 							(start spindle)
N51 M40								(Turn off visiability of trajectory in paper widget)

(--- Make first part of letter "U" --- )
N60 G91 							(change to relative move)
N70 G01 X-37.5 Y50 					(go to starting position)
N80 G01 Z-21 						(go down)
N81 M41								(Turn on visiability of trajectory in paper widget)
N85 G04 1							(wait 1s to enter a material )
N90 G01 Y-75						(Make first horizontal line in "U")
N100 G90 G03 X-12.5 Y-50 R=25		(Make first arch in "U")
N110 G91 G01 X25					(Make horizontal line in "U")
N120 G90 G03 X37.5 Y-25 R=25		(Make second arch in "U")
N125 G91
N130 G01 Y75						(Make second vertival line in "U")
N140 G04 1							(wait 1s to smooth end of engraving )
N150 G01 Z21						(go to safe position in Z axis)
N151 M40							(Turn off visiability of trajectory in paper widget)

(--- Ending program ---)
N210 M05 							(stop spindle)
N220 F FeedFast 					(set fast feed rate)
N230 G90 G01 Y0 Z300 				(go to home positon)

N999 M30