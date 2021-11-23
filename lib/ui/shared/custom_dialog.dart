import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:tourapp/views/user/view/animation/FadeAnimation.dart';
import 'package:tourapp/ui/views/user/login.dart';



enum AlertType{
  SUCCESS , WARNING , ERROR
}
class CustomAlert extends StatefulWidget {
 final  AlertType alertType ;
  final String title;
final String msg;
VoidCallback onPress;
   CustomAlert({Key key, this.alertType, this.title, this.msg ,   this.onPress}) : super(key: key);

  @override
  _CustomAlertState createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {


  RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('show');
  
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 220,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                child: Column(
                  children: [
                    Text(
                      widget.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.msg,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                 TextButton(
                      onPressed:widget.onPress,
                      
                     
                      
                      child: Text(
                        "OK",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: -60,
            child:  
  Container(
  height: 80,  
    decoration: BoxDecoration(
      shape: BoxShape.circle
    ),
  /// child:
    
    //  widget.alertType==AlertType.SUCCESS?

    //              RiveAnimation.asset(
    //             'assets/anim/success.riv',
    //           ) :  
              
    //             RiveAnimation.asset(
    //         'assets/anim/success.riv',
            
    //         ),
            
  )
                
                ),
          ],
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
