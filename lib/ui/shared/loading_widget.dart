import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({ Key key }) : super(key: key);

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>   with SingleTickerProviderStateMixin {
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
    return Center(
       child: Lottie.asset(
       "assets/loding.json",
        controller: _controller,
        onLoaded: (composition) {
          setState(() {
            _controller.duration = composition.duration;
          });
        },
      ),
    );
  }

    @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}