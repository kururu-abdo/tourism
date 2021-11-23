import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourapp/core/enums/widget_state.dart';
import 'package:tourapp/core/viewmodels/screens/user/user_vieemodel.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/services/shared_prefs.dart';
import 'package:tourapp/ui/shared/loading_widget.dart';
import 'package:tourapp/ui/views/main_button.dart';
import 'package:tourapp/ui/widgets/circular_loading.dart';
import 'package:tourapp/views/user/view/animation/FadeAnimation.dart';

class EditPassword extends StatefulWidget {
  EditPassword({Key key}) : super(key: key);

  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  var _ScaffolKey = GlobalKey<ScaffoldState>();

var _formKey = GlobalKey<FormState>();

   @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<UserViewmodel>().getUserById(sharedPrefs.getUserID());

     } );
  }
  TextEditingController passwordController = TextEditingController();


  String passwordValidation(String str) {
    if (str.length < 0 || str == null) {
      return "هذا الحقل مطلوب";
    }

    return null;
  }



  @override
  Widget build(BuildContext context) {
   var translator = Provider.of<TranslationProvider>(context);
    return Directionality(
        textDirection: translator.getCurrentLang() == "en"
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          key: _ScaffolKey,
          appBar: AppBar(
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
          body:
           Consumer<UserViewmodel>(
             builder: (context, model, _) {
            
              if (model.widgetState == WidgetState.Loading) {
                  return LoadingWidget();
                }
                if (model.widgetState == WidgetState.Error) {
                  return Center(child: Text("error"));
                }
          
          
        return    SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                     child:       
                       Form(
                         key: _formKey,
                         child: Column(
                           children: [
                             FadeAnimation(1.3, makeInput(label: "Password", obscureText: true ,   validator: passwordValidation ,   controller: passwordController      )),
                             Spacer() ,
                             buildUpgradeButton(model)
                           ],
                         ),
                       ),

                 
                   
              ),
            ),
          );
           })
        )
          );
  }



       
  Widget makeInput(
      {label,
      obscureText = false,
      Function validator,
      TextEditingController controller,
      TextInputType inputType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          obscureText: obscureText,
          keyboardType: inputType ?? TextInputType.text,
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
  Widget buildUpgradeButton(UserViewmodel   model) => MainButton(
        text: "Updae",
        onPress: ()async{

  if(_formKey.currentState.validate()){
    await model.resetPassword(passwordController.text);
  }

        },
      );


}