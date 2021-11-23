import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tourapp/core/utils/constants.dart';


class SearchingWidgte extends StatefulWidget {

   SearchingWidgte({Key key}) : super(key: key);

  @override
  _SearchingWidgteState createState() => _SearchingWidgteState();
}

class _SearchingWidgteState extends State<SearchingWidgte>  with SingleTickerProviderStateMixin {

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
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(bottom: 40),
        height: 50,
        width: 50,
        alignment: Alignment.center,
        child: 
      Lottie.asset(
          SEARCH,
          controller: _controller,
          onLoaded: (composition) {
            setState(() {
              _controller.duration = composition.duration;
            });
          },
        ),
      ),
    );
   
  }
   @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
