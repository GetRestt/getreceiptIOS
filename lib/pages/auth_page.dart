import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/pages/validation_page.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final TextEditingController _phoneField =  TextEditingController();
  final String pattern = r'(^(?:[+0]9)?[0-9]{9,10}$)';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PopScope(
          canPop: true, //When false, blocks the current route from being popped.
          onPopInvokedWithResult: (didPop, result) async {
            //do your logic here:
             false;
          },
        child: Scaffold( resizeToAvoidBottomInset: false, backgroundColor:const Color(0xfff7f6fb),
        body: SafeArea(
            child: Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 15,right: 20, left: 20),
            child: Column(
                children:  [
                   Flexible(
                    flex: 3,
                      child: Column( children: const [
                        SizedBox( height: 10,),
                        Text
                          (
                          'Get Receipt',
                          style:TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold, fontFamily: 'MontserratSubrayada-Bold' , color: Colors.green,)
                          ,),

                        SizedBox(
                          height: 90,
                        ),

                      ],),


                  ),

                  Flexible(
                    flex: 6,
                    child: Column( children: [
                      const Text(
                        'Phone No', style:  TextStyle( fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value){
                            String pattern = r'(^(?:[+0]9)?[0-9]{9,10}$)';
                            RegExp regExp = RegExp(pattern);
                            if (value!.isEmpty) {
                              return 'Please enter mobile number';
                            }
                            else if (!regExp.hasMatch(value)) {
                              return 'Please enter valid mobile number';
                            }
                            return null;
                          }                                            ,
                          controller: _phoneField,
                          style: const TextStyle(
                            fontSize: 18,
                              fontWeight: FontWeight.bold,
                          ),
                              decoration:InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10)),
                                prefix: const Padding( padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '+251',
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize:18 ),
                                ),
                                ),
                                suffixIcon: const Icon(Icons.check_circle, color: Colors.greenAccent, size: 32,),
                          ),

                          ),
                      const SizedBox(
                        height: 55,
                      ),
                       SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: (){

                          RegExp regExp = RegExp(pattern);
                          if (_phoneField.text.isEmpty) {
                            FocusManager.instance.primaryFocus!.unfocus();
                            showSnackBar(context, "Please enter mobile number");
                            //return 'Please enter mobile number';
                          }
                          else if (!regExp.hasMatch(_phoneField.text)) {
                            FocusManager.instance.primaryFocus!.unfocus();
                            showSnackBar(context, "Please enter valid mobile number");
                            //return 'Please enter valid mobile number';
                          }else if(
                          (_phoneField.text[0] =='0' &&  _phoneField.text.length!=10) ||
                              (_phoneField.text[0] =='9' &&  _phoneField.text.length!=9) ||
                              (_phoneField.text[0] !='0'&& _phoneField.text[0]!='9')){//else if(_phoneField.text.length >10 || _phoneField.text.length <9){
                            FocusManager.instance.primaryFocus!.unfocus();
                            showSnackBar(context, "incorrect phoneNo");
                          }
                          else{
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Validation(phone: _phoneField.text,),
                            ),
                            );
                          }

                        },
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                              backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                              ),
                              ),
                            ),
                            child: const Padding(padding: EdgeInsets.all(14),
                              child: Text('Next'),
                            )),
                      ),

                    ],


                    ),
                  ),
                  const Flexible(
                    flex:1,
                    child: Text('Power By Get Rest Tech',
                      style:  TextStyle( fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black38,
                      ),

                    ),
                  )

                  ],
              ),

              ),

          ),
        ),
      ),
    );

  }

  void showSnackBar(BuildContext context, String message){
    final snackBar= SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
