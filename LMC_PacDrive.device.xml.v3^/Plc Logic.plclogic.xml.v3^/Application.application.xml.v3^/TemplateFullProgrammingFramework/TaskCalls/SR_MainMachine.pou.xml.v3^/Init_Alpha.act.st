__METADATA__
{
  "v3Meta": {
    "objectGuid": "c7064f3b-2627-4c04-973c-a7917e73fc36",
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

(* AlphaModule *)
astSubModuleInterface[c_udiAlpha].i_sModuleName		:= STANDARD.CONCAT(STR1 := stMachineInterface.i_sModuleName, STR2 := ': Alpha');
astSubModuleInterface[c_udiAlpha].i_xLogEnable		:= TRUE;
astSubModuleInterface[c_udiAlpha].i_wLogDataFilter	:= UDINT_TO_WORD(TPL.ET_LogDataFilter.ModuleDefault);

SR_AlphaModule.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
									i_sName		:= 'Alpha',
									q_etDiag	=> ,
									q_etDiagExt	=> );

(* End of system generated code, could be modified for your application *)
