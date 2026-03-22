import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {

  static GlobalKey<NavigatorState> mainListNav = GlobalKey();
  static GlobalKey<NavigatorState> mainAppNav = GlobalKey();
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static formatPrice(double price) {
    final formatSample = new NumberFormat("#,##0.00", "en_US");
    return 'ETB ${formatSample.format(price)}';
  }

  static formatDate(DateTime date){
    var dateValue = new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(date.toIso8601String()).toLocal();
    return DateFormat('dd/MM/yyyy, hh:mm a').format(dateValue);
  }

  static formatDateOnly(DateTime date) => DateFormat('dd/MM/yyyy').format(date);
  static formatPhoneNo(String phoneNo) => phoneNo.replaceAll( RegExp(r"\D"), "")
      .substring(
      (phoneNo.replaceAll(RegExp(r"\D"), "").length)-9,
      (phoneNo.replaceAll(RegExp(r"\D"), "").length)
  );
  static formatStringNoSpace(String st) => st.replaceAll(' ', '');
}