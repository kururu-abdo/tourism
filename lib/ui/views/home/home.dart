import 'dart:async';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flip_drawer/flip_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_translator/flutter_translator.dart';

import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:tourapp/core/enums/view_state.dart';
import 'package:tourapp/core/models/founded_locations.dart';
import 'package:tourapp/core/models/location.dart';
import 'package:tourapp/core/models/location_type.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/core/viewmodels/screens/home/home_viewmodel.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/shared_prefs.dart';
import 'package:tourapp/services/socket_services.dart';
import 'package:tourapp/ui/shared/anim_widget.dart';
import 'package:tourapp/ui/shared/loading_widget.dart';
import 'package:tourapp/ui/shared/mock_data.dart';
import 'package:tourapp/ui/shared/my_theme_data.dart';
import 'package:tourapp/ui/shared/transition.dart';
import 'package:tourapp/ui/views/home/home_drawer.dart';
import 'package:tourapp/ui/views/no_data_found.dart';
import 'package:tourapp/ui/widgets/circular_loading.dart';
import 'package:tourapp/views/home/providers/location_provider.dart';
import 'package:tourapp/views/home/view/filter_search.dart';
import 'package:tourapp/views/home/view/location_list.dart';
import 'package:tourapp/views/home/view/search_location.dart';
import 'package:tourapp/ui/views/location/location_details.dart';
import 'package:tourapp/ui/views/settings/settings_page.dart';

class HomeScreen extends HookViewModelWidget<HomeViewModel> {
  HomeScreen({Key key}) : super(key: key, reactive: false);

  @override
  Widget buildViewModelWidget(
    BuildContext context,
    HomeViewModel model,
  ) {}
}

class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  final TranslatorGenerator translator = TranslatorGenerator.instance;

  AnimationController animationController;

  final ScrollController _scrollController = ScrollController();
  int _lastIntegerSelected;

  int selectedCategoty;
  final SearchLocation _delegate = SearchLocation();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _showButtom = false;
  List filters = [];

  //Filter fuction

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
      filters = [];
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
                                  (element) => element.typeId == data.typeId),
                              types);
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

///////////////////////////////////////////
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    API.getAppBaseUrl().then((value) {
      if (!value.error) {
        debugPrint("BASE URL FROM CLOUD STORAGE  " + value.data);

        var baseUrl = value.data;

        sharedPrefs.SaveBaseUrl(baseUrl);
      }
    });

// AwesomeNotifications()
//                       .requestPermissionToSendNotifications().then((value) => {
//                         print(value)
//                       });
// Future.microtask((){
//
//     //    Provider.of<LocationProvider>(context, listen: false).fetchLocations();
// context.read<LocationProvider>().fetchLocations();
//
//
// });

    //   Future.microtask(() async {

    //  API.getAppBaseUrl().then((value) async{
    //       if (!value.error) {
    //         debugPrint("BASE URL FROM CLOUD STORAGE  " + value.data);
    //         setState(() {

    //           sharedPrefs.SaveBaseUrl(value.data);
    //         });

    //             await context.read<HomeViewModel>().fetchLocations();

    //       }
    //     });

    // if (!sharedPrefs.getFilterState()) {
    //   await context.read<HomeViewModel>().fetchLocations();

    //   sharedPrefs.saveFilterState(false);
    // }
    // });



 SocketService().emit('user-connection', sharedPrefs.getUser()['name']);


    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void refreshData() {}

  FutureOr onGoBack(HomeViewModel model) {}

  void navigateFilterPagePage(HomeViewModel model) {
    Route route = MaterialPageRoute(builder: (context) => FiltersScreen());
    Navigator.push(context, route).then(onGoBack);
  }

  List<HotelListData> hotelList = HotelListData.hotelList;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<LocationProvider>(context, listen: false);
/*
FlipDrawer(
        items: [
          MenuItem('Home', onTap: (){Navigator.of(context).pop();}),
          MenuItem('Project', onTap: (){}),
          MenuItem('Favourite', onTap: (){}),
          MenuItem('Profile', onTap: (){}),
          MenuItem('Setting', onTap: (){
       
       Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SettingsScreen()));
       
       
          }),
        ],
        title: 'Explore Sudan',
         child:

*/

//     return Consumer<HomeViewModel>(
// //       viewModelBuilder: () => HomeViewModel(),
// //           onModelReady: (viewModel)async  {
// // if (!sharedPrefs.getFilterState()) {
// // await viewModel.fetchLocations()  ;

// // sharedPrefs.saveFilterState(false);

// // }

// //           } ,

//       builder: (context, viewModel, _) =>

    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onModelReady: (viewModel) async {
          await viewModel.fetchLocations();

          await viewModel.getFitlters();
        },
        builder: (context, viewModel, _) {
          return Theme(
              data: MyThemeData.buildLightTheme(),
              child: Container(
                  child: Directionality(
                      textDirection:
                          translator.currentLocale.languageCode == "en"
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                      child: Scaffold(
                          key: _scaffoldKey,
                          appBar: AppBar(
                            leading: Container(
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
                                    _scaffoldKey.currentState.openDrawer();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.menu),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              translator.getString(context, 'appTitle'),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                              ),
                            ),
                            actions: [
                              Material(
                                  color: Colors.transparent,
                                  child: PopupMenuButton<String>(
                                    icon: Icon(Icons.translate_outlined),
                                    initialValue: 'English',
                                    onSelected: (str) {
                                      switch (str) {
                                        case 'English':
                                          translator.translate('en');

                                          break;
                                        case 'العربية':
                                          translator.translate('ar');
                                          break;

                                        default:
                                          translator.translate('ar');
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return ['العربية', 'English']
                                          .map((String choice) {
                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: Text(choice),
                                        );
                                      }).toList();
                                    },
                                  )
                                  // InkWell(
                                  //   borderRadius: const BorderRadius.all(
                                  //     Radius.circular(32.0),
                                  //   ),
                                  //   onTap: () {},
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(8.0),
                                  //     child: Icon(Icons.favorite_border),
                                  //   ),
                                  // ),

                                  ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0),
                                  ),
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.location_on),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          drawer: HomeDrawer(),
                          body: ListView(children: [
                            getSearchBarUI(),
                            Container(
                                height:
                                    //double.infinity ,
                                    MediaQuery.of(context).size.height,
                                child: Stack(children: <Widget>[
                                  InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      },
                                      child: Column(children: <Widget>[
                                        Expanded(
                                            child: NestedScrollView(
                                        //  controller: _scrollController,
                                          headerSliverBuilder:
                                              (BuildContext context,
                                                  bool innerBoxIsScrolled) {
                                            return <Widget>[
                                              // SliverList(
                                              //   delegate: SliverChildBuilderDelegate(
                                              //       (BuildContext context, int index) {
                                              //     return Column(
                                              //       children: <Widget>[
                                              //         getSearchBarUI(),
                                              //       ],
                                              //     );
                                              //   }, childCount: 1),
                                              // ),
                                              SliverPersistentHeader(
                                                pinned: true,
                                                floating: true,
                                                delegate: ContestTabHeader(
                                                  getFilterBarUI(
                                                      viewModel.locations),
                                                ),
                                              ),
                                            ];
                                          },
                                          body: ConditionalSwitch.single<
                                                  ViewState>(
                                              context: context,
                                              valueBuilder:
                                                  (BuildContext context) =>
                                                      viewModel.state,
                                              caseBuilders: {
                                                ViewState.Busy:
                                                    (BuildContext context) =>
                                                        LoadingWidget(),
                                                ViewState.Idle: (_) {
                                                  if (viewModel
                                                          .locations.length <=
                                                      0) {
                                                  
                                                  
                                                    return NoData(
                                                      asset: EMPTY,
                                                      msg: translator
                                                                  .getLanguageName() ==
                                                              "en"
                                                          ? "No Location"
                                                          : "لم يتم العثور على مواقع",
                                                    );
                                                  } else {
                                                    return 
                                                    Column(
                                                      children: [
                                                        Expanded(
                                                            // color: MyThemeData
                                                            //         .buildLightTheme()
                                                            //     .backgroundColor,
                                                            child: RefreshIndicator(
                                                              onRefresh: () async{
                                                                await viewModel.fetchLocations();

                                                              },
                                                              child: ListView.builder(
                                                                
                                                                shrinkWrap: true,
                                                                
                                                                physics:
                                                                    BouncingScrollPhysics(),
                                                                itemCount: viewModel
                                                                    .locations.length,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(top: 8),
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  print(
                                                                      "/////////////////////////");
                                                                  print(viewModel
                                                                      .locations
                                                                      .length);
                                                                  final int count =
                                                                      hotelList.length >
                                                                              10
                                                                          ? 10
                                                                          : hotelList
                                                                              .length;
                                                                  final Animation<
                                                                      double> animation = Tween<
                                                                              double>(
                                                                          begin: 0.0,
                                                                          end: 1.0)
                                                                      .animate(CurvedAnimation(
                                                                          parent:
                                                                              animationController,
                                                                          curve: Interval(
                                                                              (1 / count) *
                                                                                  index,
                                                                              1.0,
                                                                              curve: Curves
                                                                                  .fastOutSlowIn)));
                                                                  animationController
                                                                      .forward();
                                                                  return HotelListView(
                                                                    model: viewModel,
                                                                    callback: () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .push(

//   MaterialPageRoute(builder: (_)=>  LoactionDetails(

//   location:viewModel.locations[index] ,

// ))

                                                                              CustomPageRoute(
                                                                                  LoactionDetails(
                                                                        location: viewModel
                                                                                .locations[
                                                                            index],
                                                                      )));
                                                                    },
                                                                    hotelData: viewModel
                                                                            .locations[
                                                                        index],
                                                                    animation:
                                                                        animation,
                                                                    animationController:
                                                                        animationController,
                                                                  );
                                                                },
                                                              ),
                                                            )),
                                                      ],
                                                    );
                                                  }
                                                }
                                              },
                                              fallbackBuilder:
                                                  (BuildContext context) =>
                                                      viewModel.getErrWidget(
                                                          viewModel.exception,
                                                          () async {
                                                        viewModel
                                                            .fetchLocations();
                                                      })),
                                        ))
                                      ]))
                                ]))
                          ]),
                          bottomSheet: Visibility(
                              visible: _showButtom,
                              child: Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 2 / 3,
                                child: viewModel.state == ViewState.Busy
                                    ? Center(child: LoadingWidget())
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            right: 16, left: 16),
                                        child: viewModel.types.length > 0
                                            ? Column(children: [
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
                                                        allAccommodationUI(
                                                            viewModel.types)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Divider(
                                                  height: 1,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          bottom: 16,
                                                          top: 8),
                                                  child: Container(
                                                    height: 48,
                                                    decoration: BoxDecoration(
                                                      color: MyThemeData
                                                              .buildLightTheme()
                                                          .primaryColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  24.0)),
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.6),
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                              4, 4),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    24.0)),
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          if (filters != null ||
                                                              filters.length >
                                                                  1) {
//Future.delayed(Duration(seconds: 3));

                                                            viewModel
                                                                .filterLocations(
                                                                    filters);

                                                            setState(() {
                                                              _showButtom =
                                                                  !_showButtom;
                                                            });
                                                          }
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            'Apply',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ])
                                            : Center(
                                                child:
                                                    CircularProgressIndicator())

                                        // types  .length>0?
                                        //        Column(
                                        //         children:typesWidget ,
                                        //       ): Center(child: CircularProgressIndicator()),
                                        ),
                              ))))));
        });

//     return Theme(
//       data: MyThemeData.buildLightTheme(),
//       child: Container(
//         child: Directionality(
//           textDirection: translator.currentLocale.languageCode == "en"
//               ? TextDirection.ltr
//               : TextDirection.rtl,
//           child: Scaffold(
//               key: _scaffoldKey,
//               appBar: AppBar(
//                 leading: Container(
//                   alignment: Alignment.centerLeft,
//                   width: AppBar().preferredSize.height + 40,
//                   height: AppBar().preferredSize.height,
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(32.0),
//                       ),
//                       onTap: () {
//                         _scaffoldKey.currentState.openDrawer();
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Icon(Icons.menu),
//                       ),
//                     ),
//                   ),
//                 ),
//                 title: Text(
//                   translator.getString(context, 'appTitle'),
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 22,
//                   ),
//                 ),
//                 actions: [
//                   Material(
//                       color: Colors.transparent,
//                       child: PopupMenuButton<String>(
//                         icon: Icon(Icons.translate_outlined),
//                         initialValue: 'English',
//                         onSelected: (str) {
//                           switch (str) {
//                             case 'English':
//                               translator.translate('en');

//                               break;
//                             case 'العربية':
//                               translator.translate('ar');
//                               break;

//                             default:
//                               translator.translate('ar');
//                           }
//                         },
//                         itemBuilder: (BuildContext context) {
//                           return ['العربية', 'English'].map((String choice) {
//                             return PopupMenuItem<String>(
//                               value: choice,
//                               child: Text(choice),
//                             );
//                           }).toList();
//                         },
//                       )
//                       // InkWell(
//                       //   borderRadius: const BorderRadius.all(
//                       //     Radius.circular(32.0),
//                       //   ),
//                       //   onTap: () {},
//                       //   child: Padding(
//                       //     padding: const EdgeInsets.all(8.0),
//                       //     child: Icon(Icons.favorite_border),
//                       //   ),
//                       // ),

//                       ),
//                   Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(32.0),
//                       ),
//                       onTap: () {},
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Icon(Icons.location_on),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               drawer: HomeDrawer(),

//               ///TODO:bottom sheet

//               bottomSheet: Visibility(
//                   visible: _showButtom,
//                   child: Container(
//                       width: double.infinity,
//                       height: MediaQuery.of(context).size.height / 3,
//                       child: ViewModelBuilder<HomeViewModel>.reactive(
//                           viewModelBuilder: () => HomeViewModel(),
//                           onModelReady: (model) async {
// //if(!sharedPrefs.getFilterState()){
//                             await model.getFitlters();

// //}
//                           },
//                           builder: (context, model, _) {
//                             if (model.state == ViewState.Busy) {
//                               return Center(child: LoadingWidget());
//                             } else if (model.state == ViewState.Error) {
//                               return model.getErrWidget(model.exception,
//                                   () async {
//                                 await model.getFitlters();
//                               });
//                             } else {
//                               return Padding(
//                                   padding: const EdgeInsets.only(
//                                       right: 16, left: 16),
//                                   child: model.types.length > 0
//                                       ? SingleChildScrollView(
//                                           child: Column(
//                                               children: []..add(MaterialButton(
//                                                   onPressed: () {},
//                                                   child: Center(
//                                                     child: Text(
//                                                       'Apply',
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           fontSize: 18,
//                                                           color: Colors.white),
//                                                     ),
//                                                   ),
//                                                 ))),
//                                         )
//                                       : Center(
//                                           child: CircularProgressIndicator())

//                                   // types  .length>0?
//                                   //        Column(
//                                   //         children:typesWidget ,
//                                   //       ): Center(child: CircularProgressIndicator()),
//                                   );
//                             }
//                           }))),
//               body: ListView(
//                 children: [
//                   getSearchBarUI(),
//                   Container(
//                       height:
//                           //double.infinity ,
//                           MediaQuery.of(context).size.height,
//                       child: Stack(children: <Widget>[
//                         InkWell(
//                             splashColor: Colors.transparent,
//                             focusColor: Colors.transparent,
//                             highlightColor: Colors.transparent,
//                             hoverColor: Colors.transparent,
//                             onTap: () {
//                               FocusScope.of(context).requestFocus(FocusNode());
//                             },
//                             child: Column(children: <Widget>[
//                               Expanded(
//                                   child: NestedScrollView(
//                                 controller: _scrollController,
//                                 headerSliverBuilder: (BuildContext context,
//                                     bool innerBoxIsScrolled) {
//                                   return <Widget>[
//                                     // SliverList(
//                                     //   delegate: SliverChildBuilderDelegate(
//                                     //       (BuildContext context, int index) {
//                                     //     return Column(
//                                     //       children: <Widget>[
//                                     //         getSearchBarUI(),
//                                     //       ],
//                                     //     );
//                                     //   }, childCount: 1),
//                                     // ),
//                                     SliverPersistentHeader(
//                                       pinned: true,
//                                       floating: true,
//                                       delegate: ContestTabHeader(
//                                         getFilterBarUI([]),
//                                       ),
//                                     ),
//                                   ];
//                                 },
//                                 body: ViewModelBuilder<HomeViewModel>.reactive(
//                                     viewModelBuilder: () => HomeViewModel(),
//                                     onModelReady: (model) async {
// //if(!sharedPrefs.getFilterState()){
//                                       await model.fetchLocations();

// //}
//                                     },
//                                     builder: (context, model, _) {
//                                       if (model.state == ViewState.Busy) {
//                                         return LoadingWidget();
//                                       } else if (model.state ==
//                                           ViewState.Error) {
//                                         return model.getErrWidget(
//                                             model.exception, () async {
//                                           model.fetchLocations();
//                                         });
//                                       } else {
//                                         if (model.locations.length <= 0) {
//                                           return NoData(
//                                             asset: EMPTY,
//                                             msg: translator.getLanguageName() ==
//                                                     "en"
//                                                 ? "No Location"
//                                                 : "لم يتم العثور على مواقع",
//                                           );
//                                         } else {
//                                           return Container(
//                                               color:
//                                                   MyThemeData.buildLightTheme()
//                                                       .backgroundColor,
//                                               child: ListView.builder(
//                                                 itemCount:
//                                                     model.locations.length,
//                                                 padding: const EdgeInsets.only(
//                                                     top: 8),
//                                                 scrollDirection: Axis.vertical,
//                                                 itemBuilder:
//                                                     (BuildContext context,
//                                                         int index) {
//                                                   print(
//                                                       "/////////////////////////");
//                                                   print(model.locations.length);
//                                                   final int count =
//                                                       hotelList.length > 10
//                                                           ? 10
//                                                           : hotelList.length;
//                                                   final Animation<
//                                                       double> animation = Tween<
//                                                               double>(
//                                                           begin: 0.0, end: 1.0)
//                                                       .animate(CurvedAnimation(
//                                                           parent:
//                                                               animationController,
//                                                           curve: Interval(
//                                                               (1 / count) *
//                                                                   index,
//                                                               1.0,
//                                                               curve: Curves
//                                                                   .fastOutSlowIn)));
//                                                   animationController.forward();
//                                                   return HotelListView(
//                                                     model: model,
//                                                     callback: () {
//                                                       Navigator.of(context)
//                                                           .push(

// //   MaterialPageRoute(builder: (_)=>  LoactionDetails(

// //   location:viewModel.locations[index] ,

// // ))

//                                                               CustomPageRoute(
//                                                                   LoactionDetails(
//                                                         location: model
//                                                             .locations[index],
//                                                       )));
//                                                     },
//                                                     hotelData:
//                                                         model.locations[index],
//                                                     animation: animation,
//                                                     animationController:
//                                                         animationController,
//                                                   );
//                                                 },
//                                               ));
//                                         }
//                                       }
//                                     }),
//                               ))
//                             ]))
//                       ]))
//                 ],
//               )),
//         ),
//       ),
//     );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: MyThemeData.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {},
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    enabled: false,
                    onTap: () async {
                      print(
                          "-------------------OPEN SEARCH-------------------");
                      final FoundedLocations selected =
                          await showSearch<FoundedLocations>(
                        context: context,
                        delegate: _delegate,
                      );
                    },
                    cursorColor: MyThemeData.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: MyThemeData.buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () async {
                  // FocusScope.of(context).requestFocus(FocusNode());

                  print("open serch");
                  final FoundedLocations selected =
                      await showSearch<FoundedLocations>(
                    context: context,
                    delegate: _delegate,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimatedIcon(
                      progress: _delegate.transitionAnimation,
                      icon: AnimatedIcons.search_ellipsis,
                      size: 20,
                      color: MyThemeData.buildLightTheme().backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFilterBarUI(List<TourismLocation> loc) {
    return ViewModelBuilder<HomeViewModel>.nonReactive(
        viewModelBuilder: () => HomeViewModel(),
        onModelReady: (model) async {
//
        },
        builder: (context, viewmodel, _) => Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: MyThemeData.buildLightTheme().backgroundColor,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            offset: const Offset(0, -2),
                            blurRadius: 8.0),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: MyThemeData.buildLightTheme().backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: 4),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${loc.length} location found',
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.grey.withOpacity(0.2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());

                              setState(() {
                                _showButtom = !_showButtom;
                              });

                              // Navigator.push<dynamic>(
                              //   context,
                              //   MaterialPageRoute<dynamic>(
                              //       builder: (BuildContext context) => FiltersScreen(),
                              //       fullscreenDialog: true),
                              // );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Filter',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.sort,
                                        color: MyThemeData.buildLightTheme()
                                            .primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Divider(
                    height: 1,
                  ),
                )
              ],
            ));
  }

  // void showDemoDialog({BuildContext context}) {
  //   showDialog<dynamic>(
  //     context: context,
  //     builder: (BuildContext context) => CalendarPopupView(
  //       barrierDismissible: true,
  //       minimumDate: DateTime.now(),
  //       //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
  //       initialEndDate: endDate,
  //       initialStartDate: startDate,
  //       onApplyClick: (DateTime startData, DateTime endData) {
  //         setState(() {
  //           if (startData != null && endData != null) {
  //             startDate = startData;
  //             endDate = endData;
  //           }
  //         });
  //       },
  //       onCancelClick: () {},
  //     ),
  //   );
  // }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: MyThemeData.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
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
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.menu),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  translator.getString(context, 'appTitle'),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                      color: Colors.transparent,
                      child: PopupMenuButton<String>(
                        icon: Icon(Icons.translate_outlined),
                        initialValue: 'English',
                        onSelected: (str) {
                          switch (str) {
                            case 'English':
                              translator.translate('en');

                              break;
                            case 'العربية':
                              translator.translate('ar');
                              break;

                            default:
                              translator.translate('ar');
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return ['العربية', 'English'].map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      )
                      // InkWell(
                      //   borderRadius: const BorderRadius.all(
                      //     Radius.circular(32.0),
                      //   ),
                      //   onTap: () {},
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Icon(Icons.favorite_border),
                      //   ),
                      // ),

                      ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.location_on),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
