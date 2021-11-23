import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tourapp/core/enums/trip_status.dart';
import 'package:tourapp/core/models/trip.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/ui/shared/transition.dart';
import 'package:tourapp/ui/views/base_view.dart';
import 'package:tourapp/ui/views/no_data_found.dart';
import 'package:tourapp/ui/views/trip/trip_map.dart';
import 'package:tourapp/viewmodels/trip_viewmodel.dart';

class ScheduledTrips extends StatefulWidget {
  ScheduledTrips({Key key}) : super(key: key);

  @override
  _ScheduledTripsState createState() => _ScheduledTripsState();
}

class _ScheduledTripsState extends State<ScheduledTrips> {
  @override
  Widget build(BuildContext context) {
        var translator = Provider.of<TranslationProvider>(context);

return   Directionality(textDirection: translator.getCurrentLang()=="en"?TextDirection.ltr:TextDirection.rtl,
  child:   Scaffold(
  
  
  
        resizeToAvoidBottomInset: false,
  
        backgroundColor: Colors.white,
  
        appBar: AppBar(
  
          elevation: 0,
  
          brightness: Brightness.light,
  
          backgroundColor: Colors.white,
  
          title: Text(
  
  translator.getString("trips_txt") , style: TextStyle(color: Colors.black),
  
           ),
  
          leading: IconButton(
  
            onPressed: () {
  
              Navigator.pop(context);
  
            },
  
            icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
  
          ),
  
        ),
  
  body: BaseView<TripViewModel>(
  
  onModelReady: (model)async{
  
    print("pppppppppppppppppppppppppppppppppppp");
  
    await model.getAllScheduledTrips();
  
  },
  
  builder: (context, model, _){
  
  if(model.tripState ==TripViewState.Loading){
  
  return Center(child: CircularProgressIndicator(strokeWidth: 1.5,),);
  
  }else if(model.tripState ==TripViewState.Loaded){
  
if(model.trips.length>0){
    return Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(8.0),
                  child: ListView(
                    children: model.trips.map((trip) {
                      return TripWidget(
                        trip: trip,
                        model: model,
                      );
                    }).toList(),
                  ),
                );
} else {

  return NoData(asset: NORESULT, msg: translator.getString(NOTRIPS) );
}
  
  }
  
  return  Text("errror");
  
  },
  
  
  
  ),
  
  
  
      ),
);

  }
}
class TripWidget extends StatelessWidget {
final   Trip  trip;
final TripViewModel model;
   TripWidget({Key key, this.trip , this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var translator =  Provider.of<TranslationProvider>(context);

    Widget child;


     if (trip.status==TripStatus.CANCELED) {
    child = Icon(Icons.cancel , color: Colors.red,);
  } else  if (trip.status == TripStatus.WAITING) {
    child = Icon(Icons.hourglass_bottom_rounded , color: Colors.brown[300]);
  } else{
     child = Icon(Icons.done , color: Colors.green);

}
    
    
    
    return
    
       
    
      Container(
     margin: EdgeInsets.all(8),
     padding: EdgeInsets.zero,
decoration: BoxDecoration(
borderRadius: BorderRadius.all(Radius.circular(20)),

),
      child:

       
Dismissible(

   key: Key(trip.id.toString()),

 onDismissed: (direction) async {
      // Show a snackbar. This snackbar could also contain "Undo" actions.
      await model.cancelTrip(trip);
    Scaffold
        .of(context)
        .showSnackBar(SnackBar(content: Text(
          
          translator.getCurrentLang()=="en"?
          
          "Trip cancelled":" تم إلغاء الرحلة ")));
    // Remove the item from the data source.
   
    

    
  },


      child:Card(
      
        elevation: 5.0,
      
        shape: RoundedRectangleBorder(
      
      borderRadius: BorderRadius.all(Radius.circular(20)),
      
        ),
      
      margin: EdgeInsets.all(8.0),
      
      child: ListTile(
      
        onTap: (){
      
          Navigator.of(context).push(CustomPageRoute(TripMap(destination: LatLng(trip.lat , trip.lon) , destination_name: trip.location,)));
      
        },
      
                      title: Text(trip.location),
      
                      subtitle: Text(model.getFormatedDate(trip.date)),
      
                      // leading:child,
      
        trailing: IconButton(
      
                    onPressed: () async{
      
      
      
                      model.cancelTrip(trip);
      
                    },
      
                    icon: Icon(
      
                      Icons.delete,
      
                      color: Colors.red,
      
                    )),
      
                   
      
                    ),
      
      
      
      
      
      ),

)
      );
    
      Container(
     margin: EdgeInsets.all(8),
decoration: BoxDecoration(
borderRadius: BorderRadius.all(Radius.circular(20)),
         color: Colors.green,

),
      child:       Row(
      
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      
      children: [
      
      Expanded(
        child: Stack(
        
          children: [
        
            Container(
        
             padding: EdgeInsets.zero,
        
        
              color: Colors.amber,
        
              child: ListTile(
               title: Text(trip.location),
        
            subtitle:  Text(trip.date),
        
              )
              
              ) ,
        
            Positioned(
        
               top: -5.0, right: 0.0,
        
              child: IconButton(onPressed: (){}, icon: Icon(Icons.remove_circle_outlined , color: Colors.red,)))
        
          ],
        
        ),
      ) ,
      
      
      
      
      
      Text("19/90")
      
      
      
      ],
      
      
      
      ),
    );
    
  }
}