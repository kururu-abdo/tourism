import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tourapp/core/enums/dialog_type.dart';
import 'package:tourapp/core/enums/trip_status.dart';
import 'package:tourapp/core/enums/view_state.dart';
import 'package:tourapp/core/models/location.dart';
import 'package:tourapp/core/models/trip.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/services/notification_utils.dart';
import 'package:tourapp/services/notifications.dart';
import 'package:tourapp/ui/shared/popups.dart';
import 'package:tourapp/ui/views/main_button.dart';
import 'package:tourapp/viewmodels/trip_viewmodel.dart';
import 'package:tourapp/views/user/view/animation/FadeAnimation.dart';

import '../base_view.dart';

class NewTrip extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewTripState();
  }
}

class _NewTripState extends State<NewTrip> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  TextEditingController timeController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();

  TextEditingController messgeController = new TextEditingController();

  String location;
  double lat;
  double lon;

  @override
  Widget build(BuildContext context) {
    var translator = Provider.of<TranslationProvider>(context);

    return Directionality(
      textDirection: translator.getCurrentLang() == "en"
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: BaseView<TripViewModel>(
        onModelReady: (model) => model.initiState(),
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
            body: model.tripState != TripViewState.Loading
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                                controller: this._typeAheadController,
                                decoration: InputDecoration(
                                    labelText:
                                        translator.getCurrentLang() == "en"
                                            ? 'Location'
                                            : "الوجهة")),
                            suggestionsCallback: (pattern) {
                              return model.searcLocations(pattern);
                            },
                            itemBuilder: (context, TourismLocation suggestion) {
                              return ListTile(
                                title: Text(translator.getCurrentLang() == "en"
                                    ? suggestion.locationEnName
                                    : suggestion.locationArName),
                              );
                            },
                            transitionBuilder:
                                (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            onSuggestionSelected: (TourismLocation suggestion) {
                              if (translator.getCurrentLang() == "en") {
                                this._typeAheadController.text =
                                    suggestion.locationEnName;
                              } else {
                                this._typeAheadController.text =
                                    suggestion.locationArName;
                              }

                              setState(() {
                                location = suggestion.locationArName;
                                lat = suggestion.lat;
                                lon = suggestion.lng;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return translator.getCurrentLang() == "en"
                                    ? 'Please select a place '
                                    : "قم باختير المعلم او الموقع السياحي";
                              } else
                                return null;
                            },
                            onSaved: (value) {
                              location = value;
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FadeAnimation(
                            1.2,
                            DateTimeField(
                              controller: dateController,
                              format: intl.DateFormat("yyyy-MM-dd"),
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintText: translator.getCurrentLang() == "en"
                                    ? "choose date   "
                                    : "اختر التاريخ",
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
                          SizedBox(
                            height: 10.0,
                          ),
                          FadeAnimation(
                            1.2,
                            DateTimeField(
                              format: intl.DateFormat("HH:mm"),
                              controller: timeController,
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintText: translator.getCurrentLang() == "en"
                                    ? "choose time   "
                                    : "اختر الزمن ",
                              ),
                              onShowPicker: (context, currentValue) async {
                                final TimeOfDay timeOfDay =
                                    await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  initialEntryMode: TimePickerEntryMode.dial,
                                );
                                if (timeOfDay != null &&
                                    timeOfDay != currentValue) {
                                  print(timeController.text);
                                  return DateTimeField.convert(timeOfDay);
                                } else {
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
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FadeAnimation(
                              1.2,
                              SizedBox(
                                height: 180,
                                child: TextFormField(
                                  controller: messgeController,
                                  maxLines: 8,
                                  decoration: InputDecoration(
                                    hintText:
                                        translator.getCurrentLang() == "en"
                                            ? "Enter Your Message..."
                                            : "رسالة التذكير",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                  ),
                                ),
                              )),
                          Spacer(),
                          MainButton(
                            text: translator.getCurrentLang() == "en"
                                ? "Save Raminder"
                                : "اضافة تذكير",
                            onPress: () async {
                              print("pressed");

                              model.addTrip(Trip(
                                  location: location,
                                  lat: lat,
                                  lon: lon,
                                  message: messgeController.text,
                                  status: TripStatus.WAITING,
                                  date:
                                      "${dateController.text} ${timeController.text}"));

                              Popups.ShowDialog(
                                  context,
                                  translator.getCurrentLang() == "en"
                                      ? "Done"
                                      : "تم اضافة تذكير بالرحلة",
                                  translator.getCurrentLang() == "en"
                                      ? "Trip Reminder to ${location} was added successfully "
                                      : "تم اضافة تذكير برحلة إلى ${location}",
                                  type: DialogType.SUCCESS, btnOkPressed: () {
                                Navigator.pop(context);
                              }).then(() {
                                Navigator.pop(context);
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )),
      ),
    );
  }

  @override
  void dispose() {
    timeController.dispose();
    messgeController.dispose();
    _typeAheadController.dispose();
    dateController.dispose();
    super.dispose();
  }
}
