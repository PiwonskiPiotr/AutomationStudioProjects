(*********************************************************************************
 * Copyright:   
 * Author:    ppiwo 
 * Created:   July 27, 2022/10:53 AM 
 * Description: In this action is described setting falg which tell about axis is in dangerous position.
 *********************************************************************************)

ACTION actionAlarm: 
	
	(* --- In IF structure is setting flags when position cross some value --- *)
	IF AxisState  = STATE_MATUAL_WORK THEN
		
		(* --- Setting value of flag dependent on positon Axis Z --- *)
		IF MpCnc3Axis_0.Z > 295 THEN
			FlagDisableJogPos		:= TRUE;
		ELSE
			FlagDisableJogPos		:= FALSE;
		END_IF;
		
		IF MpCnc3Axis_0.Z < 5 THEN
			FlagDisableJogNeg		:= TRUE;
		ELSE
			FlagDisableJogNeg		:= FALSE;
		END_IF;
		
		(* --- Setting value of flag dependent on positon Axis Y --- *)
		IF MpCnc3Axis_0.Y > 245 THEN
			FlagDisableJogPosY		:= TRUE;
		ELSE
			FlagDisableJogPosY		:= FALSE;
		END_IF;
		
		IF MpCnc3Axis_0.Y < -245 THEN
			FlagDisableJogNegY		:= TRUE;
		ELSE
			FlagDisableJogNegY		:= FALSE;
		END_IF;
	END_IF;
	
END_ACTION
