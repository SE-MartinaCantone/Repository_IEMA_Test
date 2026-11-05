__METADATA__
{
  "v3Meta": {
    "objectGuid": "d2a59d60-9351-44eb-8889-f883ec3c7c98",
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
astSubModuleInterface[c_udiMaster].i_sModuleName	:= STANDARD.CONCAT(STR1 := iq_stStandardModuleItf.i_sModuleName, STR2 := ': Master');

astSubModuleInterface[c_udiMaster].i_xLogEnable		:= TRUE;
astSubModuleInterface[c_udiMaster].i_wLogDataFilter	:= UDINT_TO_WORD(TPL.ET_LogDataFilter.ModuleDefault);

fbMasterModule.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
									i_sName		:= 'Master',
									q_etDiag	:= ,
									q_etDiagExt	:= );

(* AxisModule specific interface *)
stMasterInterface.stMain.i_ifMaster		:= i_ifMaster; 		(* Master *)
stMasterInterface.stMain.i_ifDrive		:= DRV_Master;
stMasterInterface.stMain.iq_lencEncoder	:= LE_Master;	


xDriveIsVirtual := FC_IsDriveVirtual(	i_ifDrive	:= stMasterInterface.stMain.i_ifDrive,
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
FC_SetDeadTimeCompensation(i_stSubModuleInterfaceMain := stMasterInterface.stMain);
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


stMasterInterface.stMain.i_lrMotionActiveVelLimit						:= 15.0;		(* Limit for max. velocity of astAxisModuleInterface to switch output AxisMove in Units/s *)
stMasterInterface.stMain.i_etMotionActiveVelType						:= AXM.ET_MotionActiveVelType.Velocity;

stMasterInterface.stMain.i_timMasterStop								:= T#1S;
stMasterInterface.stMain.i_xHwLimitPos									:= FALSE;
stMasterInterface.stMain.i_xHwLimitNeg									:= FALSE;

stMasterInterface.stMain.stReducedVelocity.i_xEnableReducedVelocity		:= FALSE;
stMasterInterface.stMain.stReducedVelocity.i_xOnlyLimitCheck			:= FALSE;
stMasterInterface.stMain.stReducedVelocity.i_lrMaxReducedVelocity		:= 50.0;

stMasterInterface.stMain.i_xStart										:= FALSE;

(***************************************************************************************************************************************************************************************************)

(*** Homing ***)		
							
IF xDriveIsVirtual THEN
	stMasterInterface.stHome.i_etMode := PDL.ET_HomeMode.SetPosAxisAndLogEncoderPosition;		(* Homing Mode in case of virtual axis *)
ELSE
	stMasterInterface.stHome.i_etMode := PDL.ET_HomeMode.PosDirectionPosEdgeTp;					(* Homing Mode in case of real axis *)
END_IF


stMasterInterface.stHome.i_xEnableInitAbsReadPos := FALSE;						(* TRUE : Restores the AxisPosition depending on the stHome.etMode
																						  If stHome.i_etMode is equal to PDL.ET_HomeMode.RestorePosFromAxisEncoder or 
																						  to PDL.ET_HomeMode.WriteAxisEncoder, the encoder of the axis is read,
																						  or else the position will be restored from the retain area *)

stMasterInterface.stHome.stSetpos.iq_pstRestorePosRetain := ADR(Grp_stRestorePositionAxis1);

stMasterInterface.stHome.i_xResetHomeOk := FALSE;

(* Possible modes for homing mode Sensor:
	PDL.ET_HomeMode.PosDirectionPosEdgeSensor
	PDL.ET_HomeMode.NegDirectionPosEdgeSensor
	PDL.ET_HomeMode.NegDirectionNegEdgeSensor
	PDL.ET_HomeMode.PosDirectionNegEdgeSensor
*)
stMasterInterface.stHome.stSensor.i_lrHomePosition			:= 0.0;			(* Position at the end of homing in units *)
stMasterInterface.stHome.stSensor.i_lrVel					:= 10.0;		(* Homing ceiling velocity in units/s *)
stMasterInterface.stHome.stSensor.i_lrAcc					:= 1000.0;		(* Homing acceleration in units/s^2 *)
stMasterInterface.stHome.stSensor.i_lrDec					:= 1000.0;		(* Homing deceleration in units/s^2 *)
stMasterInterface.stHome.stSensor.i_lrJerk					:= 10000.0;		(* Homing jerk in units/s^3 *)
stMasterInterface.stHome.stSensor.i_lrOffset				:= 0.0;			(* Offset from home signal in units *)
stMasterInterface.stHome.stSensor.i_lrMaxTravel 			:= 720.0;		(* Max. travel for referencing by normal input *)
stMasterInterface.stHome.stSensor.i_xRotativeSystem			:= FALSE;		(* Rotative system true or false for referencing by normal input *)
stMasterInterface.stHome.stSensor.i_xSensor 				:= FALSE;		(* Input for home signal. Can be a signal from a controller input. Has to be written cyclic. *)

(* Possible Modes for homing mode LimitSwitch:
	PDL.ET_HomeMode.PosDirectionPosEdgeHWLimitPos		normally open contact / Closing contact
	PDL.ET_HomeMode.NegDirectionPosEdgeHWLimitNeg		normally open contact / Closing contact
	PDL.ET_HomeMode.NegDirectionNegEdgeHWLimitNeg		normally closed contact / Opening contact  
	PDL.ET_HomeMode.PosDirectionNegEdgeHWLimitPos		normally closed contact / Opening contact 
*)
stMasterInterface.stHome.stLimitSwitch.i_lrHomePosition 	:= 0.0;			(* Position at the end of homing in units *)
stMasterInterface.stHome.stLimitSwitch.i_lrVel				:= 10.0;		(* Homing ceiling velocity in units/s *)
stMasterInterface.stHome.stLimitSwitch.i_lrLowVel			:= 5.0;			(* Homing low ceiling velocity in units/s *)
stMasterInterface.stHome.stLimitSwitch.i_lrAcc				:= 1000.0;		(* Homing acceleration in units/s^2 *)
stMasterInterface.stHome.stLimitSwitch.i_lrDec				:= 1000.0;		(* Homing deceleration in units/s^2 *)
stMasterInterface.stHome.stLimitSwitch.i_lrJerk				:= 10000.0;		(* Homing jerk in units/s^3 *)
stMasterInterface.stHome.stLimitSwitch.i_lrOffset			:= 0.0;			(* Offset from home signal in units *)
stMasterInterface.stHome.stLimitSwitch.i_lrMaxTravel 		:= 9999.0;		(* Max. travel for referencing normal input as a hardware limit *)

(* Possible modes for homing mode MoveOnPos:
	PDL.ET_HomeMode.MoveOnPosAbs 
*)
stMasterInterface.stHome.stMoveOnPos.i_lrTarget				:= 0.0;			(* Position at the end of homing in units *)
stMasterInterface.stHome.stMoveOnPos.i_lrVel				:= 10.0;		(* Homing ceiling velocity in units/s *)
stMasterInterface.stHome.stMoveOnPos.i_lrAcc				:= 1000.0;		(* Homing acceleration in units/s^2 *)
stMasterInterface.stHome.stMoveOnPos.i_lrDec				:= 1000.0;		(* Homing deceleration in units/s^2 *)
stMasterInterface.stHome.stMoveOnPos.i_lrJerk				:= 10000.0;		(* Homing jerk in units/s^3 *)
stMasterInterface.stHome.stMoveOnPos.i_lrPeriod				:= 0.0;			(* Period of the axis *)
stMasterInterface.stHome.stMoveOnPos.i_xRotativeSystem		:= FALSE;		(* Rotative system true or false *)

(* Possible modes for homing mode SetPos:
	PDL.ET_HomeMode.SetPosAxisPosition 
	PDL.ET_HomeMode.SetPosLogEncoderPosition 
	PDL.ET_HomeMode.SetPosAxisAndLogEncoderPosition
	PDL.ET_HomeMode.RestorePosFromAxisEncoder 
	PDL.ET_HomeMode.RestorePosFromRetain 
*)
stMasterInterface.stHome.stSetpos.i_lrHomePosition			:= 0.0;			(* Position at the end of homing in units *)
stMasterInterface.stHome.stSetpos.i_lrEncoderPosition		:= 0.0;			(* Encoder position in units after homing *)
stMasterInterface.stHome.stSetpos.i_lrAbsEncOffset			:= 100.0;		(* Distance to the jump of axis encoder in units *)
stMasterInterface.stHome.stSetpos.i_lrRestoreWindow			:= 180;			(* How far can the drive be away from its correct position *)
stMasterInterface.stHome.stSetpos.i_lrUserPeriod			:= 360;			(* Period of the axis *)
stMasterInterface.stHome.stSetPos.i_xKeepPowerDisabled 		:= FALSE;		(* Keep Power disabled during SetPosHoming true or false*)

(* Possible modes for homing mode Torque:
	PDL.ET_HomeMode.PosDirectionMaxTorque 
	PDL.ET_HomeMode.NegDirectionMaxTorque 
*)
stMasterInterface.stHome.stTorque.i_lrHomePosition			:= 0.0;			(* Position at the end of homing in units *)
stMasterInterface.stHome.stTorque.i_lrVel					:= 10.0;		(* Homing ceiling velocity in units/s *)
stMasterInterface.stHome.stTorque.i_lrAcc					:= 1000.0;		(* Homing acceleration in units/s^2 *)
stMasterInterface.stHome.stTorque.i_lrDec					:= 1000.0;		(* Homing deceleration in units/s^2 *)
stMasterInterface.stHome.stTorque.i_lrJerk					:= 10000.0;		(* Homing jerk in units/s^3 *)
stMasterInterface.stHome.stTorque.i_lrOffset				:= 0.0;			(* Offset from home signal in units *)
stMasterInterface.stHome.stTorque.i_lrMaxTravel				:= 9999.0;		(* Max. travel for referencing by torque *)
stMasterInterface.stHome.stTorque.i_lrMaxTorque				:= 0.0;			(* Torque for stop in Nm / referencing by torque *)
stMasterInterface.stHome.stTorque.i_diTorqueTime			:= 5;			(* Time in msec to hold torque *)

(* Possible modes for homing mode TouchProbe:
	PDL.ET_HomeMode.PosDirectionPosEdgeTp 
	PDL.ET_HomeMode.NegDirectionPosEdgeTp 
	PDL.ET_HomeMode.NegDirectionNegEdgeTp 
	PDL.ET_HomeMode.PosDirectionNegEdgeTp 
*)
stMasterInterface.stHome.stTouchProbe.i_lrHomePosition		:= 0.0;			(* Position at the end of homing in units *)
stMasterInterface.stHome.stTouchProbe.i_lrVel				:= 100.0;		(* Homing ceiling velocity in units/s *)
stMasterInterface.stHome.stTouchProbe.i_lrAcc				:= 1000.0;		(* Homing acceleration in units/s^2 *)
stMasterInterface.stHome.stTouchProbe.i_lrDec				:= 1000.0;		(* Homing deceleration in units/s^2 *)
stMasterInterface.stHome.stTouchProbe.i_lrJerk				:= 10000.0;		(* Homing jerk in units/s^3 *)
stMasterInterface.stHome.stTouchProbe.i_lrOffset			:= 30.0;		(* Offset from home signal in units *)
stMasterInterface.stHome.stTouchProbe.i_lrMaxTravel			:= 720.0;		(* Max. travel for referencing by TP *)
stMasterInterface.stHome.stTouchProbe.i_xRotativeSystem		:= TRUE;		(* Rotative system true or false for referencing by TP *)
stMasterInterface.stHome.stTouchProbe.i_ifTouchProbe		:= TP_0;		(* Input for TP *)

(* Possible modes for homing mode WritePos:
	PDL.ET_HomeMode.WriteAxisEncoder 
*)
stMasterInterface.stHome.stWritePos.i_lrHomePosition		:= 0.0;			(* Position at the end of homing in units *)
stMasterInterface.stHome.stWritePos.i_lrUserPeriod			:= 0.0;			(* Calculates Drive.Position into period ( units ) *)
stMasterInterface.stHome.stWritePos.i_lrAbsEncOffset		:= 100.0;		(* Distance to the jump of axis encoder in units *)

(***************************************************************************************************************************************************************************************************)
(*** Manual ***)

stMasterInterface.stManual.i_lrVel								:= 50.0;			(* Velocity in units/s *)
stMasterInterface.stManual.i_lrAcc								:= 100.0;			(* Acceleration in units/s^2 *)
stMasterInterface.stManual.i_lrDec								:= 100.0;			(* Deceleration in units/s^2 *)
stMasterInterface.stManual.i_lrJerk								:= 1000.0;			(* Jerk in units/s^3 *)
stMasterInterface.stManual.i_lrMaxDistance						:= 120.0;			(* Max pathlengths for one step in units *)
stMasterInterface.stManual.i_xEndless							:= FALSE;			(* TRUE: jogging endless; Position between the periode; FALSE: jogging in steps. Position can be out of periode *)
stMasterInterface.stManual.i_lrPeriod							:= 360.0;			(* Period of the axis *)

(***************************************************************************************************************************************************************************************************)
(*** Cam ***)

stMasterInterface.stMultiCam.i_etCSModeSlave					:= PDL.ET_MultiCamCsModeSlave.SetSlavePositionToFirstCamPosition;		(* ColdStartMode Slave *)
stMasterInterface.stMultiCam.i_etCSModeMaster					:= PDL.ET_MultiCamCsModeMaster.SetMasterPositionToFirstCamPosition;		(* ColdStartMode Master *)
stMasterInterface.stMultiCam.i_etWSMode							:= PDL.ET_MultiCamWsMode.StoredCamMoveAlwaysNoPositionCheck;			(* WarmStartMode *)
stMasterInterface.stMultiCam.i_lrWSWindow						:= 5.0;											(* WarmStartWindow in Axis units *)
stMasterInterface.stMultiCam.i_lrWSVel							:= 10.0;										(* Velocity for WarmStart and CSModeSlave = PDL.ET_MultiCamCsModeSlave.MoveSlaveToFirstCamPosition in Units/s *)
stMasterInterface.stMultiCam.i_lrWSAcc							:= 1000.0;										(* Acceleration and deceleration for Warmstart and CSModeSlave = PDL.ET_MultiCamCsModeSlave.MoveSlaveToFirstCamPosition in Units/s^2 *)
stMasterInterface.stMultiCam.i_lrWSJerk							:= 10000.0;										(* Jerk for Warmstart and CSModeSlave = PDL.ET_MultiCamCsModeSlave.MoveSlaveToFirstCamPosition in units/s^3 *)
stMasterInterface.stMultiCam.i_diTXend							:= 2*SYSTEMINTERFACE.FC_LzsTaskGetInterval();	(* Time of XLowEnd and XHighEnd befor Xend or Xstart in msec*)
stMasterInterface.stMultiCam.i_lrInstantXLimMax					:= 0.0;											(* Switch off position at 'InstantNewCam' *)

stMasterInterface.stMultiCam.i_xEnableTabHandler				:= TRUE;										(* TRUE: TabHandler is enabled *)
stMasterInterface.stMultiCam.i_udiTableSelectNr					:= AXM.ET_ParId.User;							(* Number of table which is used in the next cycle *)								

stMasterInterface.stMultiCam.i_xSetEncoderParameters			:= FALSE;										(* TRUE: The parameters MasterId, FeedConstand, GearIn and GearOut will be copyed into LEnc object *)
stMasterInterface.stMultiCam.i_xSetEncoderPosition				:= TRUE;										(* TRUE: Manipulation of LEnc object on startup OpMode MultiCam *)
stMasterInterface.stMultiCam.i_lrSetEncoderOffset				:= 0.0;											(* Master encoder offset *)
stMasterInterface.stMultiCam.i_xCheckEncoderPeriod				:= TRUE;										(* TRUE: Check of encoder period = 0. If encoder period <> 0 -> Exception *)

// stMasterInterface.stMultiCam.iq_xNewCam						:= FALSE;										(* TRUE: A new DataStruct will be load for next cycle. Will be reset when new cycle is started in case of stMultiCam.i_xEnableTabHandler = FALSE. *)
// stMasterInterface.stMultiCam.iq_xInstantNewCam				:= FALSE;										(* TRUE: A new DataStruct will be load. It will be active at master position stMultiCam.i_lrInstantXLimMax. Will be reset when ne DataStruct is active *)
// stMasterInterface.stMultiCam.iq_xChangeMaster				:= FALSE;										(* TRUE: Switch to a new Master. Will be reset when done. *)			

// stMasterInterface.stMultiCam.iq_stExt		;						(* Extended In of the Multicam FB, can be used if needed! *)

stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].diNumberOfCamPoints			:= 4;	(* DataStruct for the next cycle *)
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].lrYPeriod					:= 0.0;

stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[0].lrX			:= 0.0;
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[0].lrY			:= 0.0;
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[0].lrM			:= 0.0;
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[0].etCamType	:= PDL.ET_CamType.Poly5Com;
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[1].lrX			:= 60.0;
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[1].lrY			:= 30.0;
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[1].lrM			:= 1.0;
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[1].etCamType	:= PDL.ET_CamType.Straight;
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[2].lrX			:= 240.0;
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[2].lrY			:= 210.0;
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[2].lrM			:= 1.0;
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[2].etCamType	:= PDL.ET_CamType.Poly5Com;
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[3].lrX			:= 360.0;
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[3].lrY			:= 0.0;
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[3].lrM			:= 0.0;
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].astCamPoint[3].etCamType	:= PDL.ET_CamType.Poly5Com;

stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.Idle].diUserTableId	:= UDINT_TO_DINT(AXM.ET_ParId.Idle);
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.Start].diUserTableId	:= UDINT_TO_DINT(AXM.ET_ParId.Start);
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.Cont].diUserTableId	:= UDINT_TO_DINT(AXM.ET_ParId.Cont);
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.Stop].diUserTableId	:= UDINT_TO_DINT(AXM.ET_ParId.Stop);
stMasterInterface.stMultiCam.iq_astMotionPar[AXM.ET_ParId.User].diUserTableId	:= UDINT_TO_DINT(AXM.ET_ParId.User);


(*** ILS Data ***)
(*
stMasterInterface.stMultiCam.i_udiIlsSlaveNumber														:= 1;

G_stIlsData.i_stRunTime.astSlaveLimits[stMasterInterface.stMultiCam.i_udiIlsSlaveNumber].lrPosVel	:= 1000.0;
G_stIlsData.i_stRunTime.astSlaveLimits[stMasterInterface.stMultiCam.i_udiIlsSlaveNumber].lrNegVel	:= -1000.0;
G_stIlsData.i_stRunTime.astSlaveLimits[stMasterInterface.stMultiCam.i_udiIlsSlaveNumber].lrPosAcc	:= 10000.0;
G_stIlsData.i_stRunTime.astSlaveLimits[stMasterInterface.stMultiCam.i_udiIlsSlaveNumber].lrNegAcc	:= -10000.0;

G_stIlsData.i_astCamData[stMasterInterface.stMultiCam.i_diIlsSlaveNumber].diNumberOfMasterPeriods	:= 1;	
G_stIlsData.i_astCamData[stMasterInterface.stMultiCam.i_diIlsSlaveNumber].diMasterPeriodInit		:= 1;
G_stIlsData.i_astCamData[stMasterInterface.stMultiCam.i_diIlsSlaveNumber].lrXOffset					:= 0.0;

stMasterInterface.stMultiCam.pstIlsData																:= ADR(G_stIlsData);
*)

(***************************************************************************************************************************************************************************************************)
(*** Endless ***)

stMasterInterface.stEndless.i_lrVel								:= 100.0;			(* Velocity in Units/s *)
stMasterInterface.stEndless.i_lrAcc								:= 1000.0;			(* Acceleration in Units/s^2 *)
stMasterInterface.stEndless.i_lrDec								:= 1000.0;			(* Deceleration in Units/s^2 *)
stMasterInterface.stEndless.i_lrJerk							:= 10000.0;			(* Jerk in units/s^3 *)
stMasterInterface.stEndless.i_lrPeriod							:= 360.0;			(* Period one cycle in units *)
stMasterInterface.stEndless.i_lrStopPosition					:= 0.5;				(* Stop position in units *)

(*** Endless ILS ***)
(*
G_stIlsData.i_stConfig.diNumberOfSlaves							:= 4;
G_stIlsData.i_stConfig.diPositionGridSize						:= 500;
G_stIlsData.i_stConfig.diTimeGridSize							:= 50;
G_stIlsData.i_stConfig.lrHysteresis								:= 20;

G_stIlsData.i_stRunTime.iMasterAverageVelocityCycles			:= 10;
G_stIlsData.i_stRunTime.lrMasterMaxAbsVel						:= 100.0;
G_stIlsData.i_stRunTime.lrMasterMaxAbsAcc						:= 1000.0;
G_stIlsData.i_stRunTime.lrMasterMaxAbsJerk						:= 10000.0;
G_stIlsData.i_stRunTime.xActivateLimitation						:= TRUE;

stMasterInterface.stEndless.pstIlsData							:= ADR(G_stIlsData);
*)

(***************************************************************************************************************************************************************************************************)
(*** Pos ***)

stMasterInterface.stPos.i_etPosMode								:= SYSTEMINTERFACE.ET_PosMode.Endless;		(* SYSTEMINTERFACE.ET_PosMode.Endless, SYSTEMINTERFACE.ET_PosMode.Relative, SYSTEMINTERFACE.ET_PosMode.Absolute *)
stMasterInterface.stPos.i_lrTarget								:= 360.0;									(* Target position or distance in Units *)
stMasterInterface.stPos.i_lrVel									:= 360.0;									(* Ceiling velocity in Units/s *)
stMasterInterface.stPos.i_lrAcc									:= 3600.0;									(* Acceleration in Units/s^2 *)
stMasterInterface.stPos.i_lrDec									:= 3600.0;									(* Deceleration in Units/s^2 *)
stMasterInterface.stPos.i_lrJerk								:= 36000.0;									(* Jerk in units/s^3 *)

// stMasterInterface.stPos.i_xStop								:= FALSE;
(* End of system generated code, could be modified for your application *)
