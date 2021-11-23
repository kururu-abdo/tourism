import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/ui/shared/transition.dart';
import 'package:tourapp/ui/views/user/reset_password.dart';

import 'languages_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
        var translator = Provider.of<TranslationProvider>(context);

    return Directionality(
      textDirection: translator.getCurrentLang()=="en"?TextDirection.ltr :  TextDirection.rtl   ,
      child: Scaffold(
        appBar: AppBar(title: Text(
          
          translator.getCurrentLang()=="en"?
          'Settings UI': "الاعدادات" , style: TextStyle(color: Colors.black),) ,
        elevation: 0.0, 
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios , color: Colors.black,))
    
        ,  backgroundColor: Colors.white  ,),
    
    
        body: buildSettingsList(),
      ),
    );
  }

  Widget buildSettingsList() {
    return SettingsList(
      backgroundColor: Colors.white,
      sections: [
        SettingsSection(
          title:
           'Common',
          tiles: [
            SettingsTile(
              title: 'Language',
              subtitle: 'English',
              leading: Icon(Icons.language),
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => LanguagesScreen(),
                ));
              },
            ),


             SettingsTile(
              title: 'Location',
              subtitle: 'Enable Location',
              leading: Icon(Icons.location_on),
              onPressed: (context) {
               
              },
            ),
            // SettingsTile(
            //   title: 'Theme',
            //   subtitle: 'Production',
            //   leading: Icon(Icons.cloud_queue),
            // ),
          ],
        ),
        SettingsSection(
          title: 'Account',
          tiles: [
            SettingsTile(title: 'Change Password', leading: Icon(Icons.phone) , onTap: (){

Navigator.of(context).push(CustomPageRoute(EditPassword()));
            },),
         //   SettingsTile(title: 'Email', leading: Icon(Icons.email)),
            // SettingsTile(title: 'Sign out', leading: Icon(Icons.exit_to_app)),
          ],
        ),
  
    
      ],
    );
  }
}
