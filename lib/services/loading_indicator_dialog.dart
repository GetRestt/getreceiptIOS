import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadingIndicatorDialog {
  static final LoadingIndicatorDialog _singleton =
  LoadingIndicatorDialog._internal();
  late BuildContext _context;

  factory LoadingIndicatorDialog() {
    return _singleton;
  }

   LoadingIndicatorDialog._internal();

  show(BuildContext context, {String text = 'Loading...'}) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _context = context;
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              backgroundColor: Colors.transparent,
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green.withOpacity(0.8)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(text, style: TextStyle(color: Colors.black54),),
                      )
                    ],
                  ),
                )
              ] ,
            ),
          );
        }
    );
  }

  dismiss() {
    Navigator.of(_context).pop();
  }
}