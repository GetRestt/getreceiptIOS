

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/helpers/database_helper.dart';
import 'package:get_receipt/helpers/utils.dart';
import 'package:get_receipt/services/loading_indicator_dialog.dart';
import 'package:get_receipt/services/mainservice.dart';
import 'package:provider/provider.dart';

import '../model/tax_center.dart';
import '../model/user_info.dart';

class FieldInput extends StatefulWidget {
     const FieldInput(this._otpUid, this._phone,this.tc, {Key? key}) : super(key: key);
     final String _otpUid;
     final String _phone;
     final Tax_center tc;

    @override
    _FieldInputState createState() => _FieldInputState();
}

class _FieldInputState extends State<FieldInput> {
    final formKey = GlobalKey<FormState>();
    late String _selectedValue;
    late List<DropdownMenuItem> _taxCenterDrop;

    final TextEditingController _firstName =  TextEditingController();
    final TextEditingController _lastName =  TextEditingController();
    final TextEditingController _companyName =  TextEditingController();
    final TextEditingController _vatNo =  TextEditingController();
    final TextEditingController _tinNo =  TextEditingController();
    //final TextEditingController _taxCenter =  TextEditingController();

    String name= "";
    String? selectedType;
    bool _autoValidate = false;
    final String pattern = r'(^[0-9]{10}$)';
    final String patternVat = r'(^[0-9]+$)';
    bool _enabled = false;

  List<DropdownMenuItem> _loadTaxCenterToDrop()  {
    widget.tc.info?.forEach((element) {
        _taxCenterDrop.add(
            DropdownMenuItem(child: Text(element.name!), value: element.name!,));
      });
      return _taxCenterDrop;
    }

    @override
    Widget build(BuildContext context) {
      _taxCenterDrop = [];
      _taxCenterDrop= (widget.tc.info != null ) ? _loadTaxCenterToDrop() : [];
      _selectedValue= _taxCenterDrop.isNotEmpty ? _taxCenterDrop.first.value : "Noting Added";
      //widget._otpUid
        UserInfoService _userInfo = Provider.of<UserInfoService>(context, listen: false);
        final double height = MediaQuery.of(context).size.height;
        return PopScope(
          canPop: true, //When false, blocks the current route from being popped.
          onPopInvokedWithResult: (didPop, result) async {
          //do your logic here:
          false;
        },
          child: Scaffold( 
              body: Padding(
                  padding: const EdgeInsets.only(top: 80, bottom: 10,right: 20, left: 20),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,

                      children: [

                          Flexible(
                              flex: 15,
                              child: SingleChildScrollView(
                                child: Column( children:  [
                                    SizedBox(height: height*0.02),
                                    const Text
                                        (
                                        'Get Receipt',
                                        style:TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold, fontFamily: 'MontserratSubrayada-Bold' , color: Colors.green,)
                                        ,),

                                    SizedBox(height: height*0.01),
                                ]
                                ),
                              ),
                          ),

                        Flexible(
                          fit: FlexFit.tight,
                                flex: 80,
                                    child: SingleChildScrollView(
                                      child: Column(
                                          children: [
                                              const Text("Welcome !", style: TextStyle(fontSize: 18, color: Colors.green),),
                                              SizedBox(
                                                  height: height*0.02,
                                              ),
                                              Form( key: formKey,
                                                  child: Column( children: [

                                                      TextFormField(
                                                          controller: _firstName,
                                                          decoration: const InputDecoration(
                                                              labelText: "First Name"
                                                          ),
                                                          validator: (value){
                                                              if(value!.isEmpty || !RegExp(r'^[a-z A-Z]+$' ).hasMatch(value)){
                                                                  return "Enter correct name";
                                                              }else{
                                                                  return null;
                                                              }
                                                          },
                                                      ),
                                                      TextFormField(
                                                          controller: _lastName,
                                                          decoration: const InputDecoration(
                                                              labelText: "Last Name"
                                                          ),
                                                          validator: (value){
                                                              if(value!.isEmpty || !RegExp(r'^[a-z A-Z]+$' ).hasMatch(value)){
                                                                  return "Enter correct lastName";
                                                              }else{
                                                                  return null;
                                                              }
                                                          },
                                                      ),

                                                      SizedBox(
                                                          height: height*0.02,
                                                      ),

                                                      DropdownButtonFormField<String>(
                                                          value: selectedType,
                                                          hint: const Text(
                                                              'Type',
                                                          ),
                                                          onChanged: (selectedType) =>
                                                              setState(() {
                                                                this.selectedType = selectedType!;
                                                                if(selectedType == "Company") {
                                                                  _enabled = true;
                                                                }else{
                                                                  _companyName.clear();
                                                                  _vatNo.clear();
                                                                  _tinNo.clear();
                                                                  _enabled = false;
                                                                }
                                                              }),
                                                          validator: (value) => value == null ? 'field required' : null,
                                                          items: ['Individual', 'Company'].map<DropdownMenuItem<String>>((String value) {
                                                              return DropdownMenuItem<String>(
                                                                  value: value,
                                                                  child: Text(value),
                                                              );
                                                          }).toList(),
                                                      ),

                                                      TextFormField(
                                                          enabled: _enabled,
                                                          controller: _companyName,
                                                          decoration: const InputDecoration(
                                                              labelText: "Company Name"
                                                          ),
                                                        validator: (value){
                                                          if( selectedType=="Company" && (value == null || value.isEmpty)){
                                                            return "Please Insert companyName";
                                                          }else{
                                                            return null;
                                                          }
                                                        },
                                                      ),

                                                      SizedBox(
                                                          height: height*0.02,
                                                      ),
                                                      Column(
                                                          children: [
                                                              Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                      Expanded(
                                                                          child: TextFormField(
                                                                            enabled: _enabled,
                                                                              controller: _vatNo,
                                                                              decoration: const InputDecoration(
                                                                                  labelText: "Vat No"
                                                                              ),
                                                                            validator: (value){
                                                                              RegExp regExp = RegExp(patternVat);
                                                                              if( selectedType=="Company" && (value!.isEmpty || !regExp.hasMatch(value))){
                                                                                return "Enter correct Vat No";
                                                                              }else{
                                                                                return null;
                                                                              }
                                                                            },
                                                                          ),
                                                                      ),
                                                                      const Spacer(),
                                                                      Expanded(
                                                                          child: TextFormField(
                                                                            enabled: _enabled,
                                                                              controller: _tinNo,
                                                                              decoration: const InputDecoration(
                                                                                  labelText: "Tin No"
                                                                              ),
                                                                              validator: (value){
                                                                                RegExp regExp = RegExp(pattern);
                                                                                if( selectedType=="Company" && (value!.isEmpty || !regExp.hasMatch(value))){
                                                                                  return "Enter correct Tin No";
                                                                                }else{
                                                                                  return null;
                                                                                }
                                                                              },
                                                                          ),
                                                                      ),
                                                                  ],
                                                              ),

                                                          ],
                                                      ),


                                                      SizedBox(
                                                          height: height*0.02,
                                                      ),

                                                    // DropdownButtonFormField<dynamic>(
                                                    //   enableFeedback: _enabled,
                                                    //   initialValue: _selectedValue,
                                                    //   items: _taxCenterDrop,
                                                    //   hint: const Text('Category List'),
                                                    //   onChanged: (value) {
                                                    //     setState(() {
                                                    //       _selectedValue = value;
                                                    //     });
                                                    //   },
                                                    //   validator: (value) =>
                                                    //   value == null
                                                    //       ? 'field required'
                                                    //       : null,
                                                    //
                                                    // ),

/*                                                      TextFormField(
                                                        enabled: _enabled,
                                                          controller: _taxCenter,
                                                          decoration: const InputDecoration(
                                                              labelText: "Tax Center"
                                                          ),
                                                          validator: (value){
                                                            if( selectedType=="Company" && (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$' ).hasMatch(value))){
                                                              return "Enter correct Tax Ceneter";
                                                            }else{
                                                              return null;
                                                            }
                                                          },
                                                      ),*/

                                                      SizedBox(
                                                          height: height*0.03,
                                                      ),

                                                      SizedBox(
                                                          width: double.infinity,
                                                          child: ElevatedButton(
                                                              onPressed: () async{
                                                                   if (formKey.currentState!.validate()) {
                                                                      //form is valid, proceed further
                                                                      //formKey.currentState!.save();//save once fields are valid, onSaved method invoked for every form fields
                                                                     LoadingIndicatorDialog().show(context); // start dialog
                                                                     // Get FCM token
                                                                     String? fcmToken = await _userInfo.getFcmToken();

                                                                     if (fcmToken == null) throw Exception("FCM token not available");
                                                                     UserInfoMine userInfo =UserInfoMine.fromJson({
                                                                       'first_name':_firstName.text,
                                                                       'last_name':_lastName.text,
                                                                       'phone_no':widget._phone,
                                                                       'company_name':_companyName.text.trim() !=""?_companyName.text:null,
                                                                       'uid':widget._otpUid!=""? widget._otpUid:null,
                                                                       'tin_no':_tinNo.text.trim() != "" ? _tinNo.text.trim() : null,
                                                                       'vat_no':_vatNo.text.trim() != "" ? _vatNo.text.trim() : null,
                                                                       'tax_center':_selectedValue,
                                                                       'fcm': fcmToken, // Save FCM here
                                                                     });
                                                                     await DatabaseHelper.instance.createUserData(userInfo).then((value){

                                                                       LoadingIndicatorDialog().dismiss();
                                                                       _userInfo.userInfoGet(widget._otpUid);
                                                                       Utils.mainAppNav.currentState!.pushNamed('/');

                                                                     });


                                                                  } else {
                                                                      setState(() {
                                                                          _autoValidate = true; //enable realtime validation
                                                                      });
                                                                  }
                                                              },
                                                              style: ButtonStyle(
                                                                  foregroundColor:
                                                                  WidgetStateProperty.all<Color>(Colors.white),
                                                                  backgroundColor:
                                                                  WidgetStateProperty.all<Color>(Colors.green),
                                                                  shape:
                                                                  WidgetStateProperty.all<RoundedRectangleBorder>(
                                                                      RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(24.0),
                                                                      ),
                                                                  ),
                                                              ),
                                                              child: const Padding(
                                                                  padding: EdgeInsets.all(14.0),
                                                                  child: Text(
                                                                      'Finish',
                                                                      style: TextStyle(fontSize: 16),
                                                                  ),
                                                              ),
                                                          ),
                                                      ),
                                                      SizedBox(height: MediaQuery.of(context).size.height *0.008,),


                                                  ],)
                                              )

                                          ],),
                                    ),
                            ),
                        Flexible(
                          flex: 5,
                          child: SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('Power By Get Rest Technology', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54),),
                                ],
                              ),
                            ),
                          ),),
                          /*const Flexible(
                              flex:1,
                              child: Text('Power By Get Rest Tech',
                                  style:  TextStyle( fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black38,
                                  ),

                              ),
                          )*/
                      ],

                  ),
              ),

          ),
        );
    }
}
