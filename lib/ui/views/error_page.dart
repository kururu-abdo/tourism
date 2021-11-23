import 'package:flutter/material.dart';
import 'package:flutter_translator/flutter_translator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/services/constants.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/ui/shared/my_theme_data.dart';
import 'package:tourapp/ui/views/main_button.dart';

class ErrorPage extends StatefulWidget {
 final  AppException error;
 final   String asset;
 final VoidCallback onPress;
 final String msg;
   ErrorPage({ Key key, this.asset, this.onPress, this.msg, this.error }) : super(key: key);

  @override
  _ErrorWidgetState createState() => _ErrorWidgetState();
}

class _ErrorWidgetState extends State<ErrorPage>  with SingleTickerProviderStateMixin  {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 AnimationController _controller;

 @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this)
      ..value = 0.5
      ..addListener(() {
        setState(() {
          // Rebuild the widget at each frame to update the "progress" label.
        });
      });
    _controller.repeat(period: Duration(seconds: 2));
  }
  @override
  Widget build(BuildContext context) {
        var translator = Provider.of<TranslationProvider>(context);

    return Theme(
        data: MyThemeData.buildLightTheme(),
        child: Container(
          child: Directionality(
            textDirection: translator.getCurrentLang() == "en"
                ? TextDirection.ltr
                : TextDirection.rtl,
            child: Scaffold(
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
          ),),
body: SafeArea(child: 
Center(
    
        child:   Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
                  getAsset(context, widget.error),
                   controller: _controller,
            
              onLoaded: (composition) {
                setState(() {
                  _controller.duration = composition.duration;
                });
              },
                  ),
              
            Text(
              widget.msg,
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
 MainButton(

   text: translator.getCurrentLang()=="en"?"Retry":"حاول مجددا",
   onPress: widget.onPress,
 )


          ],
        )  ,
      ),

),
               
            )
          )
        )
    );
  }


String getAsset(BuildContext context, AppException appException) {
    if (appException is UnauthorisedException) {
      return UNKNOWN;
    } else if (appException is ServerException) {
      return SERVERER;
    } else if (appException is ConnectionException) {
      return NOINTERNET;
    } else {
      return UNKNOWN;
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}