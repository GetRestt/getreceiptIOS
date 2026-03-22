import 'package:get_receipt/helpers/utils.dart';
import 'package:get_receipt/model/main_data.dart';
import 'package:intl/intl.dart';

class WeeklyExpenseReport {

  List<double> calculate (List<MainData> data){
    List<double> weeklyExpense =[];
    var lastWeek = DateTime.now().subtract(const Duration(days: 7));

    var weekDay = lastWeek.weekday;
    DateTime start = lastWeek.subtract(Duration(days: weekDay - 1));
    DateTime end = lastWeek.add(Duration(days: DateTime.daysPerWeek - weekDay));
    DateTime startDate =DateTime.parse(DateFormat('yyyy-MM-dd').format(start));
    DateTime endDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(end));

    List<MainData> weeklyData = lastWeekData(data, startDate, endDate);

    //for (int i = 0; i <= end.difference(start).inDays; i++) {
    for(DateTime date = startDate; date.compareTo(endDate) <= 0; date = date.add(Duration(days: 1))){
      double dailyExpense = dailyData(weeklyData,date );
      weeklyExpense.add(dailyExpense);
    }
    return weeklyExpense ;
  }

  List<MainData> lastWeekData (List<MainData> data, DateTime startDate, DateTime endDate){
    return  data.where((e) {
      String toDateString = DateFormat('yyyy-MM-dd').format(e.date!);
      DateTime toDate = DateTime.parse(toDateString);

      return (toDate.compareTo(endDate) <= 0
          && toDate.compareTo(startDate) >= 0 );
    }).toList();
  }

  double dailyData( List<MainData> weeklyData, DateTime singleDate){
    double sumGrand=0;
    List<MainData> dailyList=weeklyData.where((e){
      DateTime toDate =DateTime.parse(DateFormat('yyyy-MM-dd').format(e.date!));
       return (toDate.compareTo(singleDate) == 0);
    }).toList();
    for(var doc in dailyList){
      sumGrand+= doc.grandTotal!.toDouble();
    }
    return sumGrand;
  }
}