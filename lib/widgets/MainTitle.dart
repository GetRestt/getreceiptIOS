import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainTitle extends StatelessWidget {
  final String Name;
  const MainTitle(String this.Name, {
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 10,
      child: Container(
          color: Colors.green.withOpacity(0.8),
          padding: EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Name, style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),)
                ],
              ),
            ],
          )
      ),
    );
  }
}