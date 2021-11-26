import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourapp/core/enums/dialog_type.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/shared_prefs.dart';
import 'package:tourapp/ui/shared/custom_dialog.dart';
import 'package:tourapp/ui/shared/loading_overlay.dart';
import 'package:tourapp/ui/shared/popups.dart';
import 'package:tourapp/services/validation.dart';
import 'package:tourapp/ui/views/home/home.dart';
import 'package:tourapp/views/user/providers/sign_up_provider.dart';
import 'package:tourapp/views/user/view/animation/FadeAnimation.dart';
import 'package:tourapp/ui/views/user/signup.dart';
import 'package:tourapp/core/enums/dialog_type.dart' as type;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
var _scaffoldKey  =   GlobalKey<ScaffoldState>();
    String phoneValidation(String str) {
    if (str.length < 0 || str == null) {
      return "هذا الحقل مطلوب";
    }
    // if (str.length < 12) {
    //   return "رقم الهاتف قصير جدا";
    // }

    if (!Validators.isValidPhoneNumber(str)) {
      return
      
      
      
       "رقم الهاتف غير صالح";
    }

    return null;
  }

  TextEditingController passwordController = TextEditingController();
  String passwordValidation(String str) {
    if (str.length < 0 || str == null) {
      return "هذا الحقل مطلوب";
    }

    return null;
  }
TextEditingController phoneController = TextEditingController();

var _formKey =  GlobalKey<FormState>();

String baseUrl;
@override
void initState() {
  super.initState();
   API.getAppBaseUrl().then((value) {
      if (!value.error) {
        debugPrint("BASE URL FROM CLOUD STORAGE  " + value.data);
        setState(() {
          baseUrl = value.data;

          sharedPrefs.SaveBaseUrl(baseUrl);
        });
      }
    });
}
  @override
  Widget build(BuildContext context) {
            var translator = Provider.of<TranslationProvider>(context);

    return Directionality(
      textDirection: translator.getCurrentLang()=="en"?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child:   ListView(
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FadeAnimation(1, Text(
                          
                          translator.getString("login_text")
                        , style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),)),
                        SizedBox(height: 20,),
                        // FadeAnimation(1.2, Text("Login to your account", style: TextStyle(
                        //   fontSize: 15,
                        //   color: Colors.grey[700]
                        // ),)),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(1.2, makeInput(label: translator.getString("phone_txt") , validator: phoneValidation , controller: phoneController)),
                          FadeAnimation(1.3,
                              makeInput(label: translator.getString("password_txt"), obscureText: true ,   validator: passwordValidation ,  controller: passwordController)),
                        ],
                      ),
                    ),
                    FadeAnimation(1.4, Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                          )
                        ),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () async{
                      
    
    
          WidgetsBinding.instance.addPostFrameCallback((_) async{        
                      
                        LoadingOverlay.of(context).show();

                                var res = await Provider.of<SignUpProvider>(
                                        context,
                                        listen: false)
                                    .login(phoneController.text,
                                        passwordController.text);

                                if (!res.error) {
                                  LoadingOverlay.of(context).hide();
                                  sharedPrefs.saveUserID(res.data.userId);
                                  sharedPrefs
                                      .saveUserPassword(res.data.password);
                                      sharedPrefs.saveUserIMage(res.data.pic);
                                          sharedPrefs.saveUser({
                                      "id": res.data.userId,
                                      "name": res.data.userName
                                    });

                                  sharedPrefs.changeLoggedIn(true);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (_) {
                                    return HomeView();
                                  }));
                                } else {
                                  LoadingOverlay.of(context).hide();


                                  if(res.statusCode==404){
                                     Popups.ShowDialog(
                                          context,
                                          translator.getCurrentLang() == "en"
                                              ? "Error"
                                              : "فشل",
                                          translator.getCurrentLang() == "en"
                                              ? "Wrong Phone/Password"
                                              : "خطأ في الهاتف أو كلمة السر",
                                          btnOkPressed: () {
                                        Navigator.of(context).pop();
                                      }, type: type.DialogType.ERROR);
                                  }  else if( res.statusCode==500){
 Popups.ShowDialog(
                                          context,
                                          translator.getCurrentLang() == "en"
                                              ? ""
                                              : "",
                                          translator.getCurrentLang() == "en"
                                              ? "Server Error"
                                              : "خطأ ب الخادم",
                                          btnOkPressed: () {
                                        Navigator.of(context).pop();
                                      }, type: type.DialogType.ERROR);



                                  } else if(res.statusCode==303){

 Popups.ShowDialog(
                                          context,
                                          translator.getCurrentLang() == "en"
                                              ? ""
                                              : "",
                                          translator.getCurrentLang() == "en"
                                              ? "No Internet Connection"
                                              : "لا يوجد اتصال بالانترنت ",
                                          btnOkPressed: () {
                                        Navigator.of(context).pop();
                                      }, type: type.DialogType.ERROR);

                                  } 
                                  
                                  else if(res.statusCode==302){

 Popups.ShowDialog(
                                          context,
                                          translator.getCurrentLang() == "en"
                                              ? "Timeout"
                                              : "انتهت المهلة",
                                          translator.getCurrentLang() == "en"
                                              ? "Connection Timeout,  check your  intenet connection speed"
                                              : "انتهت مهلة الاتصال بالخادم ",
                                          btnOkPressed: () {
                                        Navigator.of(context).pop();
                                      }, type: type.DialogType.ERROR);

                                  }
                                  
                                  
                                  else {


 Popups.ShowDialog(
                                          context,
                                          translator.getCurrentLang() == "en"
                                              ? ""
                                              : "",
                                          translator.getCurrentLang() == "en"
                                              ? "Unexpected exception"
                                              : "خطأ غير معروف ",
                                          btnOkPressed: () {
                                        Navigator.of(context).pop();
                                      }, type: type.DialogType.ERROR);




                                  }

                                 
                                  //Popups.showSuccess("فشل تسجيل الدخول", "خطأ في كلمة السر أو الهاتف", _scaffoldKey.currentState, DialogType.ERROR).show();

                                
        
                                } });
    
              
                          },
                          color: Colors.greenAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                          ),
                          child: Text(
                                translator.getString("login_text"), style: TextStyle(
                            fontWeight: FontWeight.w600, 
                            fontSize: 18
                          ),),
                        ),
                      ),
                    )),
                    FadeAnimation(1.5, Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(translator.getString("no_accuount")),
                        InkWell(
              
                 onTap: (){
                   Navigator.of(context).push(MaterialPageRoute(builder: (context){
              
              
                     return SignupPage();
                   }));
                 },
              
              
                          child: Text(
                                translator.getString("signup_txt"), style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18
                          ),),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              FadeAnimation(1.2, Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover
                  )
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput({label, obscureText = false ,  Function validator ,  TextEditingController controller }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextFormField( 
          obscureText: obscureText,


          validator: validator ,controller: controller ,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
          ),
        ),
        SizedBox(height: 30,),
      ],
    );
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

}