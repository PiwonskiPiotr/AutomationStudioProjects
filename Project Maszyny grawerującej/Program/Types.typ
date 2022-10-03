
TYPE
	ManualStateEnum : 
		( (*State in manual work describe if move in axis is able*)
		MANUAL_MOVE_ACTIVE := 0, (*in this state able is move *)
		MANUAL_MOVE_NONACTIVE := 1 (*In this move axis is enable*)
		);
	AxisStateEnum : 
		( (*State in main program  decided about axises*)
		STATE_DEFAULT := 0, (*Machine is in this state after  switch on main power*)
		STATE_READY := 1, (*Motors are ready to next action*)
		STATE_HOME := 2, (*In this state motors are hommed, are in "safety" position*)
		STATE_POWER := 3, (*In this state motors are powered on*)
		STATE_MATUAL_WORK := 4, (*Machine is in ManualMode*)
		STATE_AUTO_WORK := 5, (*Machine is in AutoMode*)
		STATE_ESTOP := 6,
		STATE_ERROR := 7 (*Machine has some error*)
		);
	AutoStateEnum : 
		( (*State in Auto mode*)
		STATE_WAIT_START := 0, (*Machine wait for activated porocedure *)
		STATE_DRIVE := 1, (*Eelemnt drive to processing place*)
		STATE_MEASUREMENT := 2, (*Element is measured*)
		STATE_POS_AFTER_MES := 3, (*In this state axis X is homed after mesured element*)
		STATE_COMPARE_STRING := 4, (*in this state is compared length of sitrng and element *)
		STATE_GOTO_CENTER := 5, (*Spindle go to center of elements*)
		STATE_HOME_ON_CENTER := 6,
		STATE_ENGRAVING := 7 (*Element is engraved*)
		);
	LettersEnum : 
		( (*Enumetated of letters type*)
		i_LETTER := 0,
		I_LETTER := 1,
		R_LETTER := 2,
		U_LETTER := 3,
		W_LETTER := 4,
		X_LETTER := 5
		);
END_TYPE
