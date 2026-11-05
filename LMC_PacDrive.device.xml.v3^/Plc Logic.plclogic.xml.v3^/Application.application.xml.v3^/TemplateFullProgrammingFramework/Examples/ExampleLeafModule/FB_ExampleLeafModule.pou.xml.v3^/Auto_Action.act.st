__METADATA__
{
  "v3Meta": {
    "objectGuid": "52a75849-8094-4c85-bfe0-08668a2e7324",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* Start application code *)
IF(iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.AutoWaitForStart) THEN
	IF(xAutoEnable) THEN
		IF(xStartFlag) THEN
			iq_stExampleLeafModuleItf.q_etState := ET_ExampleLeafModuleState.AutoRunning;
		END_IF
	ELSE
		xAutoActive := FALSE;
	END_IF
END_IF

IF(NOT xStartFlag AND iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.AutoRunning) THEN
	iq_stExampleLeafModuleItf.q_etState := ET_ExampleLeafModuleState.AutoWaitForStart;
END_IF

IF(iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.AutoRunning) THEN
	IF(xAutoEnable) THEN
		iq_stExampleLeafModuleItf.q_xValue := ifRefActualValuesPosition.RefPosition >= iq_stExampleLeafModuleItf.i_lrPosMin AND 
													ifRefActualValuesPosition.RefPosition <= iq_stExampleLeafModuleItf.i_lrPosMax;
	ELSE
		iq_stExampleLeafModuleItf.q_etState := ET_ExampleLeafModuleState.AutoWaitForStart;
	END_IF
END_IF
(* End application code *)
