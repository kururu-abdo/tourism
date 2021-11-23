import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourapp/core/enums/widget_state.dart';
import 'package:tourapp/core/models/country.dart';
import 'package:tourapp/core/viewmodels/screens/user/user_vieemodel.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/services/shared_prefs.dart';
import 'package:tourapp/ui/shared/custom_dialog.dart';
import 'package:tourapp/ui/views/main_button.dart';
import 'package:tourapp/ui/widgets/circular_loading.dart';
import 'package:tourapp/views/user/providers/sign_up_provider.dart';
import 'package:tourapp/views/user/view/animation/FadeAnimation.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
Country _country;
  List<Country> countries = [];
TextEditingController nameCountroller = TextEditingController();
TextEditingController phoneController = TextEditingController();

  TextEditingController addressController = TextEditingController();
var _formKey  = GlobalKey<FormState>();



  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<UserViewmodel>().getUserById(sharedPrefs.getUserID());
       var data = await Provider.of<SignUpProvider>(context, listen: false)
          .getCountries();
      debugPrint(data.error.toString());

      if (!data.error) {
        if (mounted) {
          setState(() {
            countries = data.data;
          });
        }
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomAlert(
                  title: "خطأ",
                  msg: data.errorMessage,
                  alertType: AlertType.ERROR);
            });
      }


    });
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
          key: _scaffoldKey,
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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Consumer<UserViewmodel>(builder: (context, model, _) {
                if (model.widgetState == WidgetState.Loading) {
                  return CircularLoading();
                }
                if (model.widgetState == WidgetState.Error) {
                  return Center(child: Text("error"));
                }
                return Form(
                  key: _formKey,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                           FadeAnimation(
                          1.2,
                          makeInput(
                              label: "Name",
                            
                              controller: nameCountroller,
                              inputType: TextInputType.text)),
                 FadeAnimation(
                          1.2,
                          makeInput(
                              label: "Phone",
                             
                              controller: phoneController,
                              inputType: TextInputType.number)),
                
                 FadeAnimation(
                          1.4,
                          makeInput(
                              label: "Address",
                          
                              controller: addressController)),
                          
                FadeAnimation(
                        1.4,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "country",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                            ),
                            DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<Country>(
                              validator: (country) {
                                if (country == null) {
                                  return "هذا الحقل مطلوب";
                                }
                
                                return null;
                              },
                              decoration: InputDecoration(
                                labelStyle: Theme.of(context)
                                    .primaryTextTheme
                                    .caption
                                    .copyWith(color: Colors.black),
                                border: const OutlineInputBorder(),
                              ),
                
                              isExpanded: true,
                
                              isDense:
                                  true, // Reduces the dropdowns height by +/- 50%
                
                              icon: Icon(Icons.keyboard_arrow_down),
                
                              value: _country,
                
                              items: countries.map((item) {
                                return DropdownMenuItem<Country>(
                                    value: item, child: Text(item.countryArName));
                              }).toList(),
                
                              onChanged: (selectedItem) => setState(
                                () => _country = selectedItem,
                              ),
                            )),
                          ],
                        ),
                      ),
                          SizedBox(height: 30,),
                      buildUpgradeButton(model)
                    ],
                  ),
                );
              }),
            ),
          ),
        ));
  }

  Widget buildUpgradeButton(UserViewmodel model) => MainButton(
        text: "Save",
        onPress: () async{
        if (_formKey.currentState.validate()) {
          //Save data
          await  model.updateUser(nameCountroller.text, phoneController.text, addressController.text,_country.countryId);
        }
        },
      );



      
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




}
