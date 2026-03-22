/// sender_name : "ab guest house"
/// sender_address : "Adama, Postoffice"
/// count : 12

class ClientModel {
  ClientModel({
      String? senderName, 
      String? senderAddress, 
      int? count,}){
    _senderName = senderName;
    _senderAddress = senderAddress;
    _count = count;
}

  ClientModel.fromJson(dynamic json) {
    _senderName = json['sender_name'];
    _senderAddress = json['sender_address'];
    _count = json['count'];
  }
  String? _senderName;
  String? _senderAddress;
  int? _count;

  String? get senderName => _senderName;
  String? get senderAddress => _senderAddress;
  int? get count => _count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sender_name'] = _senderName;
    map['sender_address'] = _senderAddress;
    map['count'] = _count;
    return map;
  }

}