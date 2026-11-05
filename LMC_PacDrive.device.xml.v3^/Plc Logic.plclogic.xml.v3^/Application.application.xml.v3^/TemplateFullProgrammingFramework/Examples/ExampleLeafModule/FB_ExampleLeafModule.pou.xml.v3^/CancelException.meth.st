__METADATA__
{
  "v3Meta": {
    "objectGuid": "60f50743-bac6-4813-b55d-90ab26b2442d",
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
METHOD CancelException
VAR_IN_OUT
	iq_stException	: TPL.ST_Exception;
END_VAR
__IMPLEMENTATION__
TPL.FC_SetException(	i_xExceptionActive	:= FALSE,
						iq_stException		:= iq_stException,
						iq_stExceptionList	:= iq_stExceptionList,
						iq_stLogDataList	:= iq_stLogDataList,
						q_etDiag 			=> etDiagBuffer,
						q_etDiagExt 		=> etDiagExtBufferTPL,
						q_sMsg 				=> sDiagMsgBuffer);
