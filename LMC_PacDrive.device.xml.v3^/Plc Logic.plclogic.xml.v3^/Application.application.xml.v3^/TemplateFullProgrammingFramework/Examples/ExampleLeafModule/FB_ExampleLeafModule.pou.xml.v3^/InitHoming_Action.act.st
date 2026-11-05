__METADATA__
{
  "v3Meta": {
    "objectGuid": "522d2040-ce61-42de-b75b-9fa026d7e50e",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
DiagQuit();
InactiveCmdExecution();

(* Emulating an initialization that takes some time *)
udiDoSomethingCounter := udiDoSomethingCounter + 1;
IF(iq_stExampleLeafModuleItf.i_xInitHoming) THEN
	xInitHomingDone := FALSE;
	iq_stExampleLeafModuleItf.q_xValue := TRUE;
	IF(udiDoSomethingCounter > c_udiDoSomeThingLevel) THEN
		(* Initial homing done *)
		xInitHomingDone := TRUE;
		iq_stExampleLeafModuleItf.q_xValue := TRUE;
		IF fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.StatusMessage THEN
			fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.StatusMessage,
										i_etDiag		:= GD.ET_Diag.Ok,
										i_udiDiagExt	:= ET_DiagExtExampleLeafModule.Ok,
										i_sMessage		:= 'InitHoming done',
										q_etDiag		:= ,
										q_etDiagExt		:= );
		END_IF
	END_IF
ELSE
	xInitHomingDone := TRUE;
END_IF

THIS^.SetOutputs();
