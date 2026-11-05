__METADATA__
{
  "v3Meta": {
    "objectGuid": "84318b56-70a0-4f03-98a7-5ef8f034a8e6",
    "objectTypeGuid": "f8a58466-d7f6-439f-bbb8-d4600e41d099",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
METHOD SetInterfaces
VAR_INPUT
END_VAR
__IMPLEMENTATION__
IF NOT SYSTEMINTERFACE.FC_IsStLogicalAddressValid(i_stLogAddr := iq_stExampleLeafModuleItf.i_ifDrive.stLogicalAddress) THEN
	stExceptionModuleReaction1.etDiag		:= GD.ET_Diag.InputParameterInvalid;
	stExceptionModuleReaction1.udiDiagExt	:= ET_DiagExtExampleLeafModule.DriveInvalid;
	stExceptionModuleReaction1.sMsg			:= 'i_ifDrive - Invalid logical address.';
	
	ReportException(iq_stException := stExceptionModuleReaction1);
END_IF

xSuccess := __QUERYINTERFACE(iq_stExampleLeafModuleItf.i_ifDrive, ifRefActualValuesPosition);
IF NOT xSuccess OR ifRefActualValuesPosition = 0 THEN
	stExceptionModuleReaction1.etDiag		:= GD.ET_Diag.InputParameterInvalid;
	stExceptionModuleReaction1.udiDiagExt	:= ET_DiagExtExampleLeafModule.DriveInvalid;
	stExceptionModuleReaction1.sMsg			:= 'i_ifDrive : IF_RefActualValues not implemented.';
	
	ReportException(iq_stException := stExceptionModuleReaction1);		
END_IF
