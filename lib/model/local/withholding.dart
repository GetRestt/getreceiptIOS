const String tableWithholding = 'withholding';

class WithholdingFields {
  static final List<String> values = [
    id,
    morNo,
    irn,
    rrn,
    systemNo,
    senderName,
    senderCity,
    senderWereda,
    senderAddress,
    senderTin,
    senderVat,
    receiverPhoneNo,
    receiverName,
    receiverTin,
    receiverAddress,
    receiverCity,
    type,
    preTax,
    withholdAmt,
    words,
    casher,
    title,
    qr,
    isNew,
    time
  ];

  static const String id = '_id';
  static const String morNo = 'mor_no';
  static const String irn = 'irn';
  static const String rrn = 'rrn';
  static const String systemNo = 'system_no';
  static const String senderName = 'sender_name';
  static const String senderCity = 'sender_city';
  static const String senderWereda = 'sender_wereda';
  static const String senderAddress = 'sender_address';
  static const String senderTin = 'sender_tin';
  static const String senderVat = 'sender_vat';
  static const String receiverPhoneNo = 'receiver_phoneno';
  static const String receiverName = 'receiver_name';
  static const String receiverTin = 'receiver_tin';
  static const String receiverAddress = 'receiver_address';
  static const String receiverCity = 'receiver_city';
  static const String type = 'type';
  static const String preTax = 'pre_tax';
  static const String withholdAmt = 'withhold_amt';
  static const String words = 'words';
  static const String casher = 'casher';
  static const String title = 'title';
  static const String qr = 'qr';
  static const String isNew = 'isNew';
  static const String time = 'time';
}

class LocalWithholding {
  final int? id;
  final String morNo;
  final String? irn;
  final String rrn;
  final String systemNo;
  final String? senderName;
  final String? senderCity;
  final String? senderWereda;
  final String? senderAddress;
  final String? senderTin;
  final String? senderVat;
  final String? receiverPhoneNo;
  final String? receiverName;
  final String? receiverTin;
  final String? receiverAddress;
  final String? receiverCity;
  final String type;
  final double preTax;
  final double withholdAmt;
  final String? words;
  final String casher;
  final String? title;
  final String qr;
  late int isNew;
  final DateTime createdTime;

   LocalWithholding({
    this.id,
    required this.morNo,
    this.irn,
    required this.rrn,
    required this.systemNo,
    this.senderName,
    this.senderCity,
    this.senderWereda,
    this.senderAddress,
    this.senderTin,
    this.senderVat,
    this.receiverPhoneNo,
    this.receiverName,
    this.receiverTin,
    this.receiverAddress,
    this.receiverCity,
    required this.type,
    required this.preTax,
    required this.withholdAmt,
    this.words,
    required this.casher,
    this.title,
    required this.qr,
    required this.isNew,
    required this.createdTime,
  });

  LocalWithholding copy({
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
    int? isNew,
    DateTime? createdTime,
  }) =>
      LocalWithholding(
        id: id ?? this.id,
        morNo: morNo ?? this.morNo,
        irn: irn ?? this.irn,
        rrn: rrn ?? this.rrn,
        systemNo: systemNo ?? this.systemNo,
        senderName: senderName ?? this.senderName,
        senderCity: senderCity ?? this.senderCity,
        senderWereda: senderWereda ?? this.senderWereda,
        senderAddress: senderAddress ?? this.senderAddress,
        senderTin: senderTin ?? this.senderTin,
        senderVat: senderVat ?? this.senderVat,
        receiverPhoneNo: receiverPhoneNo ?? this.receiverPhoneNo,
        receiverName: receiverName ?? this.receiverName,
        receiverTin: receiverTin ?? this.receiverTin,
        receiverAddress: receiverAddress ?? this.receiverAddress,
        receiverCity: receiverCity ?? this.receiverCity,
        type: type ?? this.type,
        preTax: preTax ?? this.preTax,
        withholdAmt: withholdAmt ?? this.withholdAmt,
        words: words ?? this.words,
        casher: casher ?? this.casher,
        title: title ?? this.title,
        qr: qr ?? this.qr,
        isNew: isNew ?? this.isNew,
        createdTime: createdTime ?? this.createdTime,
      );

  Map<String, Object?> toJson() => {
    WithholdingFields.id: id,
    WithholdingFields.morNo: morNo,
    WithholdingFields.irn: irn,
    WithholdingFields.rrn: rrn,
    WithholdingFields.systemNo: systemNo,
    WithholdingFields.senderName: senderName,
    WithholdingFields.senderCity: senderCity,
    WithholdingFields.senderWereda: senderWereda,
    WithholdingFields.senderAddress: senderAddress,
    WithholdingFields.senderTin: senderTin,
    WithholdingFields.senderVat: senderVat,
    WithholdingFields.receiverPhoneNo: receiverPhoneNo,
    WithholdingFields.receiverName: receiverName,
    WithholdingFields.receiverTin: receiverTin,
    WithholdingFields.receiverAddress: receiverAddress,
    WithholdingFields.receiverCity: receiverCity,
    WithholdingFields.type: type,
    WithholdingFields.preTax: preTax,
    WithholdingFields.withholdAmt: withholdAmt,
    WithholdingFields.words: words,
    WithholdingFields.casher: casher,
    WithholdingFields.title: title,
    WithholdingFields.qr: qr,
    WithholdingFields.isNew: isNew,
    WithholdingFields.time: createdTime.toIso8601String(),
  };

  static LocalWithholding fromJson(Map<String, Object?> json) => LocalWithholding(
    id: json[WithholdingFields.id] as int?,
    morNo: json[WithholdingFields.morNo] as String,
    irn: json[WithholdingFields.irn] as String?,
    rrn: json[WithholdingFields.rrn] as String,
    systemNo: json[WithholdingFields.systemNo] as String,
    senderName: json[WithholdingFields.senderName] as String?,
    senderCity: json[WithholdingFields.senderCity] as String?,
    senderWereda: json[WithholdingFields.senderWereda] as String?,
    senderAddress: json[WithholdingFields.senderAddress] as String?,
    senderTin: json[WithholdingFields.senderTin] as String?,
    senderVat: json[WithholdingFields.senderVat] as String?,
    receiverPhoneNo: json[WithholdingFields.receiverPhoneNo] as String?,
    receiverName: json[WithholdingFields.receiverName] as String?,
    receiverTin: json[WithholdingFields.receiverTin] as String?,
    receiverAddress: json[WithholdingFields.receiverAddress] as String?,
    receiverCity: json[WithholdingFields.receiverCity] as String?,
    type: json[WithholdingFields.type] as String,
    preTax: (json[WithholdingFields.preTax] as num).toDouble(),
    withholdAmt: (json[WithholdingFields.withholdAmt] as num).toDouble(),
    words: json[WithholdingFields.words] as String?,
    casher: json[WithholdingFields.casher] as String,
    title: json[WithholdingFields.title] as String?,
    qr: json[WithholdingFields.qr] as String,
    isNew: json[WithholdingFields.isNew] as int,
    createdTime: DateTime.parse(json[WithholdingFields.time] as String),
  );

  static Map<String, dynamic> mapAsNonSqlStructure(LocalWithholding withholding){
    final map = <String, dynamic>{};
    map['receipt_id']= withholding.id;
    map['mor_no']= withholding.morNo;
    map['irn']= withholding.irn;
    map['rrn']= withholding.rrn;
    map['system_no']= withholding.systemNo;
    map['sender_name'] = withholding.senderName;
    map['sender_city'] = withholding.senderCity;
    map['sender_wereda'] = withholding.senderWereda;
    map['sender_address'] = withholding.senderAddress;
    map['sender_tin'] = withholding.senderTin;
    map['sender_vat'] = withholding.senderVat;
    map['receiver_phoneno'] = withholding.receiverPhoneNo;
    map['receiver_name'] = withholding.receiverName;
    map['receiver_tin'] = withholding.receiverTin;
    map['receiver_address'] = withholding.receiverAddress;
    map['receiver_city'] = withholding.receiverCity;
    map['type'] = withholding.type;
    map['pre_tax'] = withholding.preTax;
    map['withhold_amt'] = withholding.withholdAmt;
    map['words'] = withholding.words;
    map['casher'] = withholding.casher;
    map['title'] = withholding.title;
    map['qr'] = withholding.qr;
    map['isNew'] = withholding.isNew;
    map['\$createdAt'] = withholding.createdTime;


    return map;
  }
}