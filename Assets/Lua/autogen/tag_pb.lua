-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('tag_pb')


local localTable = {}
C2SADDORUPDATETAGPROTO = protobuf.Descriptor()
localTable.C2SADDORUPDATETAGPROTO_ID_FIELD = protobuf.FieldDescriptor()
localTable.C2SADDORUPDATETAGPROTO_TAG_FIELD = protobuf.FieldDescriptor()
S2CADDORUPDATETAGPROTO = protobuf.Descriptor()
localTable.S2CADDORUPDATETAGPROTO_ID_FIELD = protobuf.FieldDescriptor()
localTable.S2CADDORUPDATETAGPROTO_TAG_FIELD = protobuf.FieldDescriptor()
localTable.S2CADDORUPDATETAGPROTO_COUNT_FIELD = protobuf.FieldDescriptor()
S2COTHERTAGMEPROTO = protobuf.Descriptor()
localTable.S2COTHERTAGMEPROTO_RECORD_FIELD = protobuf.FieldDescriptor()
C2SDELETETAGPROTO = protobuf.Descriptor()
localTable.C2SDELETETAGPROTO_TAG_FIELD = protobuf.FieldDescriptor()
S2CDELETETAGPROTO = protobuf.Descriptor()
localTable.S2CDELETETAGPROTO_TAG_FIELD = protobuf.FieldDescriptor()


localTable.C2SADDORUPDATETAGPROTO_ID_FIELD.name = "id"
localTable.C2SADDORUPDATETAGPROTO_ID_FIELD.full_name = ".proto.C2SAddOrUpdateTagProto.id"
localTable.C2SADDORUPDATETAGPROTO_ID_FIELD.number = 1
localTable.C2SADDORUPDATETAGPROTO_ID_FIELD.index = 0
localTable.C2SADDORUPDATETAGPROTO_ID_FIELD.label = 1
localTable.C2SADDORUPDATETAGPROTO_ID_FIELD.has_default_value = false
localTable.C2SADDORUPDATETAGPROTO_ID_FIELD.default_value = ""
localTable.C2SADDORUPDATETAGPROTO_ID_FIELD.type = 9
localTable.C2SADDORUPDATETAGPROTO_ID_FIELD.cpp_type = 9

localTable.C2SADDORUPDATETAGPROTO_TAG_FIELD.name = "tag"
localTable.C2SADDORUPDATETAGPROTO_TAG_FIELD.full_name = ".proto.C2SAddOrUpdateTagProto.tag"
localTable.C2SADDORUPDATETAGPROTO_TAG_FIELD.number = 2
localTable.C2SADDORUPDATETAGPROTO_TAG_FIELD.index = 1
localTable.C2SADDORUPDATETAGPROTO_TAG_FIELD.label = 1
localTable.C2SADDORUPDATETAGPROTO_TAG_FIELD.has_default_value = false
localTable.C2SADDORUPDATETAGPROTO_TAG_FIELD.default_value = ""
localTable.C2SADDORUPDATETAGPROTO_TAG_FIELD.type = 9
localTable.C2SADDORUPDATETAGPROTO_TAG_FIELD.cpp_type = 9

C2SADDORUPDATETAGPROTO.name = "C2SAddOrUpdateTagProto"
C2SADDORUPDATETAGPROTO.full_name = ".proto.C2SAddOrUpdateTagProto"
C2SADDORUPDATETAGPROTO.nested_types = {}
C2SADDORUPDATETAGPROTO.enum_types = {}
C2SADDORUPDATETAGPROTO.fields = {localTable.C2SADDORUPDATETAGPROTO_ID_FIELD, localTable.C2SADDORUPDATETAGPROTO_TAG_FIELD}
C2SADDORUPDATETAGPROTO.is_extendable = false
C2SADDORUPDATETAGPROTO.extensions = {}
localTable.S2CADDORUPDATETAGPROTO_ID_FIELD.name = "id"
localTable.S2CADDORUPDATETAGPROTO_ID_FIELD.full_name = ".proto.S2CAddOrUpdateTagProto.id"
localTable.S2CADDORUPDATETAGPROTO_ID_FIELD.number = 1
localTable.S2CADDORUPDATETAGPROTO_ID_FIELD.index = 0
localTable.S2CADDORUPDATETAGPROTO_ID_FIELD.label = 1
localTable.S2CADDORUPDATETAGPROTO_ID_FIELD.has_default_value = false
localTable.S2CADDORUPDATETAGPROTO_ID_FIELD.default_value = ""
localTable.S2CADDORUPDATETAGPROTO_ID_FIELD.type = 9
localTable.S2CADDORUPDATETAGPROTO_ID_FIELD.cpp_type = 9

localTable.S2CADDORUPDATETAGPROTO_TAG_FIELD.name = "tag"
localTable.S2CADDORUPDATETAGPROTO_TAG_FIELD.full_name = ".proto.S2CAddOrUpdateTagProto.tag"
localTable.S2CADDORUPDATETAGPROTO_TAG_FIELD.number = 2
localTable.S2CADDORUPDATETAGPROTO_TAG_FIELD.index = 1
localTable.S2CADDORUPDATETAGPROTO_TAG_FIELD.label = 1
localTable.S2CADDORUPDATETAGPROTO_TAG_FIELD.has_default_value = false
localTable.S2CADDORUPDATETAGPROTO_TAG_FIELD.default_value = ""
localTable.S2CADDORUPDATETAGPROTO_TAG_FIELD.type = 9
localTable.S2CADDORUPDATETAGPROTO_TAG_FIELD.cpp_type = 9

localTable.S2CADDORUPDATETAGPROTO_COUNT_FIELD.name = "count"
localTable.S2CADDORUPDATETAGPROTO_COUNT_FIELD.full_name = ".proto.S2CAddOrUpdateTagProto.count"
localTable.S2CADDORUPDATETAGPROTO_COUNT_FIELD.number = 3
localTable.S2CADDORUPDATETAGPROTO_COUNT_FIELD.index = 2
localTable.S2CADDORUPDATETAGPROTO_COUNT_FIELD.label = 1
localTable.S2CADDORUPDATETAGPROTO_COUNT_FIELD.has_default_value = false
localTable.S2CADDORUPDATETAGPROTO_COUNT_FIELD.default_value = 0
localTable.S2CADDORUPDATETAGPROTO_COUNT_FIELD.type = 5
localTable.S2CADDORUPDATETAGPROTO_COUNT_FIELD.cpp_type = 1

S2CADDORUPDATETAGPROTO.name = "S2CAddOrUpdateTagProto"
S2CADDORUPDATETAGPROTO.full_name = ".proto.S2CAddOrUpdateTagProto"
S2CADDORUPDATETAGPROTO.nested_types = {}
S2CADDORUPDATETAGPROTO.enum_types = {}
S2CADDORUPDATETAGPROTO.fields = {localTable.S2CADDORUPDATETAGPROTO_ID_FIELD, localTable.S2CADDORUPDATETAGPROTO_TAG_FIELD, localTable.S2CADDORUPDATETAGPROTO_COUNT_FIELD}
S2CADDORUPDATETAGPROTO.is_extendable = false
S2CADDORUPDATETAGPROTO.extensions = {}
localTable.S2COTHERTAGMEPROTO_RECORD_FIELD.name = "record"
localTable.S2COTHERTAGMEPROTO_RECORD_FIELD.full_name = ".proto.S2COtherTagMeProto.record"
localTable.S2COTHERTAGMEPROTO_RECORD_FIELD.number = 1
localTable.S2COTHERTAGMEPROTO_RECORD_FIELD.index = 0
localTable.S2COTHERTAGMEPROTO_RECORD_FIELD.label = 1
localTable.S2COTHERTAGMEPROTO_RECORD_FIELD.has_default_value = false
localTable.S2COTHERTAGMEPROTO_RECORD_FIELD.default_value = ""
localTable.S2COTHERTAGMEPROTO_RECORD_FIELD.type = 12
localTable.S2COTHERTAGMEPROTO_RECORD_FIELD.cpp_type = 9

S2COTHERTAGMEPROTO.name = "S2COtherTagMeProto"
S2COTHERTAGMEPROTO.full_name = ".proto.S2COtherTagMeProto"
S2COTHERTAGMEPROTO.nested_types = {}
S2COTHERTAGMEPROTO.enum_types = {}
S2COTHERTAGMEPROTO.fields = {localTable.S2COTHERTAGMEPROTO_RECORD_FIELD}
S2COTHERTAGMEPROTO.is_extendable = false
S2COTHERTAGMEPROTO.extensions = {}
localTable.C2SDELETETAGPROTO_TAG_FIELD.name = "tag"
localTable.C2SDELETETAGPROTO_TAG_FIELD.full_name = ".proto.C2SDeleteTagProto.tag"
localTable.C2SDELETETAGPROTO_TAG_FIELD.number = 1
localTable.C2SDELETETAGPROTO_TAG_FIELD.index = 0
localTable.C2SDELETETAGPROTO_TAG_FIELD.label = 1
localTable.C2SDELETETAGPROTO_TAG_FIELD.has_default_value = false
localTable.C2SDELETETAGPROTO_TAG_FIELD.default_value = ""
localTable.C2SDELETETAGPROTO_TAG_FIELD.type = 9
localTable.C2SDELETETAGPROTO_TAG_FIELD.cpp_type = 9

C2SDELETETAGPROTO.name = "C2SDeleteTagProto"
C2SDELETETAGPROTO.full_name = ".proto.C2SDeleteTagProto"
C2SDELETETAGPROTO.nested_types = {}
C2SDELETETAGPROTO.enum_types = {}
C2SDELETETAGPROTO.fields = {localTable.C2SDELETETAGPROTO_TAG_FIELD}
C2SDELETETAGPROTO.is_extendable = false
C2SDELETETAGPROTO.extensions = {}
localTable.S2CDELETETAGPROTO_TAG_FIELD.name = "tag"
localTable.S2CDELETETAGPROTO_TAG_FIELD.full_name = ".proto.S2CDeleteTagProto.tag"
localTable.S2CDELETETAGPROTO_TAG_FIELD.number = 1
localTable.S2CDELETETAGPROTO_TAG_FIELD.index = 0
localTable.S2CDELETETAGPROTO_TAG_FIELD.label = 1
localTable.S2CDELETETAGPROTO_TAG_FIELD.has_default_value = false
localTable.S2CDELETETAGPROTO_TAG_FIELD.default_value = ""
localTable.S2CDELETETAGPROTO_TAG_FIELD.type = 9
localTable.S2CDELETETAGPROTO_TAG_FIELD.cpp_type = 9

S2CDELETETAGPROTO.name = "S2CDeleteTagProto"
S2CDELETETAGPROTO.full_name = ".proto.S2CDeleteTagProto"
S2CDELETETAGPROTO.nested_types = {}
S2CDELETETAGPROTO.enum_types = {}
S2CDELETETAGPROTO.fields = {localTable.S2CDELETETAGPROTO_TAG_FIELD}
S2CDELETETAGPROTO.is_extendable = false
S2CDELETETAGPROTO.extensions = {}

C2SAddOrUpdateTagProto = protobuf.Message(C2SADDORUPDATETAGPROTO)
C2SDeleteTagProto = protobuf.Message(C2SDELETETAGPROTO)
S2CAddOrUpdateTagProto = protobuf.Message(S2CADDORUPDATETAGPROTO)
S2CDeleteTagProto = protobuf.Message(S2CDELETETAGPROTO)
S2COtherTagMeProto = protobuf.Message(S2COTHERTAGMEPROTO)

