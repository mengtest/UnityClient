-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('market_pb')


local localTable = {}
C2SBUYPROTO = protobuf.Descriptor()
localTable.C2SBUYPROTO_ID_FIELD = protobuf.FieldDescriptor()
S2CBUYPROTO = protobuf.Descriptor()
localTable.S2CBUYPROTO_ID_FIELD = protobuf.FieldDescriptor()
localTable.S2CBUYPROTO_FREE_TIMES_FIELD = protobuf.FieldDescriptor()
localTable.S2CBUYPROTO_BUY_TIMES_FIELD = protobuf.FieldDescriptor()


localTable.C2SBUYPROTO_ID_FIELD.name = "id"
localTable.C2SBUYPROTO_ID_FIELD.full_name = ".proto.C2SBuyProto.id"
localTable.C2SBUYPROTO_ID_FIELD.number = 1
localTable.C2SBUYPROTO_ID_FIELD.index = 0
localTable.C2SBUYPROTO_ID_FIELD.label = 1
localTable.C2SBUYPROTO_ID_FIELD.has_default_value = false
localTable.C2SBUYPROTO_ID_FIELD.default_value = 0
localTable.C2SBUYPROTO_ID_FIELD.type = 5
localTable.C2SBUYPROTO_ID_FIELD.cpp_type = 1

C2SBUYPROTO.name = "C2SBuyProto"
C2SBUYPROTO.full_name = ".proto.C2SBuyProto"
C2SBUYPROTO.nested_types = {}
C2SBUYPROTO.enum_types = {}
C2SBUYPROTO.fields = {localTable.C2SBUYPROTO_ID_FIELD}
C2SBUYPROTO.is_extendable = false
C2SBUYPROTO.extensions = {}
localTable.S2CBUYPROTO_ID_FIELD.name = "id"
localTable.S2CBUYPROTO_ID_FIELD.full_name = ".proto.S2CBuyProto.id"
localTable.S2CBUYPROTO_ID_FIELD.number = 1
localTable.S2CBUYPROTO_ID_FIELD.index = 0
localTable.S2CBUYPROTO_ID_FIELD.label = 1
localTable.S2CBUYPROTO_ID_FIELD.has_default_value = false
localTable.S2CBUYPROTO_ID_FIELD.default_value = 0
localTable.S2CBUYPROTO_ID_FIELD.type = 5
localTable.S2CBUYPROTO_ID_FIELD.cpp_type = 1

localTable.S2CBUYPROTO_FREE_TIMES_FIELD.name = "free_times"
localTable.S2CBUYPROTO_FREE_TIMES_FIELD.full_name = ".proto.S2CBuyProto.free_times"
localTable.S2CBUYPROTO_FREE_TIMES_FIELD.number = 2
localTable.S2CBUYPROTO_FREE_TIMES_FIELD.index = 1
localTable.S2CBUYPROTO_FREE_TIMES_FIELD.label = 1
localTable.S2CBUYPROTO_FREE_TIMES_FIELD.has_default_value = false
localTable.S2CBUYPROTO_FREE_TIMES_FIELD.default_value = 0
localTable.S2CBUYPROTO_FREE_TIMES_FIELD.type = 5
localTable.S2CBUYPROTO_FREE_TIMES_FIELD.cpp_type = 1

localTable.S2CBUYPROTO_BUY_TIMES_FIELD.name = "buy_times"
localTable.S2CBUYPROTO_BUY_TIMES_FIELD.full_name = ".proto.S2CBuyProto.buy_times"
localTable.S2CBUYPROTO_BUY_TIMES_FIELD.number = 3
localTable.S2CBUYPROTO_BUY_TIMES_FIELD.index = 2
localTable.S2CBUYPROTO_BUY_TIMES_FIELD.label = 1
localTable.S2CBUYPROTO_BUY_TIMES_FIELD.has_default_value = false
localTable.S2CBUYPROTO_BUY_TIMES_FIELD.default_value = 0
localTable.S2CBUYPROTO_BUY_TIMES_FIELD.type = 5
localTable.S2CBUYPROTO_BUY_TIMES_FIELD.cpp_type = 1

S2CBUYPROTO.name = "S2CBuyProto"
S2CBUYPROTO.full_name = ".proto.S2CBuyProto"
S2CBUYPROTO.nested_types = {}
S2CBUYPROTO.enum_types = {}
S2CBUYPROTO.fields = {localTable.S2CBUYPROTO_ID_FIELD, localTable.S2CBUYPROTO_FREE_TIMES_FIELD, localTable.S2CBUYPROTO_BUY_TIMES_FIELD}
S2CBUYPROTO.is_extendable = false
S2CBUYPROTO.extensions = {}

C2SBuyProto = protobuf.Message(C2SBUYPROTO)
S2CBuyProto = protobuf.Message(S2CBUYPROTO)
