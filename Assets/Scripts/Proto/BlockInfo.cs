//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

// Generated from: BlockInfo.proto
namespace proto
{
  [global::System.Serializable, global::ProtoBuf.ProtoContract(Name=@"BlockInfoProto")]
  public partial class BlockInfoProto : global::ProtoBuf.IExtensible
  {
    public BlockInfoProto() {}
    
    private readonly global::System.Collections.Generic.List<int> _x = new global::System.Collections.Generic.List<int>();
    [global::ProtoBuf.ProtoMember(1, Name=@"x", DataFormat = global::ProtoBuf.DataFormat.TwosComplement)]
    public global::System.Collections.Generic.List<int> x
    {
      get { return _x; }
    }
  
    private readonly global::System.Collections.Generic.List<int> _y = new global::System.Collections.Generic.List<int>();
    [global::ProtoBuf.ProtoMember(2, Name=@"y", DataFormat = global::ProtoBuf.DataFormat.TwosComplement)]
    public global::System.Collections.Generic.List<int> y
    {
      get { return _y; }
    }
  
    private readonly global::System.Collections.Generic.List<int> _type = new global::System.Collections.Generic.List<int>();
    [global::ProtoBuf.ProtoMember(3, Name=@"type", DataFormat = global::ProtoBuf.DataFormat.TwosComplement)]
    public global::System.Collections.Generic.List<int> type
    {
      get { return _type; }
    }
  
    private global::ProtoBuf.IExtension extensionObject;
    global::ProtoBuf.IExtension global::ProtoBuf.IExtensible.GetExtensionObject(bool createIfMissing)
      { return global::ProtoBuf.Extensible.GetExtensionObject(ref extensionObject, createIfMissing); }
  }
  
}