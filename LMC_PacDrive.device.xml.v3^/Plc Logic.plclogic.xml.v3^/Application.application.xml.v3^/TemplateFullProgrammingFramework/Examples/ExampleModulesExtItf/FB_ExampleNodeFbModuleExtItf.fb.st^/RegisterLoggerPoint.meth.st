__METADATA__
{
  "v3Meta": {
    "objectGuid": "8897088a-aa42-4507-825a-a3aa3506bb88",
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
METHOD PUBLIC RegisterLoggerPoint
VAR_INPUT
	i_ifParent		: APL.IF_LoggerPoint;
	i_sName			: STRING[80];
	i_sType			: STRING[80];
	i_sSource		: STRING[40];
END_VAR
VAR_OUTPUT
	q_etDiag		: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt		: APL.ET_DiagExt := APL.ET_DiagExt.Ok;
END_VAR
__IMPLEMENTATION__
THIS^.fbExampleNodeFbModule.RegisterLoggerPoint(	i_ifParent	:= i_ifParent,
													i_sName		:= i_sName,
													i_sType		:= i_sType,
													i_sSource	:= i_sSource,
													q_etDiag	=> q_etDiag,
													q_etDiagExt	=> q_etDiagExt);
