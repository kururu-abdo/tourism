import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tourapp/core/enums/hotel_state.dart';
import 'package:tourapp/core/models/tourism_fac_loc.dart';
import 'package:tourapp/core/viewmodels/screens/location/hotel_view_model.dart';
import 'package:tourapp/core/viewmodels/screens/location/resttunrant_view_model.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/ui/shared/transition.dart';
import 'package:tourapp/ui/views/base_view.dart';
import 'package:tourapp/ui/views/location/work_times.dart';

class Hotels extends StatefulWidget {
    final int location_id;

  Hotels({Key key, this.location_id}) : super(key: key);

  @override
  _HotelsState createState() => _HotelsState();
}

class _HotelsState extends State<Hotels> {
  @override
  Widget build(BuildContext context) {
        var translator = Provider.of<TranslationProvider>(context);

    return   Directionality(textDirection: translator.getCurrentLang()=="en"?TextDirection.ltr:TextDirection.rtl, 
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          title: Text(
              translator.getString(
                "hotel",
              ),
              style: TextStyle(color: Colors.black)),
          centerTitle: true,
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
        body: BaseView<HotelViewModel>(
          onModelReady: (model) => model.fetchData(widget.location_id),
          builder: (_, model, __) {
            if (model.widgettate == HotelState.Loading) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                ),
              );
            } else if (model.widgettate == HotelState.Error) {
              if (model.error is ServerException) {
                return Text("server");
              } else if (model.error is ConnectionException) {
                return Text("no internet");
              }
    
              return Text("unjknown");
            }
            debugPrint("no Error");
            return ListView(
              children: model.locations.map((loc) {
                return HotelCard(
                  location: loc,
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}



class HotelCard extends StatelessWidget {
  final TourismFacilitateLocation location;

  HotelCard({Key key, this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var translator = Provider.of<TranslationProvider>(context);

    debugPrint(location.facilitateLocation.enName);
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
          onTap: () {
            print("------TO TIMES----------------");
            Navigator.of(context).push(CustomPageRoute(WorkTimes(
              location_id: location.facilitateLocation.fcilitateLocId,
            )));
          },
          title: Text(
            translator.getCurrentLang() == "en"
                ? location.facilitateLocation.enName
                : location.facilitateLocation.erName,
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
          trailing: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.call,
                color: Theme.of(context).primaryColor,
              )),
          subtitle: Text(
            translator.getCurrentLang() == "en"
                ? location.facilitateLocation.enAddress
                : location.facilitateLocation.arAddress,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          leading: Hero(
            tag: "icon",
            child: 
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
               FontAwesomeIcons.hotel,
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
