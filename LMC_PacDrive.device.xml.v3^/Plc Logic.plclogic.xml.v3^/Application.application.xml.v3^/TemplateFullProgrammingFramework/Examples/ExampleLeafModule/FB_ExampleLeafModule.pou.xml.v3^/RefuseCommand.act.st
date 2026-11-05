__METADATA__
{
  "v3Meta": {
    "objectGuid": "59776825-c185-4ee6-9902-b4b2bffaf7dd",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
iq_stStandardModuleItf.q_xCMDActive := FALSE;
iq_stStandardModuleItf.q_xCMDDone := FALSE;
iq_stStandardModuleItf.iq_diCMD := - iq_stStandardModuleItf.iq_diCMD;

xCommandRefused := TRUE;
