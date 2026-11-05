__METADATA__
{
  "v3Meta": {
    "objectGuid": "b4b0fdf3-a83f-449a-8fbe-147503908709",
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
FUNCTION_BLOCK FB_ExampleLeafModuleExtItf

VAR_INPUT
(* Part of TPL.ST_StandardModuleInterface.i_... *)
	i_xEnable						: BOOL;			
END_VAR

VAR_IN_OUT
(* Part of TPL.ST_StandardModuleInterface.iq_... *)
	iq_diCmd						: DINT;

(* TPL.ST_StandardModuleInterface *)	
	iq_stStandardModuleItf			: TPL.ST_StandardModuleInterface;
	
(* ExceptionHandling and Logging *)	
	iq_stExceptionList				: TPL.ST_ExceptionList;
	iq_stLogDataList				: TPL.ST_LogDataList;
	
(* ST_ExampleLeafModuleInterface *)
	iq_stExampleLeafModuleItf		: ST_ExampleLeafModuleInterface;
END_VAR

VAR_OUTPUT
(* TPL.ST_StandardModuleInterface.q_... *)
	q_xActive						: BOOL;
	q_xReady						: BOOL;
	q_etDiag						: GD.ET_Diag; 
	q_etDiagExt						: ET_DiagExtExampleLeafModule;
	q_sMsg							: STRING[80];
	q_xCmdActive					: BOOL;
	q_diCmdActive					: DINT;
	q_xCmdDone						: BOOL;	
END_VAR

VAR
	fbExampleLeafModule : FB_ExampleLeafModule;
END_VAR
__IMPLEMENTATION__
(* System generated code, could be modified for your application *)

iq_stStandardModuleItf.i_xEnable	:= i_xEnable;
iq_stStandardModuleItf.iq_diCmd		:= iq_diCmd;

(* Module call *)
fbExampleLeafModule(iq_stStandardModuleItf		:= iq_stStandardModuleItf, 
					iq_stExceptionList			:= iq_stExceptionList, 
					iq_stLogDataList			:= iq_stLogDataList, 
					iq_stExampleLeafModuleItf	:= iq_stExampleLeafModuleItf);
					
iq_diCmd	:= iq_stStandardModuleItf.iq_diCmd;

q_xActive		:= iq_stStandardModuleItf.q_xActive;
q_xReady		:= iq_stStandardModuleItf.q_xReady;
q_etDiag		:= iq_stStandardModuleItf.q_etDiag; 
q_etDiagExt		:= iq_stStandardModuleItf.q_udiDiagExt;
q_sMsg			:= iq_stStandardModuleItf.q_sMsg;
q_xCmdActive	:= iq_stStandardModuleItf.q_xCmdActive;
q_diCmdActive	:= iq_stStandardModuleItf.q_diCmdActive;
q_xCmdDone		:= iq_stStandardModuleItf.q_xCmdDone;	

(* End of system generated code, could be modified for your application *)
