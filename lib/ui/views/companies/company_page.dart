import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:tourapp/core/enums/view_state.dart';
import 'package:tourapp/core/viewmodels/screens/company/company_viewmodel.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/ui/shared/app_colors.dart';
import 'package:tourapp/ui/shared/loading_widget.dart';
import 'package:tourapp/ui/views/companies/company_details.dart';
import 'package:tourapp/ui/views/no_data_found.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({Key key}) : super(key: key);

  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  @override
  Widget build(BuildContext context) {
    var translator = Provider.of<TranslationProvider>(context);
 
    final makeBottom = Container(
      height: 55.0,
      child: BottomAppBar(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.blur_on, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.hotel, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.account_box, color: Colors.white),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
 

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text(""),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],
    );

   ;


    return Directionality(
      textDirection: translator.getCurrentLang() == "en"
          ? TextDirection.ltr
          : TextDirection.rtl,
      child:  Scaffold(
          backgroundColor: AppColors.primaryColor,
          appBar: topAppBar,
        body: ViewModelBuilder<CompanyViewModel>.reactive(
          onModelReady: (model) async{
      await model.fetchCompanies();
          },
          
          builder: (context , model , child){
      if (model.state==ViewState.Busy) {
        return LoadingWidget();
      } else if(model.state==ViewState.Error){
        return model.getErrWidget(model.exception, ()async {
          await model.fetchCompanies();
         });
      }else {
        
        if (model.companies.length>0) {
          return  Container(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: model.companies.length,
                        itemBuilder: (BuildContext context, int index) {
                          var company =  model.companies[index];
                          return Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(64, 75, 96, .9)),
                              child:  ListTile(

                                onTap:(){
Navigator.of(context).push(

MaterialPageRoute(builder: (_)=>CompanyDetails(company))

);
                                },
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  leading: Container(
                                    padding: EdgeInsets.only(right: 12.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            right: new BorderSide(
                                                width: 1.0,
                                                color: Colors.white24))),
                                    child: Icon(Icons.autorenew,
                                        color: Colors.white),
                                  ),
                                  title: Text(
                                    translator.getCurrentLang()=="en"?
                                     model.companies[index].enName:
                                    model.companies[index].arName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  subtitle: Row(
                                    children: <Widget>[
                                      Icon(Icons.location_city ,
                                          color: Colors.yellowAccent),
                                      Text(
                                        
                                        translator.getCurrentLang()=="en"?
                                        company.enAddress:company.arAddress
                                        ,
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                  trailing: Icon(Icons.keyboard_arrow_right,
                                      color: Colors.white, size: 30.0)),
                            ),
                          );
                        },
                      ),
                    );
        }else{
          return NoData();
        }
      }
        },
        
         viewModelBuilder: ()=>CompanyViewModel()),
      )
    );
  }
}
