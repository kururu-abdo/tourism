// Skip to content
// Search or jump to…
// Pulls
// Issues
// Marketplace
// Explore

// @kururu-abdo
// enzoftware
// /
// flutter_provider_di_example
// Public
// 1
// 4
// 0
// Code
// Issues
// Pull requests
// Actions
// Projects
// Wiki
// Security
// More
// flutter_provider_di_example/lib/ui/screens/post_screen.dart
// @enzoftware
// enzoftware add ui screens
// Latest commit a755171 on Sep 23, 2019
//  History
//  1 contributor
// 41 lines (38 sloc)  1.29 KB

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';
// import 'package:provider_di/core/models/post.dart';
// import 'package:provider_di/core/models/user.dart';
// import 'package:provider_di/ui/commons/app_colors.dart' as prefix0;
// import 'package:provider_di/ui/commons/text_styles.dart';
// import 'package:provider_di/ui/commons/ui_helpers.dart';
// import 'package:provider_di/ui/widgets/comment_widget.dart';

// class PostScreen extends StatelessWidget {
//   final Post post;

//   const PostScreen({Key key, this.post}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: prefix0.backgroundColor,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             UIHelper.verticalSpaceLarge(),
//             Text(post.title, style: headerStyle),
//             Text(
//               'by ${Provider.of<User>(context).name}',
//               style: TextStyle(fontSize: 9.0),
//             ),
//             UIHelper.verticalSpaceMedium(),
//             Text(post.body),
//             CommentWidget(
//               postId: post.id,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// © 2021 GitHub, Inc.
// Terms
// Privacy
// Security
// Status
// Docs
// Contact GitHub
// Pricing
// API
// Training
// Blog
// About
// Loading complete

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttershare/widgets/header.dart';
// import 'package:fluttershare/widgets/progress.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'home.dart';

// class Comments extends StatefulWidget {
//   final String postId;
//   final String postOwnerId;
//   final String postMediaUrl;

//   Comments({this.postId, this.postMediaUrl, this.postOwnerId});

//   @override
//   CommentsState createState() => CommentsState(
//         postId: this.postId,
//         postOwnerId: this.postOwnerId,
//         postMediaUrl: this.postMediaUrl,
//       );
// }

// class CommentsState extends State<Comments> {
//   final String postId;
//   final String postOwnerId;
//   final String postMediaUrl;
//   TextEditingController commentsController = TextEditingController();

//   CommentsState({this.postId, this.postMediaUrl, this.postOwnerId});

//   buildComments() {
//     //to be realtim
//     return StreamBuilder(
//         stream: commentsRef
//             .document(postId)
//             .collection('comments')
//             .orderBy("timestamp", descending: false)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return circularProgress();
//           }
//           //deserialize
//           List<Comment> comments = [];
//           snapshot.data.documents.forEach((doc) {
//             comments.add(Comment.fromDocument(doc));
//           });
//           return ListView(
//             children: comments,
//           );
//         });
//   }

//   addComment() {
//     commentsRef.document(postId).collection("comments").add({
//       "username": currentUser.username,
//       "comment": commentsController.text,
//       "timestamp": timestamp,
//       "avatarUrl": currentUser.photoUrl,
//       "userId": currentUser.id,
//     });
//     commentsController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: header(context, titleText: "Comments"),
//       body: Column(
//         children: <Widget>[
//           Expanded(child: buildComments()),
//           Divider(),
//           ListTile(
//             title: TextFormField(
//               controller: commentsController,
//               decoration: InputDecoration(labelText: "Write a comment..."),
//             ),
//             trailing: OutlineButton(
//               onPressed: addComment,
//               borderSide: BorderSide.none,
//               child: Text("Post"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Comment extends StatelessWidget {
//   final String username;
//   final String userId;
//   final String avatarUrl;
//   final String comment;
//   final Timestamp timestamp;

//   Comment(
//       {this.username,
//       this.userId,
//       this.avatarUrl,
//       this.comment,
//       this.timestamp});

//   //factory = static
//   factory Comment.fromDocument(DocumentSnapshot doc) {
//     return Comment(
//       username: doc['username'],
//       userId: doc['userId'],
//       avatarUrl: doc['avatarUrl'],
//       comment: doc['comment'],
//       timestamp: doc['timestamp'],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         ListTile(
//             title: Text(comment),
//             leading: CircleAvatar(
//               backgroundImage: CachedNetworkImageProvider(avatarUrl),
//             ),
//             subtitle: Text(timeago.format(timestamp.toDate())) //library,
//             ),
//         Divider(),
//       ],
//     );
//   }
// }

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:stacked/stacked.dart';
import 'package:tourapp/core/enums/view_state.dart';
import 'package:tourapp/core/enums/widget_state.dart';
import 'package:tourapp/core/models/comment.dart';
import 'package:tourapp/core/models/location.dart';
import 'package:tourapp/core/models/near_location.dart';
import 'package:tourapp/core/models/tour_location.dart';
import 'package:tourapp/core/models/user_loaction.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/core/viewmodels/screens/location/near_view_model.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/ui/shared/app.dart';
import 'package:tourapp/ui/shared/my_theme_data.dart';
import 'package:tourapp/ui/shared/transition.dart';
import 'package:tourapp/ui/views/location/location_details_by_id.dart';
import 'package:tourapp/ui/views/no_data_found.dart';
import 'package:tourapp/viewmodels/comment_view_model.dart';
import 'package:location/location.dart' as MyLocation;
import 'package:tourapp/views/home/view/filter_screen_distance.dart';
import 'package:tourapp/views/home/view/filter_search.dart';
class NearPlaces extends StatefulWidget {


  NearPlaces({Key key}) : super(key: key);

  @override
  _NearPlacesState createState() => _NearPlacesState();
}

class _NearPlacesState extends State<NearPlaces> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController commentTextController = TextEditingController();
  var location = MyLocation.Location();
  LatLng loc;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
    var myLocation  =await  location.getLocation();
     setState(() {
       loc= LatLng(myLocation.altitude , myLocation.longitude);
     });
       
     context.read<NearViewmdel>().initial(loc);
    });
  }

  int distance = 10;


TextEditingController rangController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var translator = Provider.of<TranslationProvider>(context);
    var model = Provider.of<CommentViewModel>(context);

    return
        Directionality(textDirection: translator.getCurrentLang()=="en"?TextDirection.ltr:TextDirection.rtl, child: 
       
       Consumer<UserLocation>(
                             builder: (context, UserLocation myLoc, child)=>
          ViewModelBuilder<NearViewmdel>.reactive(
       
         viewModelBuilder: () => NearViewmdel(),
       onModelReady: (viewModel) async{
                        await viewModel.initial(
                    LatLng(myLoc.latitude, myLoc.longitude),
              
                    10.0
                    );

        } ,
       builder: (context, viewModel, _){
       
         return  BackdropScaffold(
         appBar: BackdropAppBar(
           leading: IconButton(onPressed: (){
             Navigator.of(context).pop();
           }, icon: Icon(Icons.arrow_back , color: Colors.white,)),
           title: Text(
                translator.getString("near_txt"),
              ),
           actions: <Widget>[
             BackdropToggleButton(
          icon: AnimatedIcons.list_view,
             )
           ],
         ),
       backLayer: 
        Consumer<UserLocation>(
                               builder: (context, UserLocation myLoc, child)=>
            Center(
             child:  
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Row(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
         children: [
         
          SizedBox(
            width: 100,
            child: TextField(
              controller: rangController,
              keyboardType: TextInputType.number,
              
              decoration:InputDecoration(
         
                fillColor: Colors.white24 ,
                filled: true,
         
                hintText:   translator.getCurrentLang()=="en"?"Distance":"المسافة"
         
              )
            ),
          ),
           Text(translator.getCurrentLang()=="en"?"K.m":"كم",   style: TextStyle(color: Colors.white , fontSize: 15.0 , fontWeight: FontWeight.bold),)
         ],
            ) ,
         
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
                          highlightColor: Colors.white,
                          onTap: () async {
         Backdrop.of(context).concealBackLayer();                     
          await viewModel.initial(LatLng(myLoc.latitude, myLoc.longitude) ,  double.parse(rangController.text));
       
         
                          },
                          child: Center(
                            child: Text(
                              translator.getCurrentLang()=="en"?"Search":"بحث"
                              ,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
            ],
          )
            )
        ) ,
       
       frontLayer: Consumer<UserLocation>(
                               builder: (context, UserLocation myLoc, child)=>
       
       
        ConditionalSwitch.single<WidgetState>(
            context: context,
            valueBuilder: (BuildContext context) => viewModel.widgetState,
            caseBuilders: {
               WidgetState.Loading   : (BuildContext context) => Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                  )),
                       
              WidgetState.Loaded: (BuildContext context) {
       
       if (viewModel.nears.length <= 0) {
                              return NoData(
                                msg: translator.getCurrentLang() == "en"
                                    ? "No NearBy locations Found"
                                    : "لا توجد أماكن بالقرب",
                                asset: EMPTY,
                              );
                            }
                            return ListView.builder(
                              itemCount: viewModel.nears.length,
                              itemBuilder: (BuildContext context, int index) {
                                return NearPlace(
                                  location: viewModel.nears[index],
                                );
                              },
                            );
              },
           
             
             WidgetState.Error: 
           (BuildContext context) => viewModel
                                  .getErrWidget(viewModel.exception, () async {
                                var myLocation = await location.getLocation();
                                await viewModel.initial(LatLng(
                                    myLocation.altitude, myLocation.longitude));
                              })
           
            },
            fallbackBuilder: (BuildContext context) =>  Center(
              child: Column(
              
              children: [
              Image.asset("assets/images/search_now.png") ,

              SizedBox(height: 20.0,),
              Text(translator.getCurrentLang()=="en"?"click the button above and enter distance":"قم بالضغط على االايقونة اعلاه و ادخل المسافة ")
              
              
              ],
              
              ),
            ),
          ),
       
       
         )
         );
       
       
       
         
       }
       
         ),
       )
        );
     Directionality(
        textDirection: translator.getCurrentLang() == "en"
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              title: Text(
                translator.getString("near_txt"),
                style: TextStyle(color: Colors.black),
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
             actions: [

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
                    Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => FiltersScreenDistaance(),
                          fullscreenDialog: true),
                    );
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
                              color:
                                  MyThemeData.buildLightTheme().primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
             ],
            ),
            body: Padding(
              padding: EdgeInsets.all(10.0),
              child: ListView(
                children: [
                
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: 
                    
                    
                    Consumer<NearViewmdel>(
                        builder: (context, model, _) {
                      if (model.widgetState == WidgetState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                          ),
                        );
                      } else if (model.widgetState == WidgetState.Error) {
                        return model.getErrWidget(model.exception, ()async { 
 var myLocation = await location.getLocation();
                   await    model.initial(
                            LatLng(myLocation.altitude, myLocation.longitude));


                        });
                      }
                      else {
                        if (model.nears.length <= 0) {
                        return NoData(
                          msg: translator.getCurrentLang() == "en"
                              ? "No NearBy locations Found"
                              : "لا توجد أماكن بالقرب",
                            asset: EMPTY,
                        );
                      }
                      return ListView.builder(
                        itemCount: model.nears.length,
                        itemBuilder: (BuildContext context, int index) {
                          return NearPlace(
                            location : model.nears[index],
                          );
                        },
                      );


                      }
                    }),
                  )
                ],
              ),
            ),
      
                )
                );
  }
}

class NearPlace extends StatelessWidget {
  final NearLocation   location;
  NearPlace({Key key, this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
            var translator = Provider.of<TranslationProvider>(context);

    return
    
    
     InkWell(
      onTap: (){
           Navigator.of(App.navigatorKey.currentContext)
            .push(CustomPageRoute(LoactionDetailsScreen(
          location_id: location.locationId,
        )));
      },
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              
              translator.getCurrentLang()=="en"?
              location.locationEnName:
              
              location.locationArName
              )
        ,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                
                  translator.getCurrentLang()=="en"?
          "Distance: " +  formatDistance(location.distance)     .toString()+"  "+"K.m":
          
          
            "المسافة: " +     formatDistance(location.distance).toString()+"  "+"كيلو متر"
          ),
            ),
    // ReadMoreText(
    
    //   comment.comment,
    
    //               trimLines: 4,
    
    //               colorClickableText: Colors.pink,
    
    //               trimMode: TrimMode.Line,
    
    //               trimCollapsedText: 'Show more',
    
    //               trimExpandedText: 'Show less',
    
    //               moreStyle: TextStyle(
    
    //                 fontSize: 14,
    
    //               color: Colors.black,
    
    //               fontWeight: FontWeight.bold),
    
    //             ),
    
    //Container(width: double.infinity, height: 2.0, color: Colors.black12,)
          ],
        ),
      ),
    );
  }
  double formatDistance(double x){
   return  (x * 1000).ceil() / 1000;
  }
}
