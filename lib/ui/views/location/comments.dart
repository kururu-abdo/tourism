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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:stacked/stacked.dart';
import 'package:tourapp/core/enums/widget_state.dart';
import 'package:tourapp/core/models/comment.dart';
import 'package:tourapp/core/models/location.dart';
import 'package:tourapp/core/viewmodels/screens/location/like_view_model.dart';
import 'package:tourapp/core/viewmodels/screens/location/rating_view_model.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/shared_prefs.dart';
import 'package:tourapp/services/socket_services.dart';
import 'package:tourapp/services/stream_sevices.dart';
import 'package:tourapp/ui/shared/my_theme_data.dart';
import 'package:tourapp/viewmodels/comment_view_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Reviews extends StatefulWidget {
  final TourismLocation location;

  Reviews({Key key, this.location}) : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController commentTextController = TextEditingController();
  FocusNode commentFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context
          .read<RatingViewmodel>()
          .getRatings(widget.location.locationId);

      await context
          .read<CommentViewModel>()
          .fetchData(widget.location.locationId);
SocketService().emit('comments', widget.location.locationId);

// await context
//           .read<LikeViewModel>()
//           .ilikeIt(widget.location.locationId , 14);
    });
  }

  @override
  Widget build(BuildContext context) {
    var translator = Provider.of<TranslationProvider>(context);
    var model = Provider.of<CommentViewModel>(context);
    return Directionality(
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
                translator.getString("review_txt"),
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

              ///TODO: handle rating bar

//           actions: [
//       ViewModelBuilder<LikeViewModel>.reactive (
//         viewModelBuilder: ()=>LikeViewModel(),
//         onModelReady: (model) async {
//           await  model.ilikeIt(widget.location.locationId , 14);
//         },

//         builder: (context , model , _){

//  if(model.widgetState==LikeState.Loading){
//    return Center(child:CircularProgressIndicator(strokeWidth: 1.5,),);

//  }

//  return  Material(

//                                       color: Colors.transparent,
//         child:Icon(
//                                                               model.iLikeIt??false?
//                                                               Icons.favorite_outlined
//                                                               :

//                                                               Icons
//                                                                   .favorite_border,
//                                                               color: MyThemeData
//                                                                       .buildLightTheme()
//                                                                   .primaryColor,
//                                                             ),
//         );
//       }
//       )
//           ],
            ),
            body: Padding(
              padding: EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                      translator.getCurrentLang() == "en"
                          ? "Stars"
                          : "التقييمات",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  Consumer<RatingViewmodel>(builder: (context, model, _) {
                    if (model.widgetState == WidgetState.Loaded) {
                      return RatingBar.builder(
                        initialRating: model.rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: MyThemeData.buildLightTheme().primaryColor,
                        ),
                        onRatingUpdate: (rating) async {
                          await model.addRating(sharedPrefs.getUserID(),
                              widget.location.locationId, rating);
                        },
                      );

                      return SmoothStarRating(
                        // allowHalfRating: false,
                        isReadOnly: false,

                        starCount: 5,
                        rating: model.rating,
                        size: 30,
                        color: MyThemeData.buildLightTheme().primaryColor,
                        borderColor: MyThemeData.buildLightTheme().primaryColor,
                        onRated: (rate) async {
                          await Future.delayed(Duration(seconds: 3));

                          print("/////////////////");
                          print(rate);
                          await model.addRating(sharedPrefs.getUserID(),
                              widget.location.locationId, rate);
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                      ),
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  
StreamBuilder<List<Comment>>(

                      stream: streamSocket.getCommentsResponse,

                    

                      builder: (BuildContext context, AsyncSnapshot snapshot) {

                       

                       if (snapshot.hasData) {

                        //  if (!snapshot.hasError) {

                        //    return Center(child :Text('error'));

                        //  } else {

//  return Container(

//                     height: MediaQuery.of(context).size.height-100,

//                     child: CustomScrollView(

//                       slivers: <Widget>[

//                          SliverFixedExtentList(

//                                 itemExtent: 50.0,

//                                 delegate: SliverChildBuilderDelegate(

//                                   (BuildContext context, int index) {

//                                       return CommentWidget(

//                               comment: snapshot.data[index],

//                             );

//                                   },

//                                   childCount: snapshot.data.length,

//                                 ),

//                               ),

//                       ],

//                     ),

//                   );

 return Expanded(

   

   
// height:
// MediaQuery.of(context).size.height +1000  ,

   

   //MediaQuery.of(context).size.height,

   child: ListView.builder(
 shrinkWrap: true,
          // scrollDirection: Axis.vertical,
physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.length,

                            itemBuilder: (BuildContext context, int index) {

                              return CommentWidget(

                                comment: snapshot.data[index],

                              );

                            },

                          

                  ),

 );

                         }

                       

                       

                       

                       //}

                       

                       

                       else{

                          return Center(

                          child: CircularProgressIndicator(

                            strokeWidth: 1.5,

                          ));

                       }

                      },

                    ) ,


                  Container(
                    height: 300,
                    child: CustomScrollView(
                      slivers: <Widget>[
                        
                      ],
                    ),
                  ),
                  
                                  ],
              ),
            ),
            bottomNavigationBar: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: TextField(
                  controller: commentTextController,
                  maxLines: null,
                  focusNode: commentFocus,
                  decoration: InputDecoration(
                    hintText: translator.getCurrentLang() == "en"
                        ? "Write a comment..."
                        : "....قم بكتابة تعليق",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    contentPadding: EdgeInsets.all(5.0),
                    suffixIcon: IconButton(
                        onPressed: () async {
                          if (commentTextController.text != null &&
                              commentTextController.text.length > 0) {
                            // await model.addComment(
                            //     sharedPrefs.getUserID(),
                            //     widget.location.locationId,
                            //     commentTextController.text);


SocketService().emit('user-comment',<String, dynamic> {
  "user": <String, dynamic>{
  "user_id": sharedPrefs.getUser()['id'] ,
  "name": sharedPrefs.getUser()['name']  
  } ,
  "location": <String, dynamic>{
"location_id" :  widget.location.locationId,
"name": widget.location.locationArName
  } ,
  "comment": commentTextController.text
});
                            commentTextController.text = "";

                            commentFocus.unfocus();
                          }
                        },
                        icon: Icon(Icons.send)),
                  ),
                ))));
  }
}

class CommentWidget extends StatelessWidget {
  final Comment comment;
  CommentWidget({Key key, this.comment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 1.9,
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: comment.user.pic.length > 0
                      ? NetworkImage(
                          API.url + comment.user.pic.replaceAll("\\", "/"))
                      : AssetImage("assets/images/logo.png"),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.user.userName),
                    Text(getFormattedDate(comment.time))
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(comment.comment),
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

  String getFormattedDate(String d) {
    return intl.DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.parse(d));
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
