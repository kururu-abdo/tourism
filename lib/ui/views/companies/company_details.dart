import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:social_media_buttons/social_media_button.dart';
import 'package:tourapp/core/models/company.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyDetails extends StatefulWidget {
  final Company company;
  CompanyDetails(this.company);

  @override
  _CompanyDetailsState createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  @override
  Widget build(BuildContext context) {
    var translator = Provider.of<TranslationProvider>(context);

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 100.0),
        Icon(
          Icons.location_city,
          color: Colors.white,
          size: 40.0,
        ),
        Container(
          width: 90.0,
          child: new Divider(color: Colors.green),
        ),
        SizedBox(height: 10.0),
        Text(
          translator.getCurrentLang() == "en"
              ? widget.company.enName
              : widget.company.arName,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        SizedBox(height: 30.0),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/company.jpg"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: SingleChildScrollView(
            child: Center(
              child: topContentText,
            ),
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText2 = new Expanded(
        flex: 1,
        child: new SingleChildScrollView(
          scrollDirection: Axis.vertical, //.horizontal
          child: new Text(
            translator.getCurrentLang() == "en"
                ? widget.company.enAbout
                : widget.company.arAbout,
            style: TextStyle(fontSize: 15.0),
          ),
        ));

    final bottomContentText = ReadMoreText(
      translator.getCurrentLang() == "en"
          ? widget.company.enAbout
          : widget.company.arAbout,
      style: TextStyle(fontSize: 15.0),
      trimLines: 5,
      colorClickableText: Colors.pink,
      trimMode: TrimMode.Line,
      trimCollapsedText:
          translator.getCurrentLang() == "en" ? 'Show more' : "عرض أكثر",
      trimExpandedText:
          translator.getCurrentLang() == "en" ? 'Show less' : "عرض أقل",
      moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () => {

          },
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child: Text("Contact us", style: TextStyle(color: Colors.white)),
        ));
    final contacts = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialMediaButton
          .whatsapp(
          url: "https://whatsapp.me/${widget.company.whatsapp}",
          size: 35,
          color: Colors.green,
        ) ,

       SocialMediaButton.google(
         url: 'mailto:<${widget.company.email}>?subject=<subject>&body=<body>',
         onTap: () async{
          

            launch("mailto:<${widget.company.email}>?subject=<subject>&body=<body>");
         },
          size: 35,
          color: Colors.red,
       
       ) 
      ],
    );
    final bottomContent = Container(
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Theme.of(context).primaryColor,
    
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[bottomContentText, contacts],
        ),
      ),
    );

    return Directionality(
      textDirection: translator.getCurrentLang() == "en"
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: <Widget>[topContent, bottomContent],
        ),
      ),
    );
  }
}
