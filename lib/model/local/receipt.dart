import 'package:get_receipt/model/local/items.dart';

import '../main_data.dart';

final String tableReceipts = 'receipts';

class ReceiptFields {
  static final List<String> values = [
    id, userPhoneNo, senderName, senderContactNo, senderTinNo, senderAddress,
    billNo, operatorName, paymentMode, store, total, scAmt, tax, grandTotal,
    barCode, isNew, status, lotteryFee, buyerTinNo, time,

    // NEW FIELDS
    irn, itemType, withholdAmt, type, qr, discount, buyerName,
    invoiceLable, salesType, systemNumber, senderVatNo, senderCity,
    amountInWords, documentNo, referenceIrn, invoiceLableAmharic,
    receiptLable, qrReceipt, receiptPayment
  ];

  static const String id = '_id';
  static const String userPhoneNo = 'userPhoneNo';
  static const String senderName = 'senderName';
  static const String senderContactNo = 'senderContactNo';
  static const String senderTinNo = 'senderTinNo';
  static const String senderAddress = 'senderAddress';
  static const String billNo = 'billNo';
  static const String operatorName = 'operatorName';
  static const String paymentMode = 'paymentMode';
  static const String store = 'store';
  static const String total = 'total';
  static const String scAmt = 'scAmt';
  static const String tax = 'tax';
  static const String grandTotal = 'grandTotal';
  static const String barCode = 'barCode';
  static const String isNew = 'isNew';
  static const String status = 'status';
  static const String lotteryFee = 'lotteryFee';
  static const String buyerTinNo = 'buyerTinNo';
  static const String time = 'time';

  // NEW FIELDS
  static const String irn = 'irn';
  static const String itemType = 'itemType';
  static const String withholdAmt = 'withholdAmt';
  static const String type = 'type';
  static const String qr = 'qr';
  static const String discount = 'discount';
  static const String buyerName = 'buyerName';
  static const String invoiceLable = 'invoiceLable';
  static const String salesType = 'salesType';
  static const String systemNumber = 'systemNumber';
  static const String senderVatNo = 'senderVatNo';
  static const String senderCity = 'senderCity';
  static const String amountInWords = 'amountInWords';
  static const String documentNo = 'documentNo';
  static const String referenceIrn = 'referenceIrn';
  static const String invoiceLableAmharic = 'invoiceLableAmharic';
  static const String receiptLable = 'receiptLable';
  static const String qrReceipt = 'qrReceipt';
  static const String receiptPayment = 'receiptPayment';
}

class LocalReceipt {
  final int? id;
  final String userPhoneNo;
  final String senderName;
  final String senderContactNo;
  final String senderTinNo;
  final String senderAddress;
  final String billNo;
  final String? operatorName;
  final String paymentMode;
  final String? store;
  final double total;
  final double scAmt;
  final double tax;
  final double grandTotal;
  final String? barCode;
  late int isNew;
  final String status;
  final double lotteryFee;
  final String? buyerTinNo;
  final DateTime createdTime;

  // NEW FIELDS
  final String? irn;
  final String? itemType;
  final double? withholdAmt;
  final String? type;
  final String? qr;
  final double? discount;
  final String? buyerName;
  final String? invoiceLable;
  final String? salesType;
  final String? systemNumber;
  final String? senderVatNo;
  final String? senderCity;
  final String? amountInWords;
  final String? documentNo;
  final String? referenceIrn;
  final String? invoiceLableAmharic;
  final String? receiptLable;
  final String? qrReceipt;
  final String? receiptPayment;

  LocalReceipt({
    this.id,
    required this.userPhoneNo,
    required this.senderName,
    required this.senderContactNo,
    required this.senderTinNo,
    required this.senderAddress,
    required this.billNo,
    this.operatorName,
    required this.paymentMode,
    this.store,
    required this.total,
    required this.scAmt,
    required this.tax,
    required this.grandTotal,
    this.barCode,
    required this.isNew,
    required this.status,
    required this.lotteryFee,
    this.buyerTinNo,
    required this.createdTime,
    this.irn,
    this.itemType,
    this.withholdAmt,
    this.type,
    this.qr,
    this.discount,
    this.buyerName,
    this.invoiceLable,
    this.salesType,
    this.systemNumber,
    this.senderVatNo,
    this.senderCity,
    this.amountInWords,
    this.documentNo,
    this.referenceIrn,
    this.invoiceLableAmharic,
    this.receiptLable,
    this.qrReceipt,
    this.receiptPayment,
  });

  LocalReceipt copy({
    int? id,
    String? userPhoneNo,
    String? senderName,
    String? senderContactNo,
    String? senderTinNo,
    String? senderAddress,
    String? billNo,
    String? operatorName,
    String? paymentMode,
    String? store,
    double? total,
    double? scAmt,
    double? tax,
    double? grandTotal,
    String? barCode,
    int? isNew,
    String? status,
    double? lotteryFee,
    String? buyerTinNo,
    DateTime? createdTime,

    // NEW FIELDS
    String? irn,
    String? itemType,
    double? withholdAmt,
    String? type,
    String? qr,
    double? discount,
    String? buyerName,
    String? invoiceLable,
    String? salesType,
    String? systemNumber,
    String? senderVatNo,
    String? senderCity,
    String? amountInWords,
    String? documentNo,
    String? referenceIrn,
    String? invoiceLableAmharic,
    String? receiptLable,
    String? qrReceipt,
    String? receiptPayment,
  }) =>
      LocalReceipt(
        id: id ?? this.id,
        userPhoneNo: userPhoneNo ?? this.userPhoneNo,
        senderName: senderName ?? this.senderName,
        senderContactNo: senderContactNo ?? this.senderContactNo,
        senderTinNo: senderTinNo ?? this.senderTinNo,
        senderAddress: senderAddress ?? this.senderAddress,
        billNo: billNo ?? this.billNo,
        operatorName: operatorName ?? this.operatorName,
        paymentMode: paymentMode ?? this.paymentMode,
        store: store ?? this.store,
        total: total ?? this.total,
        scAmt: scAmt ?? this.scAmt,
        tax: tax ?? this.tax,
        grandTotal: grandTotal ?? this.grandTotal,
        barCode: barCode ?? this.barCode,
        isNew: isNew ?? this.isNew,
        status: status ?? this.status,
        lotteryFee: lotteryFee ?? this.lotteryFee,
        buyerTinNo: buyerTinNo ?? this.buyerTinNo,
        createdTime: createdTime ?? this.createdTime,

        irn: irn ?? this.irn,
        itemType: itemType ?? this.itemType,
        withholdAmt: withholdAmt ?? this.withholdAmt,
        type: type ?? this.type,
        qr: qr ?? this.qr,
        discount: discount ?? this.discount,
        buyerName: buyerName ?? this.buyerName,
        invoiceLable: invoiceLable ?? this.invoiceLable,
        salesType: salesType ?? this.salesType,
        systemNumber: systemNumber ?? this.systemNumber,
        senderVatNo: senderVatNo ?? this.senderVatNo,
        senderCity: senderCity ?? this.senderCity,
        amountInWords: amountInWords ?? this.amountInWords,
        documentNo: documentNo ?? this.documentNo,
        referenceIrn: referenceIrn ?? this.referenceIrn,
        invoiceLableAmharic: invoiceLableAmharic ?? this.invoiceLableAmharic,
        receiptLable: receiptLable ?? this.receiptLable,
        qrReceipt: qrReceipt ?? this.qrReceipt,
        receiptPayment: receiptPayment ?? this.receiptPayment,
      );

  static LocalReceipt fromJson(Map<String, Object?> json) => LocalReceipt(
    id: json[ReceiptFields.id] as int?,
    userPhoneNo: json[ReceiptFields.userPhoneNo] as String,
    senderName: json[ReceiptFields.senderName] as String,
    senderContactNo: json[ReceiptFields.senderContactNo] as String,
    senderTinNo: json[ReceiptFields.senderTinNo] as String,
    senderAddress: json[ReceiptFields.senderAddress] as String,
    billNo: json[ReceiptFields.billNo] as String,
    operatorName: json[ReceiptFields.operatorName] as String?,
    paymentMode: json[ReceiptFields.paymentMode] as String,
    store: json[ReceiptFields.store] as String?,
    total: json[ReceiptFields.total] as double,
    scAmt: json[ReceiptFields.scAmt] as double,
    tax: json[ReceiptFields.tax] as double,
    grandTotal: json[ReceiptFields.grandTotal] as double,
    barCode: json[ReceiptFields.barCode] as String?,
    isNew: json[ReceiptFields.isNew] as int,
    status: json[ReceiptFields.status] as String,
    lotteryFee: json[ReceiptFields.lotteryFee] as double,
    buyerTinNo: json[ReceiptFields.buyerTinNo] as String?,
    createdTime: DateTime.parse(json[ReceiptFields.time] as String),

    // NEW FIELDS
    irn: json[ReceiptFields.irn] as String?,
    itemType: json[ReceiptFields.itemType] as String?,
    withholdAmt: json[ReceiptFields.withholdAmt] as double?,
    type: json[ReceiptFields.type] as String?,
    qr: json[ReceiptFields.qr] as String?,
    discount: json[ReceiptFields.discount] as double?,
    buyerName: json[ReceiptFields.buyerName] as String?,
    invoiceLable: json[ReceiptFields.invoiceLable] as String?,
    salesType: json[ReceiptFields.salesType] as String?,
    systemNumber: json[ReceiptFields.systemNumber] as String?,
    senderVatNo: json[ReceiptFields.senderVatNo] as String?,
    senderCity: json[ReceiptFields.senderCity] as String?,
    amountInWords: json[ReceiptFields.amountInWords] as String?,
    documentNo: json[ReceiptFields.documentNo] as String?,
    referenceIrn: json[ReceiptFields.referenceIrn] as String?,
    invoiceLableAmharic: json[ReceiptFields.invoiceLableAmharic] as String?,
    receiptLable: json[ReceiptFields.receiptLable] as String?,
    qrReceipt: json[ReceiptFields.qrReceipt] as String?,
    receiptPayment: json[ReceiptFields.receiptPayment] as String?,
  );

  Map<String, Object?> toJson() => {
    ReceiptFields.id: id,
    ReceiptFields.userPhoneNo: userPhoneNo,
    ReceiptFields.senderName: senderName,
    ReceiptFields.senderContactNo: senderContactNo,
    ReceiptFields.senderTinNo: senderTinNo,
    ReceiptFields.senderAddress: senderAddress,
    ReceiptFields.billNo: billNo,
    ReceiptFields.operatorName: operatorName,
    ReceiptFields.paymentMode: paymentMode,
    ReceiptFields.store: store,
    ReceiptFields.total: total,
    ReceiptFields.scAmt: scAmt,
    ReceiptFields.tax: tax,
    ReceiptFields.grandTotal: grandTotal,
    ReceiptFields.barCode: barCode,
    ReceiptFields.isNew: isNew,
    ReceiptFields.status: status,
    ReceiptFields.lotteryFee: lotteryFee,
    ReceiptFields.buyerTinNo: buyerTinNo,
    ReceiptFields.time: createdTime.toIso8601String(),

    // NEW FIELDS
    ReceiptFields.irn: irn,
    ReceiptFields.itemType: itemType,
    ReceiptFields.withholdAmt: withholdAmt,
    ReceiptFields.type: type,
    ReceiptFields.qr: qr,
    ReceiptFields.discount: discount,
    ReceiptFields.buyerName: buyerName,
    ReceiptFields.invoiceLable: invoiceLable,
    ReceiptFields.salesType: salesType,
    ReceiptFields.systemNumber: systemNumber,
    ReceiptFields.senderVatNo: senderVatNo,
    ReceiptFields.senderCity: senderCity,
    ReceiptFields.amountInWords: amountInWords,
    ReceiptFields.documentNo: documentNo,
    ReceiptFields.referenceIrn: referenceIrn,
    ReceiptFields.invoiceLableAmharic: invoiceLableAmharic,
    ReceiptFields.receiptLable: receiptLable,
    ReceiptFields.qrReceipt: qrReceipt,
    ReceiptFields.receiptPayment: receiptPayment,
  };

  static Map<String, dynamic> mapAsNonSqlStructure(LocalReceipt receipt, List<LocalItems> items){

    final map = <String, dynamic>{};
    map['receipt_id']= receipt.id;
    map['user_phone_no'] = receipt.userPhoneNo;
    map['sender_name'] = receipt.senderName;
    map['sender_contact_no'] = receipt.senderContactNo;
    map['sender_tin_no'] = receipt.senderTinNo;
    map['sender_address'] = receipt.senderAddress;
    map['bill_no'] = receipt.billNo;
    map['operator_name'] = receipt.operatorName;
    map['payment_mode'] = receipt.paymentMode;
    map['store'] = receipt.store;
    map['total'] = receipt.total;
    map['Sc_Amt'] = receipt.scAmt;
    map['tax'] = receipt.tax;
    map['Grand_total'] = receipt.grandTotal;
    map['bar_code'] = receipt.barCode;
    map['note'] = "";
    map['isNew'] = receipt.isNew;
    map['Status'] = receipt.status;
    map['lottery_fee'] = receipt.lotteryFee;
    map['buyer_tin_no'] = receipt.buyerTinNo;
    map['\$createdAt'] = receipt.createdTime;

    // NEW FIELDS
    map['irn'] = receipt.irn;
    map['item_type'] = receipt.itemType;
    map['withhold_amt'] = receipt.withholdAmt;
    map['type'] = receipt.type;
    map['qr'] = receipt.qr;
    map['discount'] = receipt.discount;
    map['buyer_name'] = receipt.buyerName;
    map['invoice_lable'] = receipt.invoiceLable;
    map['sales_type'] = receipt.salesType;
    map['system_number'] = receipt.systemNumber;
    map['sender_vat_no'] = receipt.senderVatNo;
    map['sender_city'] = receipt.senderCity;
    map['amount_In_Words'] = receipt.amountInWords;
    map['document_no'] = receipt.documentNo;
    map['reference_irn'] = receipt.referenceIrn;
    map['invoice_lable_amharic'] = receipt.invoiceLableAmharic;
    map['receipt_lable'] = receipt.receiptLable;
    map['qr_receipt'] = receipt.qrReceipt;
    map['receipt_payment'] = receipt.receiptPayment;

    if (items.isNotEmpty) {
      map['items'] = items.map((v) => v.toJson()).toList();
    }

    return map;
  }
}