-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('dungeon_pb')


local localTable = {}
C2SCHALLENGEPROTO = protobuf.Descriptor()
localTable.C2SCHALLENGEPROTO_ID_FIELD = protobuf.FieldDescriptor()
localTable.C2SCHALLENGEPROTO_CAPTAIN_ID_FIELD = protobuf.FieldDescriptor()
S2CCHALLENGEPROTO = protobuf.Descriptor()
localTable.S2CCHALLENGEPROTO_ID_FIELD = protobuf.FieldDescriptor()
localTable.S2CCHALLENGEPROTO_LINK_FIELD = protobuf.FieldDescriptor()
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD = protobuf.FieldDescriptor()
localTable.S2CCHALLENGEPROTO_PASS_FIELD = protobuf.FieldDescriptor()
C2SCOLLECTCHAPTERPRIZEPROTO = protobuf.Descriptor()
localTable.C2SCOLLECTCHAPTERPRIZEPROTO_ID_FIELD = protobuf.FieldDescriptor()
S2CCOLLECTCHAPTERPRIZEPROTO = protobuf.Descriptor()
localTable.S2CCOLLECTCHAPTERPRIZEPROTO_ID_FIELD = protobuf.FieldDescriptor()
C2SAUTOCHALLENGEPROTO = protobuf.Descriptor()
localTable.C2SAUTOCHALLENGEPROTO_ID_FIELD = protobuf.FieldDescriptor()
localTable.C2SAUTOCHALLENGEPROTO_TIMES_FIELD = protobuf.FieldDescriptor()
S2CAUTOCHALLENGEPROTO = protobuf.Descriptor()
localTable.S2CAUTOCHALLENGEPROTO_ID_FIELD = protobuf.FieldDescriptor()
localTable.S2CAUTOCHALLENGEPROTO_PRIZES_FIELD = protobuf.FieldDescriptor()
localTable.S2CAUTOCHALLENGEPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD = protobuf.FieldDescriptor()
S2CCOLLECTAUTOTIMESPROTO = protobuf.Descriptor()
localTable.S2CCOLLECTAUTOTIMESPROTO_INDEX_FIELD = protobuf.FieldDescriptor()
localTable.S2CCOLLECTAUTOTIMESPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD = protobuf.FieldDescriptor()


localTable.C2SCHALLENGEPROTO_ID_FIELD.name = "id"
localTable.C2SCHALLENGEPROTO_ID_FIELD.full_name = ".proto.C2SChallengeProto.id"
localTable.C2SCHALLENGEPROTO_ID_FIELD.number = 1
localTable.C2SCHALLENGEPROTO_ID_FIELD.index = 0
localTable.C2SCHALLENGEPROTO_ID_FIELD.label = 1
localTable.C2SCHALLENGEPROTO_ID_FIELD.has_default_value = false
localTable.C2SCHALLENGEPROTO_ID_FIELD.default_value = 0
localTable.C2SCHALLENGEPROTO_ID_FIELD.type = 5
localTable.C2SCHALLENGEPROTO_ID_FIELD.cpp_type = 1

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
C2SCHALLENGEPROTO.fields = {localTable.C2SCHALLENGEPROTO_ID_FIELD, localTable.C2SCHALLENGEPROTO_CAPTAIN_ID_FIELD}
C2SCHALLENGEPROTO.is_extendable = false
C2SCHALLENGEPROTO.extensions = {}
localTable.S2CCHALLENGEPROTO_ID_FIELD.name = "id"
localTable.S2CCHALLENGEPROTO_ID_FIELD.full_name = ".proto.S2CChallengeProto.id"
localTable.S2CCHALLENGEPROTO_ID_FIELD.number = 1
localTable.S2CCHALLENGEPROTO_ID_FIELD.index = 0
localTable.S2CCHALLENGEPROTO_ID_FIELD.label = 1
localTable.S2CCHALLENGEPROTO_ID_FIELD.has_default_value = false
localTable.S2CCHALLENGEPROTO_ID_FIELD.default_value = 0
localTable.S2CCHALLENGEPROTO_ID_FIELD.type = 5
localTable.S2CCHALLENGEPROTO_ID_FIELD.cpp_type = 1

localTable.S2CCHALLENGEPROTO_LINK_FIELD.name = "link"
localTable.S2CCHALLENGEPROTO_LINK_FIELD.full_name = ".proto.S2CChallengeProto.link"
localTable.S2CCHALLENGEPROTO_LINK_FIELD.number = 2
localTable.S2CCHALLENGEPROTO_LINK_FIELD.index = 1
localTable.S2CCHALLENGEPROTO_LINK_FIELD.label = 1
localTable.S2CCHALLENGEPROTO_LINK_FIELD.has_default_value = false
localTable.S2CCHALLENGEPROTO_LINK_FIELD.default_value = ""
localTable.S2CCHALLENGEPROTO_LINK_FIELD.type = 9
localTable.S2CCHALLENGEPROTO_LINK_FIELD.cpp_type = 9

localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.name = "prize"
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.full_name = ".proto.S2CChallengeProto.prize"
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.number = 3
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.index = 2
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.label = 1
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.has_default_value = false
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.default_value = ""
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.type = 12
localTable.S2CCHALLENGEPROTO_PRIZE_FIELD.cpp_type = 9

localTable.S2CCHALLENGEPROTO_PASS_FIELD.name = "pass"
localTable.S2CCHALLENGEPROTO_PASS_FIELD.full_name = ".proto.S2CChallengeProto.pass"
localTable.S2CCHALLENGEPROTO_PASS_FIELD.number = 4
localTable.S2CCHALLENGEPROTO_PASS_FIELD.index = 3
localTable.S2CCHALLENGEPROTO_PASS_FIELD.label = 1
localTable.S2CCHALLENGEPROTO_PASS_FIELD.has_default_value = false
localTable.S2CCHALLENGEPROTO_PASS_FIELD.default_value = false
localTable.S2CCHALLENGEPROTO_PASS_FIELD.type = 8
localTable.S2CCHALLENGEPROTO_PASS_FIELD.cpp_type = 7

S2CCHALLENGEPROTO.name = "S2CChallengeProto"
S2CCHALLENGEPROTO.full_name = ".proto.S2CChallengeProto"
S2CCHALLENGEPROTO.nested_types = {}
S2CCHALLENGEPROTO.enum_types = {}
S2CCHALLENGEPROTO.fields = {localTable.S2CCHALLENGEPROTO_ID_FIELD, localTable.S2CCHALLENGEPROTO_LINK_FIELD, localTable.S2CCHALLENGEPROTO_PRIZE_FIELD, localTable.S2CCHALLENGEPROTO_PASS_FIELD}
S2CCHALLENGEPROTO.is_extendable = false
S2CCHALLENGEPROTO.extensions = {}
localTable.C2SCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.name = "id"
localTable.C2SCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.full_name = ".proto.C2SCollectChapterPrizeProto.id"
localTable.C2SCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.number = 1
localTable.C2SCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.index = 0
localTable.C2SCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.label = 1
localTable.C2SCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.has_default_value = false
localTable.C2SCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.default_value = 0
localTable.C2SCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.type = 5
localTable.C2SCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.cpp_type = 1

C2SCOLLECTCHAPTERPRIZEPROTO.name = "C2SCollectChapterPrizeProto"
C2SCOLLECTCHAPTERPRIZEPROTO.full_name = ".proto.C2SCollectChapterPrizeProto"
C2SCOLLECTCHAPTERPRIZEPROTO.nested_types = {}
C2SCOLLECTCHAPTERPRIZEPROTO.enum_types = {}
C2SCOLLECTCHAPTERPRIZEPROTO.fields = {localTable.C2SCOLLECTCHAPTERPRIZEPROTO_ID_FIELD}
C2SCOLLECTCHAPTERPRIZEPROTO.is_extendable = false
C2SCOLLECTCHAPTERPRIZEPROTO.extensions = {}
localTable.S2CCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.name = "id"
localTable.S2CCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.full_name = ".proto.S2CCollectChapterPrizeProto.id"
localTable.S2CCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.number = 1
localTable.S2CCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.index = 0
localTable.S2CCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.label = 1
localTable.S2CCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.has_default_value = false
localTable.S2CCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.default_value = 0
localTable.S2CCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.type = 5
localTable.S2CCOLLECTCHAPTERPRIZEPROTO_ID_FIELD.cpp_type = 1

S2CCOLLECTCHAPTERPRIZEPROTO.name = "S2CCollectChapterPrizeProto"
S2CCOLLECTCHAPTERPRIZEPROTO.full_name = ".proto.S2CCollectChapterPrizeProto"
S2CCOLLECTCHAPTERPRIZEPROTO.nested_types = {}
S2CCOLLECTCHAPTERPRIZEPROTO.enum_types = {}
S2CCOLLECTCHAPTERPRIZEPROTO.fields = {localTable.S2CCOLLECTCHAPTERPRIZEPROTO_ID_FIELD}
S2CCOLLECTCHAPTERPRIZEPROTO.is_extendable = false
S2CCOLLECTCHAPTERPRIZEPROTO.extensions = {}
localTable.C2SAUTOCHALLENGEPROTO_ID_FIELD.name = "id"
localTable.C2SAUTOCHALLENGEPROTO_ID_FIELD.full_name = ".proto.C2SAutoChallengeProto.id"
localTable.C2SAUTOCHALLENGEPROTO_ID_FIELD.number = 1
localTable.C2SAUTOCHALLENGEPROTO_ID_FIELD.index = 0
localTable.C2SAUTOCHALLENGEPROTO_ID_FIELD.label = 1
localTable.C2SAUTOCHALLENGEPROTO_ID_FIELD.has_default_value = false
localTable.C2SAUTOCHALLENGEPROTO_ID_FIELD.default_value = 0
localTable.C2SAUTOCHALLENGEPROTO_ID_FIELD.type = 5
localTable.C2SAUTOCHALLENGEPROTO_ID_FIELD.cpp_type = 1

localTable.C2SAUTOCHALLENGEPROTO_TIMES_FIELD.name = "times"
localTable.C2SAUTOCHALLENGEPROTO_TIMES_FIELD.full_name = ".proto.C2SAutoChallengeProto.times"
localTable.C2SAUTOCHALLENGEPROTO_TIMES_FIELD.number = 2
localTable.C2SAUTOCHALLENGEPROTO_TIMES_FIELD.index = 1
localTable.C2SAUTOCHALLENGEPROTO_TIMES_FIELD.label = 1
localTable.C2SAUTOCHALLENGEPROTO_TIMES_FIELD.has_default_value = false
localTable.C2SAUTOCHALLENGEPROTO_TIMES_FIELD.default_value = 0
localTable.C2SAUTOCHALLENGEPROTO_TIMES_FIELD.type = 5
localTable.C2SAUTOCHALLENGEPROTO_TIMES_FIELD.cpp_type = 1

C2SAUTOCHALLENGEPROTO.name = "C2SAutoChallengeProto"
C2SAUTOCHALLENGEPROTO.full_name = ".proto.C2SAutoChallengeProto"
C2SAUTOCHALLENGEPROTO.nested_types = {}
C2SAUTOCHALLENGEPROTO.enum_types = {}
C2SAUTOCHALLENGEPROTO.fields = {localTable.C2SAUTOCHALLENGEPROTO_ID_FIELD, localTable.C2SAUTOCHALLENGEPROTO_TIMES_FIELD}
C2SAUTOCHALLENGEPROTO.is_extendable = false
C2SAUTOCHALLENGEPROTO.extensions = {}
localTable.S2CAUTOCHALLENGEPROTO_ID_FIELD.name = "id"
localTable.S2CAUTOCHALLENGEPROTO_ID_FIELD.full_name = ".proto.S2CAutoChallengeProto.id"
localTable.S2CAUTOCHALLENGEPROTO_ID_FIELD.number = 1
localTable.S2CAUTOCHALLENGEPROTO_ID_FIELD.index = 0
localTable.S2CAUTOCHALLENGEPROTO_ID_FIELD.label = 1
localTable.S2CAUTOCHALLENGEPROTO_ID_FIELD.has_default_value = false
localTable.S2CAUTOCHALLENGEPROTO_ID_FIELD.default_value = 0
localTable.S2CAUTOCHALLENGEPROTO_ID_FIELD.type = 5
localTable.S2CAUTOCHALLENGEPROTO_ID_FIELD.cpp_type = 1

localTable.S2CAUTOCHALLENGEPROTO_PRIZES_FIELD.name = "prizes"
localTable.S2CAUTOCHALLENGEPROTO_PRIZES_FIELD.full_name = ".proto.S2CAutoChallengeProto.prizes"
localTable.S2CAUTOCHALLENGEPROTO_PRIZES_FIELD.number = 2
localTable.S2CAUTOCHALLENGEPROTO_PRIZES_FIELD.index = 1
localTable.S2CAUTOCHALLENGEPROTO_PRIZES_FIELD.label = 3
localTable.S2CAUTOCHALLENGEPROTO_PRIZES_FIELD.has_default_value = false
localTable.S2CAUTOCHALLENGEPROTO_PRIZES_FIELD.default_value = {}
localTable.S2CAUTOCHALLENGEPROTO_PRIZES_FIELD.type = 12
localTable.S2CAUTOCHALLENGEPROTO_PRIZES_FIELD.cpp_type = 9

localTable.S2CAUTOCHALLENGEPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.name = "new_auto_recover_start_time"
localTable.S2CAUTOCHALLENGEPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.full_name = ".proto.S2CAutoChallengeProto.new_auto_recover_start_time"
localTable.S2CAUTOCHALLENGEPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.number = 3
localTable.S2CAUTOCHALLENGEPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.index = 2
localTable.S2CAUTOCHALLENGEPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.label = 1
localTable.S2CAUTOCHALLENGEPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.has_default_value = false
localTable.S2CAUTOCHALLENGEPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.default_value = 0
localTable.S2CAUTOCHALLENGEPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.type = 5
localTable.S2CAUTOCHALLENGEPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.cpp_type = 1

S2CAUTOCHALLENGEPROTO.name = "S2CAutoChallengeProto"
S2CAUTOCHALLENGEPROTO.full_name = ".proto.S2CAutoChallengeProto"
S2CAUTOCHALLENGEPROTO.nested_types = {}
S2CAUTOCHALLENGEPROTO.enum_types = {}
S2CAUTOCHALLENGEPROTO.fields = {localTable.S2CAUTOCHALLENGEPROTO_ID_FIELD, localTable.S2CAUTOCHALLENGEPROTO_PRIZES_FIELD, localTable.S2CAUTOCHALLENGEPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD}
S2CAUTOCHALLENGEPROTO.is_extendable = false
S2CAUTOCHALLENGEPROTO.extensions = {}
localTable.S2CCOLLECTAUTOTIMESPROTO_INDEX_FIELD.name = "index"
localTable.S2CCOLLECTAUTOTIMESPROTO_INDEX_FIELD.full_name = ".proto.S2CCollectAutoTimesProto.index"
localTable.S2CCOLLECTAUTOTIMESPROTO_INDEX_FIELD.number = 1
localTable.S2CCOLLECTAUTOTIMESPROTO_INDEX_FIELD.index = 0
localTable.S2CCOLLECTAUTOTIMESPROTO_INDEX_FIELD.label = 1
localTable.S2CCOLLECTAUTOTIMESPROTO_INDEX_FIELD.has_default_value = false
localTable.S2CCOLLECTAUTOTIMESPROTO_INDEX_FIELD.default_value = 0
localTable.S2CCOLLECTAUTOTIMESPROTO_INDEX_FIELD.type = 5
localTable.S2CCOLLECTAUTOTIMESPROTO_INDEX_FIELD.cpp_type = 1

localTable.S2CCOLLECTAUTOTIMESPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.name = "new_auto_recover_start_time"
localTable.S2CCOLLECTAUTOTIMESPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.full_name = ".proto.S2CCollectAutoTimesProto.new_auto_recover_start_time"
localTable.S2CCOLLECTAUTOTIMESPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.number = 2
localTable.S2CCOLLECTAUTOTIMESPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.index = 1
localTable.S2CCOLLECTAUTOTIMESPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.label = 1
localTable.S2CCOLLECTAUTOTIMESPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.has_default_value = false
localTable.S2CCOLLECTAUTOTIMESPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.default_value = 0
localTable.S2CCOLLECTAUTOTIMESPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.type = 5
localTable.S2CCOLLECTAUTOTIMESPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD.cpp_type = 1

S2CCOLLECTAUTOTIMESPROTO.name = "S2CCollectAutoTimesProto"
S2CCOLLECTAUTOTIMESPROTO.full_name = ".proto.S2CCollectAutoTimesProto"
S2CCOLLECTAUTOTIMESPROTO.nested_types = {}
S2CCOLLECTAUTOTIMESPROTO.enum_types = {}
S2CCOLLECTAUTOTIMESPROTO.fields = {localTable.S2CCOLLECTAUTOTIMESPROTO_INDEX_FIELD, localTable.S2CCOLLECTAUTOTIMESPROTO_NEW_AUTO_RECOVER_START_TIME_FIELD}
S2CCOLLECTAUTOTIMESPROTO.is_extendable = false
S2CCOLLECTAUTOTIMESPROTO.extensions = {}

C2SAutoChallengeProto = protobuf.Message(C2SAUTOCHALLENGEPROTO)
C2SChallengeProto = protobuf.Message(C2SCHALLENGEPROTO)
C2SCollectChapterPrizeProto = protobuf.Message(C2SCOLLECTCHAPTERPRIZEPROTO)
S2CAutoChallengeProto = protobuf.Message(S2CAUTOCHALLENGEPROTO)
S2CChallengeProto = protobuf.Message(S2CCHALLENGEPROTO)
S2CCollectAutoTimesProto = protobuf.Message(S2CCOLLECTAUTOTIMESPROTO)
S2CCollectChapterPrizeProto = protobuf.Message(S2CCOLLECTCHAPTERPRIZEPROTO)
