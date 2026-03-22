

import 'package:flutter/material.dart';
import 'package:get_receipt/model/main_data.dart';
import 'package:get_receipt/services/mainservice.dart';
import 'package:get_receipt/widgets/main_card.dart';
import 'package:provider/provider.dart';

import '../model/local/account.dart';

class DataSearch extends SearchDelegate<String>{
  @override
  String get searchFieldLabel => 'Search by Name or Address';
  late MainData _mainData;
  late bool isTab = false;
  late  List suggestionList;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query ="";
      }, icon: Icon(Icons.clear))
    ];
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      close(context, "");
    },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context)  {
    return  redirectSearch ( context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    MainService _fromRetrieveData = Provider.of<MainService>(context, listen: false);
    List<MainData> data =_fromRetrieveData.getMainData(context);
    suggestionList =query.isEmpty ? [] :data.where(
            (e) {
          final nameLower= e.senderName!.toLowerCase();
          final addressLower =e.senderAddress!.toLowerCase();
          final searchLower = query.toLowerCase();
          return nameLower.startsWith(searchLower) || addressLower.startsWith(searchLower);
          //=> e.senderName!.toLowerCase().startsWith(query.toLowerCase())).toList();
        }).toList();
    return listBuilderSample (suggestionList);
    throw UnimplementedError();
  }

  redirectSearch(  BuildContext context) {
    UserInfoService _userInfoService = Provider.of<UserInfoService>(context, listen: false);
    Account _userInfo =  _userInfoService.getUserInfo();
    if (isTab == true) {
      isTab= false;
      return MainCard(
        status: "paid",
        mainData: _mainData,
        userInfo: _userInfo,
      );
    }else{
      return listBuilderSample (suggestionList);
    }

  }

  Widget listBuilderSample (suggestionList){
    return ListView.builder(
      itemBuilder: (context, index)=> ListTile(
        onTap: (){
          isTab = true;
          _mainData = suggestionList[index];
          showResults(context);
          //buildResults(context);
        },
        leading: const Icon(Icons.print) ,
        title: RichText( text: TextSpan( text:suggestionList[index].senderName.substring(0, query.length), style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold,
        ) ,
            children: [
              TextSpan( text:suggestionList[index].senderName.substring(query.length), style: const TextStyle(
                  color: Colors.grey),
              ),
            ]
        ),
        ),
        subtitle: Text(suggestionList[index].senderAddress),
        trailing: Text(suggestionList[index].grandTotal.toString()),

      ),
      itemCount: suggestionList.length,
    );
  }

}