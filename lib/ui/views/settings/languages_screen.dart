import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int languageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var translator=Provider.of<TranslationProvider>(context);

    return Directionality(
      textDirection: translator.getCurrentLang()=="en"?TextDirection.ltr:TextDirection.rtl ,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading:  IconButton(onPressed: (){
    Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios , color:  Colors.black,)),
          title: Text(
          translator.getCurrentLang()=="en"?
          
          'Languages':"اللغات",   style: TextStyle(color:Colors.black,))),
        body: SettingsList(
          backgroundColor: Colors.white,
          sections: [
            SettingsSection(tiles: [
              SettingsTile(
                title: "English",
                trailing: trailingWidget(0),
                onPressed: (BuildContext context) {
                  translator.translator.translate("en");
                  changeLanguage(0);
                },
              ),
              SettingsTile(
                title: "Arabic",
                trailing: trailingWidget(1),
                onPressed: (BuildContext context) {
                                    translator.translator.translate("ar");

                  changeLanguage(1);
                },
              ),
            
            ]),
          ],
        ),
      ),
    );
  }

  Widget trailingWidget(int index) {
    return (languageIndex == index)
        ? Icon(Icons.check, color: Colors.blue)
        : Icon(null);
  }

  void changeLanguage(int index) {
    setState(() {
      languageIndex = index;
    });
  }
}
