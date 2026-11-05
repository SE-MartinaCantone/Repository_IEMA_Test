__METADATA__
{
  "v3Meta": {
    "objectGuid": "06b3f9d8-2084-42a3-94f5-1598cdc52698",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* System generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!! *)

IF SystemConfiguration.G_ifController <> 0 THEN
	diDiagCode := SystemConfiguration.G_ifController.DiagCode; 
	IF diDiagCode <> diDiagCode_old THEN
		diDiagCode_old	:= diDiagCode;
		stDiagSource	:= SystemConfiguration.G_ifController.DiagSource;
		IF NOT FC_ObjectTypeIsMotionAxis(i_udiObjectType := stDiagSource.udiType) THEN
			diDiagClass		:= SystemConfiguration.G_ifController.DiagClass;
			sDiagMsg		:= SystemConfiguration.G_ifController.DiagMsg;
			sInstanceName	:= 'UnknownDevice';
			SystemInterface.FC_GetObjNameByLogAddr(i_stLogAdr := stDiagSource, i_diMaxSize := SIZEOF(sInstanceName), iq_sName := sInstanceName);
			sDiagMsgExt := '';
			xSuccess := __QUERYINTERFACE(SystemConfiguration.G_ifController, ifDiagnosis);
			IF xSuccess AND (ifDiagnosis <> 0) THEN
				sDiagMsgExt := ifDiagnosis.DiagExtMsg;
			END_IF

			diDiagClass := SystemConfiguration.G_ifController.DiagClass;
			IF diDiagClass = 4 THEN
				stSystemException1.etDiag		:= GD.ET_Diag.DiagActive;
				stSystemException1.udiDiagExt	:= ET_DiagExt.SystemFatalException;								
				stSystemException1.sDiagExt		:= FC_EtDiagExtToString(stSystemException1.udiDiagExt);	
				stSystemException1.sMsg			:= PDL.FC_MultiConcat(	i_sString1 := STANDARD.CONCAT(sInstanceName, ' '),
																		i_sString2 := STANDARD.CONCAT(DINT_TO_STRING(diDiagCode), ' '), 
																		i_sString3 := STANDARD.CONCAT(sDiagMsg, ' '), 
																		i_sString4 := sDiagMsgExt);
				stSystemException1.udiExceptionNumber := TPL.FC_GenerateExceptionNumber( i_etSource := TPL.ET_ExceptionSource.System, i_udiDiagExt := DINT_TO_UDINT(diDiagCode) );
				fbExceptionHandler.SetException(i_xExceptionActive	:= TRUE,
												iq_stException		:= stSystemException1,
												iq_stExceptionList	:= G_stExceptionList);
				
			ELSIF diDiagClass = 3 THEN
				stSystemException2.etDiag		:= GD.ET_Diag.DiagActive;
				stSystemException2.udiDiagExt	:= ET_DiagExt.SystemException;				
				stSystemException2.sDiagExt		:= FC_EtDiagExtToString(stSystemException2.udiDiagExt);	
				stSystemException2.sMsg			:= PDL.FC_MultiConcat(	i_sString1 := STANDARD.CONCAT(sInstanceName, ' '),
																		i_sString2 := STANDARD.CONCAT(DINT_TO_STRING(diDiagCode), ' '), 
																		i_sString3 := STANDARD.CONCAT(sDiagMsg, ' '), 
																		i_sString4 := sDiagMsgExt);
				stSystemException2.udiExceptionNumber := TPL.FC_GenerateExceptionNumber( i_etSource := TPL.ET_ExceptionSource.System, i_udiDiagExt := DINT_TO_UDINT(diDiagCode) );
				fbExceptionHandler.SetException(i_xExceptionActive	:= TRUE,
												iq_stException		:= stSystemException2,
												iq_stExceptionList	:= G_stExceptionList);
				
			ELSIF (diDiagClass = 2 OR diDiagClass = 1) THEN
				stSystemException3.etDiag		:= GD.ET_Diag.DiagActive;
				stSystemException3.udiDiagExt	:= ET_DiagExt.SystemWarning;
				stSystemException3.sDiagExt		:= FC_EtDiagExtToString(stSystemException3.udiDiagExt);	
				stSystemException3.sMsg			:= PDL.FC_MultiConcat(	i_sString1 := STANDARD.CONCAT(sInstanceName, ' '),
																		i_sString2 := STANDARD.CONCAT(DINT_TO_STRING(diDiagCode), ' '), 
																		i_sString3 := STANDARD.CONCAT(sDiagMsg, ' '), 
																		i_sString4 := sDiagMsgExt);
				stSystemException3.udiExceptionNumber := TPL.FC_GenerateExceptionNumber( i_etSource := TPL.ET_ExceptionSource.System, i_udiDiagExt := DINT_TO_UDINT(diDiagCode) );
				fbExceptionHandler.SetException(i_xExceptionActive	:= TRUE,
												iq_stException		:= stSystemException3,
												iq_stExceptionList	:= G_stExceptionList);
			END_IF
		END_IF
	END_IF
END_IF

IF NOT xInputEmergency THEN	(* Extend logic for hardware *)

	fbExceptionHandler.SetException(i_xExceptionActive	:= TRUE,
									iq_stException		:= stEmergencyStopException,
									iq_stExceptionList	:= G_stExceptionList);
END_IF

IF etContactorControlDiag <> GD.ET_Diag.Ok THEN

	stContactorControlException.etDiag		:= etContactorControlDiag;
	stContactorControlException.udiDiagExt	:= etContactorControlDiagExt;
	stContactorControlException.sDiagExt	:= TPL.FC_EtDiagExtToString(etContactorControlDiagExt);
	stContactorControlException.sMsg		:= sContactorControlMsg;
	
	fbExceptionHandler.SetException(i_xExceptionActive	:= TRUE,
									iq_stException		:= stContactorControlException,
									iq_stExceptionList	:= G_stExceptionList);
END_IF

(* End of system generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!! *)
