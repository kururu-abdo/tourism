import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tourapp/core/enums/dialog_type.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/ui/shared/my_theme_data.dart';

class CustomDialog extends StatefulWidget {
  final String title, description ;
   DialogType type= DialogType.INFO;
  final VoidCallback btnOkPressed;
    final VoidCallback btnCacelPressed;


  CustomDialog({
    @required this.title,
    @required this.description,
    this.type, this.btnOkPressed, this.btnCacelPressed
  });

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog>   with  SingleTickerProviderStateMixin{
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
      _controller.repeat(period: Duration(seconds: 2)  );
    
}
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyThemeData.buildLightTheme(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context),
      ),
    );
  }

  dialogContent(BuildContext context) {
                var translator = Provider.of<TranslationProvider>(context);

    return Directionality(textDirection: translator.getCurrentLang()=="en"?TextDirection.ltr:TextDirection.rtl, 
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 66.0 + 16.0 * 12,
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            margin: EdgeInsets.only(top: 66.0),
            decoration: new BoxDecoration(
              color: Colors.white, //Colors.black.withOpacity(0.3),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: getButtons(context, widget.type)
                  
                  //  FlatButton(
                  //   color: Colors.amber,
                  //   onPressed: () {
                  //     Navigator.of(context).pop(); // To close the dialog
                  //   },
                  //   child: Text(
                  //     widget.buttonText,
                  //     style: TextStyle(
                  //       color: Colors.purple,
                  //     ),
                  //   ),
                  // ),
    
    
    
                ),
              ],
            ),
          ),
          Positioned(
            top: -1.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              height: 100,
              width: 100,
              child: CircleAvatar(
              
                radius: 150,
                child:Center(
      
          child:   Lottie.asset(
                getAsset(context,   this.widget.type),
                   controller: _controller,
          
              onLoaded: (composition) {
                setState(() {
                  _controller.duration = composition.duration;
                });
              },
                  )  ,
        ), 
                // backgroundImage: NetworkImage(
                //   '<https://upload.wikimedia.org/wikipedia/commons/1/1d/Rotating_Konarka_chaka.gif>',
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getButtons(BuildContext context ,DialogType type){
            var translator = Provider.of<TranslationProvider>(context);

         switch (type) {
           case   DialogType.ERROR :
        return   InkWell(
                onTap: widget.btnOkPressed,
                child: Container(
                  width: 250,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                       translator. getCurrentLang() == "en" ? "OK" : "حسنا",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              );

          case DialogType.INFO:
          return  InkWell(
                onTap: widget.btnOkPressed,
                child: Container(
                  width: 250,
            height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                       translator. getCurrentLang() == "en" ? "OK" : "حسنا",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              );

          case DialogType.SUCCESS:
      return      InkWell(
                onTap: widget.btnOkPressed,
                child: Container(
                  width: 250,
            height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                       translator. getCurrentLang() == "en" ? "OK" : "حسنا",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              );

           default:
            return Container(
          margin: EdgeInsets.only(top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: widget.btnOkPressed,
                child: Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                       translator. getCurrentLang() == "en" ? "OK" : "نعم",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),

 InkWell(
                onTap: widget.btnOkPressed,
                child: Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                       translator. getCurrentLang() == "en" ? "Cancel" : "إلغاء",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),




            ],
          ),
        );
         }



  }

String  getAsset(BuildContext context ,DialogType type) {

         switch (type) {
      case DialogType.ERROR:
             return ERROR;

      case DialogType.INFO:
       return INFO;
      case DialogType.SUCCESS:
        return SUCCESS;

      default:
      return CONFIRM;
    }



}



 @override
  void dispose() {

 _controller.dispose();
    super.dispose();
  }
}
