import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:get_receipt/helpers/database_helper.dart';
import 'package:get_receipt/helpers/utils.dart';
import 'package:get_receipt/model/main_data.dart';
import 'package:get_receipt/model/user_info.dart';
import 'package:provider/provider.dart';

import '../db/account_database.dart';
import '../db/items_database.dart';
import '../db/receipt_database.dart';
import '../model/local/account.dart';
import '../model/local/items.dart';
import '../model/local/receipt.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'log_in_service.dart';

class MainService{
  List<MainData>? _data;
  late LocalReceipt _receipt;
  late List<LocalReceipt> _receipts;
  late List<LocalItems> _items;
  late  List<model.Document> querySnapshot;
  late DateTime _latest;
  //String phoneNo = FirebaseAuth.instance.currentUser!.phoneNumber!;

  List<MainData> getMainData(BuildContext context){
    if (_data == null) {
      //_handleUninitializedData(context);
      return [];
    }
    return _data!;
  }
  List<MainData> getPaidReceiptData(BuildContext context){
    if (_data == null) {
      //_handleUninitializedData(context);
      return [];
    }
    return _data?.where((w) => w.barCode != null && w.barCode!.isNotEmpty).toList() ?? [];
    return _data!.where((w)=> w.status!.toLowerCase() =="paid").toList();
  }
  List<MainData> getPendingReceiptData() {
    if (_data == null) {
      //_handleUninitializedData(context);
      return [];
    }
    return _data?.where((w) => w.barCode == null || w.barCode!.isEmpty).toList() ?? [];
    //return _data!.where((w)=> w.receiptPayment!.emptyorNuLL()).toList();
  }

  void _handleUninitializedData(BuildContext context) {
    final loginService = Provider.of<LoginService>(context, listen: false);
    loginService.signOut(context);
  }

  Future getAllReceiptCollectionFromFirebase(String? phoneNo) async {
    final authPhoneNo = Utils.formatPhoneNo(phoneNo!);

    await getReceiptsFromSqlite();
    if(_data!.isNotEmpty){
       await getLatestReceiptDateFromSqlite();
       querySnapshot = await DatabaseHelper.instance.getReceipt(authPhoneNo, _latest);
    }else{
      querySnapshot = await DatabaseHelper.instance.getAllReceipt(authPhoneNo);
    }
//(e){
//         MainData.fromJson(e.data()).userPhoneNo!.length >= 9?
//         Utils.formatPhoneNo(MainData.fromJson(e.data()).userPhoneNo!):"";
//       }
     // new add ORDERBY
/*    final list =querySnapshot.docs.where(
            (e) {

          return phoneNoFromDB==(authPhoneNo);
          //=> e.senderName!.toLowerCase().startsWith(query.toLowerCase())).toList();
        }).toList();*/

    for (var doc in querySnapshot) {
      if(doc.data.isNotEmpty ) {
        MainData data = MainData.fromJson(doc.data);
        _receipt= await addReceipt(data);
        addItems( data.items!,_receipt.id!);
      }
    }
    await localRefresh();

  }
  Future localRefresh() async{
    await getReceiptsFromSqlite();

  }

  Future getLatestReceiptDateFromSqlite() async {
    _latest = await ReceiptDatabase.instance.getLatestDate();
  }
  Future getReceiptsFromSqlite() async {
    _data = await ReceiptDatabase.instance.readAllReceipts();
  }
  Future<List<LocalItems>> getReceiptItemsFromSqlite(int receiptId) async {
    return await ItemsDatabase.instance.readItems(receiptId);
  }

  Future<LocalReceipt> addReceipt(MainData data) async {
    final receipt = LocalReceipt(
      userPhoneNo: data.userPhoneNo!,
      senderName: data.senderName!,
      senderContactNo: data.senderContactNo!,
      senderTinNo: data.senderTinNo!,
      senderAddress: data.senderAddress!,
      billNo: data.billNo!,
      paymentMode: data.paymentMode!,
      total: data.total!,
      scAmt: data.scAmt!,
      tax: data.tax!,
      grandTotal: data.grandTotal!,
      status: data.status!,
      lotteryFee: data.lotteryFee!,
      buyerTinNo: data.buyerTinNo,
      barCode: data.barCode,
      isNew: data.isNew ?? 1,
      createdTime: data.date!,

      // NEW FIELDS
      irn: data.irn,
      itemType: data.itemType,
      withholdAmt: data.withholdAmt,
      type: data.type,
      qr: data.qr,
      discount: data.discount,
      buyerName: data.buyerName,
      invoiceLable: data.invoiceLable,
      salesType: data.salesType,
      systemNumber: data.systemNumber,
      senderVatNo: data.senderVatNo,
      senderCity: data.senderCity,
      amountInWords: data.amountInWords,
      documentNo: data.documentNo,
      referenceIrn: data.referenceIrn,
      invoiceLableAmharic: data.invoiceLableAmharic,
      receiptLable: data.receiptLable,
      qrReceipt: data.qrReceipt,

      receiptPayment: data.receiptPayment,
    );

    LocalReceipt lr = await ReceiptDatabase.instance.create(receipt);
    return lr;
  }

  Future<void> addItems(List<Items> itemList, int receiptId) async {

    final db = await ItemsDatabase.instance.database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final item in itemList) {
        final localItem = LocalItems(
          receiptId: receiptId,
          name: item.productDescription ?? item.itemCode ?? '',
          uom: item.unit ?? '',
          qty: item.quantity ?? 0,
          unit_price: item.unitPrice ?? 0.0,
          tax_code: item.taxCode ?? '',
          tax_amount: item.taxAmount ?? 0.0,
          discount: item.discount ?? 0.0,
          amount: item.totalLineAmount ?? 0.0,
        );

        batch.insert(tableItems, localItem.toJson());
      }

       await batch.commit(noResult: true);
    });
  }


  }

/*  Future getMainCollectionFromFirebase() async {

  _instance = FirebaseFirestore.instance;
  CollectionReference mainData = _instance!.collection('getreceipt');
  QuerySnapshot querySnapshot = await mainData.get();
  for (var doc in querySnapshot.docs) {
    _data.add(MainData.fromJson(doc.data()));
  }
    _instance =FirebaseFirestore.instance;
    CollectionReference mainData = _instance!.collection('getreceipt');

    Stream<QuerySnapshot> snapshot = mainData.snapshots();



    snapshot.forEach((element) {
      // convert each element  in to appropriate model
      Data da = Data.fromJson(element);

      _data.add(da);
    });
  }*/

//}

class UserInfoService{
  late Account _userInfo;
  late bool _localExist;

  Future checkUserExistFromSqlite() async {
    _userInfo = await AccountsDatabase.instance.readAccount();
    if(_userInfo.id != 0){
      //exist
      _localExist =true;
    }else{
      _localExist=false;
    }
  }

  Future<String?> getFcmToken() async {
    await FirebaseMessaging.instance.requestPermission();
    return await FirebaseMessaging.instance.getToken();
  }

  Future<bool> checkIfQrcodeExist(code) async {

    List<model.Document> qrQuery = await DatabaseHelper.instance.checkIfQrcodeExist(code);
    if (qrQuery.isEmpty) {
      //not exist
      return false;
    } else {
      return true;
    }

  }
  Future<bool> checkIfExist(uid) async {
    await checkUserExistFromSqlite();
    if(_localExist){
      return true;
    }else{
      List<model.Document> qrQuery = await DatabaseHelper.instance.getUserInfo(uid);
      if ( qrQuery.isEmpty){
        //not exist
        return false;
      }else{
        return true;
      }
    }

/*   if(userInfo.id ==uid ){

   }else{

   }*/

  }

  Account getUserInfo(){

    /*if(_userInfo!= null){*/
      return _userInfo;
    /*}else{
      Utils.mainAppNav.currentState!.pushNamed('/ErrorPage');
      return _userInfo; // null
    }*/

  }

  Future userInfoGet(uid) async {
    await checkUserExistFromSqlite();
    if(_userInfo.id != 0){
      //local user already exist
      //_userInfo =_localUsers;
      /*_userInfo= Account(
          companyName: _localUsers.orgName,
          firstName:_localUsers.firstName,
          lastName:_localUsers.lastName,
          taxCenter:_localUsers.taxCenter,
          phoneNo:_localUsers.phoneNo,
          vatNo:_localUsers.vatNo,
          tinNo:_localUsers.tinNo, uid: '', createdTime: null, orgName: '',
      );*/
    }else{
      // create user to local
      List<model.Document> userData= await DatabaseHelper.instance.getUserInfo(uid);
      if (userData == null || userData.isEmpty ){

        //dont exist (invalid user)
        Utils.mainAppNav.currentState!.pushNamed('/auth');

      }else{
        addUser( UserInfoMine.fromJson(userData.first.data), uid,userData.first.data['tin_no']);
        _userInfo =  await AccountsDatabase.instance.readAccount();

      }


    }

  }

  Future addUser(UserInfoMine userInfo, String uid, String? tinNo) async {
    final user = Account(
      uid: uid,
      orgName: userInfo.companyName??"",
      firstName: userInfo.firstName!,
      lastName: userInfo.lastName!,
      tinNo: tinNo??"",
      taxCenter: userInfo.taxCenter ?? "",
      phoneNo: userInfo.phoneNo!,
      //address: userInfo.,
      vatNo: userInfo.vatNo??"",
      createdTime: DateTime.now(),
    );

    await AccountsDatabase.instance.create(user);
  }


}

