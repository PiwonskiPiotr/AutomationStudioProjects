(*********************************************************************************
 * Copyright:   
 * Author:    ppiwo 
 * Created:   July 19, 2022/10:35 AM 
 * Description: In this action is describing functionality of ManualMode. 
				In ManualMode is applied move to set position with set velocity. 
				Moreover in this mode is applied Jog mode and switch on spindle with set velocity 
 *********************************************************************************)

ACTION actionManualWork: 

(* --- Reset before activeted move and set all necessery parameters to basic value *)
	(* Set to basic parameters of single axis *)
	MpAxisBasic_X.MoveVelocity					:= FALSE;
	AxisParameters[0].Velocity 					:= 0;
	AxisParameters[1].Velocity 					:= 0;
	AxisParameters[2].Velocity 					:= 0;
	AxisParameters[3].Velocity 					:= 0;
	MpAxisBasic_X.Update						:= TRUE;
	(* Set AutoState to basic value *)
	AutoState 									:= STATE_WAIT_START;
	FlagDisableConfMove							:= FALSE;
	(* --- Set parameters of Jog move --- *)	
	
	
(* --- Set flag, witch tell when able next move in ManualMode ---
		This flag is used to blocing or unblocking next move, like said in specification taht in ManualMode we 
		can move once axis plus spindle. This flag is in high level when all (3) Cnc axis don't move, next move will be realized.
		When Flag is in high level albe is to change mode to AutoMode an able is switch off the machine.  *)
	IF MpAxisBasic_X.MoveActive = FALSE AND MpAxisBasic_Y.MoveActive = FALSE  
		AND MpAxisBasic_Z.MoveActive = FALSE  THEN
		FlagAbleSet								:= TRUE;
		IF PowerOnSwitch = FALSE THEN
			AxisState							:= STATE_DEFAULT;
		END_IF
		IF SwitchAuto THEN
			AxisState							:=STATE_AUTO_WORK;
		END_IF;
	ELSE
		FlagAbleSet								:= FALSE;
		;
	END_IF;
	
	
(* --- Main Logic of ManualMode ---
		In case is decided which axis will be moved
		in IF with SwitchSpindelOnOff is decidec if spindle will be actived Spindel could be active parallel with other axis *)
	IF SwitchSpindleOnOff = TRUE THEN
		AxisParameters[3].Velocity				:= SpindleVelocityIn;
		MpAxisSpindle.MoveVelocity				:= TRUE;
	ELSE
		AxisParameters[3].Velocity				:= 0;
		MpAxisSpindle.Update					:= TRUE;
		MpAxisSpindle.MoveVelocity				:= FALSE;
	  
	END_IF;
	
	CASE ManualState OF
		MANUAL_MOVE_NONACTIVE:
			IF FlagAbleSet = TRUE THEN
	  			ManualState						:= MANUAL_MOVE_ACTIVE;
			END_IF;
		MANUAL_MOVE_ACTIVE:
			
			(* --- Move to set position ---
			If some axis is set to move, value of position and velocity in this axis is updated and realized move.
			After move switches of confirmation are reset to allow next move.
			Unfortunately this structure doesn't protect to rememberd setting parameters in previous terms, like X axis *)
			IF ConfXPos = TRUE THEN
				AxisParameters[0].Position 			:= XPosition;
				AxisParameters[0].Velocity 			:= XVelocity;
				MpAxisBasic_X.Update				:= TRUE;
				MpAxisBasic_X.MoveAbsolute 			:= TRUE;
				IF MpAxisBasic_X.MoveDone = TRUE THEN
					ConfXPos 						:= FALSE;
					ConfYPos 						:= FALSE;
					ConfZPos 						:= FALSE;
					MpAxisBasic_X.MoveAbsolute 		:= FALSE;
				END_IF;

			ELSIF ConfYPos = TRUE THEN
				AxisParameters[1].Position 			:= YPosition;
				AxisParameters[1].Velocity 			:= YVelocity;
				MpAxisBasic_X.Update				:= TRUE;
				MpAxisBasic_Y.MoveAbsolute 			:= TRUE;
				IF MpAxisBasic_Y.MoveDone = TRUE THEN
					ConfXPos 						:= FALSE;
					ConfYPos 						:= FALSE;
					ConfZPos 						:= FALSE;
					MpAxisBasic_Y.MoveAbsolute 		:= FALSE;
				END_IF;
			
			ELSIF ConfZPos = TRUE THEN
				AxisParameters[2].Position 			:= ZPosition;
				AxisParameters[2].Velocity 			:= ZVelocity;
				MpAxisBasic_X.Update				:= TRUE;
				MpAxisBasic_Z.MoveAbsolute 			:= TRUE;
				IF MpAxisBasic_Z.MoveDone = TRUE THEN
					ConfXPos 						:= FALSE;
					ConfYPos 						:= FALSE;
					ConfZPos 						:= FALSE;
					MpAxisBasic_Z.MoveAbsolute 		:= FALSE;
				END_IF;
			
		(* --- Jog move --- 
				If button responsible for jog in some axis is activ,
				 jog in this axis is realized *)
			ELSIF JogPlusXActive = TRUE THEN
				MpAxisBasic_X.JogPositive			:= TRUE;
		
			ELSIF JogMinusXActive = TRUE THEN
				MpAxisBasic_X.JogNegative			:= TRUE;
				
			ELSIF JogPlusYActive = TRUE THEN
				MpAxisBasic_Y.JogPositive			:= TRUE;
						
			ELSIF JogMinusYActive = TRUE THEN
				MpAxisBasic_Y.JogNegative			:= TRUE;
					
			ELSIF JogPlusZActive = TRUE THEN
				MpAxisBasic_Z.JogPositive			:= TRUE;
						
			ELSIF JogMinusZActive = TRUE THEN
				MpAxisBasic_Z.JogNegative			:= TRUE;
			ELSE
				MpAxisBasic_X.JogPositive			:= FALSE;
				MpAxisBasic_X.JogNegative			:= FALSE;
				MpAxisBasic_Y.JogPositive			:= FALSE;
				MpAxisBasic_Y.JogNegative			:= FALSE; 
				MpAxisBasic_Z.JogPositive			:= FALSE;
				MpAxisBasic_Z.JogNegative			:= FALSE;
				ManualState							:= MANUAL_MOVE_NONACTIVE;
			END_IF;
	END_CASE;
END_ACTION
