import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/ui/views/main_button.dart';
class ErrorScreen extends StatefulWidget {
String img;
VoidCallback onPress;
String msg;

  ErrorScreen({Key key , this.img , this.msg , this.onPress  }) : super(key: key);

  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen>  with  SingleTickerProviderStateMixin  {
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
    var translator = Provider.of<TranslationProvider>(context);
    return Container(
   width: double.infinity,
   child: Column(children: [

     SizedBox(height:MediaQuery.of(context).size.height/4/2) ,
     Center(child: SizedBox(
       height: 150,
       child: Lottie.asset(
                this.widget.img,
                 controller: _controller,
          
            onLoaded: (composition) {
              setState(() {
                _controller.duration = composition.duration;
              });
            },
                ),
     )  ,) ,
     SizedBox(height: 15,) ,
     Center( child: Text(widget.msg  ,  style: TextStyle(fontSize: 14 ,  ),),) ,
          // Spacer(),
Center(child: MainButton(onPress: widget.onPress,  text: translator.getString("refresh_txt"),),)

   ],),



    );
  }

 @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}