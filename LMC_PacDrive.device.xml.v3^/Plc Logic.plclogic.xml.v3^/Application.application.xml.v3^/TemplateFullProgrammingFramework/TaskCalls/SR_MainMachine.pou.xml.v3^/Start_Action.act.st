__METADATA__
{
  "v3Meta": {
    "objectGuid": "5f18f67e-367f-475b-9488-828a83e2dd17",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* This step is active until the machine is being enabled *)

(* System generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)
	xVirtualSystem := TPL.FC_GetVirtualSystem();
	
	stMachineInterface.q_sModuleTypeName	:= c_sModuleTypeName;
	stMachineInterface.q_dwModuleType		:= c_dwModuleType;
	stMachineInterface.q_udiModuleVersion	:= c_udiModuleVersion;
(* End of system generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)

(* System generated code, could be modified for your application *)
	IF(SYSTEMINTERFACE.FC_GetPacDriveBootState() <> 1) THEN
		(* avoid starting as long as the boot of the controller is not finished *)
		stMachineInterface.i_xEnable	:= FALSE; (* set transition condition to FALSE ==> ensure that this step stays active *)

		stMachineInterface.q_etDiag		:= GD.ET_Diag.Ok;
		stMachineInterface.q_udiDiagExt	:= ET_DiagExt.WaitUntilControllerFinishedBoot;
		stMachineInterface.q_sDiagExt	:= FC_EtDiagExtToString(stMachineInterface.q_udiDiagExt);
		stMachineInterface.q_sMsg		:= '';
	ELSE
		stMachineInterface.q_etDiag		:= GD.ET_Diag.Ok;
		stMachineInterface.q_udiDiagExt	:= ET_DiagExt.WaitUntilSercosState4;
		stMachineInterface.q_sDiagExt	:= FC_EtDiagExtToString(stMachineInterface.q_udiDiagExt);
		stMachineInterface.q_sMsg		:= '';
		
		IF SystemConfiguration.G_ifSercos.State = 4 
		THEN
			APL.G_ifApplicationLogger.RegisterCommunicationService(	q_etDiag => ,
																	q_etDiagExt => );	
																	
			stMachineInterface.i_xEnable	:= TRUE;
		END_IF
	END_IF
(* End of system generated code, could be modified for your application *)

(* Application specific code *)
(* ToDo: Add your application specific code here *)
;
(* End of application specific code *)
