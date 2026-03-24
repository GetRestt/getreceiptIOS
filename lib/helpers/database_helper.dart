import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get_receipt/main.dart';
import 'package:get_receipt/model/main_data.dart';
import 'package:get_receipt/model/user_info.dart';
import 'package:get_receipt/helpers/auth_helper.dart';
import 'package:get_receipt/helpers/utils.dart';


class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  static DatabaseHelper get instance => _instance;

  static Databases? databases;

  init() {
    databases = Databases(client);
  }

  Future<String> createUserData(UserInfoMine data) async {
    databases ?? init();
    try {
      //String? userId = await AuthHelper.instance.getUserId();
      Document response=await databases!.createDocument(
          databaseId: "64021c676587c617b2ba",
          collectionId: "640225bea15a95e0a6d1", //userInfo
          documentId: ID.unique(),
          data:data.toJson() );

      return response.$id;

    } on AppwriteException catch (e) {
      rethrow;
    } catch (e, stack) {
      rethrow;
    }
  }
  Future<List<Document>> getAllReceipt(String phoneNo) async {
    databases ?? init();
    try {
      DocumentList response = await databases!.listDocuments(
        databaseId: "64021c676587c617b2ba",
        collectionId: "640221aa8e0fd7548611",
        queries: [
          Query.equal("user_phone_no", phoneNo),
          Query.orderDesc('\$createdAt'),
        ],
      );
      return response.documents;

    } on AppwriteException catch (e) {
      rethrow;
    }
  }
  Future<List<Document>> getReceipt(String phoneNo, DateTime latest) async {
    databases ?? init();
    try {
      DocumentList response = await databases!.listDocuments(
        databaseId: "64021c676587c617b2ba",
        collectionId: "640221aa8e0fd7548611",//getreceipt
        queries: [
          Query.equal("user_phone_no", phoneNo),
          Query.orderDesc('\$createdAt'),
          Query.greaterThan('\$createdAt',latest.add(const Duration(seconds: 1)).toIso8601String()),
        ],
      );
      return response.documents;


    } on AppwriteException catch (e) {
      if(e.message == "The current user is not authorized to perform the requested action."){
        AuthHelper.instance.logout();
        Utils.mainAppNav.currentState!.pushNamed('/auth');
      }
      rethrow;
    }
  }
  Future<List<Document>> getAllTaxCenter () async{
    databases ?? init();
    try{

      DocumentList response = await databases!.listDocuments(
        databaseId: "64021c676587c617b2ba",
        collectionId: "64022002428cc841fbae", //taxCenter
        queries: [
          Query.limit(1)
        ],
      );
      return response.documents;

    }on AppwriteException catch (e) {
      rethrow;
    }

  }
   getUserInfo(String uid) async {
    databases ?? init();
    try {
      DocumentList response = await databases!.listDocuments(
        databaseId: "64021c676587c617b2ba",
        collectionId: "640225bea15a95e0a6d1",
        queries: [
          Query.equal("uid", uid),
          Query.limit(1)
        ],
      );
      return response.documents;

    } on AppwriteException catch (e) {
      rethrow;
    }
  }



  Future<List<MainData>> getLatestBillNo(String tinNo) async {
    databases ?? init();
    try {
      //String userId = await AuthHelper.instance.getUserId() ?? "";
      DocumentList response = await databases!.listDocuments(
        databaseId: "64021c676587c617b2ba",
        collectionId: "640221aa8e0fd7548611",//get receipt
        queries: [
          Query.equal("sender_tin_no", tinNo),
          Query.orderDesc('\$createdAt'),
          Query.limit(1)
        ],
      );
      return response.documents
          .map(
            (e) => MainData.fromJson(e.data),
      )
          .toList();
    } on AppwriteException catch (e) {
      rethrow;
    }
  }

  Future<List<Document>> checkIfQrcodeExist (String code) async {
    databases ?? init();
    try{

      DocumentList response = await databases!.listDocuments(
        databaseId: "64021c676587c617b2ba",
        collectionId: "640221aa8e0fd7548611",//get receipt
        queries: [
          Query.equal("bar_code", code),
          Query.limit(1)
        ],
      );
      return response.documents;

    } on AppwriteException catch (e) {
      rethrow;
    }
  }
  //getreceipt db
  Future<bool> checkDocumentExist( String dId) async{
    databases ?? init();
    try {
      Document response = await databases!.getDocument(
        databaseId: "64021c676587c617b2ba",
        collectionId: "640221aa8e0fd7548611",
        documentId: dId,//todo.id
      );
      if (response.data.isNotEmpty){
        return true;
      }else{
        return false;
      }

    } on AppwriteException catch (e) {
      rethrow;
    }
  }

  Future<List<Document>> getAllWithholding(String phoneNo) async {
    databases ?? init();
    try {
      DocumentList response = await databases!.listDocuments(
        databaseId: "64021c676587c617b2ba",
        collectionId: "withholding",
        queries: [
          Query.equal("receiver_phoneno", phoneNo),
          Query.orderDesc('\$createdAt'),
        ],
      );
      return response.documents;

    } on AppwriteException catch (e) {
      rethrow;
    }
  }
  Future<List<Document>> getWithholding(String phoneNo, DateTime latest) async {
    databases ?? init();
    try {
      DocumentList response = await databases!.listDocuments(
        databaseId: "64021c676587c617b2ba",
        collectionId: "withholding",//withholding
        queries: [
          Query.equal("receiver_phoneno", phoneNo),
          Query.orderDesc('\$createdAt'),
          Query.greaterThan('\$createdAt',latest.add(const Duration(seconds: 1)).toIso8601String()),
        ],
      );
      return response.documents;


    } on AppwriteException catch (e) {
      if(e.message == "The current user is not authorized to perform the requested action."){
        AuthHelper.instance.logout();
        Utils.mainAppNav.currentState!.pushNamed('/auth');
      }
      rethrow;
    }
  }

  Future<void> deleteUser(String documentId) async {
    databases ?? init();

    try {
      await databases!.deleteDocument(
        databaseId: "64021c676587c617b2ba",
        collectionId: "640225bea15a95e0a6d1",
        documentId: documentId,
      );

    } on AppwriteException catch (e) {
      if (e.message ==
          "The current user is not authorized to perform the requested action.") {
        AuthHelper.instance.logout();
        Utils.mainAppNav.currentState!.pushNamed('/auth');
      }
      rethrow;
    }
  }



}