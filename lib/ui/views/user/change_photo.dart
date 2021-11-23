import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tourapp/core/enums/dialog_type.dart';
import 'package:tourapp/core/viewmodels/screens/user/user_vieemodel.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/shared_prefs.dart';
import 'package:tourapp/ui/shared/popups.dart';
import 'package:tourapp/ui/views/main_button.dart';

class EditPicture extends StatefulWidget {
  EditPicture({Key key}) : super(key: key);

  @override
  _EditPictureState createState() => _EditPictureState();
}

class _EditPictureState extends State<EditPicture> {
  var _ScaffolKey = GlobalKey<ScaffoldState>();
  bool isloaded = false;
 bool _isLoading= false;
  String pic = "";
  File _image;
  final picker = ImagePicker();

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
          var data = json.decode(value);

          setState(() {
            isloaded = true;
            pic = data["path"];
            print(pic);
          });
        });
        break;

      default:
        setState(() {
          isloaded = true;
          pic = "";
        });
    }
    // listen for response
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
          body: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _image != null
                          ? MemoryImage(_image.readAsBytesSync())
                          : NetworkImage(API.url +
                              sharedPrefs.getUserIMage()),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amberAccent),
                          child: IconButton(
                              onPressed: () async {
                                showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => bottomSheet()),
                                );
                              },
                              icon: Icon(Icons.photo)),
                        ))
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.all(10),
                  child:
                  _isLoading?Center(child: CircularProgressIndicator(strokeWidth: 1.5,),)
                  :
                   MainButton(
                    onPress: () {
                      if (_image != null) {
                        setState(() {
                                _isLoading = true;
                              });
                        upload(_image).then((pic2) async {
                          API.updatePhoto(pic).then((value) {
                            if (!value.error) {
                              setState(() {
                                _isLoading=false;
                              });
                              Popups.ShowDialog(
                                  context,
                                  translator.getCurrentLang() == "en"
                                      ? "Success"
                                      : "نجاح",
                                  translator.getCurrentLang() == "en"
                                      ? "Photo updated Succesfully"
                                      : "تم تحديث الصورة بنجاح",
                                  btnOkPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }, type: DialogType.SUCCESS);
                            } else {
                                setState(() {
                                _isLoading = false;
                              });
                              Popups.ShowDialog(
                                  context,
                                  translator.getCurrentLang() == "en"
                                      ? "Failed"
                                      : "لم يتم",
                                  translator.getCurrentLang() == "en"
                                      ? "Photo update Failed"
                                      : "فشل تحديث الصورة",
                                  type: DialogType.ERROR, btnCacelPressed: () {
                                Navigator.pop(context);
                              });
                            }
                          });
                        });
                      }
                    },
                    text: translator.getCurrentLang() == "en"
                        ? "Update"
                        : "تحديث الصورة",
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget buildUpgradeButton(UserViewmodel model) => MainButton(
        text: "Update Photo",
        onPress: () async {},
      );
}
