import 'package:date_time_picker/date_time_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl ;
import 'package:provider/provider.dart';
import 'package:tourapp/core/enums/dialog_type.dart';
import 'package:tourapp/core/enums/trip_status.dart';
import 'package:tourapp/core/enums/view_state.dart';
import 'package:tourapp/core/models/location.dart';
import 'package:tourapp/core/models/trip.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/ui/shared/popups.dart';
import 'package:tourapp/ui/views/base_view.dart';
import 'package:tourapp/ui/views/main_button.dart';
import 'package:tourapp/viewmodels/trip_viewmodel.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart' as picker;
import 'package:tourapp/views/user/view/animation/FadeAnimation.dart';

class AddTrip extends StatefulWidget {
  final TourismLocation  location;
  AddTrip({Key key, this.location}) : super(key: key);

  @override
  _AddTripState createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
    var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  TextEditingController timeController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();


          TextEditingController messgeController = new TextEditingController();

    DateTime selectedDate;
TimeOfDay _tod=TimeOfDay.now().replacing(minute: 30);

DateTime pickedDate = DateTime.now();

_pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: _tod);
    if (t != null)
      setState(() {
        _tod = t;
      });
  }
pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickedDate,
    );
    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  _openCalendar( ){
DateTimePicker(
  type: DateTimePickerType.dateTimeSeparate,
  dateMask: 'dd MMM, yyyy',
  initialValue: DateTime.now().toString(),
  firstDate: DateTime(2000),
  lastDate: DateTime(2100),
  icon: Icon(Icons.event),
  dateLabelText: 'Date',
  timeLabelText: "Hour",
  selectableDayPredicate: (date) {
    // Disable weekend days to select from the calendar
    if (date.weekday == 6 || date.weekday == 7) {
      return false;
    }

    return true;
  },
  onChanged: (val) {
    setState(() {
       print(val);
    });
  },
  validator: (val) {
    print(val);
    return null;
  },
  onSaved: (val) {
    print(val);
  },
);

      // Navigator.of(context).push(
      // picker.showPicker(
      //   context: context,
      //   minuteInterval: MinuteInterval.FIVE,
      //   disableHour: false,
      //   disableMinute: false,
      //   minMinute: 7,
      //   maxMinute: 56,
      //   value:  _tod,
      //   onChange: (tod){
      //     _tod=tod;
      //   },
      // );
  


    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then((dateTime){
    //  tourModel.startDate=dateTime.microsecondsSinceEpoch;
      setState(() {
        selectedDate=dateTime;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    var translator =  Provider.of<TranslationProvider>(context);
  return  Directionality(
    textDirection: translator.getCurrentLang()=="en"?TextDirection.ltr:TextDirection.rtl,
    child: BaseView<TripViewModel>(
    onModelReady:(model)=>model. initiState(),
      builder: (context, model, _) => Scaffold( 
  
    resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
                key: _scaffoldKey,
  
  appBar: AppBar(
                  elevation: 0,
                  brightness: Brightness.light,
                  backgroundColor: Colors.white,
                  title: Text(
                   translator.getString("new_trip"),
                    style: TextStyle(color: Colors.black),
                  ),
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
  body:      model.tripState !=TripViewState.Loading?
   Container(
                 height: MediaQuery.of(context).size.height,
  
     child: Padding(
       padding: const EdgeInsets.all(8.0),
       child: Form(
         
                    key: _formKey,
                    child: ListView(
                      children: [
                      
                  FadeAnimation(1.2,DateTimeField(
                    controller: dateController,
                        format: intl.DateFormat("yyyy-MM-dd"),
                        decoration: InputDecoration(
    
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
    
                          hintText:
                          
                          translator.getCurrentLang() == "en"
                                        ?"choose date   ":"اختر التاريخ",
                        ),
    
    onShowPicker: (context, currentValue) {
              return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
            },
                      ),
    
                  ),
    SizedBox(height: 10.0,) ,
    FadeAnimation(1.2, DateTimeField(
            format: intl.DateFormat("HH:mm"),
            controller: timeController,
       decoration: InputDecoration(
    
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
    
                          hintText:
                                          translator.getCurrentLang() == "en"
                                              ? "choose time   "
                                              : "اختر الزمن ",
                        ),
    
        onShowPicker: (context, currentValue) async {
              final TimeOfDay timeOfDay = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now()  ,
            initialEntryMode: TimePickerEntryMode.dial,
          );
          if(timeOfDay != null && timeOfDay != currentValue)
            {
              print(timeController.text);
              return    DateTimeField.convert(timeOfDay);
            }else {
            return currentValue;
          }
              // final date = await showDatePicker(
              //     context: context,
              //     firstDate: DateTime(1900),
              //     initialDate: currentValue ?? DateTime.now(),
              //     lastDate: DateTime(2100));
              // if (date != null) {
              //   final time = await showTimePicker(
              //     context: context,
              //     initialTime:
              //         TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              //   );
              //   return DateTimeField.convert(time);
              // } else {
              //   return currentValue;
              // }
    
    
            },
          ),
    
    
    ) ,
    SizedBox(height: 10.0,) ,
    
       FadeAnimation(1.2,
        SizedBox(height: 180,
    
        child:  TextFormField(
          controller:   messgeController ,
                  maxLines: 8,
                  decoration: InputDecoration(
    
                    hintText:  translator.getCurrentLang() ==
                                                      "en"
                                                  ? "Enter Your Message..."
                                                  : "رسالة التذكير",
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.all(Radius.circular(10.0))
                 ),  
                  ),
                ) ,
        )
       ),
    
                    SizedBox(
                                  height: 30.0,
                                ),
                    FadeAnimation(1.3, 
                     MainButton(
                        text: translator.getCurrentLang() == "en"
                                        ? "Save Raminder"
                                        : "اضافة تذكير",
                            onPress: ()async{
                        print("pressed");
                        
                          model.addTrip(
                             Trip(
                        
                                 location:
                                 translator.getCurrentLang()=="en"?
                                 
                                  widget.location.locationEnName:   widget.location.locationArName  ,  lat:   widget.location.lat ,  lon:   widget.location.lng ,message: messgeController.text, status: TripStatus.WAITING  ,  date: "${dateController.text} ${timeController.text}"       )
                        
                        
                        
                          );
                        
                         
    Popups.ShowDialog(
                                          context,
                                          translator.getCurrentLang() == "en"
                                              ? "Done"
                                              : "تم اضافة تذكير بالرحلة",
                                          translator.getCurrentLang() == "en"
                                              ? "Trip Reminder to ${widget.location.locationEnName} was added successfully "
                                              : "تم اضافة تذكير برحلة إلى ${widget.location.locationArName}",
                                          type: DialogType.SUCCESS,
                                          btnOkPressed: () {
                                        Navigator.pop(context);
                                      }).then(() {
                                        Navigator.pop(context);
                                      });
    
                        
                        
                        
                            },
                      ),
                    )
                      
                      ]  
                  )
       ),
     ),
   )
            
   
  
  
  : 
  
  
  Center(child: CircularProgressIndicator(strokeWidth: 1.5,),) ,
      )
      
      
      
      
      
      ),
  );
  }
}