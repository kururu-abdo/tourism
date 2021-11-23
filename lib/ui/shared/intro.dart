import 'package:flutter/material.dart';
import 'package:nice_intro/intro_screen.dart';
import 'package:nice_intro/intro_screens.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/shared_prefs.dart';
import 'package:tourapp/ui/shared/my_theme_data.dart';
import 'package:tourapp/ui/views/home/home.dart';
import 'package:tourapp/ui/views/user/login.dart';

import '../../main.dart';
// import 'package:tourapp/views/login/login_screen_6.dart';
// import 'package:tourapp/views/signup/signup_screen_6.dart';
class Intro extends StatefulWidget   {
  const Intro({ Key key }) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<Intro> with RouteAware {
String baseUrl;
@override
  void initState() {
   
      API.getAppBaseUrl().then((value) {
        
         if(!value.error){
           debugPrint("BASE URL FROM CLOUD STORAGE  "+value.data);
         setState(() {
             baseUrl = value.data;

          sharedPrefs.SaveBaseUrl(baseUrl);
         });
         }
      });


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
List<IntroScreen> pages = [
      IntroScreen(
        title: 'البحث عن الاماكن السياحية',
        imageAsset: 'assets/images/a.png',
        description: 'يمكنك العثور الاماكن السياحية بكل سهولة',
        headerBgColor: Colors.white,
      ),
      IntroScreen(
        title: 'المرافق السياحية',
        headerBgColor: Colors.white,
        imageAsset: 'assets/images/b.png',
        description:
            "اكتشف المرافق المجاورة للاماكن السياحية  كالمطاعم و الفنادق",
      ),
      IntroScreen(
        title: 'الاماكن الاكثر جاذبية',
        headerBgColor: Colors.white,
        imageAsset: 'assets/images/tour2.webp',
        description: "يمكنك معرفة المواقع الاكثر جاذبية من خلال تفاعل الزوار ",
      ),
    ];



IntroScreens introScreens = IntroScreens(
  
      footerBgColor: MyThemeData.buildLightTheme().primaryColor ,
      //TinyColor(Color.fromARGB(255, 105, 240, 174)).lighten().color,
      activeDotColor: Colors.white,
      footerRadius: 18.0,
      
      indicatorType: IndicatorType.CIRCLE,
    
      onDone: (){
  sharedPrefs.changeShownBefore(true);

        Navigator.of(context).push(MaterialPageRoute(builder:
        (context) =>              onDone()
        
        //SignUpScreen6()
        
         ));
      },
      onSkip: (){
          sharedPrefs.changeShownBefore(true);

         Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => 
             onDone()
           
             ));
              
              //SignUpScreen6()));
      },
      skipText: "تخطي",
      footerPadding: EdgeInsets.all(0),
      textColor: Colors.white,
      slides:pages  );





    return Scaffold(
   //  appBar: AppBar(backgroundColor: Colors.white , elevation: 0.0,),
      body: introScreens,
    );
  }

Widget onDone(){
  if(sharedPrefs.isLoggedIn()){
    return HomeView();
  }else {

    return LoginPage();
  }
}
    @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    final route = ModalRoute.of(context).settings.name;
    print('didPush route: $route');
  }

  @override
  void didPopNext() {
    final route = ModalRoute.of(context).settings.name;
    print('didPopNext route: $route');
  }

  @override
  void didPushNext() {
    final route = ModalRoute.of(context).settings.name;
    print('didPushNext route: $route');
  }

  @override
  void didPop() {
    final route = ModalRoute.of(context).settings.name;
    print('didPop route: $route');
  }
}