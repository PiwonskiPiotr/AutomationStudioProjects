(*********************************************************************************
 * Copyright:   
 * Author:    ppiwo 
 * Created:   July 27, 2022/10:49 AM 
 * Description:In this action is described setting parameters of all Axis like
				velocity, position,acceleration or deceleration. 
				Make it in action safe space in main code  and 
				improve transparency.
 *********************************************************************************)

ACTION actionSetAxisParameters: 
	(* --- Set parameters to axis X --- *)
	AxisParameters[0].Position 			:= 100.0;
	AxisParameters[0].Distance 			:= 360.0;
	AxisParameters[0].Velocity 			:= XVelFast;
	AxisParameters[0].Acceleration 		:= XAcceleration;
	AxisParameters[0].Deceleration 		:= XDecleration;
	

	(* --- Set parameters to axis Y --- *)
	AxisParameters[1].Position 			:= 100.0;
	AxisParameters[1].Distance 			:= 360.0;
	AxisParameters[1].Velocity 			:= YVel;
	AxisParameters[1].Acceleration 		:= YAcceleration;
	AxisParameters[1].Deceleration 		:= YDecleration;
	
	(* --- Set parameters to axis Z --- *)
	AxisParameters[2].Position 			:= 100.0;
	AxisParameters[2].Distance 			:= 360.0;
	AxisParameters[2].Velocity 			:= ZVel;
	AxisParameters[2].Acceleration 		:= ZAcceleration;
	AxisParameters[2].Deceleration 		:= ZDecleration;
	AxisParameters[2].Homing.Mode		:= mcHOMING_DEFAULT; 
	
	(* --- Set parameters to Spindle --- *)
	AxisParameters[3].Velocity 			:= 10000.0;
	AxisParameters[3].Acceleration 		:= 10000.0;
	AxisParameters[3].Deceleration 		:= 1000.0;
	
	
	(* --- Set Parameters of JOG Mode to axis X --- *)
	CncParameters.Jog.Velocity[0]		:= X_JOG_CNC_VEL;
	AxisParameters[0].Jog.Acceleration	:= XJogAcc;
	AxisParameters[0].Jog.Deceleration	:= XJogDec;
	AxisParameters[0].Jog.Velocity		:= XJogVel;
	
	
	(* --- Set Parameters of JOG Mode to axis Y --- *)
	CncParameters.Jog.Velocity[1]		:= Y_JOG_CNC_VEL;
	AxisParameters[1].Jog.Acceleration	:= YJogAcc;
	AxisParameters[1].Jog.Deceleration	:= YJogDec;
	AxisParameters[1].Jog.Velocity		:= YJogVel;
	
	
	(* --- Set Parameters of JOG Mode to axis Z --- *)
	CncParameters.Jog.Velocity[2]		:= Z_JOG_CNC_VEL;
	AxisParameters[2].Jog.Acceleration	:= ZJogAcc;
	AxisParameters[2].Jog.Deceleration	:= ZJogDec;
	AxisParameters[2].Jog.Velocity		:= ZJogVel;
	
	(* --- Call variable CNC program to reseve mamory to their --- *)
	SPINDLE_SPEED;
	FeedFast;
	FeedSlow;
END_ACTION
