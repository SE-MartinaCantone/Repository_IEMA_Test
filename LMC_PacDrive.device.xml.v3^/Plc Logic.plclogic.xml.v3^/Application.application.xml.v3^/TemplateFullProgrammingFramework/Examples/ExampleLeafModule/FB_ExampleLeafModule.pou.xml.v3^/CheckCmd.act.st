__METADATA__
{
  "v3Meta": {
    "objectGuid": "c3140d7a-2c8d-489a-98e5-cdbf2202bc2d",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(*--------------------------------------------------------------------------------------------------*)
(* CheckCMD is checking if CMD is supported by this module *)
(*--------------------------------------------------------------------------------------------------*)
xOpModeCMD			:= FALSE;
xCheckCmdException	:= FALSE;

IF 	iq_stStandardModuleItf.iq_diCMD = ET_ExampleLeafModuleCmd.Homing OR
	iq_stStandardModuleItf.iq_diCMD = ET_ExampleLeafModuleCmd.Auto OR
	iq_stStandardModuleItf.iq_diCMD = ET_ExampleLeafModuleCmd.Stop THEN

	xOpModeCMD := TRUE;
ELSIF iq_stStandardModuleItf.iq_diCMD = ET_ExampleLeafModuleCmd.Start OR
	  iq_stStandardModuleItf.iq_diCMD = ET_ExampleLeafModuleCmd.Hold THEN
	;
ELSE
	xCheckCmdException := TRUE;
END_IF
