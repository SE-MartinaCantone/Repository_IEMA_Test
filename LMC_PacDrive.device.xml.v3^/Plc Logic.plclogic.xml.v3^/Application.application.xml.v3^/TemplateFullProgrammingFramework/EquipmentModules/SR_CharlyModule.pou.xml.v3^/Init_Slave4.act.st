__METADATA__
{
  "v3Meta": {
    "objectGuid": "55dece67-503d-47cc-994d-ea132f9266bd",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* System generated code, could be modified for your application *)

(* Standard interface *)
astSubModuleInterface[c_udiSlave4].i_sModuleName		:= CONCAT(STR1 := iq_stStandardModuleItf.i_sModuleName, STR2 := ': Slave4');

astSubModuleInterface[c_udiSlave4].i_xLogEnable			:= 	TRUE;
astSubModuleInterface[c_udiSlave4].i_wLogDataFilter		:= 	UDINT_TO_WORD(TPL.ET_LogDataFilter.ModuleDefault);

fbSlave4Module.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
									i_sName		:= 'Slave4',
									q_etDiag	:= ,
									q_etDiagExt	:= );

(* AxisModule specific interface *)
stSlave4Interface.stMain.i_ifMaster			:= i_ifMaster; 		(* Master *)
stSlave4Interface.stMain.i_ifDrive			:= DRV_Slave4;
stSlave4Interface.stMain.iq_lencEncoder		:= LE_Slave4;


xDriveIsVirtual := FC_IsDriveVirtual(	i_ifDrive	:= stSlave4Interface.stMain.i_ifDrive,
										q_etDiag	=> etDiag,
										q_etDiagExt	=> etDiagExt,
										q_sMsg		=> sMsgBuffer);

IF etDiag <> GD.ET_Diag.Ok AND NOT xIsDriveVirtualException THEN										
	stIsDriveVirtualException.etDiag 	:= etDiag;
	stIsDriveVirtualException.udiDiagExt:= etDiagExt;
	stIsDriveVirtualException.sDiagExt 	:= FC_EtDiagExtToString(i_etDiagExt := etDiagExt);										
	stIsDriveVirtualException.sMsg 		:= sMsgBuffer;
	xIsDriveVirtualException 			:= TRUE;
END_IF

fbExceptionHandler.SetException(i_xExceptionActive	:= xIsDriveVirtualException, 
								iq_stException		:= stIsDriveVirtualException, 
								iq_stExceptionList	:= iq_stExceptionList);
					
xInitSuccessful := xInitSuccessful AND NOT xIsDriveVirtualException;
etDiag := GD.ET_Diag.Ok;
	

(*Set DeadTime compensation parameters depending on used type of Master*)
FC_SetDeadTimeCompensation(i_stSubModuleInterfaceMain := stSlave4Interface.stMain);
  (*Please note, FC_DeadTimeCompensation does not recognize the master type, transferred via C2C or encoder network! 
	stXXXXInterface.stMain.iq_lencEncoder.Delay must be adjusted in order to reach shaft synchronism, it depends on:
	- Transmission delay via the choosen network, depending on topology and timing 
	- Type of the master e.g. physical encoder or an axis
	- SERCOS cycle times in master and slave controllers
	
	C2C sample (similar for encoder network):
	//Access C2C_EncIn.DataDelay only if C2C_Master.SyncGroupState = 5 or C2C_Slave.SyncGroupState = 5 and C2C_EncIn.DataValid = TRUE!

		//Master is a physical encoder (PMEnc/Inc):
			stXXXXInterface.stMain.iq_lencEncoder.Delay := C2C_EncIn.DataDelay - DRV_SlaveAxis.ShaftRefDelay;

		//Master is an axis (real/ virtual):
			stXXXXInterface.stMain.iq_lencEncoder.Delay := C2C_EncIn.DataDelay + one SERCOS cycle of C2C controller with connected master axis;*)


xFirstCall := TRUE;		// Used in Logic_Action to start movement in first cycle when OpMode is AXM.ET_OpMode.Positioning

stSlave4Interface.stMain.i_lrMotionActiveVelLimit						:= 15.0;	(* Limit for max. velocity of astAxisModuleInterface to switch output AxisMove in Units/s *)
stSlave4Interface.stMain.i_etMotionActiveVelType						:= AXM.ET_MotionActiveVelType.Velocity;

stSlave4Interface.stMain.i_timMasterStop								:= T#1S;
stSlave4Interface.stMain.i_xHwLimitPos									:= FALSE;
stSlave4Interface.stMain.i_xHwLimitNeg									:= FALSE;

stSlave4Interface.stMain.stReducedVelocity.i_xEnableReducedVelocity		:= FALSE;
stSlave4Interface.stMain.stReducedVelocity.i_xOnlyLimitCheck			:= FALSE;
stSlave4Interface.stMain.stReducedVelocity.i_lrMaxReducedVelocity		:= 50.0;

stSlave4Interface.stMain.i_xStart										:= FALSE;

(***************************************************************************************************************************************************************************************************)

(*** Homing ***)

IF xDriveIsVirtual THEN
	stSlave4Interface.stHome.i_etMode := PDL.ET_HomeMode.SetPosAxisAndLogEncoderPosition;			(* Homing Mode  in case of virtual axis *)
ELSE
	stSlave4Interface.stHome.i_etMode := PDL.ET_HomeMode.PosDirectionPosEdgeTp;						(* Homing Mode in case of real axis *)
END_IF


stSlave4Interface.stHome.i_xEnableInitAbsReadPos := FALSE;		(* TRUE : Restores the AxisPosition depending on the stHome.etMode
																		  If stHome.i_etMode is equal to PDL.ET_HomeMode.RestorePosFromAxisEncoder or 
																		  to PDL.ET_HomeMode.WriteAxisEncoder, the encoder of the axis is read,
																		  or else the position will be restored from the retain area *)
						   
stSlave4Interface.stHome.stSetpos.iq_pstRestorePosRetain := ADR(Grp_stRestorePositionAxis5);

stSlave4Interface.stHome.i_xResetHomeOk := FALSE;

(* Possible modes for homing mode Sensor:
	PDL.ET_HomeMode.PosDirectionPosEdgeSensor
	PDL.ET_HomeMode.NegDirectionPosEdgeSensor
	PDL.ET_HomeMode.NegDirectionNegEdgeSensor
	PDL.ET_HomeMode.PosDirectionNegEdgeSensor
*)
stSlave4Interface.stHome.stSensor.i_lrHomePosition			:= 0.0;			(* Position at the end of homing in units *)
stSlave4Interface.stHome.stSensor.i_lrVel					:= 10.0;		(* Homing ceiling velocity in units/s *)
stSlave4Interface.stHome.stSensor.i_lrAcc					:= 1000.0;		(* Homing acceleration in units/s^2 *)
stSlave4Interface.stHome.stSensor.i_lrDec					:= 1000.0;		(* Homing deceleration in units/s^2 *)
stSlave4Interface.stHome.stSensor.i_lrJerk					:= 10000.0;		(* Homing jerk in units/s^3 *)
stSlave4Interface.stHome.stSensor.i_lrOffset				:= 0.0;			(* Offset from home signal in units *)
stSlave4Interface.stHome.stSensor.i_lrMaxTravel				:= 720.0;		(* Max. travel for referencing by normal input *)
stSlave4Interface.stHome.stSensor.i_xRotativeSystem			:= FALSE;		(* Rotative system true or false for referencing by normal input *)
stSlave4Interface.stHome.stSensor.i_xSensor					:= FALSE;		(* Input for home signal. Can be a signal from a controller input. Has to be written cyclic. *)

(* Possible Modes for homing mode LimitSwitch:
	PDL.ET_HomeMode.PosDirectionPosEdgeHWLimitPos		normally open contact / Closing contact
	PDL.ET_HomeMode.NegDirectionPosEdgeHWLimitNeg		normally open contact / Closing contact
	PDL.ET_HomeMode.NegDirectionNegEdgeHWLimitNeg		normally closed contact / Opening contact  
	PDL.ET_HomeMode.PosDirectionNegEdgeHWLimitPos		normally closed contact / Opening contact 
*)
stSlave4Interface.stHome.stLimitSwitch.i_lrHomePosition		:= 0.0;			(* Position at the end of homing in units *)
stSlave4Interface.stHome.stLimitSwitch.i_lrVel				:= 10.0;		(* Homing ceiling velocity in units/s *)
stSlave4Interface.stHome.stLimitSwitch.i_lrLowVel			:= 5.0;			(* Homing low ceiling velocity in units/s *)
stSlave4Interface.stHome.stLimitSwitch.i_lrAcc				:= 1000.0;		(* Homing acceleration in units/s^2 *)
stSlave4Interface.stHome.stLimitSwitch.i_lrDec				:= 1000.0;		(* Homing deceleration in units/s^2 *)
stSlave4Interface.stHome.stLimitSwitch.i_lrJerk				:= 10000.0;		(* Homing jerk in units/s^3 *)
stSlave4Interface.stHome.stLimitSwitch.i_lrOffset			:= 0.0;			(* Offset from home signal in units *)
stSlave4Interface.stHome.stLimitSwitch.i_lrMaxTravel		:= 9999.0;		(* Max. travel for referencing normal input as a hardware limit *)

(* Possible modes for homing mode MoveOnPos:
	PDL.ET_HomeMode.MoveOnPosAbs 
*)
stSlave4Interface.stHome.stMoveonPos.i_lrTarget				:= 0.0;			(* Position at the end of homing in units *)
stSlave4Interface.stHome.stMoveonPos.i_lrVel				:= 10.0;		(* Homing ceiling velocity in units/s *)
stSlave4Interface.stHome.stMoveonPos.i_lrAcc				:= 1000.0;		(* Homing acceleration in units/s^2 *)
stSlave4Interface.stHome.stMoveonPos.i_lrDec				:= 1000.0;		(* Homing deceleration in units/s^2 *)
stSlave4Interface.stHome.stMoveonPos.i_lrJerk				:= 10000.0;		(* Homing jerk in units/s^3 *)
stSlave4Interface.stHome.stMoveonPos.i_lrPeriod				:= 0.0;			(* Period of the axis *)
stSlave4Interface.stHome.stMoveonPos.i_xRotativeSystem		:= FALSE;		(* Rotative system true or false *)

(* Possible modes for homing mode SetPos:
	PDL.ET_HomeMode.SetPosAxisPosition 
	PDL.ET_HomeMode.SetPosLogEncoderPosition 
	PDL.ET_HomeMode.SetPosAxisAndLogEncoderPosition
	PDL.ET_HomeMode.RestorePosFromAxisEncoder 
	PDL.ET_HomeMode.RestorePosFromRetain 
*)
stSlave4Interface.stHome.stSetpos.i_lrHomePosition			:= 0.0;			(* Position at the end of homing in units *)
stSlave4Interface.stHome.stSetpos.i_lrEncoderPosition		:= 0.0;			(* Encoder position in units after homing *)
stSlave4Interface.stHome.stSetpos.i_lrAbsEncOffset			:= 100.0;		(* Distance to the jump of axis encoder in units  *)
stSlave4Interface.stHome.stSetpos.i_lrRestoreWindow			:= 180;			(* How far can the drive be away from is correct position *)
stSlave4Interface.stHome.stSetpos.i_lrUserPeriod			:= 360;			(* Period of the axis *)
stSlave4Interface.stHome.stSetPos.i_xKeepPowerDisabled 		:= FALSE;		(* Keep Power disabled during SetPosHoming true or false*)

(* Possible modes for homing mode Torque:
	PDL.ET_HomeMode.PosDirectionMaxTorque 
	PDL.ET_HomeMode.NegDirectionMaxTorque 
*)
stSlave4Interface.stHome.stTorque.i_lrHomePosition			:= 0.0;			(* Position at the end of homing in units *)
stSlave4Interface.stHome.stTorque.i_lrVel					:= 10.0;		(* Homing ceiling velocity in units/s *)
stSlave4Interface.stHome.stTorque.i_lrAcc					:= 1000.0;		(* Homing acceleration in units/s^2 *)
stSlave4Interface.stHome.stTorque.i_lrDec					:= 1000.0;		(* Homing deceleration in units/s^2 *)
stSlave4Interface.stHome.stTorque.i_lrJerk					:= 10000.0;		(* Homing jerk in units/s^3 *)
stSlave4Interface.stHome.stTorque.i_lrOffset				:= 0.0;			(* Offset from home signal in units *)
stSlave4Interface.stHome.stTorque.i_lrMaxTravel				:= 9999.0;		(* Max. travel for referencing by torque *)
stSlave4Interface.stHome.stTorque.i_lrMaxTorque				:= 0.0;			(* Torque for stop in Nm / referencing by torque *)
stSlave4Interface.stHome.stTorque.i_diTorqueTime			:= 5;			(* Time in msec to hold torque *)

(* Possible modes for homing mode TouchProbe:
	PDL.ET_HomeMode.PosDirectionPosEdgeTp 
	PDL.ET_HomeMode.NegDirectionPosEdgeTp 
	PDL.ET_HomeMode.NegDirectionNegEdgeTp 
	PDL.ET_HomeMode.PosDirectionNegEdgeTp 
*)
stSlave4Interface.stHome.stTouchProbe.i_lrHomePosition		:= 0.0;			(* Position at the end of homing in units *)
stSlave4Interface.stHome.stTouchProbe.i_lrVel				:= 100.0;		(* Homing ceiling velocity in units/s *)
stSlave4Interface.stHome.stTouchProbe.i_lrAcc				:= 1000.0;		(* Homing acceleration in units/s^2 *)
stSlave4Interface.stHome.stTouchProbe.i_lrDec				:= 1000.0;		(* Homing deceleration in units/s^2 *)
stSlave4Interface.stHome.stTouchProbe.i_lrJerk				:= 10000.0;		(* Homing jerk in units/s^3 *)
stSlave4Interface.stHome.stTouchProbe.i_lrOffset			:= 30.0;		(* Offset from home signal in units *)
stSlave4Interface.stHome.stTouchProbe.i_lrMaxTravel			:= 720.0;		(* Max. travel for referencing by TP *)
stSlave4Interface.stHome.stTouchProbe.i_xRotativeSystem		:= TRUE;		(* Rotative system true or false for referencing by TP *)
stSlave4Interface.stHome.stTouchProbe.i_ifTouchProbe		:= TP_4;		(* Input for TP *)

(* Possible modes for homing mode WritePos:
	PDL.ET_HomeMode.WriteAxisEncoder 
*)
stSlave4Interface.stHome.stWritePos.i_lrHomePosition		:= 0.0;			(* Position at the end of homing in units *)
stSlave4Interface.stHome.stWritePos.i_lrUserPeriod			:= 0.0;			(* Calculates Drive.position into period ( units ) *)
stSlave4Interface.stHome.stWritePos.i_lrAbsEncOffset		:= 100.0;		(* Distance to the jump of axis encoder in units *)

(***************************************************************************************************************************************************************************************************)
(*** Manual ***)

stSlave4Interface.stManual.i_lrVel								:= 50.0;			(* Velocity in units/s *)
stSlave4Interface.stManual.i_lrAcc								:= 100.0;			(* Acceleration in units/s^2 *)
stSlave4Interface.stManual.i_lrDec								:= 100.0;			(* Deceleration in units/s^2 *)
stSlave4Interface.stManual.i_lrJerk								:= 1000.0;			(* Jerk in units/s^3 *)
stSlave4Interface.stManual.i_lrMaxDistance						:= 120.0;			(* Max pathlengths for one step in units *)
stSlave4Interface.stManual.i_xEndless							:= FALSE;			(* TRUE: jogging endless; Position between the periode; FALSE: jogging in steps. Position can be out of periode *)
stSlave4Interface.stManual.i_lrPeriod							:= 360.0;			(* Period of the axis *)

(***************************************************************************************************************************************************************************************************)
(*** Cam ***)

stSlave4Interface.stMultiCam.i_etCSModeSlave					:= PDL.ET_MultiCamCsModeSlave.SetSlavePositionToFirstCamPosition;		(* ColdStartMode Slave *)
stSlave4Interface.stMultiCam.i_etCSModeMaster					:= PDL.ET_MultiCamCsModeMaster.SetMasterPositionToFirstCamPosition;		(* ColdStartMode Master *)
stSlave4Interface.stMultiCam.i_etWSMode							:= PDL.ET_MultiCamWsMode.StoredCamMoveAlwaysNoPositionCheck;			(* WarmStartMode *)
stSlave4Interface.stMultiCam.i_lrWSWindow						:= 5.0;											(* WarmStartWindow in Axis units *)
stSlave4Interface.stMultiCam.i_lrWSVel							:= 10.0;										(* Velocity for WarmStart and CSModeSlave = PDL.ET_MultiCamCsModeSlave.MoveSlaveToFirstCamPosition in Units/s *)
stSlave4Interface.stMultiCam.i_lrWSAcc							:= 1000.0;										(* Acceleration and deceleration for Warmstart and CSModeSlave = PDL.ET_MultiCamCsModeSlave.MoveSlaveToFirstCamPosition in Units/s^2 *)
stSlave4Interface.stMultiCam.i_lrWSJerk							:= 10000.0;										(* Jerk for Warmstart and CSModeSlave = PDL.ET_MultiCamCsModeSlave.MoveSlaveToFirstCamPosition in units/s^3 *)
stSlave4Interface.stMultiCam.i_diTXend							:= 2*SYSTEMINTERFACE.FC_LzsTaskGetInterval();	(* Time of XLowEnd and XHighEnd befor Xend or Xstart in msec*)
stSlave4Interface.stMultiCam.i_lrInstantXLimMax					:= 0.0;											(* Switch off position at 'InstantNewCam' *)

stSlave4Interface.stMultiCam.i_xEnableTabHandler				:= TRUE;										(* TRUE: TabHandler is enabled *)
stSlave4Interface.stMultiCam.i_udiTableSelectNr					:= AXM.ET_ParId.User;							(* Number of table which is used in the next cycle *)								

stSlave4Interface.stMultiCam.i_xSetEncoderParameters			:= FALSE;										(* TRUE: The parameters MasterId, FeedConstand, GearIn and GearOut will be copyed into LEnc object *)
stSlave4Interface.stMultiCam.i_xSetEncoderPosition				:= TRUE;										(* TRUE: Manipulation of LEnc object on startup OpMode MultiCam *)
stSlave4Interface.stMultiCam.i_lrSetEncoderOffset				:= 0.0;											(* Master encoder offset *)
stSlave4Interface.stMultiCam.i_xCheckEncoderPeriod				:= TRUE;										(* TRUE: Check of encoder period = 0. If encoder period <> 0 -> Exception *)

// stSlave4Interface.stMultiCam.iq_xNewCam						:= FALSE;										(* TRUE: A new DataStruct will be load for next cycle. Will be reset when new cycle is started in case of stMultiCam.i_xEnableTabHandler = FALSE. *)
// stSlave4Interface.stMultiCam.iq_xInstantNewCam				:= FALSE;										(* TRUE: A new DataStruct will be load. It will be active at master position stMultiCam.i_lrInstantXLimMax. Will be reset when ne DataStruct is active *)
// stSlave4Interface.stMultiCam.iq_xChangeMaster				:= FALSE;										(* TRUE: Switch to a new Master. Will be reset when done. *)			

// stSlave4Interface.stMultiCam.iq_stExt		;						(* Extended In of the Multicam FB, can be used if needed! *)

stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].diNumberOfCamPoints		:= 4;	(* DataStruct for the next cycle *)
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].lrYPeriod				:= 0.0;

stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[0].lrX		:= 0.0;
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[0].lrY		:= 0.0;
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[0].lrM		:= 0.0;
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[0].etCamType	:= PDL.ET_CamType.Poly5Com;
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[1].lrX		:= 60.0;
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[1].lrY		:= 30.0;
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[1].lrM		:= 1.0;
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[1].etCamType	:= PDL.ET_CamType.Straight;
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[2].lrX		:= 240.0;
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[2].lrY		:= 210.0;
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[2].lrM		:= 1.0;
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[2].etCamType	:= PDL.ET_CamType.Poly5Com;
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[3].lrX		:= 360.0;
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[3].lrY		:= 0.0;
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[3].lrM		:= 0.0;
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[3].etCamType	:= PDL.ET_CamType.Poly5Com;

stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.Idle].diUserTableId	:= UDINT_TO_DINT(AXM.ET_ParId.Idle);
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.Start].diUserTableId	:= UDINT_TO_DINT(AXM.ET_ParId.Start);
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.Cont].diUserTableId	:= UDINT_TO_DINT(AXM.ET_ParId.Cont);
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.Stop].diUserTableId	:= UDINT_TO_DINT(AXM.ET_ParId.Stop);
stSlave4Interface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].diUserTableId	:= UDINT_TO_DINT(AXM.ET_ParId.User);


(*** ILS Data ***)
(*
stSlave4Interface.stMultiCam.i_udiIlsSlaveNumber														:= 1;

G_stIlsData.i_stRunTime.astSlaveLimits[stSlave4Interface.stMultiCam.i_udiIlsSlaveNumber].lrPosVel	:= 1000.0;
G_stIlsData.i_stRunTime.astSlaveLimits[stSlave4Interface.stMultiCam.i_udiIlsSlaveNumber].lrNegVel	:= -1000.0;
G_stIlsData.i_stRunTime.astSlaveLimits[stSlave4Interface.stMultiCam.i_udiIlsSlaveNumber].lrPosAcc	:= 10000.0;
G_stIlsData.i_stRunTime.astSlaveLimits[stSlave4Interface.stMultiCam.i_udiIlsSlaveNumber].lrNegAcc	:= -10000.0;

G_stIlsData.i_astCamData[stSlave4Interface.stMultiCam.i_udiIlsSlaveNumber].diNumberOfMasterPeriods	:= 1;	
G_stIlsData.i_astCamData[stSlave4Interface.stMultiCam.i_udiIlsSlaveNumber].diMasterPeriodInit		:= 1;
G_stIlsData.i_astCamData[stSlave4Interface.stMultiCam.i_udiIlsSlaveNumber].lrXOffset				:= 0.0;

stSlave4Interface.stMultiCam.pstIlsData																:= ADR(G_stIlsData);
*)

(***************************************************************************************************************************************************************************************************)
(*** Endless ***)

stSlave4Interface.stEndless.i_lrVel								:= 100.0;			(* Velocity in Units/s *)
stSlave4Interface.stEndless.i_lrAcc								:= 1000.0;			(* Acceleration in Units/s^2 *)
stSlave4Interface.stEndless.i_lrDec								:= 1000.0;			(* Deceleration in Units/s^2 *)
stSlave4Interface.stEndless.i_lrJerk							:= 10000.0;			(* Jerk in units/s^3 *)
stSlave4Interface.stEndless.i_lrPeriod							:= 360.0;			(* Period one cycle in units *)
stSlave4Interface.stEndless.i_lrStopPosition					:= 0.5;				(* Stop position in units *)

(*** Endless ILS ***)
(*
G_stIlsData.i_stConfig.diNumberOfSlaves							:= 0;
G_stIlsData.i_stConfig.diPositionGridSize						:= 500;
G_stIlsData.i_stConfig.diTimeGridSize							:= 50;
G_stIlsData.i_stConfig.lrHysteresis								:= 20;

G_stIlsData.i_stRunTime.iMasterAverageVelocityCycles			:= 10;
G_stIlsData.i_stRunTime.lrMasterMaxAbsVel						:= 100.0;
G_stIlsData.i_stRunTime.lrMasterMaxAbsAcc						:= 1000.0;
G_stIlsData.i_stRunTime.lrMasterMaxAbsJerk						:= 10000.0;
G_stIlsData.i_stRunTime.xActivateLimitation						:= TRUE;

stSlave4Interface.stEndless.pstIlsData							:= ADR(G_stIlsData);
*)

(***************************************************************************************************************************************************************************************************)
(*** Pos ***)

stSlave4Interface.stPos.i_etPosMode								:= SYSTEMINTERFACE.ET_PosMode.Endless;		(* SYSTEMINTERFACE.ET_PosMode.Endless, SYSTEMINTERFACE.ET_PosMode.Relative, SYSTEMINTERFACE.ET_PosMode.Absolute *)
stSlave4Interface.stPos.i_lrTarget								:= 360.0;									(* Target position or distance in Units *)
stSlave4Interface.stPos.i_lrVel									:= 100.0;									(* Ceiling velocity in Units/s *)
stSlave4Interface.stPos.i_lrAcc									:= 3600.0;									(* Acceleration in Units/s^2 *)
stSlave4Interface.stPos.i_lrDec									:= 3600.0;									(* Deceleration in Units/s^2 *)
stSlave4Interface.stPos.i_lrJerk								:= 36000.0;									(* Jerk in units/s^3 *)

// stSlave4Interface.stPos.i_xStop								:= FALSE;
(* End of system generated code, could be modified for your application *)
