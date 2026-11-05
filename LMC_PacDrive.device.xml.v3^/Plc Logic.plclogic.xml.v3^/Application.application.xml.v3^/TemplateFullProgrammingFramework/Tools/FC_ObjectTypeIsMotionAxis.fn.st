__METADATA__
{
  "v3Meta": {
    "objectGuid": "027ac39a-f208-45fc-a82c-1ff263181d29",
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
(* Checks whether the given diObjectType is an object representing a Motion Axis (drive beneath SercosIII bus) *)
FUNCTION FC_ObjectTypeIsMotionAxis : BOOL

VAR_INPUT
	i_udiObjectType: UDINT; (* Type (UDINT) of object to be checked to be a motion axis *)  
END_VAR
__IMPLEMENTATION__
(* Currently, this implemetation is hacky. We compare the ObjectType to a static list of ObjectTypes known as Motion Drives.
   What we acutlly want is to get the IEC object by LogicalAddress and check whether it fits the interface IF_Drive. But sadly, 
   such a function doesn't exist yet *)

IF	i_udiObjectType = SystemInterface.LXM62DxS_TYPE.udiType OR
	i_udiObjectType = SystemInterface.ILM62_TYPE.udiType OR
	i_udiObjectType = SystemInterface.LXM52_TYPE.udiType OR
	i_udiObjectType = SystemInterface.SERCDRV_TYPE.udiType OR
	i_udiObjectType = SystemInterface.LXM52Linear_TYPE.udiType OR
	i_udiObjectType = SystemInterface.LXM62DxSLinear_TYPE.udiType
THEN
   FC_ObjectTypeIsMotionAxis := TRUE;
ELSE
   FC_ObjectTypeIsMotionAxis := FALSE;
END_IF

RETURN;
