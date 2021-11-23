import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tourapp/core/enums/resturnat_state.dart';
import 'package:tourapp/core/enums/work_times_state.dart';
import 'package:tourapp/core/models/facilitate_loc.dart';
import 'package:tourapp/core/models/tourism_fac_loc.dart';
import 'package:tourapp/core/models/work_time.dart';
import 'package:tourapp/core/utils/exceptions.dart';
import 'package:tourapp/core/viewmodels/screens/location/resttunrant_view_model.dart';
import 'package:tourapp/core/viewmodels/screens/location/work_times_viewModel.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/services/strings.dart';
import 'package:tourapp/ui/shared/my_theme_data.dart';
import 'package:tourapp/ui/views/base_view.dart';
import 'package:tourapp/views/user/view/animation/FadeAnimation.dart';

class WorkTimes extends StatefulWidget {
  final int location_id;
  WorkTimes({Key key, this.location_id}) : super(key: key);

  @override
  _nameState createState() => _nameState();
}

class _nameState extends State<WorkTimes> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();


  Widget build(BuildContext context) {
    var translator = Provider.of<TranslationProvider>(context);
    return Directionality(
      textDirection: translator.getCurrentLang() == "en"
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
Hero(
                tag: "icon",
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.access_time_filled,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          blurRadius: 8.0,
                        )
                      ]),
                ),
              ),


              Text(
                  translator.getString(
                    "times_txt",
                  ),
                  style: TextStyle(color: Colors.black)),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: BaseView<WorkTimeViewModel>(
          onModelReady: (model) => model.fetchDate(widget.location_id),
          builder: (_, model, __) {
            if (model.widgetState == WorkTimeState.Loading) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                ),
              );
            } else if (model.widgetState == WorkTimeState.Error) {
              if (model.exception is ServerException) {
                return Text("server");
              } else if (model.exception is ConnectionException) {
                return Text("no internet");
              }

              return Text("unjknown");
            }
            debugPrint("no Error");
            return ListView(
              children: model.workTimes.map((loc) {
                return FadeAnimation(
                 loc.id.toDouble(),
                  TimeWidget(
                    workTime: loc,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class TimeWidget extends StatelessWidget {
  final WorkTime workTime;

  TimeWidget({Key key, this.workTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var translator = Provider.of<TranslationProvider>(context);

    return Container(
        height: 100,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), //color of shadow
                spreadRadius: 3, //spread radius
                blurRadius: 7, // blur radius
                offset: Offset(0, 2), // changes position of shadow
                //first paramerter of offset is left-right
                //second parameter is top to down
              ),
            ]),
        child: ListTile(
          title: Text(
            translator.getCurrentLang() == "en"
                ? workTime.day.dayEnName
              :workTime.day.dayArName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          // trailing:
          //  Row(
          //     children: [
          //       Text(location.facilitateLocation.whtsapp),

          //       IconButton(onPressed: (){}, icon: Icon(Icons.call , color: Theme.of(context).primaryColor,)),
          //     ],
          //   )
         subtitle:  Text(translator.getCurrentLang()=="en"?   "From: "+getFormatedTime(workTime.startTime)+" to:"+ getFormatedTime(workTime.endTime) : 
          "من: " + getFormatedARTime(workTime.startTime) + " إلى:" + getFormatedARTime(workTime.endTime)
         ) ,
        )

        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   //  crossAxisAlignment: CrossAxisAlignment.start,
        //     children: <Widget>[

        // Container(
        //         padding: const EdgeInsets.all(16.0),
        //         child: Icon(
        //            Icons.restaurant,
        //           color: Colors.white,
        //         ),
        //         decoration:
        //             BoxDecoration(color:  Colors.red, shape: BoxShape.circle, boxShadow: [
        //           BoxShadow(
        //             color: Color.fromRGBO(0, 0, 0, 0.15),
        //             blurRadius: 8.0,
        //           )
        //         ]),
        //       ),

        //       Text(
        //      location.facilitateLocation.erName,
        //         style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),

        //     Row(
        //       children: [
        //         Text(location.facilitateLocation.whtsapp),

        //         IconButton(onPressed: (){}, icon: Icon(Icons.call , color: Theme.of(context).primaryColor,)),
        //       ],
        //     )
        //       // UIHelper.verticalSpaceSmall(),
        //  SmoothStarRating(
        //                                               allowHalfRating: true,
        //                                               starCount: 5,
        //                                               rating: 3,
        //                                               size: 20,
        //                                               color: MyThemeData
        //                                                       .buildLightTheme()
        //                                                   .primaryColor,
        //                                               borderColor: MyThemeData
        //                                                       .buildLightTheme()
        //                                                   .primaryColor,
        //                                             )
        //  ],
        //),
        );
  }
}
