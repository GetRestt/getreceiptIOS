import 'package:flutter/material.dart';
import 'package:get_receipt/helpers/database_helper.dart';
import 'package:get_receipt/helpers/utils.dart';
import 'package:get_receipt/model/main_withhold_data.dart';
import 'package:get_receipt/model/local/withholding.dart';
import '../db/withholding_database.dart';

class WithholdingService {
  List<MainWithholdData>? _data;
  late LocalWithholding _withholding;
  late List<LocalWithholding> _withholdings;
  late DateTime _latest;

  /// Get all withholding data in memory
  List<MainWithholdData> getMainWithholdData(BuildContext context) {
    if (_data == null) {
      return [];
    }
    return _data!;
  }

  /// Refresh local SQLite data
  Future<void> localRefresh() async {
    await getWithholdingFromSqlite();
  }

  /// Get the latest withholding date from local DB
  Future<void> getLatestWithholdingFromSqlite() async {
    _latest = await WithholdingDatabase.instance.getLatestDate();
  }

  /// Get all withholding records from local SQLite
  Future<void> getWithholdingFromSqlite() async {
    _data = await WithholdingDatabase.instance.readAllWithholdings();
  }


  /// Fetch all withholding records from Firebase
  Future<void> getAllWithholdingCollectionFromFirebase(String? phoneNo) async {
    final authPhoneNo = Utils.formatPhoneNo(phoneNo!);

    await getWithholdingFromSqlite();

    List<dynamic> querySnapshot;

    if (_data!.isNotEmpty) {
      await getLatestWithholdingFromSqlite();
      querySnapshot = await DatabaseHelper.instance.getWithholding(authPhoneNo, _latest);
    } else {
      querySnapshot = await DatabaseHelper.instance.getAllWithholding(authPhoneNo);
    }

    for (var doc in querySnapshot) {
      if (doc.data.isNotEmpty) {
        MainWithholdData data = MainWithholdData.fromJson(doc.data);
        _withholding = await addWithhold(data);
      }
    }

    await localRefresh();
  }

  /// Add a new withholding record to local SQLite
  Future<LocalWithholding> addWithhold(MainWithholdData data) async {
    final withhold = LocalWithholding(
      morNo: data.morNo!,
      irn: data.irn,
      rrn: data.rrn!,
      systemNo: data.systemNo!,
      senderName: data.senderName,
      senderCity: data.senderCity,
      senderWereda: data.senderWereda,
      senderAddress: data.senderAddress,
      senderTin: data.senderTin,
      senderVat: data.senderVat,
      receiverPhoneNo: data.receiverPhoneNo,
      receiverName: data.receiverName,
      receiverTin: data.receiverTin,
      receiverAddress: data.receiverAddress,
      receiverCity: data.receiverCity,
      type: data.type!,
      preTax: data.preTax!,
      withholdAmt: data.withholdAmt!,
      words: data.words,
      casher: data.casher!,
      title: data.title,
      qr: data.qr!,
      createdTime: data.createdAt ?? DateTime.now(),
      isNew: 1,
    );

    LocalWithholding lw = await WithholdingDatabase.instance.create(withhold);
    return lw;
  }
}