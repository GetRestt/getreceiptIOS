const String tableItems = 'items';

class ItemFields {
  static final List<String> values = [
    id,
    receiptId,
    name,
    uom,
    qty,
    unit_price,
    tax_code,
    tax_amount,
    discount,
    amount,
  ];

  static const String id = '_id';
  static const String receiptId = 'receiptId';
  static const String name = 'name';
  static const String uom = 'uom';
  static const String qty = 'qty';
  static const String unit_price = 'unit_price';
  static const String tax_code = 'tax_code';
  static const String tax_amount = 'tax_amount';
  static const String discount = 'discount';
  static const String amount = 'amount';
}

class LocalItems {
  final int? id;
  final int receiptId;
  final String name;
  final String uom;
  final int qty;
  final double unit_price;
  final String tax_code;
  final double tax_amount;
  final double discount;
  final double amount;

  const LocalItems({
    this.id,
    required this.receiptId,
    required this.name,
    required this.uom,
    required this.qty,
    required this.unit_price,
    required this.tax_code,
    required this.tax_amount,
    required this.discount,
    required this.amount,
  });

  LocalItems copy({
    int? id,
    int? receiptId,
    String? name,
    String? uom,
    int? qty,
    double? unitPrice,
    String? taxCode,
    double? taxAmount,
    double? discount,
    double? amount,
  }) =>
      LocalItems(
        id: id ?? this.id,
        receiptId: receiptId ?? this.receiptId,
        name: name ?? this.name,
        uom: uom ?? this.uom,
        qty: qty ?? this.qty,
        unit_price: unitPrice ?? this.unit_price,
        tax_code: taxCode ?? this.tax_code,
        tax_amount: taxAmount ?? this.tax_amount,
        discount: discount ?? this.discount,
        amount: amount ?? this.amount,
      );

  /// Convert DB JSON → List<LocalItems>
  static List<LocalItems> fromJson(dynamic json) {
    final List<LocalItems> items = [];

    if (json != null) {
      for (var v in json) {
        items.add(LocalItems(
          id: v[ItemFields.id] as int?,
          receiptId: v[ItemFields.receiptId] as int,
          name: v[ItemFields.name] as String? ?? '',
          uom: v[ItemFields.uom] as String? ?? '',
          qty: v[ItemFields.qty] as int? ?? 0,
          unit_price:
          (v[ItemFields.unit_price] as num?)?.toDouble() ?? 0.0,
          tax_code: v[ItemFields.tax_code] as String? ?? '',
          tax_amount:
          (v[ItemFields.tax_amount] as num?)?.toDouble() ?? 0.0,
          discount:
          (v[ItemFields.discount] as num?)?.toDouble() ?? 0.0,
          amount:
          (v[ItemFields.amount] as num?)?.toDouble() ?? 0.0,
        ));
      }
    }

    return items;
  }

  /// Convert LocalItems → DB JSON
  Map<String, Object?> toJson() => {
    ItemFields.id: id,
    ItemFields.receiptId: receiptId,
    ItemFields.name: name,
    ItemFields.uom: uom,
    ItemFields.qty: qty,
    ItemFields.unit_price: unit_price,
    ItemFields.tax_code: tax_code,
    ItemFields.tax_amount: tax_amount,
    ItemFields.discount: discount,
    ItemFields.amount: amount,
  };
}