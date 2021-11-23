import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:tourapp/core/enums/view_state.dart';
import 'package:tourapp/core/models/location_type.dart';
import 'package:tourapp/core/models/tag.dart';
import 'package:tourapp/core/viewmodels/screens/home/home_viewmodel.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/api_response.dart';
import 'package:tourapp/services/shared_prefs.dart';
import 'package:tourapp/ui/shared/loading_widget.dart';
import 'package:tourapp/ui/shared/my_theme_data.dart';
import 'package:tourapp/ui/shared/popular_filter_list.dart';
import 'package:tourapp/ui/shared/popups.dart';
import 'package:tourapp/ui/views/base_view.dart';
import 'package:tourapp/ui/views/skeleton.dart';
import 'range_slider_view.dart';
import 'slider_view.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  List<PopularFilterListData> popularFilterListData =
      PopularFilterListData.popularFList;
  List<PopularFilterListData> accomodationListData =
      PopularFilterListData.accomodationList;

  RangeValues _values = const RangeValues(100, 600);
  double distValue = 50.0;

  List<LocationType> types = [];
  List<Widget> typesWidget = [];
   List filters =[];
  List<Tag> tags = [];
  Widget tagsWidget;

  @override
  void initState() {
   
   
    // API.getAccomodations().then((value) {
    //   if (!value.error) {
    //     setState(() {
    //       types = value.data;

    //       for (var i = 0; i < types.length; i++) {
    //         typesWidget.add(
    //           Material(
    //             color: Colors.transparent,
    //             child: InkWell(
    //               borderRadius: const BorderRadius.all(Radius.circular(4.0)),
    //               onTap: () {
    //                 setState(() {
    //                   checkAppPosition(
    //                       types.indexWhere(
    //                           (element) => element.typeId == types[i].typeId),
    //                       types);
    //                 });
    //               },
    //               child: Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Row(
    //                   children: <Widget>[
    //                     Expanded(
    //                       child: Text(
    //                         types[i].typeArName,
    //                         style: TextStyle(color: Colors.black),
    //                       ),
    //                     ),
    //                     CupertinoSwitch(
    //                       activeColor: types[i].isSelected
    //                           ? MyThemeData.buildLightTheme().primaryColor
    //                           : Colors.grey.withOpacity(0.6),
    //                       onChanged: (bool value) {
    //                         setState(() {
    //                           checkAppPosition(
    //                               types.indexWhere((element) =>
    //                                   element.typeId == types[i].typeId),
    //                               types);
    //                         });
    //                       },
    //                       value: types[i].isSelected,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         );

    //         if (types[i].typeId == 0) {
    //           typesWidget.add(const Divider(
    //             height: 1,
    //           ));
    //         }
    //       }
    //     });


//       }   else {

// //  setState(() {
// //           types =[];
// //           Popups.ShowDialog(context, "Opps", description)
//  });
  //    }
 //   });

    // API.getTags().then((value) {
    //   if (!value.error) {
    //     setState(() {
    //       tags = value.data.cast<Tag>();
    //     });
    //     tagsWidget = Wrap(
    //       runSpacing: 10,
    //       spacing: 10,
    //       children: tags
    //           .map((inputChip) => InputChip(
    //               avatar: CircleAvatar(
    //                   // backgroundImage: NetworkImage(inputChip.tagName),
    //                   ),
    //               label: Text(inputChip.tagName),
    //               labelStyle: TextStyle(
    //                   fontWeight: FontWeight.bold, color: Colors.black),
    //               onPressed: () {}))
    //           .toList(),
    //     );
    //   }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

   

    return  ViewModelBuilder<HomeViewModel>.reactive(
          viewModelBuilder: () => HomeViewModel(),
           onModelReady: (viewModel) async{

             await viewModel.getFitlters();

           } ,

     builder: (context, viewModel, _) {
  if(viewModel.state == ViewState.Busy){
return Scaffold(body: Center(child: LoadingWidget(),)
 
 );
 
 
  }else if(viewModel.state==ViewState.Error){
    return Container(
           color: MyThemeData.buildLightTheme().backgroundColor,
      child: Scaffold(
        body: viewModel.getErrWidget(viewModel.exception, ()async {
      
      await viewModel.getFitlters();
      
         }),
      ),
    );
  }




       return (
    Container(
        color: MyThemeData.buildLightTheme().backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              getAppBarUI(),
             
             
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // priceBarFilter(),
                      // const Divider(
                      //   height: 1,
                      // ),
                      // popularFilter(),
                      // const Divider(
                      //   height: 1,
                      // ),
                      // distanceViewUI(),
                      // const Divider(
                      //   height: 1,
                      // ),
                      allAccommodationUI(viewModel.types)
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 16, top: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: MyThemeData.buildLightTheme().primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                      highlightColor: Colors.transparent,
                      onTap: ()async {
                        if(filters != null  ||   filters.length>1){
                        
//Future.delayed(Duration(seconds: 3));

  sharedPrefs.saveFilterState(true);
 viewModel.filterLocations(filters).then((value) {


          
                        Navigator.pop(context);

 });
                        }
                    
                      },
                      child: Center(
                        child: Text(
                          
                          'Apply',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ));
     }
    );
  }

  Widget allAccommodationUI(List<LocationType> types) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Padding(
        //   padding:
        //       const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
        //   child: Text(
        //     'tags',
        //     textAlign: TextAlign.left,
        //     style: TextStyle(
        //         color: Colors.grey,
        //         fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
        //         fontWeight: FontWeight.normal),
        //   ),
        // ),
        // Padding(
        //     padding: const EdgeInsets.only(right: 16, left: 16),
        //     child: tagsWidget == null
        //         ? Center(child: CircularProgressIndicator())
        //         : tagsWidget

        //     //  FutureBuilder<APiRespnose<List<Tag>>>(
        //     //   future: API.getTags(),
        //     //   builder: (BuildContext context,
        //     //       AsyncSnapshot<APiRespnose<List<Tag>>> snapshot) {
        //     //     if (snapshot.hasData) {
        //     //       return Wrap(
        //     //         runSpacing: 10,
        //     //         spacing: 10,
        //     //         children: snapshot.data.data
        //     //             .map((inputChip) => InputChip(
        //     //                 avatar: CircleAvatar(
        //     //                   backgroundImage: NetworkImage(inputChip.tagName),
        //     //                 ),
        //     //                 label: Text(inputChip.tagName),
        //     //                 labelStyle: TextStyle(
        //     //                     fontWeight: FontWeight.bold, color: Colors.black),
        //     //                 onPressed: () {}))
        //     //             .toList(),
        //     //       );
        //     //     } else {
        //     //       return Center(child: CircularProgressIndicator());
        //     //     }
        //     //   },
        //     // ),
        //     ),





        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'location type',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: types.length > 0
                ? Column(
                    children: getAccomodationListUI(types),
                  )
                : Center(child: CircularProgressIndicator())

            // types  .length>0?
            //        Column(
            //         children:typesWidget ,
            //       ): Center(child: CircularProgressIndicator()),
            ),
        const SizedBox(
          height: 8,
        ),
     //   distanceViewUI()
      ],
    );
  }

  List<Widget> getAccomodationListUI(List<LocationType> types) {
    final List<Widget> noList = <Widget>[];

    try {
      for (var data in types) {
        noList.add(
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              onTap: () {
                setState(() {
                  checkAppPosition(
                      types.indexWhere(
                          (element) => element.typeId == data.typeId),
                      types);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        data.typeArName,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    CupertinoSwitch(
                      activeColor: data.isSelected
                          ? MyThemeData.buildLightTheme().primaryColor
                          : Colors.grey.withOpacity(0.6),
                      onChanged: (bool value) {
                        setState(() {
                          checkAppPosition(
                              types.indexWhere(
                                  (element) => element.typeId == data.typeId), types);
                        });
                      },
                      value: data.isSelected,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        if (data.typeId == 0) {
          noList.add(const Divider(
            height: 1,
          ));
        }
      }

      //  return noList;

      // for (int i = 0; i < accomodationListData.length; i++) {
      //   final PopularFilterListData date = accomodationListData[i];
      //   noList.add(
      //     Material(
      //       color: Colors.transparent,
      //       child: InkWell(
      //         borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      //         onTap: () {
      //           setState(() {
      //             checkAppPosition(i);
      //           });
      //         },
      //         child: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Row(
      //             children: <Widget>[
      //               Expanded(
      //                 child: Text(
      //                   date.titleTxt,
      //                   style: TextStyle(color: Colors.black),
      //                 ),
      //               ),
      //               CupertinoSwitch(
      //                 activeColor: date.isSelected
      //                     ? MyThemeData.buildLightTheme().primaryColor
      //                     : Colors.grey.withOpacity(0.6),
      //                 onChanged: (bool value) {
      //                   setState(() {
      //                     checkAppPosition(i);
      //                   });
      //                 },
      //                 value: date.isSelected,
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   );
      //   if (i == 0) {
      //     noList.add(const Divider(
      //       height: 1,
      //     ));
      //   }
      // }
      return noList;
    } catch (e) {
      debugPrint(e);
    }
    // noList.add(Text("dkfdkfdkf"));

    return noList;
  }

  void checkAppPosition(int index, List<LocationType> types) {
    print(index);

    // if (index == 0) {
    //   print(types[0].isSelected);
    //   if (types[0].isSelected) {
    //     types.forEach((d) {
    //       d.isSelected = false;
    //     });
    //   } else {
    //     types.forEach((d) {
    //       d.isSelected = true;
    //     });
    //   }
    // } else {
      types[index].isSelected = !types[index].isSelected;
      setState(() {
        filters=[];
      });
    for (var type in types) {
      if (type.isSelected) {
        setState(() {
          filters.add(type.typeId);
        });
      }

    }
      // if(types[index].isSelected){
      //     setState(() {
      //   filters.add(types[index].typeId);
      // });
      // } else {
      // }
      // int count = 0;
      // for (int i = 0; i < types.length; i++) {
      //   if (i != 0) {
      //     final LocationType data = types[i];
      //     if (data.isSelected) {
      //       count += 1;
      //     }
      //   }
      

      // if (count == types.length - 1) {
      //   types[0].isSelected = true;
      // } else {
      //   types[0].isSelected = false;
      // }
   // }

    ////////////////////////////////////////////////////////

    // if (index == 0) {
    //   if (accomodationListData[0].isSelected) {
    //     accomodationListData.forEach((d) {
    //       d.isSelected = false;
    //     });
    //   } else {
    //     accomodationListData.forEach((d) {
    //       d.isSelected = true;
    //     });
    //   }
    // } else {
    //   accomodationListData[index].isSelected =
    //       !accomodationListData[index].isSelected;

    //   int count = 0;
    //   for (int i = 0; i < accomodationListData.length; i++) {
    //     if (i != 0) {
    //       final PopularFilterListData data = accomodationListData[i];
    //       if (data.isSelected) {
    //         count += 1;
    //       }
    //     }
    //   }

    //   if (count == accomodationListData.length - 1) {
    //     accomodationListData[0].isSelected = true;
    //   } else {
    //     accomodationListData[0].isSelected = false;
    //   }
    // }
  }

  Widget distanceViewUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Distance from city center',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        SliderView(
          distValue: distValue,
          onChangedistValue: (double value) {
            distValue = value;
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget popularFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Popular filters',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getPList(),
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  List<Widget> getPList() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    const int columnCount = 2;
    for (int i = 0; i < popularFilterListData.length / columnCount; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < columnCount; i++) {
        try {
          final PopularFilterListData date = popularFilterListData[count];
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        date.isSelected = !date.isSelected;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            date.isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: date.isSelected
                                ? MyThemeData.buildLightTheme().primaryColor
                                : Colors.grey.withOpacity(0.6),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            date.titleTxt,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
          if (count < popularFilterListData.length - 1) {
            count += 1;
          } else {
            break;
          }
        } catch (e) {
          print(e);
        }
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  Widget priceBarFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Price (for 1 night)',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        RangeSliderView(
          values: _values,
          onChangeRangeValues: (RangeValues values) {
            _values = values;
          },
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: MyThemeData.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Filters',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
}
