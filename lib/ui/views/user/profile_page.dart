import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourapp/core/enums/widget_state.dart';
import 'package:tourapp/core/models/user.dart';
import 'package:tourapp/core/viewmodels/screens/user/user_vieemodel.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/services/shared_prefs.dart';
import 'package:tourapp/ui/shared/transition.dart';
import 'package:tourapp/ui/views/main_button.dart';
import 'package:tourapp/ui/views/user/edit_profile.dart';
import 'package:tourapp/ui/widgets/circular_loading.dart';
import 'package:tourapp/ui/widgets/number_widget.dart';
import 'package:tourapp/ui/widgets/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  var _scaffoldKey = GlobalKey<ScaffoldState>();


@override
void initState() {
  super.initState();
  Future.microtask(() async{
await context.read<UserViewmodel>().getUserById(sharedPrefs.getUserID());;

  });
}
  @override
  Widget build(BuildContext context) {
    var translator =Provider.of<TranslationProvider>(context);
    return  Directionality(
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
                   child:  Consumer<UserViewmodel>(builder: (context ,  model , _){

                      if(model.widgetState==WidgetState.Loading){
                        return CircularLoading();
                      }
            if (model.widgetState == WidgetState.Error) {
                  return Center(child: Text("error"));
                }
return ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: model.user.pic,
            onClicked: () async {},
          ),
           SizedBox(height: 24),
          buildName(model.user),
           SizedBox(height: 24),
           _buildAddress(model.user) ,
           SizedBox(height: 24),
 _buildCountry(model.user),
                    SizedBox(height: 24),
          Center(child: buildUpgradeButton()),
         //  SizedBox(height: 24),
          // NumbersWidget(),
          // const SizedBox(height: 48),
      
        ],
      );




                   }),
    
          ),
        ),
      )
    );
  }
Widget buildName(User user) => Column(
        children: [
          Text(
            user.userName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey),
          ),
           const SizedBox(height: 4),
          Text(
            user.phone,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );
 Widget buildUpgradeButton() => MainButton(
        text: "Edit",
        onPress : () {


          Navigator.of(context).push(CustomPageRoute(EditProfile()));
        },
      );


Widget _buildAddress(User user){
  return Row(
      children: [
        Icon(Icons.place),
        const SizedBox(width: 20),
        Text(
          user.address,
          style: TextStyle(color: Colors.black ,  ),
        ),
      ],
    );
}
Widget _buildCountry(User user) {
    return Row(
      children: [
        Icon(Icons.flag_outlined),
        const SizedBox(width: 20),
        Text(
          user.country.countryEnName,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }

}