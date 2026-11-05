__METADATA__
{
  "v3Meta": {
    "objectGuid": "59c77616-d3fc-4023-ad55-6ff3180620b4",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION FC_IsDriveVirtual : BOOL
VAR_INPUT
	i_ifDrive	: SystemConfigurationItf.IF_Drive;
END_VAR

VAR_OUTPUT
	q_etDiag	: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt	: ET_DiagExt := ET_DiagExt.Ok;
	q_sMsg		: STRING[80];
END_VAR

VAR
	xSuccess						: BOOL;
	ifSercosDeviceIdentification	: SystemConfigurationItf.IF_SercosDeviceIdentification; 
END_VAR
__IMPLEMENTATION__
IF i_ifDrive = 0 THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt	:= ET_DiagExt.DriveInvalid;
	q_sMsg		:= 'FC_IsDriveVirtual: i_ifDrive not set';		
ELSE
	xSuccess := __QUERYINTERFACE(i_ifDrive, ifSercosDeviceIdentification);
	IF NOT xSuccess OR ifSercosDeviceIdentification = 0 THEN
		q_etDiag	:= GD.ET_Diag.InputParameterInvalid;
		q_etDiagExt	:= ET_DiagExt.DriveInvalid;
		q_sMsg		:= Standard.CONCAT(i_ifDrive.Name, ' - IF_SercosDeviceIdentification not implemented');						
	ELSE
		IF ifSercosDeviceIdentification.WorkingState = 0 THEN	// Drive is virtual
			FC_IsDriveVirtual := TRUE;
		ELSE
			FC_IsDriveVirtual := FALSE;
		END_IF
	END_IF
END_IF
