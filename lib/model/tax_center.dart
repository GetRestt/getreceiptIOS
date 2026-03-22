/// Info : [{"region":"","address":"","code":"","name":""},{"region":"","address":"","code":"","name":""}]

class Tax_center {
  Tax_center({
      List<Info>? info,}){
    _info = info;
}

  Tax_center.fromJson(dynamic json) {
      if (json != null) {
        _info = [];
        json.forEach((v) {
          _info?.add(Info.fromJson(v));
        });
      }
  }
  List<Info>? _info;

  List<Info>? get info => _info;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_info != null) {
      map['Info'] = _info?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// region : ""
/// address : ""
/// code : ""
/// name : ""

class Info {
  Info({
      String? region, 
      String? address, 
      String? code, 
      String? name,}){
    _region = region;
    _address = address;
    _code = code;
    _name = name;
}

  Info.fromJson(dynamic json) {
    _region = json['region'];
    _address = json['address'];
    _code = json['code'];
    _name = json['name'];
  }
  String? _region;
  String? _address;
  String? _code;
  String? _name;

  String? get region => _region;
  String? get address => _address;
  String? get code => _code;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['region'] = _region;
    map['address'] = _address;
    map['code'] = _code;
    map['name'] = _name;
    return map;
  }

}