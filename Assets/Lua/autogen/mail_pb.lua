-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('mail_pb')


local localTable = {}
C2SLISTMAILPROTO = protobuf.Descriptor()
localTable.C2SLISTMAILPROTO_READ_FIELD = protobuf.FieldDescriptor()
localTable.C2SLISTMAILPROTO_KEEP_FIELD = protobuf.FieldDescriptor()
localTable.C2SLISTMAILPROTO_REPORT_FIELD = protobuf.FieldDescriptor()
localTable.C2SLISTMAILPROTO_HAS_PRIZE_FIELD = protobuf.FieldDescriptor()
localTable.C2SLISTMAILPROTO_COLLECTED_FIELD = protobuf.FieldDescriptor()
localTable.C2SLISTMAILPROTO_MIN_ID_FIELD = protobuf.FieldDescriptor()
localTable.C2SLISTMAILPROTO_COUNT_FIELD = protobuf.FieldDescriptor()
S2CLISTMAILPROTO = protobuf.Descriptor()
localTable.S2CLISTMAILPROTO_READ_FIELD = protobuf.FieldDescriptor()
localTable.S2CLISTMAILPROTO_KEEP_FIELD = protobuf.FieldDescriptor()
localTable.S2CLISTMAILPROTO_REPORT_FIELD = protobuf.FieldDescriptor()
localTable.S2CLISTMAILPROTO_HAS_PRIZE_FIELD = protobuf.FieldDescriptor()
localTable.S2CLISTMAILPROTO_COLLECTED_FIELD = protobuf.FieldDescriptor()
localTable.S2CLISTMAILPROTO_MAIL_FIELD = protobuf.FieldDescriptor()
S2CRECEIVEMAILPROTO = protobuf.Descriptor()
localTable.S2CRECEIVEMAILPROTO_MAIL_FIELD = protobuf.FieldDescriptor()
C2SDELETEMAILPROTO = protobuf.Descriptor()
localTable.C2SDELETEMAILPROTO_ID_FIELD = protobuf.FieldDescriptor()
S2CDELETEMAILPROTO = protobuf.Descriptor()
localTable.S2CDELETEMAILPROTO_ID_FIELD = protobuf.FieldDescriptor()
C2SKEEPMAILPROTO = protobuf.Descriptor()
localTable.C2SKEEPMAILPROTO_ID_FIELD = protobuf.FieldDescriptor()
localTable.C2SKEEPMAILPROTO_KEEP_FIELD = protobuf.FieldDescriptor()
S2CKEEPMAILPROTO = protobuf.Descriptor()
localTable.S2CKEEPMAILPROTO_ID_FIELD = protobuf.FieldDescriptor()
localTable.S2CKEEPMAILPROTO_KEEP_FIELD = protobuf.FieldDescriptor()
C2SCOLLECTMAILPRIZEPROTO = protobuf.Descriptor()
localTable.C2SCOLLECTMAILPRIZEPROTO_ID_FIELD = protobuf.FieldDescriptor()
S2CCOLLECTMAILPRIZEPROTO = protobuf.Descriptor()
localTable.S2CCOLLECTMAILPRIZEPROTO_ID_FIELD = protobuf.FieldDescriptor()
C2SREADMAILPROTO = protobuf.Descriptor()
localTable.C2SREADMAILPROTO_ID_FIELD = protobuf.FieldDescriptor()
S2CREADMAILPROTO = protobuf.Descriptor()
localTable.S2CREADMAILPROTO_ID_FIELD = protobuf.FieldDescriptor()


localTable.C2SLISTMAILPROTO_READ_FIELD.name = "read"
localTable.C2SLISTMAILPROTO_READ_FIELD.full_name = ".proto.C2SListMailProto.read"
localTable.C2SLISTMAILPROTO_READ_FIELD.number = 11
localTable.C2SLISTMAILPROTO_READ_FIELD.index = 0
localTable.C2SLISTMAILPROTO_READ_FIELD.label = 1
localTable.C2SLISTMAILPROTO_READ_FIELD.has_default_value = false
localTable.C2SLISTMAILPROTO_READ_FIELD.default_value = 0
localTable.C2SLISTMAILPROTO_READ_FIELD.type = 5
localTable.C2SLISTMAILPROTO_READ_FIELD.cpp_type = 1

localTable.C2SLISTMAILPROTO_KEEP_FIELD.name = "keep"
localTable.C2SLISTMAILPROTO_KEEP_FIELD.full_name = ".proto.C2SListMailProto.keep"
localTable.C2SLISTMAILPROTO_KEEP_FIELD.number = 8
localTable.C2SLISTMAILPROTO_KEEP_FIELD.index = 1
localTable.C2SLISTMAILPROTO_KEEP_FIELD.label = 1
localTable.C2SLISTMAILPROTO_KEEP_FIELD.has_default_value = false
localTable.C2SLISTMAILPROTO_KEEP_FIELD.default_value = 0
localTable.C2SLISTMAILPROTO_KEEP_FIELD.type = 5
localTable.C2SLISTMAILPROTO_KEEP_FIELD.cpp_type = 1

localTable.C2SLISTMAILPROTO_REPORT_FIELD.name = "report"
localTable.C2SLISTMAILPROTO_REPORT_FIELD.full_name = ".proto.C2SListMailProto.report"
localTable.C2SLISTMAILPROTO_REPORT_FIELD.number = 9
localTable.C2SLISTMAILPROTO_REPORT_FIELD.index = 2
localTable.C2SLISTMAILPROTO_REPORT_FIELD.label = 1
localTable.C2SLISTMAILPROTO_REPORT_FIELD.has_default_value = false
localTable.C2SLISTMAILPROTO_REPORT_FIELD.default_value = 0
localTable.C2SLISTMAILPROTO_REPORT_FIELD.type = 5
localTable.C2SLISTMAILPROTO_REPORT_FIELD.cpp_type = 1

localTable.C2SLISTMAILPROTO_HAS_PRIZE_FIELD.name = "has_prize"
localTable.C2SLISTMAILPROTO_HAS_PRIZE_FIELD.full_name = ".proto.C2SListMailProto.has_prize"
localTable.C2SLISTMAILPROTO_HAS_PRIZE_FIELD.number = 5
localTable.C2SLISTMAILPROTO_HAS_PRIZE_FIELD.index = 3
localTable.C2SLISTMAILPROTO_HAS_PRIZE_FIELD.label = 1
localTable.C2SLISTMAILPROTO_HAS_PRIZE_FIELD.has_default_value = false
localTable.C2SLISTMAILPROTO_HAS_PRIZE_FIELD.default_value = 0
localTable.C2SLISTMAILPROTO_HAS_PRIZE_FIELD.type = 5
localTable.C2SLISTMAILPROTO_HAS_PRIZE_FIELD.cpp_type = 1

localTable.C2SLISTMAILPROTO_COLLECTED_FIELD.name = "collected"
localTable.C2SLISTMAILPROTO_COLLECTED_FIELD.full_name = ".proto.C2SListMailProto.collected"
localTable.C2SLISTMAILPROTO_COLLECTED_FIELD.number = 10
localTable.C2SLISTMAILPROTO_COLLECTED_FIELD.index = 4
localTable.C2SLISTMAILPROTO_COLLECTED_FIELD.label = 1
localTable.C2SLISTMAILPROTO_COLLECTED_FIELD.has_default_value = false
localTable.C2SLISTMAILPROTO_COLLECTED_FIELD.default_value = 0
localTable.C2SLISTMAILPROTO_COLLECTED_FIELD.type = 5
localTable.C2SLISTMAILPROTO_COLLECTED_FIELD.cpp_type = 1

localTable.C2SLISTMAILPROTO_MIN_ID_FIELD.name = "min_id"
localTable.C2SLISTMAILPROTO_MIN_ID_FIELD.full_name = ".proto.C2SListMailProto.min_id"
localTable.C2SLISTMAILPROTO_MIN_ID_FIELD.number = 4
localTable.C2SLISTMAILPROTO_MIN_ID_FIELD.index = 5
localTable.C2SLISTMAILPROTO_MIN_ID_FIELD.label = 1
localTable.C2SLISTMAILPROTO_MIN_ID_FIELD.has_default_value = false
localTable.C2SLISTMAILPROTO_MIN_ID_FIELD.default_value = ""
localTable.C2SLISTMAILPROTO_MIN_ID_FIELD.type = 9
localTable.C2SLISTMAILPROTO_MIN_ID_FIELD.cpp_type = 9

localTable.C2SLISTMAILPROTO_COUNT_FIELD.name = "count"
localTable.C2SLISTMAILPROTO_COUNT_FIELD.full_name = ".proto.C2SListMailProto.count"
localTable.C2SLISTMAILPROTO_COUNT_FIELD.number = 7
localTable.C2SLISTMAILPROTO_COUNT_FIELD.index = 6
localTable.C2SLISTMAILPROTO_COUNT_FIELD.label = 1
localTable.C2SLISTMAILPROTO_COUNT_FIELD.has_default_value = false
localTable.C2SLISTMAILPROTO_COUNT_FIELD.default_value = 0
localTable.C2SLISTMAILPROTO_COUNT_FIELD.type = 5
localTable.C2SLISTMAILPROTO_COUNT_FIELD.cpp_type = 1

C2SLISTMAILPROTO.name = "C2SListMailProto"
C2SLISTMAILPROTO.full_name = ".proto.C2SListMailProto"
C2SLISTMAILPROTO.nested_types = {}
C2SLISTMAILPROTO.enum_types = {}
C2SLISTMAILPROTO.fields = {localTable.C2SLISTMAILPROTO_READ_FIELD, localTable.C2SLISTMAILPROTO_KEEP_FIELD, localTable.C2SLISTMAILPROTO_REPORT_FIELD, localTable.C2SLISTMAILPROTO_HAS_PRIZE_FIELD, localTable.C2SLISTMAILPROTO_COLLECTED_FIELD, localTable.C2SLISTMAILPROTO_MIN_ID_FIELD, localTable.C2SLISTMAILPROTO_COUNT_FIELD}
C2SLISTMAILPROTO.is_extendable = false
C2SLISTMAILPROTO.extensions = {}
localTable.S2CLISTMAILPROTO_READ_FIELD.name = "read"
localTable.S2CLISTMAILPROTO_READ_FIELD.full_name = ".proto.S2CListMailProto.read"
localTable.S2CLISTMAILPROTO_READ_FIELD.number = 8
localTable.S2CLISTMAILPROTO_READ_FIELD.index = 0
localTable.S2CLISTMAILPROTO_READ_FIELD.label = 1
localTable.S2CLISTMAILPROTO_READ_FIELD.has_default_value = false
localTable.S2CLISTMAILPROTO_READ_FIELD.default_value = 0
localTable.S2CLISTMAILPROTO_READ_FIELD.type = 5
localTable.S2CLISTMAILPROTO_READ_FIELD.cpp_type = 1

localTable.S2CLISTMAILPROTO_KEEP_FIELD.name = "keep"
localTable.S2CLISTMAILPROTO_KEEP_FIELD.full_name = ".proto.S2CListMailProto.keep"
localTable.S2CLISTMAILPROTO_KEEP_FIELD.number = 5
localTable.S2CLISTMAILPROTO_KEEP_FIELD.index = 1
localTable.S2CLISTMAILPROTO_KEEP_FIELD.label = 1
localTable.S2CLISTMAILPROTO_KEEP_FIELD.has_default_value = false
localTable.S2CLISTMAILPROTO_KEEP_FIELD.default_value = 0
localTable.S2CLISTMAILPROTO_KEEP_FIELD.type = 5
localTable.S2CLISTMAILPROTO_KEEP_FIELD.cpp_type = 1

localTable.S2CLISTMAILPROTO_REPORT_FIELD.name = "report"
localTable.S2CLISTMAILPROTO_REPORT_FIELD.full_name = ".proto.S2CListMailProto.report"
localTable.S2CLISTMAILPROTO_REPORT_FIELD.number = 6
localTable.S2CLISTMAILPROTO_REPORT_FIELD.index = 2
localTable.S2CLISTMAILPROTO_REPORT_FIELD.label = 1
localTable.S2CLISTMAILPROTO_REPORT_FIELD.has_default_value = false
localTable.S2CLISTMAILPROTO_REPORT_FIELD.default_value = 0
localTable.S2CLISTMAILPROTO_REPORT_FIELD.type = 5
localTable.S2CLISTMAILPROTO_REPORT_FIELD.cpp_type = 1

localTable.S2CLISTMAILPROTO_HAS_PRIZE_FIELD.name = "has_prize"
localTable.S2CLISTMAILPROTO_HAS_PRIZE_FIELD.full_name = ".proto.S2CListMailProto.has_prize"
localTable.S2CLISTMAILPROTO_HAS_PRIZE_FIELD.number = 3
localTable.S2CLISTMAILPROTO_HAS_PRIZE_FIELD.index = 3
localTable.S2CLISTMAILPROTO_HAS_PRIZE_FIELD.label = 1
localTable.S2CLISTMAILPROTO_HAS_PRIZE_FIELD.has_default_value = false
localTable.S2CLISTMAILPROTO_HAS_PRIZE_FIELD.default_value = 0
localTable.S2CLISTMAILPROTO_HAS_PRIZE_FIELD.type = 5
localTable.S2CLISTMAILPROTO_HAS_PRIZE_FIELD.cpp_type = 1

localTable.S2CLISTMAILPROTO_COLLECTED_FIELD.name = "collected"
localTable.S2CLISTMAILPROTO_COLLECTED_FIELD.full_name = ".proto.S2CListMailProto.collected"
localTable.S2CLISTMAILPROTO_COLLECTED_FIELD.number = 7
localTable.S2CLISTMAILPROTO_COLLECTED_FIELD.index = 4
localTable.S2CLISTMAILPROTO_COLLECTED_FIELD.label = 1
localTable.S2CLISTMAILPROTO_COLLECTED_FIELD.has_default_value = false
localTable.S2CLISTMAILPROTO_COLLECTED_FIELD.default_value = 0
localTable.S2CLISTMAILPROTO_COLLECTED_FIELD.type = 5
localTable.S2CLISTMAILPROTO_COLLECTED_FIELD.cpp_type = 1

localTable.S2CLISTMAILPROTO_MAIL_FIELD.name = "mail"
localTable.S2CLISTMAILPROTO_MAIL_FIELD.full_name = ".proto.S2CListMailProto.mail"
localTable.S2CLISTMAILPROTO_MAIL_FIELD.number = 1
localTable.S2CLISTMAILPROTO_MAIL_FIELD.index = 5
localTable.S2CLISTMAILPROTO_MAIL_FIELD.label = 3
localTable.S2CLISTMAILPROTO_MAIL_FIELD.has_default_value = false
localTable.S2CLISTMAILPROTO_MAIL_FIELD.default_value = {}
localTable.S2CLISTMAILPROTO_MAIL_FIELD.type = 12
localTable.S2CLISTMAILPROTO_MAIL_FIELD.cpp_type = 9

S2CLISTMAILPROTO.name = "S2CListMailProto"
S2CLISTMAILPROTO.full_name = ".proto.S2CListMailProto"
S2CLISTMAILPROTO.nested_types = {}
S2CLISTMAILPROTO.enum_types = {}
S2CLISTMAILPROTO.fields = {localTable.S2CLISTMAILPROTO_READ_FIELD, localTable.S2CLISTMAILPROTO_KEEP_FIELD, localTable.S2CLISTMAILPROTO_REPORT_FIELD, localTable.S2CLISTMAILPROTO_HAS_PRIZE_FIELD, localTable.S2CLISTMAILPROTO_COLLECTED_FIELD, localTable.S2CLISTMAILPROTO_MAIL_FIELD}
S2CLISTMAILPROTO.is_extendable = false
S2CLISTMAILPROTO.extensions = {}
localTable.S2CRECEIVEMAILPROTO_MAIL_FIELD.name = "mail"
localTable.S2CRECEIVEMAILPROTO_MAIL_FIELD.full_name = ".proto.S2CReceiveMailProto.mail"
localTable.S2CRECEIVEMAILPROTO_MAIL_FIELD.number = 1
localTable.S2CRECEIVEMAILPROTO_MAIL_FIELD.index = 0
localTable.S2CRECEIVEMAILPROTO_MAIL_FIELD.label = 1
localTable.S2CRECEIVEMAILPROTO_MAIL_FIELD.has_default_value = false
localTable.S2CRECEIVEMAILPROTO_MAIL_FIELD.default_value = ""
localTable.S2CRECEIVEMAILPROTO_MAIL_FIELD.type = 12
localTable.S2CRECEIVEMAILPROTO_MAIL_FIELD.cpp_type = 9

S2CRECEIVEMAILPROTO.name = "S2CReceiveMailProto"
S2CRECEIVEMAILPROTO.full_name = ".proto.S2CReceiveMailProto"
S2CRECEIVEMAILPROTO.nested_types = {}
S2CRECEIVEMAILPROTO.enum_types = {}
S2CRECEIVEMAILPROTO.fields = {localTable.S2CRECEIVEMAILPROTO_MAIL_FIELD}
S2CRECEIVEMAILPROTO.is_extendable = false
S2CRECEIVEMAILPROTO.extensions = {}
localTable.C2SDELETEMAILPROTO_ID_FIELD.name = "id"
localTable.C2SDELETEMAILPROTO_ID_FIELD.full_name = ".proto.C2SDeleteMailProto.id"
localTable.C2SDELETEMAILPROTO_ID_FIELD.number = 1
localTable.C2SDELETEMAILPROTO_ID_FIELD.index = 0
localTable.C2SDELETEMAILPROTO_ID_FIELD.label = 1
localTable.C2SDELETEMAILPROTO_ID_FIELD.has_default_value = false
localTable.C2SDELETEMAILPROTO_ID_FIELD.default_value = ""
localTable.C2SDELETEMAILPROTO_ID_FIELD.type = 9
localTable.C2SDELETEMAILPROTO_ID_FIELD.cpp_type = 9

C2SDELETEMAILPROTO.name = "C2SDeleteMailProto"
C2SDELETEMAILPROTO.full_name = ".proto.C2SDeleteMailProto"
C2SDELETEMAILPROTO.nested_types = {}
C2SDELETEMAILPROTO.enum_types = {}
C2SDELETEMAILPROTO.fields = {localTable.C2SDELETEMAILPROTO_ID_FIELD}
C2SDELETEMAILPROTO.is_extendable = false
C2SDELETEMAILPROTO.extensions = {}
localTable.S2CDELETEMAILPROTO_ID_FIELD.name = "id"
localTable.S2CDELETEMAILPROTO_ID_FIELD.full_name = ".proto.S2CDeleteMailProto.id"
localTable.S2CDELETEMAILPROTO_ID_FIELD.number = 1
localTable.S2CDELETEMAILPROTO_ID_FIELD.index = 0
localTable.S2CDELETEMAILPROTO_ID_FIELD.label = 1
localTable.S2CDELETEMAILPROTO_ID_FIELD.has_default_value = false
localTable.S2CDELETEMAILPROTO_ID_FIELD.default_value = ""
localTable.S2CDELETEMAILPROTO_ID_FIELD.type = 9
localTable.S2CDELETEMAILPROTO_ID_FIELD.cpp_type = 9

S2CDELETEMAILPROTO.name = "S2CDeleteMailProto"
S2CDELETEMAILPROTO.full_name = ".proto.S2CDeleteMailProto"
S2CDELETEMAILPROTO.nested_types = {}
S2CDELETEMAILPROTO.enum_types = {}
S2CDELETEMAILPROTO.fields = {localTable.S2CDELETEMAILPROTO_ID_FIELD}
S2CDELETEMAILPROTO.is_extendable = false
S2CDELETEMAILPROTO.extensions = {}
localTable.C2SKEEPMAILPROTO_ID_FIELD.name = "id"
localTable.C2SKEEPMAILPROTO_ID_FIELD.full_name = ".proto.C2SKeepMailProto.id"
localTable.C2SKEEPMAILPROTO_ID_FIELD.number = 1
localTable.C2SKEEPMAILPROTO_ID_FIELD.index = 0
localTable.C2SKEEPMAILPROTO_ID_FIELD.label = 1
localTable.C2SKEEPMAILPROTO_ID_FIELD.has_default_value = false
localTable.C2SKEEPMAILPROTO_ID_FIELD.default_value = ""
localTable.C2SKEEPMAILPROTO_ID_FIELD.type = 9
localTable.C2SKEEPMAILPROTO_ID_FIELD.cpp_type = 9

localTable.C2SKEEPMAILPROTO_KEEP_FIELD.name = "keep"
localTable.C2SKEEPMAILPROTO_KEEP_FIELD.full_name = ".proto.C2SKeepMailProto.keep"
localTable.C2SKEEPMAILPROTO_KEEP_FIELD.number = 2
localTable.C2SKEEPMAILPROTO_KEEP_FIELD.index = 1
localTable.C2SKEEPMAILPROTO_KEEP_FIELD.label = 1
localTable.C2SKEEPMAILPROTO_KEEP_FIELD.has_default_value = false
localTable.C2SKEEPMAILPROTO_KEEP_FIELD.default_value = false
localTable.C2SKEEPMAILPROTO_KEEP_FIELD.type = 8
localTable.C2SKEEPMAILPROTO_KEEP_FIELD.cpp_type = 7

C2SKEEPMAILPROTO.name = "C2SKeepMailProto"
C2SKEEPMAILPROTO.full_name = ".proto.C2SKeepMailProto"
C2SKEEPMAILPROTO.nested_types = {}
C2SKEEPMAILPROTO.enum_types = {}
C2SKEEPMAILPROTO.fields = {localTable.C2SKEEPMAILPROTO_ID_FIELD, localTable.C2SKEEPMAILPROTO_KEEP_FIELD}
C2SKEEPMAILPROTO.is_extendable = false
C2SKEEPMAILPROTO.extensions = {}
localTable.S2CKEEPMAILPROTO_ID_FIELD.name = "id"
localTable.S2CKEEPMAILPROTO_ID_FIELD.full_name = ".proto.S2CKeepMailProto.id"
localTable.S2CKEEPMAILPROTO_ID_FIELD.number = 1
localTable.S2CKEEPMAILPROTO_ID_FIELD.index = 0
localTable.S2CKEEPMAILPROTO_ID_FIELD.label = 1
localTable.S2CKEEPMAILPROTO_ID_FIELD.has_default_value = false
localTable.S2CKEEPMAILPROTO_ID_FIELD.default_value = ""
localTable.S2CKEEPMAILPROTO_ID_FIELD.type = 9
localTable.S2CKEEPMAILPROTO_ID_FIELD.cpp_type = 9

localTable.S2CKEEPMAILPROTO_KEEP_FIELD.name = "keep"
localTable.S2CKEEPMAILPROTO_KEEP_FIELD.full_name = ".proto.S2CKeepMailProto.keep"
localTable.S2CKEEPMAILPROTO_KEEP_FIELD.number = 2
localTable.S2CKEEPMAILPROTO_KEEP_FIELD.index = 1
localTable.S2CKEEPMAILPROTO_KEEP_FIELD.label = 1
localTable.S2CKEEPMAILPROTO_KEEP_FIELD.has_default_value = false
localTable.S2CKEEPMAILPROTO_KEEP_FIELD.default_value = false
localTable.S2CKEEPMAILPROTO_KEEP_FIELD.type = 8
localTable.S2CKEEPMAILPROTO_KEEP_FIELD.cpp_type = 7

S2CKEEPMAILPROTO.name = "S2CKeepMailProto"
S2CKEEPMAILPROTO.full_name = ".proto.S2CKeepMailProto"
S2CKEEPMAILPROTO.nested_types = {}
S2CKEEPMAILPROTO.enum_types = {}
S2CKEEPMAILPROTO.fields = {localTable.S2CKEEPMAILPROTO_ID_FIELD, localTable.S2CKEEPMAILPROTO_KEEP_FIELD}
S2CKEEPMAILPROTO.is_extendable = false
S2CKEEPMAILPROTO.extensions = {}
localTable.C2SCOLLECTMAILPRIZEPROTO_ID_FIELD.name = "id"
localTable.C2SCOLLECTMAILPRIZEPROTO_ID_FIELD.full_name = ".proto.C2SCollectMailPrizeProto.id"
localTable.C2SCOLLECTMAILPRIZEPROTO_ID_FIELD.number = 1
localTable.C2SCOLLECTMAILPRIZEPROTO_ID_FIELD.index = 0
localTable.C2SCOLLECTMAILPRIZEPROTO_ID_FIELD.label = 1
localTable.C2SCOLLECTMAILPRIZEPROTO_ID_FIELD.has_default_value = false
localTable.C2SCOLLECTMAILPRIZEPROTO_ID_FIELD.default_value = ""
localTable.C2SCOLLECTMAILPRIZEPROTO_ID_FIELD.type = 9
localTable.C2SCOLLECTMAILPRIZEPROTO_ID_FIELD.cpp_type = 9

C2SCOLLECTMAILPRIZEPROTO.name = "C2SCollectMailPrizeProto"
C2SCOLLECTMAILPRIZEPROTO.full_name = ".proto.C2SCollectMailPrizeProto"
C2SCOLLECTMAILPRIZEPROTO.nested_types = {}
C2SCOLLECTMAILPRIZEPROTO.enum_types = {}
C2SCOLLECTMAILPRIZEPROTO.fields = {localTable.C2SCOLLECTMAILPRIZEPROTO_ID_FIELD}
C2SCOLLECTMAILPRIZEPROTO.is_extendable = false
C2SCOLLECTMAILPRIZEPROTO.extensions = {}
localTable.S2CCOLLECTMAILPRIZEPROTO_ID_FIELD.name = "id"
localTable.S2CCOLLECTMAILPRIZEPROTO_ID_FIELD.full_name = ".proto.S2CCollectMailPrizeProto.id"
localTable.S2CCOLLECTMAILPRIZEPROTO_ID_FIELD.number = 1
localTable.S2CCOLLECTMAILPRIZEPROTO_ID_FIELD.index = 0
localTable.S2CCOLLECTMAILPRIZEPROTO_ID_FIELD.label = 1
localTable.S2CCOLLECTMAILPRIZEPROTO_ID_FIELD.has_default_value = false
localTable.S2CCOLLECTMAILPRIZEPROTO_ID_FIELD.default_value = ""
localTable.S2CCOLLECTMAILPRIZEPROTO_ID_FIELD.type = 9
localTable.S2CCOLLECTMAILPRIZEPROTO_ID_FIELD.cpp_type = 9

S2CCOLLECTMAILPRIZEPROTO.name = "S2CCollectMailPrizeProto"
S2CCOLLECTMAILPRIZEPROTO.full_name = ".proto.S2CCollectMailPrizeProto"
S2CCOLLECTMAILPRIZEPROTO.nested_types = {}
S2CCOLLECTMAILPRIZEPROTO.enum_types = {}
S2CCOLLECTMAILPRIZEPROTO.fields = {localTable.S2CCOLLECTMAILPRIZEPROTO_ID_FIELD}
S2CCOLLECTMAILPRIZEPROTO.is_extendable = false
S2CCOLLECTMAILPRIZEPROTO.extensions = {}
localTable.C2SREADMAILPROTO_ID_FIELD.name = "id"
localTable.C2SREADMAILPROTO_ID_FIELD.full_name = ".proto.C2SReadMailProto.id"
localTable.C2SREADMAILPROTO_ID_FIELD.number = 1
localTable.C2SREADMAILPROTO_ID_FIELD.index = 0
localTable.C2SREADMAILPROTO_ID_FIELD.label = 1
localTable.C2SREADMAILPROTO_ID_FIELD.has_default_value = false
localTable.C2SREADMAILPROTO_ID_FIELD.default_value = ""
localTable.C2SREADMAILPROTO_ID_FIELD.type = 9
localTable.C2SREADMAILPROTO_ID_FIELD.cpp_type = 9

C2SREADMAILPROTO.name = "C2SReadMailProto"
C2SREADMAILPROTO.full_name = ".proto.C2SReadMailProto"
C2SREADMAILPROTO.nested_types = {}
C2SREADMAILPROTO.enum_types = {}
C2SREADMAILPROTO.fields = {localTable.C2SREADMAILPROTO_ID_FIELD}
C2SREADMAILPROTO.is_extendable = false
C2SREADMAILPROTO.extensions = {}
localTable.S2CREADMAILPROTO_ID_FIELD.name = "id"
localTable.S2CREADMAILPROTO_ID_FIELD.full_name = ".proto.S2CReadMailProto.id"
localTable.S2CREADMAILPROTO_ID_FIELD.number = 1
localTable.S2CREADMAILPROTO_ID_FIELD.index = 0
localTable.S2CREADMAILPROTO_ID_FIELD.label = 1
localTable.S2CREADMAILPROTO_ID_FIELD.has_default_value = false
localTable.S2CREADMAILPROTO_ID_FIELD.default_value = ""
localTable.S2CREADMAILPROTO_ID_FIELD.type = 9
localTable.S2CREADMAILPROTO_ID_FIELD.cpp_type = 9

S2CREADMAILPROTO.name = "S2CReadMailProto"
S2CREADMAILPROTO.full_name = ".proto.S2CReadMailProto"
S2CREADMAILPROTO.nested_types = {}
S2CREADMAILPROTO.enum_types = {}
S2CREADMAILPROTO.fields = {localTable.S2CREADMAILPROTO_ID_FIELD}
S2CREADMAILPROTO.is_extendable = false
S2CREADMAILPROTO.extensions = {}

C2SCollectMailPrizeProto = protobuf.Message(C2SCOLLECTMAILPRIZEPROTO)
C2SDeleteMailProto = protobuf.Message(C2SDELETEMAILPROTO)
C2SKeepMailProto = protobuf.Message(C2SKEEPMAILPROTO)
C2SListMailProto = protobuf.Message(C2SLISTMAILPROTO)
C2SReadMailProto = protobuf.Message(C2SREADMAILPROTO)
S2CCollectMailPrizeProto = protobuf.Message(S2CCOLLECTMAILPRIZEPROTO)
S2CDeleteMailProto = protobuf.Message(S2CDELETEMAILPROTO)
S2CKeepMailProto = protobuf.Message(S2CKEEPMAILPROTO)
S2CListMailProto = protobuf.Message(S2CLISTMAILPROTO)
S2CReadMailProto = protobuf.Message(S2CREADMAILPROTO)
S2CReceiveMailProto = protobuf.Message(S2CRECEIVEMAILPROTO)
