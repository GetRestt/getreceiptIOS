
import 'dart:convert';
/// user_phone_no : "+251911342345"
/// sender_name : "Dire International Hotel"
/// sender_contact_no : "+25111345456"
/// sender_tin_no : "123231212121"
/// sender_address : "Adama, Ethiopia"
/// bill_no : "B-121223"
/// operator_name : "Josy Alemu"
/// payment_mode : "Cash"
/// store : "Main Store"
/// total : "1600.00"
/// Sc_Amt : "400.00"
/// tax : 200.00
/// Grand_total : 2200.00
/// bar_code : "123452345672"
/// note : "Daily Bill"
/// Status : "paid"
/// Date : "2021-10-24T00:00:00"
/// items : [{"name":"keywot","qty":2,"unit_price":"600","amount":"1200"},{"name":"Kikele","qty":2,"unit_price":"500","amount":"1000"}]

class MainData {
  MainData({
     int? receiptId,
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
      String? note,
      int? isNew, //new added
      String? status,
      String? buyerTinNo,
      double? lotteryFee,
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


      DateTime? date, //dateTime
      String? items,}){
    _receiptId =receiptId;
    _userPhoneNo = userPhoneNo;
    _senderName = senderName;
    _senderContactNo = senderContactNo;
    _senderTinNo = senderTinNo;
    _senderAddress = senderAddress;
    _billNo = billNo;
    _operatorName = operatorName;
    _paymentMode = paymentMode;
    _store = store;
    _total = total;
    _scAmt = scAmt;
    _tax = tax;
    _grandTotal = grandTotal;
    _barCode = barCode;
    _note = note;
    _isNew = isNew;
    _status = status;
    _buyerTinNo = buyerTinNo;
    _lotteryFee = lotteryFee;
    _irn=irn;
    _itemType=itemType;
    _withholdAmt=withholdAmt;
    _type= type;
    _qr= qr;
    _discount=discount;
    _buyerName=buyerName;
    _invoiceLable=invoiceLable;
    _salesType=salesType;
     _systemNumber=systemNumber;
     _senderVatNo=senderVatNo;
    _senderCity=senderCity;
    _amountInWords =amountInWords;
    _documentNo = documentNo;
     _referenceIrn = referenceIrn;
     _invoiceLableAmharic = invoiceLableAmharic;
     _receiptLable = receiptLable;
     _qrReceipt = qrReceipt;
     _receiptPayment= receiptPayment;
    _date = date;
    _items = json.decode(items!);
}

  MainData.fromJson(dynamic json) {
    _receiptId=json['receipt_id'];
    _userPhoneNo = json['user_phone_no'];
    _senderName = json['sender_name'];
    _senderContactNo = json['sender_contact_no'];
    _senderTinNo = json['sender_tin_no'];
    _senderAddress = json['sender_address'];
    _billNo = json['bill_no'];
    _operatorName = json['operator_name'];
    _paymentMode = json['payment_mode'];
    _store = json['store'];
    _total = json['total'].toDouble();
    _scAmt = json['Sc_Amt'] != null ? json['Sc_Amt'].toDouble() : 0.0;
    _tax = json['tax'].toDouble();
    _grandTotal = json['Grand_total'].toDouble();
    _barCode = json['bar_code'];
    _note = json['note'];
    _isNew = json['isNew'];
    _status = json['Status'];
    _buyerTinNo = json['buyer_tin_no'];
    _lotteryFee = json['lottery_fee'].toDouble();
    _irn= json['irn'];
    _itemType = json['item_type'];
    _withholdAmt = json['withhold_amt'] != null ?json['withhold_amt'].toDouble(): 0.0;
    _type = json['type'];
    _qr = json['qr'];
    _discount = json['discount'] != null ? json['discount'].toDouble(): 0.0;
    _buyerName = json['buyer_name'];
    _invoiceLable = json['invoice_lable'];
    _salesType = json['sales_type'];
    _systemNumber = json['system_number'];
    _senderVatNo = json['sender_vat_no'];
    _senderCity = json['sender_city'];
    _amountInWords = json['amount_In_Words'];
    _documentNo = json['document_no'];
    _referenceIrn = json['reference_irn'];
    _invoiceLableAmharic = json['invoice_lable_amharic'];
    _receiptLable = json['receipt_lable'];
    _qrReceipt = json['qr_receipt'];
    _receiptPayment = json['receipt_payment'];

    _date = DateTime.parse(json['\$createdAt'].toString());

    if (json['items'] != null) {
      _items = [];
      if(json['items'].runtimeType == String){
        //string
        jsonDecode(json['items']).forEach((v) {
          _items?.add(Items.fromJson(v));
        });
      }else{
        //object
        json['items'].forEach((v) {
          _items?.add(Items.fromJson(v));
        });
      }

    }
  }
  int? _receiptId;
  String? _userPhoneNo;
  String? _senderName;
  String? _senderContactNo;
  String? _senderTinNo;
  String? _senderAddress;
  String? _billNo;
  String? _operatorName;
  String? _paymentMode;
  String? _store;
  double? _total;
  double? _scAmt;
  double? _tax;
  double? _grandTotal;
  String? _barCode;
  String? _note;
  int? _isNew;
  String? _status;
  String? _buyerTinNo;
  double? _lotteryFee;
  String?_irn;
  String?_itemType;
  double?_withholdAmt;
  String?_type;
  String?_qr;
  double?_discount;
  String?_buyerName;
  String?_invoiceLable;
  String?_salesType;
  String?_systemNumber;
  String?_senderVatNo;
  String?_senderCity;
  String?_amountInWords ;
  String?_documentNo ;
  String?_referenceIrn ;
  String?_invoiceLableAmharic ;
  String?_receiptLable ;
  String?_qrReceipt;
  String?_receiptPayment;
  DateTime? _date;
  List<Items>? _items;

  int? get receiptId => _receiptId;
  String? get userPhoneNo => _userPhoneNo;
  String? get senderName => _senderName;
  String? get senderContactNo => _senderContactNo;
  String? get senderTinNo => _senderTinNo;
  String? get senderAddress => _senderAddress;
  String? get billNo => _billNo;
  String? get operatorName => _operatorName;
  String? get paymentMode => _paymentMode;
  String? get store => _store;
  double? get total => _total;
  double? get scAmt => _scAmt;
  double? get tax => _tax;
  double? get grandTotal => _grandTotal;
  String? get barCode => _barCode;
  String? get note => _note;
  int? get isNew => _isNew;
  String? get status => _status;
  String? get buyerTinNo => _buyerTinNo;
  double? get lotteryFee => _lotteryFee;

  String? get irn => _irn;
  String? get itemType => _itemType;
  double? get withholdAmt => _withholdAmt;
  String? get type => _type;
  String? get qr => _qr;
  double? get discount => _discount;
  String? get invoiceLable =>_invoiceLable;
  String? get buyerName =>_buyerName;
  String?  get salesType =>_salesType;
  String?  get systemNumber =>_systemNumber;
  String? get senderVatNo => _senderVatNo;
  String? get senderCity => _senderCity;
  String? get amountInWords =>_amountInWords ;
  String? get documentNo =>_documentNo ;
  String? get referenceIrn =>_referenceIrn ;
  String? get invoiceLableAmharic =>_invoiceLableAmharic ;
  String? get receiptLable =>_receiptLable ;
  String? get qrReceipt =>_qrReceipt;
  String? get receiptPayment =>_receiptPayment;






  DateTime? get date => _date;
  List<Items>? get items => _items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['receipt_id']= _receiptId;
    map['user_phone_no'] = _userPhoneNo;
    map['sender_name'] = _senderName;
    map['sender_contact_no'] = _senderContactNo;
    map['sender_tin_no'] = _senderTinNo;
    map['sender_address'] = _senderAddress;
    map['bill_no'] = _billNo;
    map['operator_name'] = _operatorName;
    map['payment_mode'] = _paymentMode;
    map['store'] = _store;
    map['total'] = _total;
    map['Sc_Amt'] = _scAmt;
    map['tax'] = _tax;
    map['Grand_total'] = _grandTotal;
    map['bar_code'] = _barCode;
    map['note'] = _note;
    map['isNew'] = _isNew;
    map['Status'] = _status;
    map['buyer_tin_no'] = _buyerTinNo;
    map['lottery_fee'] = _lotteryFee;

    map['irn'] =  _irn;
    map['item_type'] =  _itemType;
    map['withhold_amt'] = _withholdAmt;
    map['type'] =  _type;
    map['qr'] = _qr;
    map['discount'] = _discount;
    map['buyer_name'] =_buyerName;
    map['invoice_lable'] =_invoiceLable;
    map['sales_type'] =_salesType;
    map['system_number'] =_systemNumber;
    map['sender_vat_no'] = _senderVatNo;
    map['sender_city'] = _senderCity;
    map['amount_In_Words'] =_amountInWords ;
    map['document_no'] =_documentNo ;
    map['reference_irn'] =_referenceIrn ;
    map['invoice_lable_amharic'] =_invoiceLableAmharic ;
    map['receipt_lable'] =_receiptLable ;
    map['qr_receipt'] =_qrReceipt;
    map['receipt_payment'] =_receiptPayment;


    map['\$createdAt'] = _date;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Items {
  Items({
    String? itemCode,
    String? productDescription,
    int? quantity,
    double? unitPrice,
    double? totalLineAmount,
    double? taxAmount,
    String? taxCode,
    double? discount,
    double? exciseTaxValue,
    String? natureOfSupplies,
    String? unit,
    int? lineNumber,
    dynamic harmonizationCode,
    double? preTaxValue,
  }) {
    _itemCode = itemCode;
    _productDescription = productDescription;
    _quantity = quantity;
    _unitPrice = unitPrice;
    _totalLineAmount = totalLineAmount;
    _taxAmount = taxAmount;
    _taxCode = taxCode;
    _discount = discount;
    _exciseTaxValue = exciseTaxValue;
    _natureOfSupplies = natureOfSupplies;
    _unit = unit;
    _lineNumber = lineNumber;
    _harmonizationCode = harmonizationCode;
    _preTaxValue = preTaxValue;
  }

  Items.fromJson(dynamic json) {
    _itemCode = json['ItemCode'];
    _productDescription = json['name'];
    _quantity = json['qty'];
    _unitPrice = (json['unit_price'] as num?)?.toDouble();
    _totalLineAmount = (json['amount'] as num?)?.toDouble();
    _taxAmount = (json['tax_amount'] as num?)?.toDouble();
    _taxCode = json['tax_code'];
    _discount = (json['discount'] as num?)?.toDouble();
    _exciseTaxValue = (json['ExciseTaxValue'] as num?)?.toDouble();
    _natureOfSupplies = json['NatureOfSupplies'];
    _unit = json['uom'];
    _lineNumber = json['LineNumber'];
    _harmonizationCode = json['HarmonizationCode'];
    _preTaxValue = (json['PreTaxValue'] as num?)?.toDouble();
  }

  String? _itemCode;
  String? _productDescription;
  int? _quantity;
  double? _unitPrice;
  double? _totalLineAmount;
  double? _taxAmount;
  String? _taxCode;
  double? _discount;
  double? _exciseTaxValue;
  String? _natureOfSupplies;
  String? _unit;
  int? _lineNumber;
  dynamic _harmonizationCode;
  double? _preTaxValue;

  String? get itemCode => _itemCode;
  String? get productDescription => _productDescription;
  int? get quantity => _quantity;
  double? get unitPrice => _unitPrice;
  double? get totalLineAmount => _totalLineAmount;
  double? get taxAmount => _taxAmount;
  String? get taxCode => _taxCode;
  double? get discount => _discount;
  double? get exciseTaxValue => _exciseTaxValue;
  String? get natureOfSupplies => _natureOfSupplies;
  String? get unit => _unit;
  int? get lineNumber => _lineNumber;
  dynamic get harmonizationCode => _harmonizationCode;
  double? get preTaxValue => _preTaxValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ItemCode'] = _itemCode;
    map['ProductDescription'] = _productDescription;
    map['Quantity'] = _quantity;
    map['UnitPrice'] = _unitPrice;
    map['TotalLineAmount'] = _totalLineAmount;
    map['TaxAmount'] = _taxAmount;
    map['TaxCode'] = _taxCode;
    map['Discount'] = _discount;
    map['ExciseTaxValue'] = _exciseTaxValue;
    map['NatureOfSupplies'] = _natureOfSupplies;
    map['Unit'] = _unit;
    map['LineNumber'] = _lineNumber;
    map['HarmonizationCode'] = _harmonizationCode;
    map['PreTaxValue'] = _preTaxValue;
    return map;
  }
}