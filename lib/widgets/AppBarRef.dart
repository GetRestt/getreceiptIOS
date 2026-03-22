import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/helpers/search_delegate.dart';

class AppBarRef extends StatelessWidget implements PreferredSizeWidget  {

  const AppBarRef({
    Key? key,
  }) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      iconTheme: const IconThemeData(color: Colors.green),
      actions: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            IconButton(onPressed: (){
              showSearch(context: context, delegate: DataSearch());
              },
              icon: Icon(Icons.search_rounded, size: 21,),
              ),

              SizedBox(width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.08,),
            ],
          ),
        ),
      ],
    );
  }

}