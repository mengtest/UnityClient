-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('equipment_pb')


local localTable = {}
S2CADDEQUIPMENTPROTO = protobuf.Descriptor()
localTable.S2CADDEQUIPMENTPROTO_DATA_FIELD = protobuf.FieldDescriptor()
S2CADDEQUIPMENTWITHEXPIRETIMEPROTO = protobuf.Descriptor()
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_DATA_FIELD = protobuf.FieldDescriptor()
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_EXPIRE_TIME_FIELD = protobuf.FieldDescriptor()
C2SWEAREQUIPMENTPROTO = protobuf.Descriptor()
localTable.C2SWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD = protobuf.FieldDescriptor()
localTable.C2SWEAREQUIPMENTPROTO_EQUIPMENT_ID_FIELD = protobuf.FieldDescriptor()
localTable.C2SWEAREQUIPMENTPROTO_DOWN_FIELD = protobuf.FieldDescriptor()
S2CWEAREQUIPMENTPROTO = protobuf.Descriptor()
localTable.S2CWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD = protobuf.FieldDescriptor()
localTable.S2CWEAREQUIPMENTPROTO_UP_ID_FIELD = protobuf.FieldDescriptor()
localTable.S2CWEAREQUIPMENTPROTO_DOWN_ID_FIELD = protobuf.FieldDescriptor()
localTable.S2CWEAREQUIPMENTPROTO_TAOZ_FIELD = protobuf.FieldDescriptor()
C2SUPGRADEEQUIPMENTPROTO = protobuf.Descriptor()
localTable.C2SUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD = protobuf.FieldDescriptor()
localTable.C2SUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD = protobuf.FieldDescriptor()
localTable.C2SUPGRADEEQUIPMENTPROTO_UPGRADE_TIMES_FIELD = protobuf.FieldDescriptor()
S2CUPGRADEEQUIPMENTPROTO = protobuf.Descriptor()
localTable.S2CUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD = protobuf.FieldDescriptor()
localTable.S2CUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD = protobuf.FieldDescriptor()
localTable.S2CUPGRADEEQUIPMENTPROTO_LEVEL_FIELD = protobuf.FieldDescriptor()
C2SUPGRADEEQUIPMENTALLPROTO = protobuf.Descriptor()
localTable.C2SUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD = protobuf.FieldDescriptor()
S2CUPGRADEEQUIPMENTALLPROTO = protobuf.Descriptor()
localTable.S2CUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD = protobuf.FieldDescriptor()
localTable.S2CUPGRADEEQUIPMENTALLPROTO_LEVEL_FIELD = protobuf.FieldDescriptor()
C2SREFINEDEQUIPMENTPROTO = protobuf.Descriptor()
localTable.C2SREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD = protobuf.FieldDescriptor()
localTable.C2SREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD = protobuf.FieldDescriptor()
S2CREFINEDEQUIPMENTPROTO = protobuf.Descriptor()
localTable.S2CREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD = protobuf.FieldDescriptor()
localTable.S2CREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD = protobuf.FieldDescriptor()
localTable.S2CREFINEDEQUIPMENTPROTO_LEVEL_FIELD = protobuf.FieldDescriptor()
localTable.S2CREFINEDEQUIPMENTPROTO_TAOZ_FIELD = protobuf.FieldDescriptor()
S2CUPDATEEQUIPMENTPROTO = protobuf.Descriptor()
localTable.S2CUPDATEEQUIPMENTPROTO_DATA_FIELD = protobuf.FieldDescriptor()
S2CUPDATEMULTIEQUIPMENTPROTO = protobuf.Descriptor()
localTable.S2CUPDATEMULTIEQUIPMENTPROTO_DATA_FIELD = protobuf.FieldDescriptor()
C2SSMELTEQUIPMENTPROTO = protobuf.Descriptor()
localTable.C2SSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD = protobuf.FieldDescriptor()
S2CSMELTEQUIPMENTPROTO = protobuf.Descriptor()
localTable.S2CSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD = protobuf.FieldDescriptor()
C2SREBUILDEQUIPMENTPROTO = protobuf.Descriptor()
localTable.C2SREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD = protobuf.FieldDescriptor()
S2CREBUILDEQUIPMENTPROTO = protobuf.Descriptor()
localTable.S2CREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD = protobuf.FieldDescriptor()
S2COPENEQUIPCOMBINEPROTO = protobuf.Descriptor()
localTable.S2COPENEQUIPCOMBINEPROTO_ID_FIELD = protobuf.FieldDescriptor()


localTable.S2CADDEQUIPMENTPROTO_DATA_FIELD.name = "data"
localTable.S2CADDEQUIPMENTPROTO_DATA_FIELD.full_name = ".proto.S2CAddEquipmentProto.data"
localTable.S2CADDEQUIPMENTPROTO_DATA_FIELD.number = 1
localTable.S2CADDEQUIPMENTPROTO_DATA_FIELD.index = 0
localTable.S2CADDEQUIPMENTPROTO_DATA_FIELD.label = 1
localTable.S2CADDEQUIPMENTPROTO_DATA_FIELD.has_default_value = false
localTable.S2CADDEQUIPMENTPROTO_DATA_FIELD.default_value = ""
localTable.S2CADDEQUIPMENTPROTO_DATA_FIELD.type = 12
localTable.S2CADDEQUIPMENTPROTO_DATA_FIELD.cpp_type = 9

S2CADDEQUIPMENTPROTO.name = "S2CAddEquipmentProto"
S2CADDEQUIPMENTPROTO.full_name = ".proto.S2CAddEquipmentProto"
S2CADDEQUIPMENTPROTO.nested_types = {}
S2CADDEQUIPMENTPROTO.enum_types = {}
S2CADDEQUIPMENTPROTO.fields = {localTable.S2CADDEQUIPMENTPROTO_DATA_FIELD}
S2CADDEQUIPMENTPROTO.is_extendable = false
S2CADDEQUIPMENTPROTO.extensions = {}
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_DATA_FIELD.name = "data"
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_DATA_FIELD.full_name = ".proto.S2CAddEquipmentWithExpireTimeProto.data"
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_DATA_FIELD.number = 1
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_DATA_FIELD.index = 0
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_DATA_FIELD.label = 1
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_DATA_FIELD.has_default_value = false
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_DATA_FIELD.default_value = ""
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_DATA_FIELD.type = 12
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_DATA_FIELD.cpp_type = 9

localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_EXPIRE_TIME_FIELD.name = "expire_time"
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_EXPIRE_TIME_FIELD.full_name = ".proto.S2CAddEquipmentWithExpireTimeProto.expire_time"
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_EXPIRE_TIME_FIELD.number = 2
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_EXPIRE_TIME_FIELD.index = 1
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_EXPIRE_TIME_FIELD.label = 1
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_EXPIRE_TIME_FIELD.has_default_value = false
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_EXPIRE_TIME_FIELD.default_value = 0
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_EXPIRE_TIME_FIELD.type = 5
localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_EXPIRE_TIME_FIELD.cpp_type = 1

S2CADDEQUIPMENTWITHEXPIRETIMEPROTO.name = "S2CAddEquipmentWithExpireTimeProto"
S2CADDEQUIPMENTWITHEXPIRETIMEPROTO.full_name = ".proto.S2CAddEquipmentWithExpireTimeProto"
S2CADDEQUIPMENTWITHEXPIRETIMEPROTO.nested_types = {}
S2CADDEQUIPMENTWITHEXPIRETIMEPROTO.enum_types = {}
S2CADDEQUIPMENTWITHEXPIRETIMEPROTO.fields = {localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_DATA_FIELD, localTable.S2CADDEQUIPMENTWITHEXPIRETIMEPROTO_EXPIRE_TIME_FIELD}
S2CADDEQUIPMENTWITHEXPIRETIMEPROTO.is_extendable = false
S2CADDEQUIPMENTWITHEXPIRETIMEPROTO.extensions = {}
localTable.C2SWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.name = "captain_id"
localTable.C2SWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.full_name = ".proto.C2SWearEquipmentProto.captain_id"
localTable.C2SWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.number = 1
localTable.C2SWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.index = 0
localTable.C2SWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.label = 1
localTable.C2SWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.has_default_value = false
localTable.C2SWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.default_value = 0
localTable.C2SWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.type = 5
localTable.C2SWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.cpp_type = 1

localTable.C2SWEAREQUIPMENTPROTO_EQUIPMENT_ID_FIELD.name = "equipment_id"
localTable.C2SWEAREQUIPMENTPROTO_EQUIPMENT_ID_FIELD.full_name = ".proto.C2SWearEquipmentProto.equipment_id"
localTable.C2SWEAREQUIPMENTPROTO_EQUIPMENT_ID_FIELD.number = 2
localTable.C2SWEAREQUIPMENTPROTO_EQUIPMENT_ID_FIELD.index = 1
localTable.C2SWEAREQUIPMENTPROTO_EQUIPMENT_ID_FIELD.label = 1
localTable.C2SWEAREQUIPMENTPROTO_EQUIPMENT_ID_FIELD.has_default_value = false
localTable.C2SWEAREQUIPMENTPROTO_EQUIPMENT_ID_FIELD.default_value = 0
localTable.C2SWEAREQUIPMENTPROTO_EQUIPMENT_ID_FIELD.type = 5
localTable.C2SWEAREQUIPMENTPROTO_EQUIPMENT_ID_FIELD.cpp_type = 1

localTable.C2SWEAREQUIPMENTPROTO_DOWN_FIELD.name = "down"
localTable.C2SWEAREQUIPMENTPROTO_DOWN_FIELD.full_name = ".proto.C2SWearEquipmentProto.down"
localTable.C2SWEAREQUIPMENTPROTO_DOWN_FIELD.number = 3
localTable.C2SWEAREQUIPMENTPROTO_DOWN_FIELD.index = 2
localTable.C2SWEAREQUIPMENTPROTO_DOWN_FIELD.label = 1
localTable.C2SWEAREQUIPMENTPROTO_DOWN_FIELD.has_default_value = false
localTable.C2SWEAREQUIPMENTPROTO_DOWN_FIELD.default_value = false
localTable.C2SWEAREQUIPMENTPROTO_DOWN_FIELD.type = 8
localTable.C2SWEAREQUIPMENTPROTO_DOWN_FIELD.cpp_type = 7

C2SWEAREQUIPMENTPROTO.name = "C2SWearEquipmentProto"
C2SWEAREQUIPMENTPROTO.full_name = ".proto.C2SWearEquipmentProto"
C2SWEAREQUIPMENTPROTO.nested_types = {}
C2SWEAREQUIPMENTPROTO.enum_types = {}
C2SWEAREQUIPMENTPROTO.fields = {localTable.C2SWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD, localTable.C2SWEAREQUIPMENTPROTO_EQUIPMENT_ID_FIELD, localTable.C2SWEAREQUIPMENTPROTO_DOWN_FIELD}
C2SWEAREQUIPMENTPROTO.is_extendable = false
C2SWEAREQUIPMENTPROTO.extensions = {}
localTable.S2CWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.name = "captain_id"
localTable.S2CWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.full_name = ".proto.S2CWearEquipmentProto.captain_id"
localTable.S2CWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.number = 1
localTable.S2CWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.index = 0
localTable.S2CWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.label = 1
localTable.S2CWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.has_default_value = false
localTable.S2CWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.default_value = 0
localTable.S2CWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.type = 5
localTable.S2CWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD.cpp_type = 1

localTable.S2CWEAREQUIPMENTPROTO_UP_ID_FIELD.name = "up_id"
localTable.S2CWEAREQUIPMENTPROTO_UP_ID_FIELD.full_name = ".proto.S2CWearEquipmentProto.up_id"
localTable.S2CWEAREQUIPMENTPROTO_UP_ID_FIELD.number = 2
localTable.S2CWEAREQUIPMENTPROTO_UP_ID_FIELD.index = 1
localTable.S2CWEAREQUIPMENTPROTO_UP_ID_FIELD.label = 1
localTable.S2CWEAREQUIPMENTPROTO_UP_ID_FIELD.has_default_value = false
localTable.S2CWEAREQUIPMENTPROTO_UP_ID_FIELD.default_value = 0
localTable.S2CWEAREQUIPMENTPROTO_UP_ID_FIELD.type = 5
localTable.S2CWEAREQUIPMENTPROTO_UP_ID_FIELD.cpp_type = 1

localTable.S2CWEAREQUIPMENTPROTO_DOWN_ID_FIELD.name = "down_id"
localTable.S2CWEAREQUIPMENTPROTO_DOWN_ID_FIELD.full_name = ".proto.S2CWearEquipmentProto.down_id"
localTable.S2CWEAREQUIPMENTPROTO_DOWN_ID_FIELD.number = 3
localTable.S2CWEAREQUIPMENTPROTO_DOWN_ID_FIELD.index = 2
localTable.S2CWEAREQUIPMENTPROTO_DOWN_ID_FIELD.label = 1
localTable.S2CWEAREQUIPMENTPROTO_DOWN_ID_FIELD.has_default_value = false
localTable.S2CWEAREQUIPMENTPROTO_DOWN_ID_FIELD.default_value = 0
localTable.S2CWEAREQUIPMENTPROTO_DOWN_ID_FIELD.type = 5
localTable.S2CWEAREQUIPMENTPROTO_DOWN_ID_FIELD.cpp_type = 1

localTable.S2CWEAREQUIPMENTPROTO_TAOZ_FIELD.name = "taoz"
localTable.S2CWEAREQUIPMENTPROTO_TAOZ_FIELD.full_name = ".proto.S2CWearEquipmentProto.taoz"
localTable.S2CWEAREQUIPMENTPROTO_TAOZ_FIELD.number = 4
localTable.S2CWEAREQUIPMENTPROTO_TAOZ_FIELD.index = 3
localTable.S2CWEAREQUIPMENTPROTO_TAOZ_FIELD.label = 1
localTable.S2CWEAREQUIPMENTPROTO_TAOZ_FIELD.has_default_value = false
localTable.S2CWEAREQUIPMENTPROTO_TAOZ_FIELD.default_value = 0
localTable.S2CWEAREQUIPMENTPROTO_TAOZ_FIELD.type = 5
localTable.S2CWEAREQUIPMENTPROTO_TAOZ_FIELD.cpp_type = 1

S2CWEAREQUIPMENTPROTO.name = "S2CWearEquipmentProto"
S2CWEAREQUIPMENTPROTO.full_name = ".proto.S2CWearEquipmentProto"
S2CWEAREQUIPMENTPROTO.nested_types = {}
S2CWEAREQUIPMENTPROTO.enum_types = {}
S2CWEAREQUIPMENTPROTO.fields = {localTable.S2CWEAREQUIPMENTPROTO_CAPTAIN_ID_FIELD, localTable.S2CWEAREQUIPMENTPROTO_UP_ID_FIELD, localTable.S2CWEAREQUIPMENTPROTO_DOWN_ID_FIELD, localTable.S2CWEAREQUIPMENTPROTO_TAOZ_FIELD}
S2CWEAREQUIPMENTPROTO.is_extendable = false
S2CWEAREQUIPMENTPROTO.extensions = {}
localTable.C2SUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.name = "captain_id"
localTable.C2SUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.full_name = ".proto.C2SUpgradeEquipmentProto.captain_id"
localTable.C2SUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.number = 1
localTable.C2SUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.index = 0
localTable.C2SUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.label = 1
localTable.C2SUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.has_default_value = false
localTable.C2SUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.default_value = 0
localTable.C2SUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.type = 5
localTable.C2SUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.cpp_type = 1

localTable.C2SUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.name = "equipment_id"
localTable.C2SUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.full_name = ".proto.C2SUpgradeEquipmentProto.equipment_id"
localTable.C2SUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.number = 2
localTable.C2SUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.index = 1
localTable.C2SUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.label = 1
localTable.C2SUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.has_default_value = false
localTable.C2SUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.default_value = 0
localTable.C2SUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.type = 5
localTable.C2SUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.cpp_type = 1

localTable.C2SUPGRADEEQUIPMENTPROTO_UPGRADE_TIMES_FIELD.name = "upgrade_times"
localTable.C2SUPGRADEEQUIPMENTPROTO_UPGRADE_TIMES_FIELD.full_name = ".proto.C2SUpgradeEquipmentProto.upgrade_times"
localTable.C2SUPGRADEEQUIPMENTPROTO_UPGRADE_TIMES_FIELD.number = 3
localTable.C2SUPGRADEEQUIPMENTPROTO_UPGRADE_TIMES_FIELD.index = 2
localTable.C2SUPGRADEEQUIPMENTPROTO_UPGRADE_TIMES_FIELD.label = 1
localTable.C2SUPGRADEEQUIPMENTPROTO_UPGRADE_TIMES_FIELD.has_default_value = false
localTable.C2SUPGRADEEQUIPMENTPROTO_UPGRADE_TIMES_FIELD.default_value = 0
localTable.C2SUPGRADEEQUIPMENTPROTO_UPGRADE_TIMES_FIELD.type = 5
localTable.C2SUPGRADEEQUIPMENTPROTO_UPGRADE_TIMES_FIELD.cpp_type = 1

C2SUPGRADEEQUIPMENTPROTO.name = "C2SUpgradeEquipmentProto"
C2SUPGRADEEQUIPMENTPROTO.full_name = ".proto.C2SUpgradeEquipmentProto"
C2SUPGRADEEQUIPMENTPROTO.nested_types = {}
C2SUPGRADEEQUIPMENTPROTO.enum_types = {}
C2SUPGRADEEQUIPMENTPROTO.fields = {localTable.C2SUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD, localTable.C2SUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD, localTable.C2SUPGRADEEQUIPMENTPROTO_UPGRADE_TIMES_FIELD}
C2SUPGRADEEQUIPMENTPROTO.is_extendable = false
C2SUPGRADEEQUIPMENTPROTO.extensions = {}
localTable.S2CUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.name = "captain_id"
localTable.S2CUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.full_name = ".proto.S2CUpgradeEquipmentProto.captain_id"
localTable.S2CUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.number = 1
localTable.S2CUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.index = 0
localTable.S2CUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.label = 1
localTable.S2CUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.has_default_value = false
localTable.S2CUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.default_value = 0
localTable.S2CUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.type = 5
localTable.S2CUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD.cpp_type = 1

localTable.S2CUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.name = "equipment_id"
localTable.S2CUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.full_name = ".proto.S2CUpgradeEquipmentProto.equipment_id"
localTable.S2CUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.number = 2
localTable.S2CUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.index = 1
localTable.S2CUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.label = 1
localTable.S2CUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.has_default_value = false
localTable.S2CUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.default_value = 0
localTable.S2CUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.type = 5
localTable.S2CUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.cpp_type = 1

localTable.S2CUPGRADEEQUIPMENTPROTO_LEVEL_FIELD.name = "level"
localTable.S2CUPGRADEEQUIPMENTPROTO_LEVEL_FIELD.full_name = ".proto.S2CUpgradeEquipmentProto.level"
localTable.S2CUPGRADEEQUIPMENTPROTO_LEVEL_FIELD.number = 3
localTable.S2CUPGRADEEQUIPMENTPROTO_LEVEL_FIELD.index = 2
localTable.S2CUPGRADEEQUIPMENTPROTO_LEVEL_FIELD.label = 1
localTable.S2CUPGRADEEQUIPMENTPROTO_LEVEL_FIELD.has_default_value = false
localTable.S2CUPGRADEEQUIPMENTPROTO_LEVEL_FIELD.default_value = 0
localTable.S2CUPGRADEEQUIPMENTPROTO_LEVEL_FIELD.type = 5
localTable.S2CUPGRADEEQUIPMENTPROTO_LEVEL_FIELD.cpp_type = 1

S2CUPGRADEEQUIPMENTPROTO.name = "S2CUpgradeEquipmentProto"
S2CUPGRADEEQUIPMENTPROTO.full_name = ".proto.S2CUpgradeEquipmentProto"
S2CUPGRADEEQUIPMENTPROTO.nested_types = {}
S2CUPGRADEEQUIPMENTPROTO.enum_types = {}
S2CUPGRADEEQUIPMENTPROTO.fields = {localTable.S2CUPGRADEEQUIPMENTPROTO_CAPTAIN_ID_FIELD, localTable.S2CUPGRADEEQUIPMENTPROTO_EQUIPMENT_ID_FIELD, localTable.S2CUPGRADEEQUIPMENTPROTO_LEVEL_FIELD}
S2CUPGRADEEQUIPMENTPROTO.is_extendable = false
S2CUPGRADEEQUIPMENTPROTO.extensions = {}
localTable.C2SUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.name = "captain_id"
localTable.C2SUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.full_name = ".proto.C2SUpgradeEquipmentAllProto.captain_id"
localTable.C2SUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.number = 1
localTable.C2SUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.index = 0
localTable.C2SUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.label = 1
localTable.C2SUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.has_default_value = false
localTable.C2SUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.default_value = 0
localTable.C2SUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.type = 5
localTable.C2SUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.cpp_type = 1

C2SUPGRADEEQUIPMENTALLPROTO.name = "C2SUpgradeEquipmentAllProto"
C2SUPGRADEEQUIPMENTALLPROTO.full_name = ".proto.C2SUpgradeEquipmentAllProto"
C2SUPGRADEEQUIPMENTALLPROTO.nested_types = {}
C2SUPGRADEEQUIPMENTALLPROTO.enum_types = {}
C2SUPGRADEEQUIPMENTALLPROTO.fields = {localTable.C2SUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD}
C2SUPGRADEEQUIPMENTALLPROTO.is_extendable = false
C2SUPGRADEEQUIPMENTALLPROTO.extensions = {}
localTable.S2CUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.name = "captain_id"
localTable.S2CUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.full_name = ".proto.S2CUpgradeEquipmentAllProto.captain_id"
localTable.S2CUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.number = 1
localTable.S2CUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.index = 0
localTable.S2CUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.label = 1
localTable.S2CUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.has_default_value = false
localTable.S2CUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.default_value = 0
localTable.S2CUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.type = 5
localTable.S2CUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD.cpp_type = 1

localTable.S2CUPGRADEEQUIPMENTALLPROTO_LEVEL_FIELD.name = "level"
localTable.S2CUPGRADEEQUIPMENTALLPROTO_LEVEL_FIELD.full_name = ".proto.S2CUpgradeEquipmentAllProto.level"
localTable.S2CUPGRADEEQUIPMENTALLPROTO_LEVEL_FIELD.number = 2
localTable.S2CUPGRADEEQUIPMENTALLPROTO_LEVEL_FIELD.index = 1
localTable.S2CUPGRADEEQUIPMENTALLPROTO_LEVEL_FIELD.label = 3
localTable.S2CUPGRADEEQUIPMENTALLPROTO_LEVEL_FIELD.has_default_value = false
localTable.S2CUPGRADEEQUIPMENTALLPROTO_LEVEL_FIELD.default_value = {}
localTable.S2CUPGRADEEQUIPMENTALLPROTO_LEVEL_FIELD.type = 5
localTable.S2CUPGRADEEQUIPMENTALLPROTO_LEVEL_FIELD.cpp_type = 1

S2CUPGRADEEQUIPMENTALLPROTO.name = "S2CUpgradeEquipmentAllProto"
S2CUPGRADEEQUIPMENTALLPROTO.full_name = ".proto.S2CUpgradeEquipmentAllProto"
S2CUPGRADEEQUIPMENTALLPROTO.nested_types = {}
S2CUPGRADEEQUIPMENTALLPROTO.enum_types = {}
S2CUPGRADEEQUIPMENTALLPROTO.fields = {localTable.S2CUPGRADEEQUIPMENTALLPROTO_CAPTAIN_ID_FIELD, localTable.S2CUPGRADEEQUIPMENTALLPROTO_LEVEL_FIELD}
S2CUPGRADEEQUIPMENTALLPROTO.is_extendable = false
S2CUPGRADEEQUIPMENTALLPROTO.extensions = {}
localTable.C2SREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.name = "captain_id"
localTable.C2SREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.full_name = ".proto.C2SRefinedEquipmentProto.captain_id"
localTable.C2SREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.number = 1
localTable.C2SREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.index = 0
localTable.C2SREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.label = 1
localTable.C2SREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.has_default_value = false
localTable.C2SREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.default_value = 0
localTable.C2SREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.type = 5
localTable.C2SREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.cpp_type = 1

localTable.C2SREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.name = "equipment_id"
localTable.C2SREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.full_name = ".proto.C2SRefinedEquipmentProto.equipment_id"
localTable.C2SREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.number = 2
localTable.C2SREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.index = 1
localTable.C2SREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.label = 1
localTable.C2SREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.has_default_value = false
localTable.C2SREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.default_value = 0
localTable.C2SREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.type = 5
localTable.C2SREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.cpp_type = 1

C2SREFINEDEQUIPMENTPROTO.name = "C2SRefinedEquipmentProto"
C2SREFINEDEQUIPMENTPROTO.full_name = ".proto.C2SRefinedEquipmentProto"
C2SREFINEDEQUIPMENTPROTO.nested_types = {}
C2SREFINEDEQUIPMENTPROTO.enum_types = {}
C2SREFINEDEQUIPMENTPROTO.fields = {localTable.C2SREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD, localTable.C2SREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD}
C2SREFINEDEQUIPMENTPROTO.is_extendable = false
C2SREFINEDEQUIPMENTPROTO.extensions = {}
localTable.S2CREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.name = "captain_id"
localTable.S2CREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.full_name = ".proto.S2CRefinedEquipmentProto.captain_id"
localTable.S2CREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.number = 1
localTable.S2CREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.index = 0
localTable.S2CREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.label = 1
localTable.S2CREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.has_default_value = false
localTable.S2CREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.default_value = 0
localTable.S2CREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.type = 5
localTable.S2CREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD.cpp_type = 1

localTable.S2CREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.name = "equipment_id"
localTable.S2CREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.full_name = ".proto.S2CRefinedEquipmentProto.equipment_id"
localTable.S2CREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.number = 2
localTable.S2CREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.index = 1
localTable.S2CREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.label = 1
localTable.S2CREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.has_default_value = false
localTable.S2CREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.default_value = 0
localTable.S2CREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.type = 5
localTable.S2CREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.cpp_type = 1

localTable.S2CREFINEDEQUIPMENTPROTO_LEVEL_FIELD.name = "level"
localTable.S2CREFINEDEQUIPMENTPROTO_LEVEL_FIELD.full_name = ".proto.S2CRefinedEquipmentProto.level"
localTable.S2CREFINEDEQUIPMENTPROTO_LEVEL_FIELD.number = 3
localTable.S2CREFINEDEQUIPMENTPROTO_LEVEL_FIELD.index = 2
localTable.S2CREFINEDEQUIPMENTPROTO_LEVEL_FIELD.label = 1
localTable.S2CREFINEDEQUIPMENTPROTO_LEVEL_FIELD.has_default_value = false
localTable.S2CREFINEDEQUIPMENTPROTO_LEVEL_FIELD.default_value = 0
localTable.S2CREFINEDEQUIPMENTPROTO_LEVEL_FIELD.type = 5
localTable.S2CREFINEDEQUIPMENTPROTO_LEVEL_FIELD.cpp_type = 1

localTable.S2CREFINEDEQUIPMENTPROTO_TAOZ_FIELD.name = "taoz"
localTable.S2CREFINEDEQUIPMENTPROTO_TAOZ_FIELD.full_name = ".proto.S2CRefinedEquipmentProto.taoz"
localTable.S2CREFINEDEQUIPMENTPROTO_TAOZ_FIELD.number = 4
localTable.S2CREFINEDEQUIPMENTPROTO_TAOZ_FIELD.index = 3
localTable.S2CREFINEDEQUIPMENTPROTO_TAOZ_FIELD.label = 1
localTable.S2CREFINEDEQUIPMENTPROTO_TAOZ_FIELD.has_default_value = false
localTable.S2CREFINEDEQUIPMENTPROTO_TAOZ_FIELD.default_value = 0
localTable.S2CREFINEDEQUIPMENTPROTO_TAOZ_FIELD.type = 5
localTable.S2CREFINEDEQUIPMENTPROTO_TAOZ_FIELD.cpp_type = 1

S2CREFINEDEQUIPMENTPROTO.name = "S2CRefinedEquipmentProto"
S2CREFINEDEQUIPMENTPROTO.full_name = ".proto.S2CRefinedEquipmentProto"
S2CREFINEDEQUIPMENTPROTO.nested_types = {}
S2CREFINEDEQUIPMENTPROTO.enum_types = {}
S2CREFINEDEQUIPMENTPROTO.fields = {localTable.S2CREFINEDEQUIPMENTPROTO_CAPTAIN_ID_FIELD, localTable.S2CREFINEDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD, localTable.S2CREFINEDEQUIPMENTPROTO_LEVEL_FIELD, localTable.S2CREFINEDEQUIPMENTPROTO_TAOZ_FIELD}
S2CREFINEDEQUIPMENTPROTO.is_extendable = false
S2CREFINEDEQUIPMENTPROTO.extensions = {}
localTable.S2CUPDATEEQUIPMENTPROTO_DATA_FIELD.name = "data"
localTable.S2CUPDATEEQUIPMENTPROTO_DATA_FIELD.full_name = ".proto.S2CUpdateEquipmentProto.data"
localTable.S2CUPDATEEQUIPMENTPROTO_DATA_FIELD.number = 1
localTable.S2CUPDATEEQUIPMENTPROTO_DATA_FIELD.index = 0
localTable.S2CUPDATEEQUIPMENTPROTO_DATA_FIELD.label = 1
localTable.S2CUPDATEEQUIPMENTPROTO_DATA_FIELD.has_default_value = false
localTable.S2CUPDATEEQUIPMENTPROTO_DATA_FIELD.default_value = ""
localTable.S2CUPDATEEQUIPMENTPROTO_DATA_FIELD.type = 12
localTable.S2CUPDATEEQUIPMENTPROTO_DATA_FIELD.cpp_type = 9

S2CUPDATEEQUIPMENTPROTO.name = "S2CUpdateEquipmentProto"
S2CUPDATEEQUIPMENTPROTO.full_name = ".proto.S2CUpdateEquipmentProto"
S2CUPDATEEQUIPMENTPROTO.nested_types = {}
S2CUPDATEEQUIPMENTPROTO.enum_types = {}
S2CUPDATEEQUIPMENTPROTO.fields = {localTable.S2CUPDATEEQUIPMENTPROTO_DATA_FIELD}
S2CUPDATEEQUIPMENTPROTO.is_extendable = false
S2CUPDATEEQUIPMENTPROTO.extensions = {}
localTable.S2CUPDATEMULTIEQUIPMENTPROTO_DATA_FIELD.name = "data"
localTable.S2CUPDATEMULTIEQUIPMENTPROTO_DATA_FIELD.full_name = ".proto.S2CUpdateMultiEquipmentProto.data"
localTable.S2CUPDATEMULTIEQUIPMENTPROTO_DATA_FIELD.number = 1
localTable.S2CUPDATEMULTIEQUIPMENTPROTO_DATA_FIELD.index = 0
localTable.S2CUPDATEMULTIEQUIPMENTPROTO_DATA_FIELD.label = 3
localTable.S2CUPDATEMULTIEQUIPMENTPROTO_DATA_FIELD.has_default_value = false
localTable.S2CUPDATEMULTIEQUIPMENTPROTO_DATA_FIELD.default_value = {}
localTable.S2CUPDATEMULTIEQUIPMENTPROTO_DATA_FIELD.type = 12
localTable.S2CUPDATEMULTIEQUIPMENTPROTO_DATA_FIELD.cpp_type = 9

S2CUPDATEMULTIEQUIPMENTPROTO.name = "S2CUpdateMultiEquipmentProto"
S2CUPDATEMULTIEQUIPMENTPROTO.full_name = ".proto.S2CUpdateMultiEquipmentProto"
S2CUPDATEMULTIEQUIPMENTPROTO.nested_types = {}
S2CUPDATEMULTIEQUIPMENTPROTO.enum_types = {}
S2CUPDATEMULTIEQUIPMENTPROTO.fields = {localTable.S2CUPDATEMULTIEQUIPMENTPROTO_DATA_FIELD}
S2CUPDATEMULTIEQUIPMENTPROTO.is_extendable = false
S2CUPDATEMULTIEQUIPMENTPROTO.extensions = {}
localTable.C2SSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.name = "equipment_id"
localTable.C2SSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.full_name = ".proto.C2SSmeltEquipmentProto.equipment_id"
localTable.C2SSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.number = 1
localTable.C2SSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.index = 0
localTable.C2SSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.label = 3
localTable.C2SSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.has_default_value = false
localTable.C2SSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.default_value = {}
localTable.C2SSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.type = 5
localTable.C2SSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.cpp_type = 1

C2SSMELTEQUIPMENTPROTO.name = "C2SSmeltEquipmentProto"
C2SSMELTEQUIPMENTPROTO.full_name = ".proto.C2SSmeltEquipmentProto"
C2SSMELTEQUIPMENTPROTO.nested_types = {}
C2SSMELTEQUIPMENTPROTO.enum_types = {}
C2SSMELTEQUIPMENTPROTO.fields = {localTable.C2SSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD}
C2SSMELTEQUIPMENTPROTO.is_extendable = false
C2SSMELTEQUIPMENTPROTO.extensions = {}
localTable.S2CSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.name = "equipment_id"
localTable.S2CSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.full_name = ".proto.S2CSmeltEquipmentProto.equipment_id"
localTable.S2CSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.number = 1
localTable.S2CSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.index = 0
localTable.S2CSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.label = 3
localTable.S2CSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.has_default_value = false
localTable.S2CSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.default_value = {}
localTable.S2CSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.type = 5
localTable.S2CSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.cpp_type = 1

S2CSMELTEQUIPMENTPROTO.name = "S2CSmeltEquipmentProto"
S2CSMELTEQUIPMENTPROTO.full_name = ".proto.S2CSmeltEquipmentProto"
S2CSMELTEQUIPMENTPROTO.nested_types = {}
S2CSMELTEQUIPMENTPROTO.enum_types = {}
S2CSMELTEQUIPMENTPROTO.fields = {localTable.S2CSMELTEQUIPMENTPROTO_EQUIPMENT_ID_FIELD}
S2CSMELTEQUIPMENTPROTO.is_extendable = false
S2CSMELTEQUIPMENTPROTO.extensions = {}
localTable.C2SREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.name = "equipment_id"
localTable.C2SREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.full_name = ".proto.C2SRebuildEquipmentProto.equipment_id"
localTable.C2SREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.number = 1
localTable.C2SREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.index = 0
localTable.C2SREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.label = 3
localTable.C2SREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.has_default_value = false
localTable.C2SREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.default_value = {}
localTable.C2SREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.type = 5
localTable.C2SREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.cpp_type = 1

C2SREBUILDEQUIPMENTPROTO.name = "C2SRebuildEquipmentProto"
C2SREBUILDEQUIPMENTPROTO.full_name = ".proto.C2SRebuildEquipmentProto"
C2SREBUILDEQUIPMENTPROTO.nested_types = {}
C2SREBUILDEQUIPMENTPROTO.enum_types = {}
C2SREBUILDEQUIPMENTPROTO.fields = {localTable.C2SREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD}
C2SREBUILDEQUIPMENTPROTO.is_extendable = false
C2SREBUILDEQUIPMENTPROTO.extensions = {}
localTable.S2CREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.name = "equipment_id"
localTable.S2CREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.full_name = ".proto.S2CRebuildEquipmentProto.equipment_id"
localTable.S2CREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.number = 1
localTable.S2CREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.index = 0
localTable.S2CREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.label = 3
localTable.S2CREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.has_default_value = false
localTable.S2CREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.default_value = {}
localTable.S2CREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.type = 5
localTable.S2CREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD.cpp_type = 1

S2CREBUILDEQUIPMENTPROTO.name = "S2CRebuildEquipmentProto"
S2CREBUILDEQUIPMENTPROTO.full_name = ".proto.S2CRebuildEquipmentProto"
S2CREBUILDEQUIPMENTPROTO.nested_types = {}
S2CREBUILDEQUIPMENTPROTO.enum_types = {}
S2CREBUILDEQUIPMENTPROTO.fields = {localTable.S2CREBUILDEQUIPMENTPROTO_EQUIPMENT_ID_FIELD}
S2CREBUILDEQUIPMENTPROTO.is_extendable = false
S2CREBUILDEQUIPMENTPROTO.extensions = {}
localTable.S2COPENEQUIPCOMBINEPROTO_ID_FIELD.name = "id"
localTable.S2COPENEQUIPCOMBINEPROTO_ID_FIELD.full_name = ".proto.S2COpenEquipCombineProto.id"
localTable.S2COPENEQUIPCOMBINEPROTO_ID_FIELD.number = 1
localTable.S2COPENEQUIPCOMBINEPROTO_ID_FIELD.index = 0
localTable.S2COPENEQUIPCOMBINEPROTO_ID_FIELD.label = 1
localTable.S2COPENEQUIPCOMBINEPROTO_ID_FIELD.has_default_value = false
localTable.S2COPENEQUIPCOMBINEPROTO_ID_FIELD.default_value = 0
localTable.S2COPENEQUIPCOMBINEPROTO_ID_FIELD.type = 5
localTable.S2COPENEQUIPCOMBINEPROTO_ID_FIELD.cpp_type = 1

S2COPENEQUIPCOMBINEPROTO.name = "S2COpenEquipCombineProto"
S2COPENEQUIPCOMBINEPROTO.full_name = ".proto.S2COpenEquipCombineProto"
S2COPENEQUIPCOMBINEPROTO.nested_types = {}
S2COPENEQUIPCOMBINEPROTO.enum_types = {}
S2COPENEQUIPCOMBINEPROTO.fields = {localTable.S2COPENEQUIPCOMBINEPROTO_ID_FIELD}
S2COPENEQUIPCOMBINEPROTO.is_extendable = false
S2COPENEQUIPCOMBINEPROTO.extensions = {}

C2SRebuildEquipmentProto = protobuf.Message(C2SREBUILDEQUIPMENTPROTO)
C2SRefinedEquipmentProto = protobuf.Message(C2SREFINEDEQUIPMENTPROTO)
C2SSmeltEquipmentProto = protobuf.Message(C2SSMELTEQUIPMENTPROTO)
C2SUpgradeEquipmentAllProto = protobuf.Message(C2SUPGRADEEQUIPMENTALLPROTO)
C2SUpgradeEquipmentProto = protobuf.Message(C2SUPGRADEEQUIPMENTPROTO)
C2SWearEquipmentProto = protobuf.Message(C2SWEAREQUIPMENTPROTO)
S2CAddEquipmentProto = protobuf.Message(S2CADDEQUIPMENTPROTO)
S2CAddEquipmentWithExpireTimeProto = protobuf.Message(S2CADDEQUIPMENTWITHEXPIRETIMEPROTO)
S2COpenEquipCombineProto = protobuf.Message(S2COPENEQUIPCOMBINEPROTO)
S2CRebuildEquipmentProto = protobuf.Message(S2CREBUILDEQUIPMENTPROTO)
S2CRefinedEquipmentProto = protobuf.Message(S2CREFINEDEQUIPMENTPROTO)
S2CSmeltEquipmentProto = protobuf.Message(S2CSMELTEQUIPMENTPROTO)
S2CUpdateEquipmentProto = protobuf.Message(S2CUPDATEEQUIPMENTPROTO)
S2CUpdateMultiEquipmentProto = protobuf.Message(S2CUPDATEMULTIEQUIPMENTPROTO)
S2CUpgradeEquipmentAllProto = protobuf.Message(S2CUPGRADEEQUIPMENTALLPROTO)
S2CUpgradeEquipmentProto = protobuf.Message(S2CUPGRADEEQUIPMENTPROTO)
S2CWearEquipmentProto = protobuf.Message(S2CWEAREQUIPMENTPROTO)

