import 'dart:io';

import 'package:excel/excel.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/helpers/create_directory.dart';
import 'package:get_receipt/helpers/expense_summery.dart';
import 'package:get_receipt/helpers/weekly_report.dart';
import 'package:get_receipt/helpers/utils.dart';
import 'package:get_receipt/model/main_data.dart';
import 'package:get_receipt/widgets/AppBarRef.dart';
import 'package:get_receipt/widgets/MainTitle.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/main_withhold_data.dart';
import '../services/mainservice.dart';
import '../services/withholding_service.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  late List<WeeklyReport> _weekChartData;

  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();

  final TextEditingController _textFromDate = TextEditingController();
  final TextEditingController _textToDate = TextEditingController();

  // Note: you had `newFormat = DateFormat("DD-MM-yyyy")`
  // That is wrong — use lowercase `dd` and `MM` etc:
  final DateFormat _dateFmt = DateFormat("dd-MM-yyyy");

  late List<MainData> data;
  late List<MainData> _filterData;
  late List<MainWithholdData> dataWithold;
  late List<MainWithholdData> _filterDataWithhold;

  late List<double> totalValue;
  late List<double> witholdAmt;
  late List<double> _weeklyExpense;

  @override
  void initState() {
    super.initState();
    MainService mainService = Provider.of<MainService>(context, listen: false);
    WithholdingService witholdService = Provider.of<WithholdingService>(context, listen: false);
    data = mainService.getMainData(context);
    _filterData = List<MainData>.from(data);
    dataWithold= witholdService.getMainWithholdData(context);
    _filterDataWithhold=List<MainWithholdData>.from(dataWithold);
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> exportToExcel() async {
    final excel = Excel.createExcel();
    final String sheetName = excel.getDefaultSheet()!;
    final Sheet sheet = excel[sheetName];

    // Header row
    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('Date');
    sheet.cell(CellIndex.indexByString('B1')).value = TextCellValue('Bill No');
    sheet.cell(CellIndex.indexByString('C1')).value = TextCellValue('Sender NAME');
    sheet.cell(CellIndex.indexByString('D1')).value = TextCellValue('Sender ContactNo');
    sheet.cell(CellIndex.indexByString('E1')).value = TextCellValue('Sender TinNo');
    sheet.cell(CellIndex.indexByString('F1')).value = TextCellValue('Tax(15%)');
    sheet.cell(CellIndex.indexByString('G1')).value = TextCellValue('Grand Total');

    for (int row = 0; row < _filterData.length; row++) {
      final MainData e = _filterData[row];
      final int excelRow = row + 2;

      sheet.cell(CellIndex.indexByString('A$excelRow')).value =
          TextCellValue(Utils.formatDateOnly(e.date!));

      sheet.cell(CellIndex.indexByString('B$excelRow')).value =
          TextCellValue(e.billNo ?? "");

      sheet.cell(CellIndex.indexByString('C$excelRow')).value =
          TextCellValue(e.senderName ?? "");

      sheet.cell(CellIndex.indexByString('D$excelRow')).value =
          TextCellValue(e.senderContactNo ?? "");

      sheet.cell(CellIndex.indexByString('E$excelRow')).value =
          TextCellValue(e.senderTinNo ?? "");

      sheet.cell(CellIndex.indexByString('F$excelRow')).value =
          DoubleCellValue(e.tax ?? 0.0);

      sheet.cell(CellIndex.indexByString('G$excelRow')).value =
          DoubleCellValue(e.grandTotal ?? 0.0);
    }

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd_HH-mm-ss').format(now);

    final fileBytes = excel.save();

    if (fileBytes == null) {
      showSnackBar(context, "Failed to generate Excel bytes");
      return;
    }

    await CreateExternalFolder.createFolder();
    final dir = await CreateExternalFolder.createSubFolder("excel");

    final File output = File('$dir/${formattedDate}_report.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);

    showSnackBar(context, "Excel exported: ${output.path}");
  }

  @override
  Widget build(BuildContext context) {
    totalValue = context.read<ExpenseSummery>().calculate(_filterData);
    witholdAmt = context.read<ExpenseSummery>().calculateWithold(_filterDataWithhold);
    _weeklyExpense = context.read<WeeklyExpenseReport>().calculate(data);
    _weekChartData = _makeWeekChartData();

    return Scaffold(
      appBar: AppBarRef(),
      body: Column(
        children: [
          MainTitle('Reports'),
          Expanded(
            flex: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8),
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: ExpandablePanel(
                          header: const Text(
                            'Filter By',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.green),
                          ),
                          collapsed: const SizedBox.shrink(),
                          expanded: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                _dateFilter(context),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _filterDataList(_fromDate, _toDate);
                                      },
                                      icon: const Icon(Icons.search_rounded),
                                    ),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _filterData = List<MainData>.from(data);
                                          _filterDataWithhold = List<MainWithholdData>.from(dataWithold);
                                          _textFromDate.text = "";
                                          _textToDate.text = "";
                                          _fromDate = DateTime.now();
                                          _toDate = DateTime.now();
                                        });
                                      },
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: _buildColumn(
                        Utils.formatPrice(totalValue[1]), "Tax Payable (15%)"),
                  ),
                  const Divider(),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: _buildColumn(
                        Utils.formatPrice(totalValue[0]), "Total Income"),
                  ),
                  const Divider(),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: _buildColumn(
                        Utils.formatPrice(witholdAmt[0]), "Withhold Paid"),
                  ),

                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: const Row(
                      children: [
                        Text(
                          'Details',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Export to Excel',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: () async {
                            await exportToExcel();
                          },
                          icon: const Icon(Icons.menu_book_sharp,
                              size: 22, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    title: ChartTitle(
                        text: 'Last Week Analysis',
                        textStyle: const TextStyle(fontSize: 10)),
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                    ),
                    series: <CartesianSeries<dynamic, dynamic>>[
                      LineSeries<WeeklyReport, String>(
                        name: 'Expenses',
                        color: Colors.green,
                        dataSource: _weekChartData,
                        xValueMapper: (WeeklyReport wr, _) => wr.day,
                        yValueMapper: (WeeklyReport wr, _) => wr.expense,
                      ),
                    ],
                    primaryYAxis: NumericAxis(
                      numberFormat:
                      NumberFormat.simpleCurrency(name: 'ETB', decimalDigits: 0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              margin: const EdgeInsets.only(bottom: 25),
              alignment: Alignment.bottomCenter,
              child: const Text(
                'Powered By Get Rest Technology',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<WeeklyReport> _makeWeekChartData() {
    return [
      WeeklyReport('Mon', _weeklyExpense.length > 0 ? _weeklyExpense[0] : 0.0),
      WeeklyReport('Tue', _weeklyExpense.length > 1 ? _weeklyExpense[1] : 0.0),
      WeeklyReport('Wed', _weeklyExpense.length > 2 ? _weeklyExpense[2] : 0.0),
      WeeklyReport('Thu', _weeklyExpense.length > 3 ? _weeklyExpense[3] : 0.0),
      WeeklyReport('Fri', _weeklyExpense.length > 4 ? _weeklyExpense[4] : 0.0),
      WeeklyReport('Sat', _weeklyExpense.length > 5 ? _weeklyExpense[5] : 0.0),
      WeeklyReport('Sun', _weeklyExpense.length > 6 ? _weeklyExpense[6] : 0.0),
    ];
  }

  Future<void> _selectDate(
      BuildContext context, DateTime initialDate, TextEditingController tc, String type) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2060),
      builder: (context, picker) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: picker!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (type == 'from') {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
        tc.text = _dateFmt.format(picked);
      });
    }
  }

  Widget _dateFilter(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              labelText: "From Date",
              icon: Icon(Icons.date_range),
            ),
            controller: _textFromDate,
            readOnly: true,
            onTap: () => _selectDate(context, _fromDate, _textFromDate, 'from'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              labelText: "To Date",
              icon: Icon(Icons.date_range),
            ),
            controller: _textToDate,
            readOnly: true,
            onTap: () => _selectDate(context, _toDate, _textToDate, 'to'),
          ),
        ),
      ],
    );
  }

  Widget _buildColumn(String price, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          price,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black45),
        ),
      ],
    );
  }

  void _filterDataList(DateTime fromDate, DateTime toDate) {
    setState(() {
      _filterData = data.where((e) {
        if (e.date == null) return false;
        return e.date!.compareTo(fromDate) >= 0 && e.date!.compareTo(toDate) <= 0;
      }).toList();
      _filterDataWithhold = dataWithold.where((e) {
        if (e.createdAt == null) return false;
        return e.createdAt!.compareTo(fromDate) >= 0 && e.createdAt!.compareTo(toDate) <= 0;
      }).toList();

    });
  }
}

class WeeklyReport {
  final String day;
  final double expense;

  WeeklyReport(this.day, this.expense);
}
