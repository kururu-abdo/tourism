import 'dart:convert';
import 'dart:io';
import 'dart:ffi';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:tourapp/core/enums/dialog_type.dart';
import 'package:tourapp/core/enums/view_state.dart';
import 'package:tourapp/core/models/country.dart';
import 'package:tourapp/core/models/user.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/main.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/ui/shared/app_colors.dart';
import 'package:tourapp/ui/shared/custom_dialog.dart';
import 'package:tourapp/ui/shared/loading_overlay.dart';
import 'package:tourapp/services/validation.dart';
import 'package:tourapp/ui/shared/popups.dart';
import 'package:tourapp/viewmodels/sign_up_viewModel.dart';
import 'package:tourapp/viewmodels/trip_viewmodel.dart';
import 'package:tourapp/views/user/providers/sign_up_provider.dart';
import 'package:tourapp/views/user/view/animation/FadeAnimation.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
    bool isloaded = false;
var _formKey =   GlobalKey<FormState>();
var _ScaffolKey = GlobalKey<ScaffoldState>();

Country  _country;
List<Country>  countries =[] ;
String pic = "";
File _image;
  final picker = ImagePicker();
Country country;














  Future<void> getImage(src) async {
    final pickedFile = await picker.getImage(source: src);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  upload(File imageFile) async {
   
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("${API.url}upload");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: path.basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);
switch (response.statusCode) {
  case 200:
     response.stream.transform(utf8.decoder).listen((value) {
       debugPrint("//////////////////");

       debugPrint(value);
var data  = json.decode(value);

         setState(() {
           isloaded =  true;
           pic =  data["path"];
           print(pic);
         });
                 return data["path"];

        }
        
        );
    break;


    
  default:
   setState(() {
          isloaded = true;
          pic = "";
        });
        return "";
}
    // listen for response
   
  }
TextEditingController  nameCountroller =  TextEditingController();
String nameValidation(String str){
  if(str.length<=0  ){
return Provider.of<TranslationProvider>(context , listen: false).getString("required_txt");
  }


  return null;
}

TextEditingController phoneController = TextEditingController();
  String phoneValidation(String str) {
    if (str.length < 0 || str == null) {
    return Provider.of<TranslationProvider>(context, listen: false)
          .getString("required_txt");

    }
 if (  !Validators.isValidPhoneNumber(str)) {
       return Provider.of<TranslationProvider>(context , listen: false).getString("phone_format");

    }

  

    return null;
  }






TextEditingController emailCountroller = TextEditingController();
  String emailValidation(String str) {
    if (str.length <= 0    ) {
      return Provider.of<TranslationProvider>(context, listen: false)
          .getString("required_txt");
    }
 if (!Validators.isValidEmail(str)) {
      return Provider
          .of<TranslationProvider>(context, listen: false)
          .getString("email_format");
    }

    return null;
  }




TextEditingController passwordController = TextEditingController();
  String passwordValidation(String str) {
    if (str.length <= 0 ) {
      return Provider.of<TranslationProvider>(context, listen: false)
          .getString("required_txt");
    }
   

    return null;
  }





TextEditingController addressController = TextEditingController();
  String addressValidation(String str) {
    if (str.length <= 0) {
      return Provider.of<TranslationProvider>(context, listen: false)
          .getString("required_txt");
    }

    return null;
  }




      @override
      void initState() { 
        super.initState();



//         Future.microtask(()  async{

//   var data =await   Provider.of<SignUpProvider>(context  ,  listen: false).getCountries();
// debugPrint(data.error.toString());

//      if (!data.error) {
//      if (mounted) {
//          setState(() {
//             countries = data.data;
//           });
        
//        }
//      }else{
//        showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return CustomAlert(
//                   title: "خطأ",
//                   msg: data.errorMessage,
//                   alertType: AlertType.ERROR);
//             });
//      }





//         });
      }


  @override
  Widget build(BuildContext context) {
                var translator = Provider.of<TranslationProvider>(context);

    return Directionality(
       textDirection: translator.getCurrentLang()=="en"?TextDirection.ltr:TextDirection.rtl,
      child: ViewModelBuilder<SignUpViewModel>.reactive(
        
        onModelReady: (model)async{
await model.getCountries();
        },
        builder: (context , model , _){


         if(model.state==ViewState.Error){
           return       model.getErrWidget(model.exception, () async{
await model.getCountries();


            }) ;
           
           
       //    getErrorWidget(model.exception, model.exception.toString(), "", (){


       //    });
         }
      
 return      Scaffold(
        resizeToAvoidBottomInset: true,
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
            icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
    
     Stack(
                              children: [
                                _image != null
                                    ? CircleAvatar(
                                        maxRadius: 70.0,
                                        backgroundColor: AppColors.primaryColor,
                                        backgroundImage: 
                                          MemoryImage(
                                                    _image.readAsBytesSync())
                                               
    
                                        // user.pic!.length<1 ?
                                        //  AssetImage(
                                        //   "images/time.jpg",
                                        // )
                                        // :
                                        // base64image.startsWith("htt")?
    
                                        // NetworkImage(API.imgUrl+base64image):
    
                                        // NetworkImage(API.imgUrl+base64image):
    
                                        // :
                                        // MemoryImage(_image.readAsBytesSync())
    
                                        // as ImageProvider
    
                                        // ,
                                        )
                                    : Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            border: Border.all(
                                                width: 1.5,
                                                color: AppColors
                                                    .primaryColor)),
                                        child: Center(
                                            child: Icon(
                                          Icons.person,
                                          size: 80.0,
                                          color: AppColors.primaryColor,
                                        ))),
                                Positioned(
                                  bottom: 5.0,
                                  child: Container(
                                    padding: EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        color: AppColors.primaryColor),
                                    child: IconButton(
                                        onPressed: () {
                                        
                                         showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
                                        
                                        } ,
    
                                          //  getImage(ImageSource.gallery),
                                        icon: Icon(Icons.photo_camera,
                                            color: Colors.white, size: 20.0)),
                                  ),
                                )
                              ],
                            ),
                           
                        SizedBox(
                          height: 10,
                        ),
    
    
    
    
    
                  Column(
                    children: <Widget>[
                      FadeAnimation(1, Text(
                          translator.getString("sign_up")
                        
                      , style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),)),
                      SizedBox(height: 20,),
                     
                    ],
                  ),
                  Column(
                    children: <Widget>[
             FadeAnimation(1.2, makeInput(label: translator.getString("name_txt") ,   validator: nameValidation ,  controller: nameCountroller  , inputType: TextInputType.text)),
             FadeAnimation(1.2, makeInput(label: translator.getString("phone_txt") ,   validator: phoneValidation ,  controller: phoneController ,
                              inputType: TextInputType.number)),
            
            
                      FadeAnimation(1.2, makeInput(label:  translator.getString("email_txt")  ,   validator: emailValidation ,  controller: emailCountroller  )),
            
             FadeAnimation(
                          1.4,
                          makeInput(
                            label: translator.getString("address_txt"),   validator: addressValidation ,  controller: addressController
                          )),
            
            
                      FadeAnimation(1.3, makeInput(label: translator.getString("password_txt"), obscureText: true ,   validator: passwordValidation ,   controller: passwordController      )),
            
            
            FadeAnimation(  1.4,
                 Column(
              
              
              
              
              
              
              
                  crossAxisAlignment: CrossAxisAlignment.start,
              
                    children: <Widget>[
              
              Text(
                translator.getString("country")
                
           , style: TextStyle(
              
                fontSize: 15,
              
                fontWeight: FontWeight.w400,
              
                color: Colors.black87
              
              ),),
              
              DropdownButtonHideUnderline(
              
                  
              
                child: DropdownButtonFormField<Country>(
            
            
                  validator: (country){
                    if (country==null) {
                     return translator.getString("required_txt"); 
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
              
                  
              
                  isDense: true, // Reduces the dropdowns height by +/- 50%
              
                  
              
                  icon: Icon(Icons.keyboard_arrow_down),
              
                  
              
                  value:_country,
              
                  
              
                  items:model.countries.map((item) {
              
                  
              
                    return DropdownMenuItem<Country>(
              
                  
              
                      value: item,
              
                  
              
                      child: Text(item.countryArName)
              
                  
              
                    );
              
                  
              
                  }).toList(),
              
                  
              
                  onChanged: (selectedItem) => setState(() => _country = selectedItem,
              
                  
              
                ),
              
                  
              
                )
              
                  
              
              ),
              
                ],
              
              ),
            ),
            
            
            SizedBox(height: 30,)
            
            
            
            
                     
                    ],
                  ),
                  FadeAnimation(1.5, Container(
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
    if (_formKey.currentState.validate()) {
    
    
    if(_image!=null) {
    
var pic= await upload(_image);
     
    var user = User(
                                    userName: nameCountroller.text,
                                    
                                    email: emailCountroller.text,
                                    phone: phoneController.text,
                                    password: passwordController.text,
                                    address: addressController.text,
                                    country: _country   ,pic: pic     );
    
                                LoadingOverlay.of(context).show();
    
                                var res = await Provider.of<SignUpProvider>(
                                        context,
                                        listen: false)
                                    .newUser(user);
    
                                if (!res.error) {
                                  LoadingOverlay.of(context).hide();
    
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return CustomAlert(
                                  //           title: "نجاح",
                                  //           msg: "تم التسجل بنجاح",
                                  //           alertType: AlertType.SUCCESS);
                                  //     });

                                             Popups.ShowDialog(
                                              context,
                                              translator.getCurrentLang() ==
                                                      "en"
                                                  ? "Done"
                                                  : "تم",
                                              translator.getCurrentLang() ==
                                                      "en"
                                                  ? "Signup done successfully"
                                                  : "تم التسجيل بنجاح",
                                              btnOkPressed: () {
                                            Navigator.of(context).pop();
                                          }, type: DialogType.SUCCESS);
                                } else {
                                  LoadingOverlay.of(context).hide();

 Popups.ShowDialog(
                                              context,
                                              translator.getCurrentLang() ==
                                                      "en"
                                                  ? "Error"
                                                  : "خطأ",
                                              translator.getCurrentLang() ==
                                                      "en"
                                                  ? "Signup Failed , Try Again"
                                                  :                                                 "فشل في التسجيل  ,  الرجاء المحاولة مرة اخرى",

                                              btnOkPressed: () {
                                            Navigator.of(context).pop();
                                          }, type: DialogType.ERROR);    
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return CustomAlert(
                                  //           title: "خطأ",
                                  //           msg:
                                  //               "فشل في التسجيل  ,  الرجاء المحاولة مرة اخرى",
                                  //           alertType: AlertType.ERROR);
                                  //     });
                              
                              
                              
                              
                              
                                }
    }else{
      
    var user = User(
                                    userName: nameCountroller.text,
                                    email: emailCountroller.text,
                                    phone: phoneController.text,
                                    password: passwordController.text,
                                    address: addressController.text,
                                    pic: "",
                                    country: _country);
    
                                LoadingOverlay.of(context).show();
    
                                var res = await Provider.of<SignUpProvider>(
                                        context,
                                        listen: false)
                                    .newUser(user);
    
                                if (!res.error) {
                                  LoadingOverlay.of(context).hide();
    
                                
                                             Popups.ShowDialog(
                                              context,
                                              translator.getCurrentLang() ==
                                                      "en"
                                                  ? "Done"
                                                  : "تم",
                                              translator.getCurrentLang() ==
                                                      "en"
                                                  ? "Signup done successfully"
                                                  : "تم التسجيل بنجاح",
                                              btnOkPressed: () {
                                            Navigator.of(context).pop();
                                          }, type: DialogType.SUCCESS);
                                } else {
                                  LoadingOverlay.of(context).hide();
    
                              Popups.ShowDialog(
                                              context,
                                              translator.getCurrentLang() ==
                                                      "en"
                                                  ? "Error"
                                                  : "خطأ",
                                              translator.getString(res.errorMessage) ,
                                              
                                              // .getCurrentLang() ==
                                              //         "en"
                                              //     ? "Signup Failed , Try Again"
                                              //     : "فشل في التسجيل  ,  الرجاء المحاولة مرة اخرى"
                                                  
                                              //     ,
                                              btnOkPressed: () {
                                            Navigator.of(context).pop();
                                          }, type: DialogType.ERROR);    
                                }
    }
    
    
    
    
    }
    
    
    
    
                      },
                      color: Colors.greenAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text(
                            translator.getString("sign_up"), style: TextStyle(
                        fontWeight: FontWeight.w600, 
                        fontSize: 18
                      ),),
                    ),
                  )),
                  FadeAnimation(1.6, Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(translator.getString("already_txt")),
                      Text(
                            translator.getString("login_text"), style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18
                      ),),
                    ],
                  )),
            
            
            
            
                ],
              ),
            ),
          ),
        ),
      );
      }, viewModelBuilder: ()=>SignUpViewModel())
      
      
      
    );
  }

  Widget makeInput({label, obscureText = false ,  Function validator ,  TextEditingController controller  ,TextInputType inputType }) {
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

    keyboardType: inputType?? TextInputType.text,
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








 Widget bottomSheet() {
    return Container(
      height: 150.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                getImage(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }












  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

}