import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:provider/provider.dart';
import 'package:tourapp/core/models/location.dart';
import 'package:tourapp/core/models/tour_location.dart';
import 'package:tourapp/core/viewmodels/screens/home/home_viewmodel.dart';
import 'package:tourapp/core/viewmodels/screens/location/like_view_model.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/services/API.dart';

import 'package:tourapp/ui/shared/my_theme_data.dart';

class HotelListView extends StatefulWidget {
  HotelListView(
      {Key key,
      this.hotelData,
      this.animationController,
      this.animation,
      this.model,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  //
  //
  //final Location hotelData;
  final HomeViewModel model;
  final TourismLocation hotelData;

  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  _HotelListViewState createState() => _HotelListViewState();
}

class _HotelListViewState extends State<HotelListView> with AutomaticKeepAliveClientMixin<HotelListView> {
  @override
  void initState() {
  
    // Future.microtask(() async {
    //   context
    //       .read<LikeViewModel>()
    //       .getLocationLikes(widget.hotelData.locationId);
    // });
getLocationLikes().then((value) {
setState(() {
  isLoading=false;
  likes=value;
});
}).onError((error, stackTrace) {

setState(() {
        isLoading = false;
        likes = 0;
      });
});
      super.initState();
  }
bool isLoading=true;
int likes=0;

 Future<int> getLocationLikes() async {
    var res = await API.getLocationLikes(widget.hotelData.locationId);
    if (!res.error) {
      return  res.data;
    }
    return  0;
  }

  @override
  Widget build(BuildContext context) {
    var translator= Provider.of<TranslationProvider>(context);
        super.build(context); // need to call super method.

    return AnimatedBuilder(
      animation: widget.animationController,
      
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - widget.animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  widget.callback();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 2,
                              child: Hero(
                                tag: widget.hotelData.locationId,

                                transitionOnUserGestures: true,
                                //  createRectTween: (begin, end) {
                                //   return CustomRectTween(
                                //       begin: begin, end: end);
                                // },
                                child: Image.network(
                                  widget.hotelData.locationPics[0].pic.trim(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              color:
                                  MyThemeData.buildLightTheme().backgroundColor,
                                  padding: EdgeInsets.only(left:8.0 , right:8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              translator.getCurrentLang()=="en"?
                                              widget.hotelData.locationEnName: widget
                                                      .hotelData.locationArName   ,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22,
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  translator.getCurrentLang()=="en"?
                                                  widget.hotelData.state
                                                      .stateEnName:    widget.hotelData.state
                                                          .stateArName  ,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey
                                                          .withOpacity(0.8)),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Icon(
                                                  Icons.location_on,
                                                  size: 12,
                                                  color: MyThemeData
                                                          .buildLightTheme()
                                                      .primaryColor,
                                                ),

                                                ///TODO: destination
                                                // Expanded(
                                                //   child: Text(
                                                //     '${hotelData.dist.toStringAsFixed(1)} km to city',
                                                //     overflow:
                                                //         TextOverflow.ellipsis,
                                                //     style: TextStyle(
                                                //         fontSize: 14,
                                                //         color: Colors.grey
                                                //             .withOpacity(0.8)),
                                                //   ),
                                                // ),
                                              ],
                                            ),

                                            ///TODO:  rating and likes
                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.only(top: 4),
                                            //   child: Row(
                                            //     children: <Widget>[
                                            //       SmoothStarRating(
                                            //         allowHalfRating: true,
                                            //         starCount: 5,
                                            //         rating: hotelData.rating,
                                            //         size: 20,
                                            //         color: MyThemeData
                                            //                 .buildLightTheme()
                                            //             .primaryColor,
                                            //         borderColor: MyThemeData
                                            //                 .buildLightTheme()
                                            //             .primaryColor,
                                            //       ),
                                            //       Text(
                                            //         ' ${hotelData.reviews} Reviews',
                                            //         style: TextStyle(
                                            //             fontSize: 14,
                                            //             color: Colors.grey
                                            //                 .withOpacity(0.8)),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  ///TODO:  some data

                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       right: 16, top: 8),
                                  //   child: Column(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.end,
                                  //     children: <Widget>[
                                  //       Text(
                                  //         '\$${hotelData.perNight}',
                                  //         textAlign: TextAlign.left,
                                  //         style: TextStyle(
                                  //           fontWeight: FontWeight.w600,
                                  //           fontSize: 22,
                                  //         ),
                                  //       ),
                                  //       Text(
                                  //         '/per night',
                                  //         style: TextStyle(
                                  //             fontSize: 14,
                                  //             color:
                                  //                 Colors.grey.withOpacity(0.8)),
                                  //       ),
                                  //     ],
                                  //   ),
                                  //),
                             
  
                           Material(
                                    color: Colors.transparent,
                                    child:
//                             Consumer<LikeViewModel>(builder: (context  , model , _){
//                                 if(model.widgetState==LikeState.Loading){
//                                  return Center(child: CircularProgressIndicator(strokeWidth: 1.0),);

//                                 }

// return InkWell(
//                                   borderRadius: const BorderRadius.all(
//                                     Radius.circular(32.0),
//                                   ),
//                                   onTap: () {},
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Column(
//                                       children: [
//                                         Icon(
//                                           Icons.favorite_border,
//                                           color: MyThemeData.buildLightTheme()
//                                               .primaryColor,
//                                         ),
//                                         Text(model.likes.toString() , style: TextStyle(color:Colors.red),)
//                                       ],
//                                     ),
//                                   ),
//                                 );

//                             }
//                             ,)

InkWell(
  onTap: ()async{
await  widget.model.addLike(
                                                             14, widget.hotelData.locationId);
  },
  child:   ConditionalSwitch.single<bool>(
  
            context: context,
  
            valueBuilder: (BuildContext context) => isLoading,
  
            caseBuilders: {
  
              true: (BuildContext context) => CircularProgressIndicator(
  
                                                            strokeWidth: 1.0),
  
          false: (BuildContext context) =>  Column(
  
                                                          children: [
  
                                                            Icon(
  
                                                              Icons
  
                                                                  .favorite_border,
  
                                                              color: MyThemeData
  
                                                                      .buildLightTheme()
  
                                                                  .primaryColor,
  
                                                            ),
  
                                                            Text(
  
                                                              likes.toString(),
  
                                                                  overflow: TextOverflow.ellipsis,
  
                                                              style: TextStyle(
  
                                                                  color: Colors
  
                                                                      .black),
  
                                                            )
  
                                                          ],
  
                                                        ),
  
            },
  
            fallbackBuilder: (BuildContext context) =>  Column(
  
                                                          children: [
  
                                                            Icon(
  
                                                              Icons
  
                                                                  .favorite_border,
  
                                                              color: MyThemeData
  
                                                                      .buildLightTheme()
  
                                                                  .primaryColor,
  
                                                            ),
  
                                                            Text(
  
                                                              "0",
  
                                                                  overflow: TextOverflow.ellipsis,
  
                                                              style: TextStyle(
  
                                                                  color: Colors
  
                                                                      .black),
  
                                                            )
  
                                                          ],
  
                                                        ),
  
          ),
),


//                                         StreamBuilder<int>(
//                                             stream: widget.model
//                                                 .getLocationLikes(widget
//                                                     .hotelData.locationId),
//                                             builder: (context, snapshot) {
//                                               if (snapshot.connectionState ==
//                                                   ConnectionState.waiting) {
//                                                 return Center(
//                                                   child:
//                                                       CircularProgressIndicator(
//                                                           strokeWidth: 1.0),
//                                                 );
//                                               } else if (snapshot
//                                                       .connectionState ==
//                                                   ConnectionState.done) {
//                                                 if (snapshot.hasData) {
//                                                   return InkWell(
//                                                     borderRadius:
//                                                         const BorderRadius.all(
//                                                       Radius.circular(32.0),
//                                                     ),
//                                                     onTap: ()async {

// await  widget.model.addLike(
//                                                               14, widget.hotelData.locationId);


//                                                     },
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               8.0),
//                                                       child:
                                                      
//                                                        Column(
//                                                         children: [
//                                                           Icon(
//                                                             Icons
//                                                                 .favorite_border,
//                                                             color: MyThemeData
//                                                                     .buildLightTheme()
//                                                                 .primaryColor,
//                                                           ),
//                                                           Text(
//                                                             snapshot.data
//                                                                 .toString()
//                                                                 .toString(),
//                                                                 overflow: TextOverflow.ellipsis,
//                                                             style: TextStyle(
//                                                                 color: Colors
//                                                                     .black),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 } else if (snapshot.hasError) {
//                                                   return InkWell(
//                                                     borderRadius:
//                                                         const BorderRadius.all(
//                                                       Radius.circular(32.0),
//                                                     ),
//                                                     onTap: () {},
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               8.0),
//                                                       child: Column(
//                                                         children: [
//                                                           Icon(
//                                                             Icons
//                                                                 .favorite_border,
//                                                             color: MyThemeData
//                                                                     .buildLightTheme()
//                                                                 .primaryColor,
//                                                           ),
//                                                           Text(
//                                                             0.toString(),
//                                                             style: TextStyle(
//                                                                 color:
//                                                                     Colors.black),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 }
//                                               }
//                                               return Center(
//                                                 child:
//                                                     CircularProgressIndicator(
//                                                         strokeWidth: 1.0),
//                                               );
//                                             }),
                                  ),      
                             
                                ],
                              ),
                            ),
                          ],
                        ),
//                         Positioned(
//                           top: 8,
//                           right: 8,
//                           child:
                          
//                            Material(
//                             color: Colors.transparent,
//                             child:
// //                             Consumer<LikeViewModel>(builder: (context  , model , _){
// //                                 if(model.widgetState==LikeState.Loading){
// //                                  return Center(child: CircularProgressIndicator(strokeWidth: 1.0),);

// //                                 }

// // return InkWell(
// //                                   borderRadius: const BorderRadius.all(
// //                                     Radius.circular(32.0),
// //                                   ),
// //                                   onTap: () {},
// //                                   child: Padding(
// //                                     padding: const EdgeInsets.all(8.0),
// //                                     child: Column(
// //                                       children: [
// //                                         Icon(
// //                                           Icons.favorite_border,
// //                                           color: MyThemeData.buildLightTheme()
// //                                               .primaryColor,
// //                                         ),
// //                                         Text(model.likes.toString() , style: TextStyle(color:Colors.red),)
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 );

// //                             }
// //                             ,)

//                                 FutureBuilder<int>(
//                                     future: widget.model.getLocationLikes(
//                                         widget.hotelData.locationId),
//                                     builder: (context, snapshot) {
//                                       if (snapshot.connectionState ==
//                                           ConnectionState.waiting) {
//                                         return Center(
//                                           child: CircularProgressIndicator(
//                                               strokeWidth: 1.0),
//                                         );
//                                       } else if (snapshot.connectionState ==
//                                           ConnectionState.done) {
//                                         if (snapshot.hasData) {
//                                           return InkWell(
//                                             borderRadius:
//                                                 const BorderRadius.all(
//                                               Radius.circular(32.0),
//                                             ),
//                                             onTap: () {},
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: Column(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.favorite_border,
//                                                     color: MyThemeData
//                                                             .buildLightTheme()
//                                                         .primaryColor,
//                                                   ),
//                                                   Text(
//                                                     snapshot.data
//                                                         .toString()
//                                                         .toString(),
//                                                     style: TextStyle(
//                                                         color: Colors.black),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           );
//                                         } else if (snapshot.hasError) {
//                                           return InkWell(
//                                             borderRadius:
//                                                 const BorderRadius.all(
//                                               Radius.circular(32.0),
//                                             ),
//                                             onTap: () {},
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: Column(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.favorite_border,
//                                                     color: MyThemeData
//                                                             .buildLightTheme()
//                                                         .primaryColor,
//                                                   ),
//                                                   Text(
//                                                     0.toString(),
//                                                     style: TextStyle(
//                                                         color: Colors.black),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           );
//                                         }
//                                       }
//                                       return Center(
//                                         child: CircularProgressIndicator(
//                                             strokeWidth: 1.0),
//                                       );
//                                     }),
//                           ),
//                         )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}