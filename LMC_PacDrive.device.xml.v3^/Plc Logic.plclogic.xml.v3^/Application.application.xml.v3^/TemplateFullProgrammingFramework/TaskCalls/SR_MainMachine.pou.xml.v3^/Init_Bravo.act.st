__METADATA__
{
  "v3Meta": {
    "objectGuid": "29adaf6b-3218-48fc-8ad4-589e6937a5ee",
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

(* BravoModule *)
astSubModuleInterface[c_udiBravo].i_sModuleName		:= STANDARD.CONCAT(STR1 := stMachineInterface.i_sModuleName, STR2 := ': Bravo');
astSubModuleInterface[c_udiBravo].i_xLogEnable		:= TRUE;
astSubModuleInterface[c_udiBravo].i_wLogDataFilter	:= UDINT_TO_WORD(TPL.ET_LogDataFilter.ModuleDefault);

SR_BravoModule.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
									i_sName		:= 'Bravo',
									q_etDiag	=> ,
									q_etDiagExt	=> );

(* End of system generated code, could be modified for your application *)
