import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class NoData extends StatefulWidget {
  final String msg;
  final dynamic asset;

  NoData({Key key, this.msg, this.asset  }) : super(key: key);

  @override
  _NoDataState createState() => _NoDataState();
}

class _NoDataState extends State<NoData>  with SingleTickerProviderStateMixin {
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
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              this.widget.asset,
              controller: _controller,
              onLoaded: (composition) {
                setState(() {
                  _controller.duration = composition.duration;
                });
              },
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              widget.msg,
              style: GoogleFonts.lato(
                color: Colors.blue[800],
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
