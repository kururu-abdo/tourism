import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimWidget extends StatefulWidget {
  final String asset;
   AnimWidget({Key key, this.asset}) : super(key: key);

  @override
  _NoDataFoundState createState() => _NoDataFoundState();
}

class _NoDataFoundState extends State<AnimWidget> with  SingleTickerProviderStateMixin  {
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
    return SafeArea(
      child: Center(
    
        child:   Lottie.asset(
              this.widget.asset,
               controller: _controller,
        
          onLoaded: (composition) {
            setState(() {
              _controller.duration = composition.duration;
            });
          },
              )  ,
      ),
    );
  }

  @override
  void dispose() {

 _controller.dispose();
    super.dispose();
  }
}