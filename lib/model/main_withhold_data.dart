import 'dart:convert';

class MainWithholdData {
  MainWithholdData({
    int? id,
    required String morNo,
    String? irn,
    required String rrn,
    required String systemNo,
    String? senderName,
    String? senderCity,
    String? senderWereda,
    String? senderAddress,
    String? senderTin,
    String? senderVat,
    String? receiverPhoneNo,
    String? receiverName,
    String? receiverTin,
    String? receiverAddress,
    String? receiverCity,
    String? type,
    required double preTax,
    required double withholdAmt,
    String? words,
    String? casher,
    String? title,
    required String qr,
    int? isNew, //new added
    DateTime? createdAt,
  }) {
    _id = id;
    _morNo = morNo;
    _irn = irn;
    _rrn = rrn;
    _systemNo = systemNo;
    _senderName = senderName;
    _senderCity = senderCity;
    _senderWereda = senderWereda;
    _senderAddress = senderAddress;
    _senderTin = senderTin;
    _senderVat = senderVat;
    _receiverPhoneNo = receiverPhoneNo;
    _receiverName = receiverName;
    _receiverTin = receiverTin;
    _receiverAddress = receiverAddress;
    _receiverCity = receiverCity;
    _type = type;
    _preTax = preTax;
    _withholdAmt = withholdAmt;
    _words = words;
    _casher = casher;
    _title = title;
    _qr = qr;
    _isNew = isNew;
    _createdAt = createdAt;
  }

  MainWithholdData.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _morNo = json['mor_no'];
    _irn = json['irn'];
    _rrn = json['rrn'];
    _systemNo = json['system_no'];
    _senderName = json['sender_name'];
    _senderCity = json['sender_city'];
    _senderWereda = json['sender_wereda'];
    _senderAddress = json['sender_address'];
    _senderTin = json['sender_tin'];
    _senderVat = json['sender_vat'];
    _receiverPhoneNo = json['receiver_phoneno'];
    _receiverName = json['receiver_name'];
    _receiverTin = json['receiver_tin'];
    _receiverAddress = json['receiver_address'];
    _receiverCity = json['receiver_city'];
    _type = json['type'];
    _preTax = (json['pre_tax'] as num).toDouble();
    _withholdAmt = (json['withhold_amt'] as num).toDouble();
    _words = json['words'];
    _casher = json['casher'];
    _title = json['title'];
    _qr = json['qr'];
    _isNew = json['isNew'];
    _createdAt = DateTime.parse(json['\$createdAt'].toString());
  }

  int? _id;
  late String _morNo;
  String? _irn;
  late String _rrn;
  late String _systemNo;
  String? _senderName;
  String? _senderCity;
  String? _senderWereda;
  String? _senderAddress;
  String? _senderTin;
  String? _senderVat;
  String? _receiverPhoneNo;
  String? _receiverName;
  String? _receiverTin;
  String? _receiverAddress;
  String? _receiverCity;
  String? _type;
  late double _preTax;
  late double _withholdAmt;
  String? _words;
  String? _casher;
  String? _title;
  late String _qr;
  int? _isNew;
  DateTime? _createdAt;

  int? get id => _id;
  String get morNo => _morNo;
  String? get irn => _irn;
  String get rrn => _rrn;
  String get systemNo => _systemNo;
  String? get senderName => _senderName;
  String? get senderCity => _senderCity;
  String? get senderWereda => _senderWereda;
  String? get senderAddress => _senderAddress;
  String? get senderTin => _senderTin;
  String? get senderVat => _senderVat;
  String? get receiverPhoneNo => _receiverPhoneNo;
  String? get receiverName => _receiverName;
  String? get receiverTin => _receiverTin;
  String? get receiverAddress => _receiverAddress;
  String? get receiverCity => _receiverCity;
  String? get type => _type;
  double get preTax => _preTax;
  double get withholdAmt => _withholdAmt;
  String? get words => _words;
  String? get casher => _casher;
  String? get title => _title;
  String get qr => _qr;
  int? get isNew => _isNew;
  DateTime? get createdAt => _createdAt;

  MainWithholdData copy({
    int? id,
    String? morNo,
    String? irn,
    String? rrn,
    String? systemNo,
    String? senderName,
    String? senderCity,
    String? senderWereda,
    String? senderAddress,
    String? senderTin,
    String? senderVat,
    String? receiverPhoneNo,
    String? receiverName,
    String? receiverTin,
    String? receiverAddress,
    String? receiverCity,
    String? type,
    double? preTax,
    double? withholdAmt,
    String? words,
    String? casher,
    String? title,
    String? qr,
    DateTime? createdAt,
  }) =>
      MainWithholdData(
        id: id ?? _id,
        morNo: morNo ?? _morNo,
        irn: irn ?? _irn,
        rrn: rrn ?? _rrn,
        systemNo: systemNo ?? _systemNo,
        senderName: senderName ?? _senderName,
        senderCity: senderCity ?? _senderCity,
        senderWereda: senderWereda ?? _senderWereda,
        senderAddress: senderAddress ?? _senderAddress,
        senderTin: senderTin ?? _senderTin,
        senderVat: senderVat ?? _senderVat,
        receiverPhoneNo: receiverPhoneNo ?? _receiverPhoneNo,
        receiverName: receiverName ?? _receiverName,
        receiverTin: receiverTin ?? _receiverTin,
        receiverAddress: receiverAddress ?? _receiverAddress,
        receiverCity: receiverCity ?? _receiverCity,
        type: type ?? _type,
        preTax: preTax ?? _preTax,
        withholdAmt: withholdAmt ?? _withholdAmt,
        words: words ?? _words,
        casher: casher ?? _casher,
        title: title ?? _title,
        qr: qr ?? _qr,
        createdAt: createdAt ?? _createdAt,
      );

  Map<String, dynamic> toJson() => {
    'id': _id,
    'mor_no': _morNo,
    'irn': _irn,
    'rrn': _rrn,
    'system_no': _systemNo,
    'sender_name': _senderName,
    'sender_city': _senderCity,
    'sender_wereda': _senderWereda,
    'sender_address': _senderAddress,
    'sender_tin': _senderTin,
    'sender_vat': _senderVat,
    'receiver_phoneno': _receiverPhoneNo,
    'receiver_name': _receiverName,
    'receiver_tin': _receiverTin,
    'receiver_address': _receiverAddress,
    'receiver_city': _receiverCity,
    'type': _type,
    'pre_tax': _preTax,
    'withhold_amt': _withholdAmt,
    'words': _words,
    'casher': _casher,
    'title': _title,
    'qr': _qr,
    'isNew': _isNew,
    'created_at': _createdAt?.toIso8601String(),
  };
}