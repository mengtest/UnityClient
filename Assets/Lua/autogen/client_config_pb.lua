-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('client_config_pb')


local localTable = {}
C2SCONFIGPROTO = protobuf.Descriptor()
localTable.C2SCONFIGPROTO_PATH_FIELD = protobuf.FieldDescriptor()
S2CCONFIGPROTO = protobuf.Descriptor()
localTable.S2CCONFIGPROTO_DATA_FIELD = protobuf.FieldDescriptor()


localTable.C2SCONFIGPROTO_PATH_FIELD.name = "path"
localTable.C2SCONFIGPROTO_PATH_FIELD.full_name = ".proto.C2SConfigProto.path"
localTable.C2SCONFIGPROTO_PATH_FIELD.number = 1
localTable.C2SCONFIGPROTO_PATH_FIELD.index = 0
localTable.C2SCONFIGPROTO_PATH_FIELD.label = 1
localTable.C2SCONFIGPROTO_PATH_FIELD.has_default_value = false
localTable.C2SCONFIGPROTO_PATH_FIELD.default_value = ""
localTable.C2SCONFIGPROTO_PATH_FIELD.type = 9
localTable.C2SCONFIGPROTO_PATH_FIELD.cpp_type = 9

C2SCONFIGPROTO.name = "C2SConfigProto"
C2SCONFIGPROTO.full_name = ".proto.C2SConfigProto"
C2SCONFIGPROTO.nested_types = {}
C2SCONFIGPROTO.enum_types = {}
C2SCONFIGPROTO.fields = {localTable.C2SCONFIGPROTO_PATH_FIELD}
C2SCONFIGPROTO.is_extendable = false
C2SCONFIGPROTO.extensions = {}
localTable.S2CCONFIGPROTO_DATA_FIELD.name = "data"
localTable.S2CCONFIGPROTO_DATA_FIELD.full_name = ".proto.S2CConfigProto.data"
localTable.S2CCONFIGPROTO_DATA_FIELD.number = 1
localTable.S2CCONFIGPROTO_DATA_FIELD.index = 0
localTable.S2CCONFIGPROTO_DATA_FIELD.label = 1
localTable.S2CCONFIGPROTO_DATA_FIELD.has_default_value = false
localTable.S2CCONFIGPROTO_DATA_FIELD.default_value = ""
localTable.S2CCONFIGPROTO_DATA_FIELD.type = 12
localTable.S2CCONFIGPROTO_DATA_FIELD.cpp_type = 9

S2CCONFIGPROTO.name = "S2CConfigProto"
S2CCONFIGPROTO.full_name = ".proto.S2CConfigProto"
S2CCONFIGPROTO.nested_types = {}
S2CCONFIGPROTO.enum_types = {}
S2CCONFIGPROTO.fields = {localTable.S2CCONFIGPROTO_DATA_FIELD}
S2CCONFIGPROTO.is_extendable = false
S2CCONFIGPROTO.extensions = {}

C2SConfigProto = protobuf.Message(C2SCONFIGPROTO)
S2CConfigProto = protobuf.Message(S2CCONFIGPROTO)

