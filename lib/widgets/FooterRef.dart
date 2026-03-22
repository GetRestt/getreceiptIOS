import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FooterRef extends StatelessWidget {
  const FooterRef({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 10,
      child: Container(
        margin: EdgeInsets.only(bottom: 23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text('Power By Get Rest Technology', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54),),
          ],
        ),
      ),);
  }
}