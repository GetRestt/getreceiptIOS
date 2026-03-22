final String tableAccounts = 'accounts';

class AccountFields {
  static final List<String> values = [
    /// Add all fields
    id, uid,orgName, firstName,lastName,taxCenter,phoneNo,tinNo,vatNo, time //address
  ];

  static const String id = '_id';
  static const String uid = 'uid';
  static const String orgName = 'orgName';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String taxCenter = 'taxCenter';
  static const String phoneNo = 'phoneNo';
  //static const String address = 'address';
  static const String tinNo = 'tinNo';
  static const String vatNo = 'vatNo';
  static const String time = 'time';
}

class Account {
  final int? id;
  final String uid;
  final String orgName;
  final String firstName;
  final String lastName;
  final String taxCenter;
  final String phoneNo;
  //final String? address;
  final String tinNo;
  final String vatNo;
  final DateTime createdTime;

  const Account({
    this.id,
    required this.uid,
    required this.orgName,
    required this.firstName,
    required this.lastName,
    required this.taxCenter,
    required this.phoneNo,
    //this.address,
    required this.tinNo,
    required this.vatNo,
    required this.createdTime,
  });

  Account copy({
    int? id,
    String? uid,
    String? orgName,
    String? firstName,
    String? lastName,
    String? taxCenter,
    String? phoneNo,
    //String? address,
    String? tinNo,
    String? vatNo,
    DateTime? createdTime,
  }) =>
      Account(
        id: id ?? this.id,
        uid: orgName ?? this.uid,
        orgName: orgName ?? this.orgName,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        taxCenter: taxCenter ?? this.taxCenter,
        phoneNo: phoneNo ?? this.phoneNo,
        //address: address ?? this.address,
        tinNo: tinNo ?? this.tinNo,
        vatNo: vatNo ?? this.vatNo,
        createdTime: createdTime ?? this.createdTime,
      );

  static Account fromJson(Map<String, Object?> json) => Account(
    id: json[AccountFields.id] as int?,
    uid: json[AccountFields.uid] as String,
    orgName: json[AccountFields.orgName] as String,
    firstName: json[AccountFields.firstName] as String,
    lastName: json[AccountFields.lastName] as String,
    taxCenter: json[AccountFields.taxCenter] as String,
    phoneNo: json[AccountFields.phoneNo] as String,
    //address: json[AccountFields.address] as String?,
    tinNo: json[AccountFields.tinNo] as String,
    vatNo:json[AccountFields.vatNo] as String,
    createdTime: DateTime.parse(json[AccountFields.time] as String),
  );

  Map<String, Object?> toJson() => {
    AccountFields.id: id,
    AccountFields.uid: uid,
    AccountFields.orgName: orgName,
    AccountFields.firstName: firstName,
    AccountFields.lastName: lastName,
    AccountFields.taxCenter: taxCenter,
    AccountFields.phoneNo: phoneNo,
    //AccountFields.address: address??"",
    AccountFields.tinNo: tinNo,
    AccountFields.vatNo: vatNo,
    AccountFields.time: createdTime.toIso8601String(),
  };
}
