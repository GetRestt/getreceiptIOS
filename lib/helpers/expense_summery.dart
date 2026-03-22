import 'dart:ffi';

import 'package:get_receipt/model/main_data.dart';

import '../model/main_withhold_data.dart';

class ExpenseSummery{

  List<double> calculate (List<MainData> data){
    double sumGrand=0;
    double sumTax =0;
      for (var doc in data) {
        sumGrand+= doc.grandTotal!.toDouble();
        sumTax+=  doc.tax!.toDouble();
      }
      return[sumGrand, sumTax] ;
    }

  List<double> calculateWithold (List<MainWithholdData> data){
    double sumWithold=0;
    for (var doc in data) {
      sumWithold+= doc.withholdAmt!.toDouble();
    }
    return[sumWithold] ;
  }
}