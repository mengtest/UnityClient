-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('fishing_pb')


local localTable = {}
C2SFISHINGPROTO = protobuf.Descriptor()
localTable.C2SFISHINGPROTO_TIMES_FIELD = protobuf.FieldDescriptor()
S2CFISHINGPROTO = protobuf.Descriptor()
localTable.S2CFISHINGPROTO_FISHING_RESULT_FIELD = protobuf.FieldDescriptor()
localTable.S2CFISHINGPROTO_HAVE_SOUL_TO_GOODS_FIELD = protobuf.FieldDescriptor()
S2CFISHINGBROADCASTPROTO = protobuf.Descriptor()
localTable.S2CFISHINGBROADCASTPROTO_ID_FIELD = protobuf.FieldDescriptor()
localTable.S2CFISHINGBROADCASTPROTO_NAME_FIELD = protobuf.FieldDescriptor()
localTable.S2CFISHINGBROADCASTPROTO_FLAGNAME_FIELD = protobuf.FieldDescriptor()
localTable.S2CFISHINGBROADCASTPROTO_CONTENT_FIELD = protobuf.FieldDescriptor()


localTable.C2SFISHINGPROTO_TIMES_FIELD.name = "times"
localTable.C2SFISHINGPROTO_TIMES_FIELD.full_name = ".proto.C2SFishingProto.times"
localTable.C2SFISHINGPROTO_TIMES_FIELD.number = 1
localTable.C2SFISHINGPROTO_TIMES_FIELD.index = 0
localTable.C2SFISHINGPROTO_TIMES_FIELD.label = 1
localTable.C2SFISHINGPROTO_TIMES_FIELD.has_default_value = false
localTable.C2SFISHINGPROTO_TIMES_FIELD.default_value = 0
localTable.C2SFISHINGPROTO_TIMES_FIELD.type = 5
localTable.C2SFISHINGPROTO_TIMES_FIELD.cpp_type = 1

C2SFISHINGPROTO.name = "C2SFishingProto"
C2SFISHINGPROTO.full_name = ".proto.C2SFishingProto"
C2SFISHINGPROTO.nested_types = {}
C2SFISHINGPROTO.enum_types = {}
C2SFISHINGPROTO.fields = {localTable.C2SFISHINGPROTO_TIMES_FIELD}
C2SFISHINGPROTO.is_extendable = false
C2SFISHINGPROTO.extensions = {}
localTable.S2CFISHINGPROTO_FISHING_RESULT_FIELD.name = "fishing_result"
localTable.S2CFISHINGPROTO_FISHING_RESULT_FIELD.full_name = ".proto.S2CFishingProto.fishing_result"
localTable.S2CFISHINGPROTO_FISHING_RESULT_FIELD.number = 5
localTable.S2CFISHINGPROTO_FISHING_RESULT_FIELD.index = 0
localTable.S2CFISHINGPROTO_FISHING_RESULT_FIELD.label = 3
localTable.S2CFISHINGPROTO_FISHING_RESULT_FIELD.has_default_value = false
localTable.S2CFISHINGPROTO_FISHING_RESULT_FIELD.default_value = {}
localTable.S2CFISHINGPROTO_FISHING_RESULT_FIELD.type = 12
localTable.S2CFISHINGPROTO_FISHING_RESULT_FIELD.cpp_type = 9

localTable.S2CFISHINGPROTO_HAVE_SOUL_TO_GOODS_FIELD.name = "have_soul_to_goods"
localTable.S2CFISHINGPROTO_HAVE_SOUL_TO_GOODS_FIELD.full_name = ".proto.S2CFishingProto.have_soul_to_goods"
localTable.S2CFISHINGPROTO_HAVE_SOUL_TO_GOODS_FIELD.number = 6
localTable.S2CFISHINGPROTO_HAVE_SOUL_TO_GOODS_FIELD.index = 1
localTable.S2CFISHINGPROTO_HAVE_SOUL_TO_GOODS_FIELD.label = 3
localTable.S2CFISHINGPROTO_HAVE_SOUL_TO_GOODS_FIELD.has_default_value = false
localTable.S2CFISHINGPROTO_HAVE_SOUL_TO_GOODS_FIELD.default_value = {}
localTable.S2CFISHINGPROTO_HAVE_SOUL_TO_GOODS_FIELD.type = 8
localTable.S2CFISHINGPROTO_HAVE_SOUL_TO_GOODS_FIELD.cpp_type = 7

S2CFISHINGPROTO.name = "S2CFishingProto"
S2CFISHINGPROTO.full_name = ".proto.S2CFishingProto"
S2CFISHINGPROTO.nested_types = {}
S2CFISHINGPROTO.enum_types = {}
S2CFISHINGPROTO.fields = {localTable.S2CFISHINGPROTO_FISHING_RESULT_FIELD, localTable.S2CFISHINGPROTO_HAVE_SOUL_TO_GOODS_FIELD}
S2CFISHINGPROTO.is_extendable = false
S2CFISHINGPROTO.extensions = {}
localTable.S2CFISHINGBROADCASTPROTO_ID_FIELD.name = "id"
localTable.S2CFISHINGBROADCASTPROTO_ID_FIELD.full_name = ".proto.S2CFishingBroadcastProto.id"
localTable.S2CFISHINGBROADCASTPROTO_ID_FIELD.number = 1
localTable.S2CFISHINGBROADCASTPROTO_ID_FIELD.index = 0
localTable.S2CFISHINGBROADCASTPROTO_ID_FIELD.label = 1
localTable.S2CFISHINGBROADCASTPROTO_ID_FIELD.has_default_value = false
localTable.S2CFISHINGBROADCASTPROTO_ID_FIELD.default_value = ""
localTable.S2CFISHINGBROADCASTPROTO_ID_FIELD.type = 9
localTable.S2CFISHINGBROADCASTPROTO_ID_FIELD.cpp_type = 9

localTable.S2CFISHINGBROADCASTPROTO_NAME_FIELD.name = "name"
localTable.S2CFISHINGBROADCASTPROTO_NAME_FIELD.full_name = ".proto.S2CFishingBroadcastProto.name"
localTable.S2CFISHINGBROADCASTPROTO_NAME_FIELD.number = 2
localTable.S2CFISHINGBROADCASTPROTO_NAME_FIELD.index = 1
localTable.S2CFISHINGBROADCASTPROTO_NAME_FIELD.label = 1
localTable.S2CFISHINGBROADCASTPROTO_NAME_FIELD.has_default_value = false
localTable.S2CFISHINGBROADCASTPROTO_NAME_FIELD.default_value = ""
localTable.S2CFISHINGBROADCASTPROTO_NAME_FIELD.type = 9
localTable.S2CFISHINGBROADCASTPROTO_NAME_FIELD.cpp_type = 9

localTable.S2CFISHINGBROADCASTPROTO_FLAGNAME_FIELD.name = "flagname"
localTable.S2CFISHINGBROADCASTPROTO_FLAGNAME_FIELD.full_name = ".proto.S2CFishingBroadcastProto.flagname"
localTable.S2CFISHINGBROADCASTPROTO_FLAGNAME_FIELD.number = 3
localTable.S2CFISHINGBROADCASTPROTO_FLAGNAME_FIELD.index = 2
localTable.S2CFISHINGBROADCASTPROTO_FLAGNAME_FIELD.label = 1
localTable.S2CFISHINGBROADCASTPROTO_FLAGNAME_FIELD.has_default_value = false
localTable.S2CFISHINGBROADCASTPROTO_FLAGNAME_FIELD.default_value = ""
localTable.S2CFISHINGBROADCASTPROTO_FLAGNAME_FIELD.type = 9
localTable.S2CFISHINGBROADCASTPROTO_FLAGNAME_FIELD.cpp_type = 9

localTable.S2CFISHINGBROADCASTPROTO_CONTENT_FIELD.name = "content"
localTable.S2CFISHINGBROADCASTPROTO_CONTENT_FIELD.full_name = ".proto.S2CFishingBroadcastProto.content"
localTable.S2CFISHINGBROADCASTPROTO_CONTENT_FIELD.number = 5
localTable.S2CFISHINGBROADCASTPROTO_CONTENT_FIELD.index = 3
localTable.S2CFISHINGBROADCASTPROTO_CONTENT_FIELD.label = 1
localTable.S2CFISHINGBROADCASTPROTO_CONTENT_FIELD.has_default_value = false
localTable.S2CFISHINGBROADCASTPROTO_CONTENT_FIELD.default_value = ""
localTable.S2CFISHINGBROADCASTPROTO_CONTENT_FIELD.type = 9
localTable.S2CFISHINGBROADCASTPROTO_CONTENT_FIELD.cpp_type = 9

S2CFISHINGBROADCASTPROTO.name = "S2CFishingBroadcastProto"
S2CFISHINGBROADCASTPROTO.full_name = ".proto.S2CFishingBroadcastProto"
S2CFISHINGBROADCASTPROTO.nested_types = {}
S2CFISHINGBROADCASTPROTO.enum_types = {}
S2CFISHINGBROADCASTPROTO.fields = {localTable.S2CFISHINGBROADCASTPROTO_ID_FIELD, localTable.S2CFISHINGBROADCASTPROTO_NAME_FIELD, localTable.S2CFISHINGBROADCASTPROTO_FLAGNAME_FIELD, localTable.S2CFISHINGBROADCASTPROTO_CONTENT_FIELD}
S2CFISHINGBROADCASTPROTO.is_extendable = false
S2CFISHINGBROADCASTPROTO.extensions = {}

C2SFishingProto = protobuf.Message(C2SFISHINGPROTO)
S2CFishingBroadcastProto = protobuf.Message(S2CFISHINGBROADCASTPROTO)
S2CFishingProto = protobuf.Message(S2CFISHINGPROTO)
