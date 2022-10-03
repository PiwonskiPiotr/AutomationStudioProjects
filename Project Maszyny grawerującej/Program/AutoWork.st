(*********************************************************************************
 * Copyright:   
 * Author:    ppiwo 
 * Created:   July 12, 2022/11:00 AM 
 * Description: In this file is located logic of Finite State Machine
				which supports automaticly engraving of elements.
 *********************************************************************************)

ACTION actionAutoWork: 
	
	(* --- Condition to go to ManualMode ---
			Machine can go to ManualMode in all AutoState except Engraving state *)
	IF (AutoState <> STATE_ENGRAVING) AND (SwitchManual = TRUE) THEN
		AxisState 									:= STATE_MATUAL_WORK;
	END_IF;
	
	(* --- Finite State Machine described working machine in Auto mode --- *)
	CASE AutoState OF
		
		(* STATE_WAIT_START is default state when machine go to Auto mode.
			In this state machine wait for signal from switchStart (clicked in visualization)
			and go to STATE_DRIVE. *)
		STATE_WAIT_START:
			(* Set Flag to corecr value to have corret action of AutoMode. Set new parameters of axis. *)
			FlagAbleSet 							:= TRUE;
			FlagDisableConfMove						:= TRUE;
			actionSetAxisParameters;
			MpAxisBasic_X.Update					:= TRUE; 
			
			IF SwitchStart = TRUE THEN
				AutoState 							:= STATE_DRIVE;				
			END_IF;
			IF PowerOnSwitch = FALSE THEN
				AxisState							:= STATE_DEFAULT;
			END_IF
			(* STATE_DRIVE is state where element commute to processing place.
				Element drive with high speed and when element enter to processing area (laser sensor give high level) 
				speed is set a low speed to make better accuracy.
				In this state memorized value of position when object is firstly detected and FSM go to nest state.   *)
		STATE_DRIVE:
			MpAlarmXReset(gAlarmXCore,'Too short object');	//Reset alarm 	
			MpCnc3Axis_0.MoveProgram				:= FALSE;
			FlagDisableConfMove						:= TRUE;
			(* --- reset value of measure temp variable --- *)
			startMeasurePos							:= 0;
			endMeasurePos							:= 0;
			
			(* --- logic of drive --- *)
			AxisParameters[0].Velocity 				:= XVelFast;
			MpAxisBasic_X.MoveVelocity				:= TRUE;
			
			IF diLaserSensor = TRUE AND prevLaserSensorState = FALSE THEN
				startMeasurePos 					:= LREAL_TO_REAL(MpCnc3Axis_0.X);
				AxisParameters[0].Velocity 			:= XVelSlow;
				MpAxisBasic_X.Update 				:= TRUE;
				prevLaserSensorState				:= diLaserSensor;
				AutoState							:= STATE_MEASUREMENT;
			END_IF;
		
			ChosenLetter							:= RemembLetter; //Update value of ChosenLetter
			
			(* IN this sate element is measure. Position when element is not in processing area is memorized in variable.
			length of element is diffrence between start and end position.
			After measure axis X is stopped and FSM go to state homing on front of element.  *)
		STATE_MEASUREMENT:
			IF  diLaserSensor = FALSE AND prevLaserSensorState = TRUE THEN
				endMeasurePos						:= LREAL_TO_REAL(MpCnc3Axis_0.X);
				LenghtOfElement						:= ABS(startMeasurePos-endMeasurePos);
				MpAxisBasic_X.MoveVelocity			:= FALSE;
				prevLaserSensorState				:= diLaserSensor;
				AutoState							:= STATE_POS_AFTER_MES;				
			END_IF;
			
			
			(* In this state axis X is homing in front of element.
			 at first axis go to front of element and set move to false. When move is false axis is homed 
			After homing FSM go to next state. *)
		STATE_POS_AFTER_MES:
			AxisParameters[0].Position 				:= endMeasurePos;
			MpAxisBasic_X.Update					:= TRUE;
			MpAxisBasic_X.MoveAbsolute				:= TRUE;
			AutoState								:= STATE_COMPARE_STRING;
			
			
			(* In is compare length of string with length of elemnt. 
			Length of string saved in constant variable and is chosen by structue CASE. 
			To length of string is added 40[mm] because engraving is made 20mm from the all edge.
			If length of string if greater than len of elements we have error in other case go to next state. *)	
		STATE_COMPARE_STRING:
			LenOfString								:= 0;
			MpAxisBasic_X.MoveAbsolute				:= FALSE;
			CASE ChosenLetter OF
				i_LETTER:
					LenOfString						:= LEN_i;
				I_LETTER:
					LenOfString						:= LEN_I;
				R_LETTER:
					LenOfString						:= LEN_R;
				U_LETTER:
					LenOfString						:= LEN_U;
				W_LETTER:
					LenOfString						:= LEN_W;
				X_LETTER:
					LenOfString						:= LEN_X;
			END_CASE;
			
			LenOfString								:= LenOfString + 40;
			
			IF LenOfString <= LenghtOfElement THEN				
				AutoState							:= STATE_GOTO_CENTER;
				
			ELSE
				MpAlarmXSet(gAlarmXCore,'Too short object');
				showMesBox							:= TRUE; 	//set flag to show messege box with text about that object is too short
				AutoState							:= STATE_DRIVE;
		
				
			END_IF;
		
			(* In this state axis X go to  center of element.
			Center of element is calculated by mean and go to this point by additive move.
			When axis is in position move is switched off and FSM go to next state.  *)
		STATE_GOTO_CENTER:
			CenterOfElement							:= LenghtOfElement / 2;
			AxisParameters[0].Distance 				:= - CenterOfElement;
			MpAxisBasic_X.Update					:= TRUE;
			MpAxisBasic_X.MoveAdditive				:= TRUE;
			IF MpAxisBasic_X.MoveDone = TRUE THEN
				MpAxisBasic_X.MoveAdditive			:= FALSE;
				AutoState							:= STATE_HOME_ON_CENTER;
			END_IF;
			
		(* In this state axis X is homing in center of element. 
			When motor is homed FSM go to next step*)	
		STATE_HOME_ON_CENTER:	
			MpAxisBasic_X.Home						:= TRUE;
			
			(* --- condition to step to next state ---
				I made condition with direct position and flag ComandBusy to have
				confidence that axis is homed  *)
			IF MpCnc3Axis_0.X = 0 AND MpAxisBasic_X.CommandBusy = FALSE THEN
				MpAxisBasic_X.Home					:= FALSE;
				AutoState							:= STATE_ENGRAVING;
			END_IF;
			
		STATE_ENGRAVING:
			//CncParameters.MoveProgramOptions.StartMode:=mcPRGSM_SIMULATION_GEOMETRY;
			CASE ChosenLetter OF
				i_LETTER:
					CncParameters.ProgramName 		:= 'LetterSi';
				I_LETTER:
					CncParameters.ProgramName 		:= 'LetterI';
				W_LETTER:
					CncParameters.ProgramName 		:= 'LetterW';
				R_LETTER:
					CncParameters.ProgramName 		:= 'LetterR';
				X_LETTER:
					CncParameters.ProgramName 		:= 'LetterX';
				U_LETTER:
					CncParameters.ProgramName 		:= 'LetterU';
	
			END_CASE;
			(* --- remember press switch STOPProgram when object is envraving --- *)
			IF SwitchStop=TRUE THEN
				RememberStop						:= TRUE;
			END_IF;
			
			MpCnc3Axis_0.MoveProgram				:= TRUE;
			
			(* --- Check if pozition on axis Z is 99 --- 
					use it ro M-Function*)
			IF MpCnc3Axis_0.Z > 100 THEN
				EngravingLevel						:= FALSE;	
			ELSE 
				EngravingLevelUp					:= FALSE;
			END_IF;
			
			IF MpCnc3Axis_0.MoveDone = TRUE THEN
				FlagDisableConfMove					:= FALSE;
				AutoState							:= STATE_DRIVE;
			END_IF;
								
	END_CASE;
	
	(* --- Stop AutoMode --- 
			AutoMode is stopping when object is not engraving.
			When STOP was pressed in state ENGRAVING, program was doing to end and AutoMode is stopped. *)	
	IF AutoState <> STATE_ENGRAVING THEN
		IF (RememberStop = TRUE) OR (SwitchStop = TRUE) THEN
			MpAxisBasic_X.MoveVelocity				:= FALSE;
			RememberStop							:= FALSE;
			AutoState								:= STATE_WAIT_START;
		END_IF;
	END_IF;		
END_ACTION