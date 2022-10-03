(*********************************************************************************
 * Copyright:   
 * Author:    ppiwo 
 * Created:   July 11, 2022/1:00 PM 
 * Description: File with Fine State Machine of homing motors and configuration of used motors
 *********************************************************************************)

PROGRAM _INIT
    (*--- Enable MpCnc3Axis ---
		Enable MpCncsAxis and define parameters*)
	MpCnc3Axis_0.Enable 				:= TRUE;
	MpCnc3Axis_0.Override 				:= 100.0;
	CncParameters.ProgramName 			:= 'GoToHome';
    
	(*--- Enable MpAxisBasic ---
		Enable MpAxisBasic and define parameters*)
	MpAxisBasic_X.Enable				:= TRUE;
	MpAxisBasic_Y.Enable 				:= TRUE;
	MpAxisBasic_Z.Enable 				:= TRUE;
	MpAxisSpindle.Enable 				:= TRUE;
	
	(* --- Set default Axis Parameters --- *)
	actionSetAxisParameters;
	
	(* --- Initialize value of variables in program ---  *)
	diEmergencyStop						:= TRUE; //Set high level Emergency Stop to have confidence thet in HMI it has value TRUE 
	PathPrevStatus						:= 0; 
	svg_path 							:= '/FileDevice:CNC_ProgDir/PathPreview.svg'; //Initialize path to draw trajectory
	svg_string;
	FlagEstop							:= FALSE;
	
	(* --- Set enable and MpLink of Alarm Core and AlarmHistoryCore --- *)
	AlarmCore.MpLink					:= ADR(gAlarmXCore);
	AlarmCore.Enable					:= TRUE;
	
	AlarmHistoryCore.MpLink				:= ADR(gAlarmXHistory);
	AlarmHistoryCore.Enable				:= TRUE;

	
END_PROGRAM

PROGRAM _CYCLIC
	
(* --- Initialize of AlarmCore and AlarmHistoryCore --- *)
	AlarmCore();
	AlarmHistoryCore();
	
(* --- Initialize MpCncAxis and all MpAxisBasic ---
	  Initialize axis by before prepered parameters  in Init Block*)
	
	MpCnc3Axis_0.MpLink 				:= ADR(gCncXYZ);
	MpCnc3Axis_0.Parameters 			:= ADR(CncParameters);
	MpCnc3Axis_0();
	MpAxisBasic_X.MpLink     			:= ADR(gAxisQX);
	MpAxisBasic_X.Parameters 			:= ADR(AxisParameters[0]);
	MpAxisBasic_X();
	MpAxisBasic_Y.MpLink    			:= ADR(gAxisQY);
	MpAxisBasic_Y.Parameters 			:= ADR(AxisParameters[1]);
	MpAxisBasic_Y();
	MpAxisBasic_Z.MpLink     			:= ADR(gAxisQZ);
	MpAxisBasic_Z.Parameters 			:= ADR(AxisParameters[2]);
	MpAxisBasic_Z();
	MpAxisSpindle.MpLink     			:= ADR(gAxisQS);
	MpAxisSpindle.Parameters 			:= ADR(AxisParameters[3]);
	MpAxisSpindle();
	
	actionAlarm; // Check position Z, Y position and set flag to alarm/enable switch JOG
	
	(* --- Transition to STATE_ERROR ---*)
	IF MpCnc3Axis_0.Error THEN
		AxisState							:= STATE_ERROR;
	END_IF;
	
	(* --- Service press Emenrency STOP --- 
			Motors of machine are switch off and machine go to STATE_DEFAULT,
			AutoMOde goto STATE_WAIT_START*)
	IF diEmergencyStop = FALSE THEN
		MpCnc3Axis_0.Stop				:= TRUE;
		FlagPresEStop 					:= TRUE;
		AxisState 						:= STATE_DEFAULT;
		AutoState 						:= STATE_WAIT_START;	
	END_IF;
	
	
	(*--- Finite State Machine to powered on and homed motors ---*)
	CASE AxisState OF
		
		(* In STATE_DEFAULT machine is automaticly after switch on main power. In this state all axis action is reset
			FSM go to next state when PowerOnSwitch is on high level and Flag ReadyToPowerOn is true *)
		STATE_DEFAULT:
			
			(* Reset all parameters of motors  *)
			MpCnc3Axis_0.Stop			:= FALSE;
			MpCnc3Axis_0.Power			:= FALSE;
			MpCnc3Axis_0.Home			:= FALSE;
			MpCnc3Axis_0.MoveProgram	:= FALSE;
			
			MpAxisBasic_X.MoveAbsolute	:= FALSE;
			MpAxisBasic_X.MoveAdditive	:= FALSE;
			MpAxisBasic_X.MoveVelocity	:= FALSE;
			
			ConfXPos					:= FALSE;
			ConfYPos					:= FALSE;
			ConfZPos					:= FALSE;
			
			FlagAbleSet					:= TRUE;
			FlagConfirmError 			:= FALSE;
			MpAlarmXReset(gAlarmXCore,'Axis Error');
			
			(* Set new Axis Parameters *)
			actionSetAxisParameters;
			
			IF PowerOnSwitch = TRUE AND MpCnc3Axis_0.Info.ReadyToPowerOn = TRUE  THEN //transition to StatePower
				AxisState				:= STATE_POWER; 
			END_IF;
			
			(* In STATE_POWER all axis are powerd on, when flag PowerOn is in high level FSM go to nest step *)
		STATE_POWER:
			
			MpCnc3Axis_0.Power			:= TRUE; //motors are powered on
		
			IF MpCnc3Axis_0.PowerOn = TRUE THEN  //Transition to StateHome, check if motors is powered on
				AxisState				:= STATE_HOME;
			END_IF;
			
			(* In STATE_HOME all axis is homed. We set up taht in the first time machine is in safety position.
			    Next step is able if flag IsHomed is True. If machine is switch on after EStop axis Y and Z go to homing position *)
		STATE_HOME:
			IF (FlagPresEStop = FALSE)  THEN
				MpCnc3Axis_0.Home		:= TRUE; //Motors are homed
				IF MpCnc3Axis_0.IsHomed = TRUE THEN //Transition to StateReady, check if motors is homed on
					AxisState			:= STATE_READY;
				END_IF;
			ELSE 
				(* Service case when Emergency STOP was used *)
				IF FlagEstop = TRUE THEN
					CncParameters.ProgramName	:= 'GoToHome';
					MpCnc3Axis_0.MoveProgram	:= TRUE;
					IF MpCnc3Axis_0.MoveDone = TRUE THEN
						FlagPresEStop			:= FALSE;
						MpCnc3Axis_0.MoveProgram:= FALSE;
						FlagEstop       		:= FALSE;
						AxisState				:= STATE_READY;
					END_IF;
				END_IF;
			END_IF;
			
			(* STATE_READY is  state when machine could start workin with element. 
				This state have 2 substeps, which are mode of work machine *)
		STATE_READY: 
			MpCnc3Axis_0.Home			:= FALSE;
			IF SwitchAuto THEN
				AxisState 				:= STATE_AUTO_WORK;
			END_IF;
			
			IF SwitchManual THEN
				AxisState 				:= STATE_MATUAL_WORK;
			END_IF;
		
			(* In this  state machine work in Automatic mode.
				Machine in Auto mode drive to processing place, measure elements and engraving elements  *)	
		STATE_AUTO_WORK:
			actionAutoWork;
			
			(* In this  state machine work in Manualy mode.
				Operator make all activity to move machine and engraving elements  *)	
		STATE_MATUAL_WORK:
			actionSetAxisParameters;
			actionManualWork;
		
			(* In this state is described behavior when machine has some errors.
			   When error is detected machine is stopping and is setting alarm.
			   If Alarm is confirmed error is deleted and machine return into STATE_DEFAULT*)	
		STATE_ERROR:
			(* Motors are off *)
			MpCnc3Axis_0.Power			:= FALSE;
			MpCnc3Axis_0.Home			:= FALSE;
			MpCnc3Axis_0.MoveProgram	:= FALSE;
			MpAlarmXSet(gAlarmXCore,'Axis Error');
			
			IF FlagConfirmError = TRUE THEN
				MpCnc3Axis_0.ErrorReset		:= TRUE;
			END_IF;
			IF  NOT MpCnc3Axis_0.Error THEN //transition to go out from stateError
				MpCnc3Axis_0.ErrorReset	:= FALSE;
				AxisState				:= STATE_DEFAULT;
			END_IF;	
	END_CASE;

	(* Rewriting value od sensor to physical output *)
	IF diLaserSensor=TRUE THEN
		doLaserSensor:=TRUE;
	ELSE
		doLaserSensor:=FALSE;
	END_IF;
END_PROGRAM

PROGRAM _EXIT
	MpCnc3Axis_0(Enable := FALSE);
END_PROGRAM