__METADATA__
{
  "v3Meta": {
    "objectGuid": "988a9a77-f250-4378-92cf-5dc7496f5b9c",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* -----------------------------------------------------------------------------------------------*)
(* Check Axis Errors *)
(* -----------------------------------------------------------------------------------------------*)
	IF (iq_stExampleLeafModuleItf.i_ifDrive.DiagClass > 3) THEN
		stExceptionDriveFatal.sMsg := PDL.FC_MultiConcat(	i_sString1 := 'DiagCode: ',
															i_sString2 := DINT_TO_STRING(iq_stExampleLeafModuleItf.i_ifDrive.DiagCode),
															i_sString3 := ' Msg: ',
															i_sString4 := iq_stExampleLeafModuleItf.i_ifDrive.DiagMsg);
															
		ReportException(iq_stException := stExceptionDriveFatal);
		
	ELSIF (iq_stExampleLeafModuleItf.i_ifDrive.DiagClass = 3) THEN
		stExcepitonDrive.sMsg := PDL.FC_MultiConcat(	i_sString1 := 'DiagCode: ',
														i_sString2 := DINT_TO_STRING(iq_stExampleLeafModuleItf.i_ifDrive.DiagCode),
														i_sString3 := ' Msg: ',
														i_sString4 := iq_stExampleLeafModuleItf.i_ifDrive.DiagMsg);
														
		ReportException(iq_stException := stExcepitonDrive);
		
	ELSIF (iq_stExampleLeafModuleItf.i_ifDrive.DiagClass > 0)  AND (iq_stExampleLeafModuleItf.i_ifDrive.DiagClass < 3) THEN
		stWarningDrive.sMsg := PDL.FC_MultiConcat(	i_sString1 := 'DiagCode: ',
													i_sString2 := DINT_TO_STRING(iq_stExampleLeafModuleItf.i_ifDrive.DiagCode),
													i_sString3 := ' Msg: ',
													i_sString4 := iq_stExampleLeafModuleItf.i_ifDrive.DiagMsg);
													
		ReportException(iq_stException := stWarningDrive);
	END_IF

(* -----------------------------------------------------------------------------------------------*)
(* Check StopModi *)
(* -----------------------------------------------------------------------------------------------*)
IF (NOT iq_stStandardModuleItf.i_xEnable OR 
	stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] OR 
	stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] OR 
	stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]) THEN

	xAutoEnable := FALSE;
	xHomingEnable := FALSE;
END_IF
IF (NOT iq_stStandardModuleItf.i_xEnable OR 
	stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] OR 
	stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] OR 
	stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH] OR 
	stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle] ) THEN

	xStartFlag := FALSE;
END_IF
