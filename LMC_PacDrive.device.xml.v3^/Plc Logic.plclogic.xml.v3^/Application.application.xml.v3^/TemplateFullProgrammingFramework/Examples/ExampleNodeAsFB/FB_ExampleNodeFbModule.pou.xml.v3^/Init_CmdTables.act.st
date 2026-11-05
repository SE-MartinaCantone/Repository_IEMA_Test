__METADATA__
{
  "v3Meta": {
    "objectGuid": "625a41cb-af29-403d-a0ef-70eec0e267d4",
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

(*********************************************************************************************************************)
(*** Prepare  ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astPrepareTable[udiStepIndex].sTitle					:= 'DriveEnable On Slave1';
astPrepareTable[udiStepIndex].udiModuleName				:= c_udiSlave1;
astPrepareTable[udiStepIndex].diStep					:= diStep;
astPrepareTable[udiStepIndex].diCmd						:= AXM.ET_Cmd.DriveEnableOn;
astPrepareTable[udiStepIndex].timTimeOut				:= T#0MS;
astPrepareTable[udiStepIndex].xEndCmd					:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astPrepareTable[udiStepIndex].sTitle					:= 'Homing Mode Slave1';
astPrepareTable[udiStepIndex].udiModuleName				:= c_udiSlave1;
astPrepareTable[udiStepIndex].diStep					:= diStep;
astPrepareTable[udiStepIndex].diCmd						:= AXM.ET_Cmd.Homing;
astPrepareTable[udiStepIndex].timTimeOut				:= T#0MS;
astPrepareTable[udiStepIndex].xEndCmd					:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astPrepareTable[udiStepIndex].sTitle					:= 'Homing Start Slave1';
astPrepareTable[udiStepIndex].udiModuleName				:= c_udiSlave1;
astPrepareTable[udiStepIndex].diStep					:= diStep;
astPrepareTable[udiStepIndex].diCmd						:= AXM.ET_Cmd.Start;
astPrepareTable[udiStepIndex].timTimeOut				:= T#0MS;
astPrepareTable[udiStepIndex].xEndCmd					:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astPrepareTable[udiStepIndex].sTitle					:= 'End';
astPrepareTable[udiStepIndex].udiModuleName				:= 0;
astPrepareTable[udiStepIndex].diStep					:= diStep;
astPrepareTable[udiStepIndex].diCmd						:= 0;
astPrepareTable[udiStepIndex].timTimeOut				:= T#0MS;
astPrepareTable[udiStepIndex].xEndCmd					:= TRUE;

TPL.FC_FirstCmdTable(iq_udiTableIndex := udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Prepare';
astListofCMDTables[udiTableIndex].diCmd					:= ET_Cmd.Prepare;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Auto  ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astAutoTable[udiStepIndex].sTitle						:= 'DriveEnable On AllSubModules';
astAutoTable[udiStepIndex].udiModuleName				:= TPL.Gc_udiAllSubModules;
astAutoTable[udiStepIndex].diStep						:= diStep;
astAutoTable[udiStepIndex].diCmd						:= AXM.ET_Cmd.DriveEnableOn;
astAutoTable[udiStepIndex].timTimeOut					:= T#0MS;
astAutoTable[udiStepIndex].xEndCmd						:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astAutoTable[udiStepIndex].sTitle						:= 'CamWs Mode AllSubModules';
astAutoTable[udiStepIndex].udiModuleName				:= TPL.Gc_udiAllSubModules;
astAutoTable[udiStepIndex].diStep						:= diStep;
astAutoTable[udiStepIndex].diCmd						:= AXM.ET_Cmd.CamWs;
astAutoTable[udiStepIndex].timTimeOut					:= T#0MS;
astAutoTable[udiStepIndex].xEndCmd						:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astAutoTable[udiStepIndex].sTitle						:= 'Start AllSubModules';
astAutoTable[udiStepIndex].udiModuleName				:= TPL.Gc_udiAllSubModules;
astAutoTable[udiStepIndex].diStep						:= diStep;
astAutoTable[udiStepIndex].diCmd						:= AXM.ET_Cmd.Start;
astAutoTable[udiStepIndex].timTimeOut					:= T#0MS;
astAutoTable[udiStepIndex].xEndCmd						:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astAutoTable[udiStepIndex].sTitle						:= 'WarmStart AllSubModules';
astAutoTable[udiStepIndex].udiModuleName				:= TPL.Gc_udiAllSubModules;
astAutoTable[udiStepIndex].diStep						:= diStep;
astAutoTable[udiStepIndex].diCmd						:= AXM.ET_Cmd.WsStart;
astAutoTable[udiStepIndex].timTimeOut					:= T#0MS;
astAutoTable[udiStepIndex].xEndCmd						:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astAutoTable[udiStepIndex].sTitle						:= 'End';
astAutoTable[udiStepIndex].udiModuleName				:= 0;
astAutoTable[udiStepIndex].diStep						:= diStep;
astAutoTable[udiStepIndex].diCmd						:= 0;
astAutoTable[udiStepIndex].timTimeOut					:= T#0MS;
astAutoTable[udiStepIndex].xEndCmd						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Auto';
astListofCMDTables[udiTableIndex].diCmd					:= ET_Cmd.Auto;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Manual  ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astManualTable[udiStepIndex].sTitle						:= 'DriveEnable On AllSubModules';
astManualTable[udiStepIndex].udiModuleName				:= TPL.Gc_udiAllSubModules;
astManualTable[udiStepIndex].diStep						:= diStep;
astManualTable[udiStepIndex].diCmd						:= AXM.ET_Cmd.DriveEnableOn;
astManualTable[udiStepIndex].timTimeOut					:= T#0MS;
astManualTable[udiStepIndex].xEndCmd					:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astManualTable[udiStepIndex].sTitle						:= 'Manual Mode AllSubModules';
astManualTable[udiStepIndex].udiModuleName				:= TPL.Gc_udiAllSubModules;
astManualTable[udiStepIndex].diStep						:= diStep;
astManualTable[udiStepIndex].diCmd						:= AXM.ET_Cmd.Manual;
astManualTable[udiStepIndex].timTimeOut					:= T#0MS;
astManualTable[udiStepIndex].xEndCmd					:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astManualTable[udiStepIndex].sTitle						:= 'End';
astManualTable[udiStepIndex].udiModuleName				:= 0;
astManualTable[udiStepIndex].diStep						:= diStep;
astManualTable[udiStepIndex].diCmd						:= 0;
astManualTable[udiStepIndex].timTimeOut					:= T#0MS;
astManualTable[udiStepIndex].xEndCmd					:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Manual';
astListofCMDTables[udiTableIndex].diCmd					:= ET_Cmd.Manual;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Stop ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astStopTable[udiStepIndex].sTitle						:= 'Stop AllSubModules';
astStopTable[udiStepIndex].udiModuleName				:= TPL.Gc_udiAllSubModules;
astStopTable[udiStepIndex].diStep						:= diStep;
astStopTable[udiStepIndex].diCmd						:= AXM.ET_Cmd.Stop;
astStopTable[udiStepIndex].timTimeOut					:= T#0MS;
astStopTable[udiStepIndex].xEndCmd						:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astStopTable[udiStepIndex].sTitle						:= 'End';
astStopTable[udiStepIndex].udiModuleName				:= 0;
astStopTable[udiStepIndex].diStep						:= diStep;
astStopTable[udiStepIndex].diCmd						:= 0;
astStopTable[udiStepIndex].timTimeOut					:= T#0MS;
astStopTable[udiStepIndex].xEndCmd						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Stop';
astListofCMDTables[udiTableIndex].diCmd					:= ET_Cmd.Stop;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Start ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astStartTable[udiStepIndex].sTitle						:= 'Start AllSubModules';
astStartTable[udiStepIndex].udiModuleName				:= TPL.Gc_udiAllSubModules;
astStartTable[udiStepIndex].diStep						:= diStep;
astStartTable[udiStepIndex].diCmd						:= AXM.ET_Cmd.Start;
astStartTable[udiStepIndex].timTimeOut					:= T#0MS;
astStartTable[udiStepIndex].xEndCmd						:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astStartTable[udiStepIndex].sTitle						:= 'End';
astStartTable[udiStepIndex].udiModuleName				:= 0;
astStartTable[udiStepIndex].diStep						:= diStep;
astStartTable[udiStepIndex].diCmd						:= 0;
astStartTable[udiStepIndex].timTimeOut					:= T#0MS;
astStartTable[udiStepIndex].xEndCmd						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Start';
astListofCMDTables[udiTableIndex].diCmd					:= ET_Cmd.Start;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Abort ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astAbortTable[udiStepIndex].sTitle						:= 'Stop AllSubModules';
astAbortTable[udiStepIndex].udiModuleName				:= TPL.Gc_udiAllSubModules;
astAbortTable[udiStepIndex].diStep						:= diStep;
astAbortTable[udiStepIndex].diCmd						:= AXM.ET_Cmd.Stop;
astAbortTable[udiStepIndex].timTimeOut					:= T#0MS;
astAbortTable[udiStepIndex].xEndCmd						:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astAbortTable[udiStepIndex].sTitle						:= 'End';
astAbortTable[udiStepIndex].udiModuleName				:= 0;
astAbortTable[udiStepIndex].diStep						:= diStep;
astAbortTable[udiStepIndex].diCmd						:= 0;
astAbortTable[udiStepIndex].timTimeOut					:= T#0MS;
astAbortTable[udiStepIndex].xEndCmd						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Abort';
astListofCMDTables[udiTableIndex].diCmd					:= ET_Cmd.Abort;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Hold ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astHoldTable[udiStepIndex].sTitle						:= 'Hold AllSubModules';
astHoldTable[udiStepIndex].udiModuleName				:= TPL.Gc_udiAllSubModules;
astHoldTable[udiStepIndex].diStep						:= diStep;
astHoldTable[udiStepIndex].diCmd						:= AXM.ET_Cmd.Hold;
astHoldTable[udiStepIndex].timTimeOut					:= T#0MS;
astHoldTable[udiStepIndex].xEndCmd						:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astHoldTable[udiStepIndex].sTitle						:= 'End';
astHoldTable[udiStepIndex].udiModuleName				:= 0;
astHoldTable[udiStepIndex].diStep						:= diStep;
astHoldTable[udiStepIndex].diCmd						:= 0;
astHoldTable[udiStepIndex].timTimeOut					:= T#0MS;
astHoldTable[udiStepIndex].xEndCmd						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Hold';
astListofCMDTables[udiTableIndex].diCmd					:= ET_Cmd.Hold;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Brake Release ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astBrakeReleaseTable[udiStepIndex].sTitle				:= 'DriveEnable Off AllSubModules';
astBrakeReleaseTable[udiStepIndex].udiModuleName		:= TPL.Gc_udiAllSubModules;
astBrakeReleaseTable[udiStepIndex].diStep				:= diStep;
astBrakeReleaseTable[udiStepIndex].diCmd				:= AXM.ET_Cmd.DriveEnableOff;
astBrakeReleaseTable[udiStepIndex].timTimeOut			:= T#0MS;
astBrakeReleaseTable[udiStepIndex].xEndCmd				:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astBrakeReleaseTable[udiStepIndex].sTitle				:= 'BrakeRelease Mode AllSubModules';
astBrakeReleaseTable[udiStepIndex].udiModuleName		:= TPL.Gc_udiAllSubModules;
astBrakeReleaseTable[udiStepIndex].diStep				:= diStep;
astBrakeReleaseTable[udiStepIndex].diCmd				:= AXM.ET_Cmd.BrakeRelease;
astBrakeReleaseTable[udiStepIndex].timTimeOut			:= T#0MS;
astBrakeReleaseTable[udiStepIndex].xEndCmd				:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astBrakeReleaseTable[udiStepIndex].sTitle				:= 'Start AllSubModules';
astBrakeReleaseTable[udiStepIndex].udiModuleName		:= TPL.Gc_udiAllSubModules;
astBrakeReleaseTable[udiStepIndex].diStep				:= diStep;
astBrakeReleaseTable[udiStepIndex].diCmd				:= AXM.ET_Cmd.Start;
astBrakeReleaseTable[udiStepIndex].timTimeOut			:= T#0MS;
astBrakeReleaseTable[udiStepIndex].xEndCmd				:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astBrakeReleaseTable[udiStepIndex].sTitle				:= 'End';
astBrakeReleaseTable[udiStepIndex].udiModuleName		:= 0;
astBrakeReleaseTable[udiStepIndex].diStep				:= diStep;
astBrakeReleaseTable[udiStepIndex].diCmd				:= 0;
astBrakeReleaseTable[udiStepIndex].timTimeOut			:= T#0MS;
astBrakeReleaseTable[udiStepIndex].xEndCmd				:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'BrakeRelease';
astListofCMDTables[udiTableIndex].diCmd					:= ET_Cmd.BrakeRelease;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(* End of system generated code, could be modified for your application *)
