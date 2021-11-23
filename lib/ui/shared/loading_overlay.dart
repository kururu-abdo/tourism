import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoadingOverlay {
  BuildContext _context;

  void hide() {
    Navigator.of(_context).pop();
  }

  void show() {
    showDialog(
        context: _context,
        barrierDismissible: false,
        builder:(context)=> _FullScreenLoader());
  }

  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
  }

  LoadingOverlay._create(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._create(context);
  }
}

class _FullScreenLoader extends StatefulWidget {
  @override
  __FullScreenLoaderState createState() => __FullScreenLoaderState();
}

class __FullScreenLoaderState extends State<_FullScreenLoader> {
RiveAnimationController _controller;


@override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('infinite');
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
        child: Center(child: 

        //circular_progress_indicator_square_medium.gif
     Image.asset("assets/anim/spinner_loader.gif" ,
     
     )
,
          ),
        
        
        
        
        );
  }
}
