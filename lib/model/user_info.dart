/// id : "tyktk545343d4546d"
/// company_name : "josr"
/// first_name : "selam"
/// last_name : "kese"
/// phone_no : "09343304343"
/// tin_no : "090945945009"
/// vat_no : "434343434343"

class UserInfoMine {
  UserInfoMine({
      String? companyName, 
      String? firstName, 
      String? lastName, 
      String? taxCenter,
      String? phoneNo,
      String? address,
      String? uid,
      String? tinNo,
      String? vatNo,
      String? fcm,}){
    _companyName = companyName;
    _firstName = firstName;
    _lastName = lastName;
    _taxCenter = taxCenter;
    _phoneNo = phoneNo;
    _uid = uid;
    _tinNo = tinNo;
    _vatNo = vatNo;
    _fcm = fcm;
}

  UserInfoMine.fromJson(dynamic json) {
    _companyName = json['company_name'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _taxCenter = json['tax_center'];
    _phoneNo = json['phone_no'];
    _uid = json['uid'];
    _tinNo = json['tin_no'];
    _vatNo = json['vat_no'];
    _fcm = json['fcm'];

  }
  String? _companyName;
  String? _firstName;
  String? _lastName;
  String? _taxCenter;
  String? _phoneNo;
  String? _uid;
  String? _tinNo;
  String? _vatNo;
  String? _fcm;

  String? get companyName => _companyName;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get taxCenter => _taxCenter;
  String? get phoneNo => _phoneNo;
  String? get uid => _uid;
  String? get tinNo => _tinNo;
  String? get vatNo => _vatNo;
  String? get fcm => _fcm;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['company_name'] = _companyName;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['tax_center'] = _taxCenter;
    map['phone_no'] = _phoneNo;
    map['uid'] = _uid;
    map['tin_no'] = _tinNo;
    map['vat_no'] = _vatNo;
    map['fcm'] = _fcm;
    return map;
  }

}