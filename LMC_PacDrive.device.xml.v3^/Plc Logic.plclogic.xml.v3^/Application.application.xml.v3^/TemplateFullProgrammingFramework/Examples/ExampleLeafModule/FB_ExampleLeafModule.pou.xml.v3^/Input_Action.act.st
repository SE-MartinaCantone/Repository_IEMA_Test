__METADATA__
{
  "v3Meta": {
    "objectGuid": "b80a94df-6ecb-4747-841b-6a07af00b94b",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
iq_stStandardModuleItf.q_xReady := TRUE;
THIS^.DiagQuit();

(* -----------------------------------------------------------------------------------------------*)
(* Check external Reaction *)
(* -----------------------------------------------------------------------------------------------*)
stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] := stLocalReaction.axReaction[TPL.ET_Reaction.AsyncStop] OR iq_stStandardModuleItf.i_stReaction.axReaction[TPL.ET_Reaction.AsyncStop];
stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] := stLocalReaction.axReaction[TPL.ET_Reaction.SyncStopEL] OR iq_stStandardModuleItf.i_stReaction.axReaction[TPL.ET_Reaction.SyncStopEL];
stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH] := stLocalReaction.axReaction[TPL.ET_Reaction.SyncStopEH] OR iq_stStandardModuleItf.i_stReaction.axReaction[TPL.ET_Reaction.SyncStopEH];
stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle] := stLocalReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle] OR iq_stStandardModuleItf.i_stReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle];
stModuleReaction.axReaction[TPL.ET_Reaction.MainsContactorOff] := stLocalReaction.axReaction[TPL.ET_Reaction.MainsContactorOff] OR iq_stStandardModuleItf.i_stReaction.axReaction[TPL.ET_Reaction.MainsContactorOff];
