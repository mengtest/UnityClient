-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('tower_pb')


local localTable = {}
C2SCHALLENGEPROTO = protobuf.Descriptor()
localTable.C2SCHALLENGEPROTO_FLOOR_FIELD = protobuf.FieldDescriptor()
localTable.C2SCHALLENGEPROTO_CAPTAIN_ID_FIELD = protobuf.FieldDescriptor()
S2CCHALLENGEPROTO = protobuf.Descriptor()
localTable.S2CCHALLENGEPROTO_LINK_FIELD = protobuf.FieldDescriptor()
localTable.S2CCHALLENGEPROTO_FIRST_PASS_PRIZE_FIELD = protobuf.FieldDescriptor()
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD = protobuf.FieldDescriptor()
localTable.S2CCHALLENGEPROTO_AUTO_MAX_FLOOR_FIELD = protobuf.FieldDescriptor()
S2CFAILURECHALLENGEPROTO = protobuf.Descriptor()
localTable.S2CFAILURECHALLENGEPROTO_CHALLENGE_TIMES_FIELD = protobuf.FieldDescriptor()
localTable.S2CFAILURECHALLENGEPROTO_LINK_FIELD = protobuf.FieldDescriptor()
C2SAUTOCHALLENGEPROTO = protobuf.Descriptor()
localTable.C2SAUTOCHALLENGEPROTO_CAPTAIN_ID_FIELD = protobuf.FieldDescriptor()
S2CAUTOCHALLENGEPROTO = protobuf.Descriptor()
localTable.S2CAUTOCHALLENGEPROTO_FLOOR_FIELD = protobuf.FieldDescriptor()
localTable.S2CAUTOCHALLENGEPROTO_PRIZE_FIELD = protobuf.FieldDescriptor()
S2CCOLLECTBOXPROTO = protobuf.Descriptor()
localTable.S2CCOLLECTBOXPROTO_BOX_FLOOR_FIELD = protobuf.FieldDescriptor()
C2SLISTPASSREPLAYPROTO = protobuf.Descriptor()
localTable.C2SLISTPASSREPLAYPROTO_FLOOR_FIELD = protobuf.FieldDescriptor()
S2CLISTPASSREPLAYPROTO = protobuf.Descriptor()
localTable.S2CLISTPASSREPLAYPROTO_FLOOR_FIELD = protobuf.FieldDescriptor()
localTable.S2CLISTPASSREPLAYPROTO_DATA_FIELD = protobuf.FieldDescriptor()


localTable.C2SCHALLENGEPROTO_FLOOR_FIELD.name = "floor"
localTable.C2SCHALLENGEPROTO_FLOOR_FIELD.full_name = ".proto.C2SChallengeProto.floor"
localTable.C2SCHALLENGEPROTO_FLOOR_FIELD.number = 1
localTable.C2SCHALLENGEPROTO_FLOOR_FIELD.index = 0
localTable.C2SCHALLENGEPROTO_FLOOR_FIELD.label = 1
localTable.C2SCHALLENGEPROTO_FLOOR_FIELD.has_default_value = false
localTable.C2SCHALLENGEPROTO_FLOOR_FIELD.default_value = 0
localTable.C2SCHALLENGEPROTO_FLOOR_FIELD.type = 5
localTable.C2SCHALLENGEPROTO_FLOOR_FIELD.cpp_type = 1

localTable.C2SCHALLENGEPROTO_CAPTAIN_ID_FIELD.name = "captain_id"
localTable.C2SCHALLENGEPROTO_CAPTAIN_ID_FIELD.full_name = ".proto.C2SChallengeProto.captain_id"
localTable.C2SCHALLENGEPROTO_CAPTAIN_ID_FIELD.number = 2
localTable.C2SCHALLENGEPROTO_CAPTAIN_ID_FIELD.index = 1
localTable.C2SCHALLENGEPROTO_CAPTAIN_ID_FIELD.label = 3
localTable.C2SCHALLENGEPROTO_CAPTAIN_ID_FIELD.has_default_value = false
localTable.C2SCHALLENGEPROTO_CAPTAIN_ID_FIELD.default_value = {}
localTable.C2SCHALLENGEPROTO_CAPTAIN_ID_FIELD.type = 5
localTable.C2SCHALLENGEPROTO_CAPTAIN_ID_FIELD.cpp_type = 1

C2SCHALLENGEPROTO.name = "C2SChallengeProto"
C2SCHALLENGEPROTO.full_name = ".proto.C2SChallengeProto"
C2SCHALLENGEPROTO.nested_types = {}
C2SCHALLENGEPROTO.enum_types = {}
C2SCHALLENGEPROTO.fields = {localTable.C2SCHALLENGEPROTO_FLOOR_FIELD, localTable.C2SCHALLENGEPROTO_CAPTAIN_ID_FIELD}
C2SCHALLENGEPROTO.is_extendable = false
C2SCHALLENGEPROTO.extensions = {}
localTable.S2CCHALLENGEPROTO_LINK_FIELD.name = "link"
localTable.S2CCHALLENGEPROTO_LINK_FIELD.full_name = ".proto.S2CChallengeProto.link"
localTable.S2CCHALLENGEPROTO_LINK_FIELD.number = 3
localTable.S2CCHALLENGEPROTO_LINK_FIELD.index = 0
localTable.S2CCHALLENGEPROTO_LINK_FIELD.label = 1
localTable.S2CCHALLENGEPROTO_LINK_FIELD.has_default_value = false
localTable.S2CCHALLENGEPROTO_LINK_FIELD.default_value = ""
localTable.S2CCHALLENGEPROTO_LINK_FIELD.type = 9
localTable.S2CCHALLENGEPROTO_LINK_FIELD.cpp_type = 9

localTable.S2CCHALLENGEPROTO_FIRST_PASS_PRIZE_FIELD.name = "first_pass_prize"
localTable.S2CCHALLENGEPROTO_FIRST_PASS_PRIZE_FIELD.full_name = ".proto.S2CChallengeProto.first_pass_prize"
localTable.S2CCHALLENGEPROTO_FIRST_PASS_PRIZE_FIELD.number = 4
localTable.S2CCHALLENGEPROTO_FIRST_PASS_PRIZE_FIELD.index = 1
localTable.S2CCHALLENGEPROTO_FIRST_PASS_PRIZE_FIELD.label = 1
localTable.S2CCHALLENGEPROTO_FIRST_PASS_PRIZE_FIELD.has_default_value = false
localTable.S2CCHALLENGEPROTO_FIRST_PASS_PRIZE_FIELD.default_value = ""
localTable.S2CCHALLENGEPROTO_FIRST_PASS_PRIZE_FIELD.type = 12
localTable.S2CCHALLENGEPROTO_FIRST_PASS_PRIZE_FIELD.cpp_type = 9

localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.name = "prize"
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.full_name = ".proto.S2CChallengeProto.prize"
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.number = 5
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.index = 2
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.label = 1
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.has_default_value = false
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.default_value = ""
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.type = 12
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.cpp_type = 9

localTable.S2CCHALLENGEPROTO_AUTO_MAX_FLOOR_FIELD.name = "auto_max_floor"
localTable.S2CCHALLENGEPROTO_AUTO_MAX_FLOOR_FIELD.full_name = ".proto.S2CChallengeProto.auto_max_floor"
localTable.S2CCHALLENGEPROTO_AUTO_MAX_FLOOR_FIELD.number = 6
localTable.S2CCHALLENGEPROTO_AUTO_MAX_FLOOR_FIELD.index = 3
localTable.S2CCHALLENGEPROTO_AUTO_MAX_FLOOR_FIELD.label = 1
localTable.S2CCHALLENGEPROTO_AUTO_MAX_FLOOR_FIELD.has_default_value = false
localTable.S2CCHALLENGEPROTO_AUTO_MAX_FLOOR_FIELD.default_value = 0
localTable.S2CCHALLENGEPROTO_AUTO_MAX_FLOOR_FIELD.type = 5
localTable.S2CCHALLENGEPROTO_AUTO_MAX_FLOOR_FIELD.cpp_type = 1

S2CCHALLENGEPROTO.name = "S2CChallengeProto"
S2CCHALLENGEPROTO.full_name = ".proto.S2CChallengeProto"
S2CCHALLENGEPROTO.nested_types = {}
S2CCHALLENGEPROTO.enum_types = {}
S2CCHALLENGEPROTO.fields = {localTable.S2CCHALLENGEPROTO_LINK_FIELD, localTable.S2CCHALLENGEPROTO_FIRST_PASS_PRIZE_FIELD, localTable.S2CCHALLENGEPROTO_PRIZE_FIELD, localTable.S2CCHALLENGEPROTO_AUTO_MAX_FLOOR_FIELD}
S2CCHALLENGEPROTO.is_extendable = false
S2CCHALLENGEPROTO.extensions = {}
localTable.S2CFAILURECHALLENGEPROTO_CHALLENGE_TIMES_FIELD.name = "challenge_times"
localTable.S2CFAILURECHALLENGEPROTO_CHALLENGE_TIMES_FIELD.full_name = ".proto.S2CFailureChallengeProto.challenge_times"
localTable.S2CFAILURECHALLENGEPROTO_CHALLENGE_TIMES_FIELD.number = 1
localTable.S2CFAILURECHALLENGEPROTO_CHALLENGE_TIMES_FIELD.index = 0
localTable.S2CFAILURECHALLENGEPROTO_CHALLENGE_TIMES_FIELD.label = 1
localTable.S2CFAILURECHALLENGEPROTO_CHALLENGE_TIMES_FIELD.has_default_value = false
localTable.S2CFAILURECHALLENGEPROTO_CHALLENGE_TIMES_FIELD.default_value = 0
localTable.S2CFAILURECHALLENGEPROTO_CHALLENGE_TIMES_FIELD.type = 5
localTable.S2CFAILURECHALLENGEPROTO_CHALLENGE_TIMES_FIELD.cpp_type = 1

localTable.S2CFAILURECHALLENGEPROTO_LINK_FIELD.name = "link"
localTable.S2CFAILURECHALLENGEPROTO_LINK_FIELD.full_name = ".proto.S2CFailureChallengeProto.link"
localTable.S2CFAILURECHALLENGEPROTO_LINK_FIELD.number = 2
localTable.S2CFAILURECHALLENGEPROTO_LINK_FIELD.index = 1
localTable.S2CFAILURECHALLENGEPROTO_LINK_FIELD.label = 1
localTable.S2CFAILURECHALLENGEPROTO_LINK_FIELD.has_default_value = false
localTable.S2CFAILURECHALLENGEPROTO_LINK_FIELD.default_value = ""
localTable.S2CFAILURECHALLENGEPROTO_LINK_FIELD.type = 9
localTable.S2CFAILURECHALLENGEPROTO_LINK_FIELD.cpp_type = 9

S2CFAILURECHALLENGEPROTO.name = "S2CFailureChallengeProto"
S2CFAILURECHALLENGEPROTO.full_name = ".proto.S2CFailureChallengeProto"
S2CFAILURECHALLENGEPROTO.nested_types = {}
S2CFAILURECHALLENGEPROTO.enum_types = {}
S2CFAILURECHALLENGEPROTO.fields = {localTable.S2CFAILURECHALLENGEPROTO_CHALLENGE_TIMES_FIELD, localTable.S2CFAILURECHALLENGEPROTO_LINK_FIELD}
S2CFAILURECHALLENGEPROTO.is_extendable = false
S2CFAILURECHALLENGEPROTO.extensions = {}
localTable.C2SAUTOCHALLENGEPROTO_CAPTAIN_ID_FIELD.name = "captain_id"
localTable.C2SAUTOCHALLENGEPROTO_CAPTAIN_ID_FIELD.full_name = ".proto.C2SAutoChallengeProto.captain_id"
localTable.C2SAUTOCHALLENGEPROTO_CAPTAIN_ID_FIELD.number = 1
localTable.C2SAUTOCHALLENGEPROTO_CAPTAIN_ID_FIELD.index = 0
localTable.C2SAUTOCHALLENGEPROTO_CAPTAIN_ID_FIELD.label = 3
localTable.C2SAUTOCHALLENGEPROTO_CAPTAIN_ID_FIELD.has_default_value = false
localTable.C2SAUTOCHALLENGEPROTO_CAPTAIN_ID_FIELD.default_value = {}
localTable.C2SAUTOCHALLENGEPROTO_CAPTAIN_ID_FIELD.type = 5
localTable.C2SAUTOCHALLENGEPROTO_CAPTAIN_ID_FIELD.cpp_type = 1

C2SAUTOCHALLENGEPROTO.name = "C2SAutoChallengeProto"
C2SAUTOCHALLENGEPROTO.full_name = ".proto.C2SAutoChallengeProto"
C2SAUTOCHALLENGEPROTO.nested_types = {}
C2SAUTOCHALLENGEPROTO.enum_types = {}
C2SAUTOCHALLENGEPROTO.fields = {localTable.C2SAUTOCHALLENGEPROTO_CAPTAIN_ID_FIELD}
C2SAUTOCHALLENGEPROTO.is_extendable = false
C2SAUTOCHALLENGEPROTO.extensions = {}
localTable.S2CAUTOCHALLENGEPROTO_FLOOR_FIELD.name = "floor"
localTable.S2CAUTOCHALLENGEPROTO_FLOOR_FIELD.full_name = ".proto.S2CAutoChallengeProto.floor"
localTable.S2CAUTOCHALLENGEPROTO_FLOOR_FIELD.number = 1
localTable.S2CAUTOCHALLENGEPROTO_FLOOR_FIELD.index = 0
localTable.S2CAUTOCHALLENGEPROTO_FLOOR_FIELD.label = 1
localTable.S2CAUTOCHALLENGEPROTO_FLOOR_FIELD.has_default_value = false
localTable.S2CAUTOCHALLENGEPROTO_FLOOR_FIELD.default_value = 0
localTable.S2CAUTOCHALLENGEPROTO_FLOOR_FIELD.type = 5
localTable.S2CAUTOCHALLENGEPROTO_FLOOR_FIELD.cpp_type = 1

localTable.S2CAUTOCHALLENGEPROTO_PRIZE_FIELD.name = "prize"
localTable.S2CAUTOCHALLENGEPROTO_PRIZE_FIELD.full_name = ".proto.S2CAutoChallengeProto.prize"
localTable.S2CAUTOCHALLENGEPROTO_PRIZE_FIELD.number = 2
localTable.S2CAUTOCHALLENGEPROTO_PRIZE_FIELD.index = 1
localTable.S2CAUTOCHALLENGEPROTO_PRIZE_FIELD.label = 3
localTable.S2CAUTOCHALLENGEPROTO_PRIZE_FIELD.has_default_value = false
localTable.S2CAUTOCHALLENGEPROTO_PRIZE_FIELD.default_value = {}
localTable.S2CAUTOCHALLENGEPROTO_PRIZE_FIELD.type = 12
localTable.S2CAUTOCHALLENGEPROTO_PRIZE_FIELD.cpp_type = 9

S2CAUTOCHALLENGEPROTO.name = "S2CAutoChallengeProto"
S2CAUTOCHALLENGEPROTO.full_name = ".proto.S2CAutoChallengeProto"
S2CAUTOCHALLENGEPROTO.nested_types = {}
S2CAUTOCHALLENGEPROTO.enum_types = {}
S2CAUTOCHALLENGEPROTO.fields = {localTable.S2CAUTOCHALLENGEPROTO_FLOOR_FIELD, localTable.S2CAUTOCHALLENGEPROTO_PRIZE_FIELD}
S2CAUTOCHALLENGEPROTO.is_extendable = false
S2CAUTOCHALLENGEPROTO.extensions = {}
localTable.S2CCOLLECTBOXPROTO_BOX_FLOOR_FIELD.name = "box_floor"
localTable.S2CCOLLECTBOXPROTO_BOX_FLOOR_FIELD.full_name = ".proto.S2CCollectBoxProto.box_floor"
localTable.S2CCOLLECTBOXPROTO_BOX_FLOOR_FIELD.number = 1
localTable.S2CCOLLECTBOXPROTO_BOX_FLOOR_FIELD.index = 0
localTable.S2CCOLLECTBOXPROTO_BOX_FLOOR_FIELD.label = 1
localTable.S2CCOLLECTBOXPROTO_BOX_FLOOR_FIELD.has_default_value = false
localTable.S2CCOLLECTBOXPROTO_BOX_FLOOR_FIELD.default_value = 0
localTable.S2CCOLLECTBOXPROTO_BOX_FLOOR_FIELD.type = 5
localTable.S2CCOLLECTBOXPROTO_BOX_FLOOR_FIELD.cpp_type = 1

S2CCOLLECTBOXPROTO.name = "S2CCollectBoxProto"
S2CCOLLECTBOXPROTO.full_name = ".proto.S2CCollectBoxProto"
S2CCOLLECTBOXPROTO.nested_types = {}
S2CCOLLECTBOXPROTO.enum_types = {}
S2CCOLLECTBOXPROTO.fields = {localTable.S2CCOLLECTBOXPROTO_BOX_FLOOR_FIELD}
S2CCOLLECTBOXPROTO.is_extendable = false
S2CCOLLECTBOXPROTO.extensions = {}
localTable.C2SLISTPASSREPLAYPROTO_FLOOR_FIELD.name = "floor"
localTable.C2SLISTPASSREPLAYPROTO_FLOOR_FIELD.full_name = ".proto.C2SListPassReplayProto.floor"
localTable.C2SLISTPASSREPLAYPROTO_FLOOR_FIELD.number = 1
localTable.C2SLISTPASSREPLAYPROTO_FLOOR_FIELD.index = 0
localTable.C2SLISTPASSREPLAYPROTO_FLOOR_FIELD.label = 1
localTable.C2SLISTPASSREPLAYPROTO_FLOOR_FIELD.has_default_value = false
localTable.C2SLISTPASSREPLAYPROTO_FLOOR_FIELD.default_value = 0
localTable.C2SLISTPASSREPLAYPROTO_FLOOR_FIELD.type = 5
localTable.C2SLISTPASSREPLAYPROTO_FLOOR_FIELD.cpp_type = 1

C2SLISTPASSREPLAYPROTO.name = "C2SListPassReplayProto"
C2SLISTPASSREPLAYPROTO.full_name = ".proto.C2SListPassReplayProto"
C2SLISTPASSREPLAYPROTO.nested_types = {}
C2SLISTPASSREPLAYPROTO.enum_types = {}
C2SLISTPASSREPLAYPROTO.fields = {localTable.C2SLISTPASSREPLAYPROTO_FLOOR_FIELD}
C2SLISTPASSREPLAYPROTO.is_extendable = false
C2SLISTPASSREPLAYPROTO.extensions = {}
localTable.S2CLISTPASSREPLAYPROTO_FLOOR_FIELD.name = "floor"
localTable.S2CLISTPASSREPLAYPROTO_FLOOR_FIELD.full_name = ".proto.S2CListPassReplayProto.floor"
localTable.S2CLISTPASSREPLAYPROTO_FLOOR_FIELD.number = 1
localTable.S2CLISTPASSREPLAYPROTO_FLOOR_FIELD.index = 0
localTable.S2CLISTPASSREPLAYPROTO_FLOOR_FIELD.label = 1
localTable.S2CLISTPASSREPLAYPROTO_FLOOR_FIELD.has_default_value = false
localTable.S2CLISTPASSREPLAYPROTO_FLOOR_FIELD.default_value = 0
localTable.S2CLISTPASSREPLAYPROTO_FLOOR_FIELD.type = 5
localTable.S2CLISTPASSREPLAYPROTO_FLOOR_FIELD.cpp_type = 1

localTable.S2CLISTPASSREPLAYPROTO_DATA_FIELD.name = "data"
localTable.S2CLISTPASSREPLAYPROTO_DATA_FIELD.full_name = ".proto.S2CListPassReplayProto.data"
localTable.S2CLISTPASSREPLAYPROTO_DATA_FIELD.number = 2
localTable.S2CLISTPASSREPLAYPROTO_DATA_FIELD.index = 1
localTable.S2CLISTPASSREPLAYPROTO_DATA_FIELD.label = 1
localTable.S2CLISTPASSREPLAYPROTO_DATA_FIELD.has_default_value = false
localTable.S2CLISTPASSREPLAYPROTO_DATA_FIELD.default_value = ""
localTable.S2CLISTPASSREPLAYPROTO_DATA_FIELD.type = 12
localTable.S2CLISTPASSREPLAYPROTO_DATA_FIELD.cpp_type = 9

S2CLISTPASSREPLAYPROTO.name = "S2CListPassReplayProto"
S2CLISTPASSREPLAYPROTO.full_name = ".proto.S2CListPassReplayProto"
S2CLISTPASSREPLAYPROTO.nested_types = {}
S2CLISTPASSREPLAYPROTO.enum_types = {}
S2CLISTPASSREPLAYPROTO.fields = {localTable.S2CLISTPASSREPLAYPROTO_FLOOR_FIELD, localTable.S2CLISTPASSREPLAYPROTO_DATA_FIELD}
S2CLISTPASSREPLAYPROTO.is_extendable = false
S2CLISTPASSREPLAYPROTO.extensions = {}

C2SAutoChallengeProto = protobuf.Message(C2SAUTOCHALLENGEPROTO)
C2SChallengeProto = protobuf.Message(C2SCHALLENGEPROTO)
C2SListPassReplayProto = protobuf.Message(C2SLISTPASSREPLAYPROTO)
S2CAutoChallengeProto = protobuf.Message(S2CAUTOCHALLENGEPROTO)
S2CChallengeProto = protobuf.Message(S2CCHALLENGEPROTO)
S2CCollectBoxProto = protobuf.Message(S2CCOLLECTBOXPROTO)
S2CFailureChallengeProto = protobuf.Message(S2CFAILURECHALLENGEPROTO)
S2CListPassReplayProto = protobuf.Message(S2CLISTPASSREPLAYPROTO)

