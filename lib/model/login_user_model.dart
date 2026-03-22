/// uid : ""
/// phoneNo : ""

class LoginUserModel {
  LoginUserModel({
      String? uid, 
      String? phoneNo,}){
    _uid = uid;
    _phoneNo = phoneNo;
}

  LoginUserModel.fromJson(dynamic json) {
    _uid = json['uid'];
    _phoneNo = json['phoneNo'];
  }
  String? _uid;
  String? _phoneNo;

  String? get uid => _uid;
  String? get phoneNo => _phoneNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = _uid;
    map['phoneNo'] = _phoneNo;
    return map;
  }

}