import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/services.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stacked/stacked.dart';
import 'package:tourapp/core/enums/LocationDetails_states.dart';
import 'package:tourapp/core/enums/tabs.dart';
import 'package:tourapp/core/enums/view_state.dart';
import 'package:tourapp/core/models/location.dart';
import 'package:tourapp/core/viewmodels/screens/location/location_details_viewmodel.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/socket_services.dart';
import 'package:tourapp/ui/shared/custom_tween.dart';
import 'package:tourapp/ui/shared/transition.dart';
import 'package:tourapp/ui/views/base_view.dart';
import 'package:tourapp/ui/views/location/comments.dart';
import 'package:tourapp/ui/views/location/hotels.dart';
import 'package:tourapp/ui/views/location/resturnats.dart';
import 'package:tourapp/ui/views/trip/add_trip.dart';
import 'package:tourapp/ui/views/trip/trip_map.dart';

class LoactionDetails extends StatefulWidget {
  final TourismLocation location;
  final int location_id;
  LoactionDetails({  this.location , this.location_id});

  @override
  _LoactionDetailsState createState() => _LoactionDetailsState();
}

class _LoactionDetailsState extends State<LoactionDetails>  with SingleTickerProviderStateMixin {
   final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 95.0;
  TabController _tabController;

    bool _show=false;
  bool verticalGallery = false;
final  List imageList =[];



//  void _showOverlay(BuildContext context , translator) async {
      
//   OverlayState overlayState = Overlay.of(context);
//     OverlayEntry overlayEntry;
//     overlayEntry = OverlayEntry(builder: (context) {
        
//       // You can return any widget you like here
//       // to be displayed on the Overlay
//       return Theme (
//         data: ThemeData(),
//         child: Positioned(
//           left: MediaQuery.of(context).size.width * 0.2,
//           top: MediaQuery.of(context).size.height * 0.3,
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.8,
//             child: Stack(
//               children: [
//                 Container(
//                   height: 250,
//                   width: double.infinity,
//                   color: Colors.grey.shade200,
//                   //  alignment: Alignment.center,
//                   child: GridView.count(
//                     crossAxisSpacing: 5,
//                     mainAxisSpacing: 5,
//                     crossAxisCount: 2,
//                     children: <Widget>[
//                       InkWell(
//                           onTap: () {
//                             Navigator.of(context).push(CustomPageRoute(Hotels(
//                               location_id: widget.location.locationId,
//                             )));
//                           },
//                           child: _button(
//                               "Hotels", FontAwesomeIcons.hotel, Colors.green)),
//                       InkWell(
//                           onTap: () {
//                             Navigator.of(context).push(CustomPageRoute(Resturants(
//                               location_id: widget.location.locationId,
//                             )));
//                           },
//                           child: _button(
//                               "Resturants", Icons.restaurant, Colors.red)),
//                       InkWell(
//                           onTap: () {},
//                           child: _button(
//                               "Reviews", FontAwesomeIcons.comment, Colors.amber)),
//                       InkWell(
//                           onTap: () {},
//                           child:
//                               _button("Go", FontAwesomeIcons.map, Colors.blue)),
//                     ],
//                   ),
//                   // ElevatedButton(
//                   //   child: Text("Close Bottom Sheet"),
//                   //   style: ElevatedButton.styleFrom(
//                   //     onPrimary: Colors.white,
//                   //     primary: Colors.green,
      
//                   //   ),
//                   //   onPressed: () {
//                   //     _show = false;
//                   //     setState(() {
      
//                   //     });
//                   //   },
//                   // ),
//                 ),
//                 Positioned(
//                   top: MediaQuery.of(context).size.height * 0.13,
//                   left: MediaQuery.of(context).size.width * 0.13,
//                   child: Row(
//                     children: [
                    
//                       GestureDetector(
//                         onTap: () {
                            
//                           // When the icon is pressed the OverlayEntry
//                           // is removed from Overlay
//                           overlayEntry.remove();
//                         },
//                         child: Icon(Icons.close,
//                             color: Colors.green,
//                             size: MediaQuery.of(context).size.height * 0.025),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
  
//     // Inserting the OverlayEntry into the Overlay
//     overlayState.insert(overlayEntry);
//   }
  









Widget _showBottomSheet(translator)
  {
    if(_show)
    {
      return BottomSheet(
        onClosing: () {
 
        },
        builder: (context) {
          return 
          
          Container(
            height: 250,
            width: double.infinity,
            color: Colors.grey.shade200,
          //  alignment: Alignment.center,
            child: 
           GridView.count(
             crossAxisSpacing: 5,
             mainAxisSpacing: 5,
             crossAxisCount: 2,
             children: <Widget> [
               

                          
                          
                          InkWell(
                            onTap: (){
                  Navigator.of(context).push(CustomPageRoute(Hotels(
                        location_id: widget.location.locationId,
                      ))).then((value) {
                        _show=false;
                        setState(() {
                          
                        });
                      } 
                      
                      );
                            },
                            child: _button(
                          translator.getCurrentLang()=="en" ?
                              
                              
                              
                              "Hotels":
                              
                              "فنادق"
                              
                              , FontAwesomeIcons.hotel, Colors.green)
                            
                            ),
                    InkWell(
                      onTap: (){
                Navigator.of(context).push(CustomPageRoute(Resturants(
                        location_id: widget.location.locationId,
                      )))
                          .then((value) {
                        _show = false;
                        setState(() {});
                      });
                      ;
                      },
                      child: _button(
                                                  translator.getCurrentLang()=="en" ?

                        "Resturants":"مطاعم", Icons.restaurant, Colors.red)),
                    InkWell(
                      
                      onTap: (){
                          Navigator.of(context).push(CustomPageRoute(Reviews(
                        location   : widget.location,
                      )))
                          .then((value) {
                        _show = false;
                        setState(() {});
                      });
                      
                      },
                      child: _button(
                                                  translator.getCurrentLang()=="en" ?

                        "Reviews":
                        "الاراء و التعليقات"
                        , FontAwesomeIcons.comment, Colors.amber)),
                  


   InkWell(
                    onTap: () {
Navigator.of(context).push(CustomPageRoute(
                      TripMap(
  destination: LatLng(widget.location.lat ,widget.location.lng ),
  destination_name: 
  translator.getCurrentLang() == "en"  ?
  widget.location.locationEnName: widget.location.locationArName,
)
))
                          .then((value) {
                        _show = false;
                        setState(() {});
                      });
                      
                    },
                    child: _button(
                                                translator.getCurrentLang()=="en" ?

                      
                      "Go":"الخريطة", FontAwesomeIcons.map, Colors.blue)),









             ],
           ),
            // ElevatedButton(
            //   child: Text("Close Bottom Sheet"),
            //   style: ElevatedButton.styleFrom(
            //     onPrimary: Colors.white,
            //     primary: Colors.green,
 
            //   ),
            //   onPressed: () {
            //     _show = false;
            //     setState(() {
 
            //     });
            //   },
            // ),


          );
        },
      );
    }
    else{
      return null;
    }
  }









  @override
  void initState() { 
    super.initState();
        _fabHeight = _initFabHeight;
 _tabController = new TabController(
      initialIndex: 1,
      length: 4,
      vsync: this,
    );


    widget.location.locationPics.forEach((element) {
      
imageList.add(element.pic);
    });

    



  }
  @override
  Widget build(BuildContext context) {
        _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    final translator = Provider.of<TranslationProvider>(context);

    return  
    Directionality(


        textDirection: translator.getCurrentLang() == "en"
          ? TextDirection.ltr
          : TextDirection.rtl,

      child: Material(child: 
       Scaffold(
         
            body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              snap: false,
              pinned: true,
              floating: false,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                     translator.getCurrentLang()=="en"?
                      widget.location.locationEnName
                    :
                    widget.location.locationArName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ) //TextStyle
                      ), //Text
                  background: Hero(
                    tag: widget.location.locationEnName +
                            widget.location.locationId.toString(),
                      transitionOnUserGestures: true,
                        // createRectTween: (begin, end) {
                        //   return CustomRectTween(begin: begin, end: end);
                        // },
                    child: Image.network(
                     widget.location.locationPics[0].pic,
                      fit: BoxFit.cover,
                    ),
                  ) //Images.network
                  ), //FlexibleSpaceBar
              expandedHeight: 230,
              backgroundColor:Theme.of(context).primaryColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                tooltip: 'Menu',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ), //IconButton
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.notification_add_sharp),
                  tooltip: 'Comment Icon',
                  onPressed: () {
    
    Navigator.of(context).push(CustomPageRoute(AddTrip(location: widget.location,)));
    
    
                  },
                ), //IconButton
                IconButton(
                  icon: Icon(Icons.menu),
                  tooltip: 'Menu',
                  onPressed: () {
     _show = true;
                        setState(() {});
    
    
                  },
                ), //IconButton
              ], //<Widget>[]
            ), 
    
            // SliverList(
            //   delegate: SliverChildBuilderDelegate(
                
            //     (context, index) => ListTile(
            //       tileColor: (index % 2 == 0) ? Colors.white : Colors.green[50],
            //       title: Center(
            //         child: Text('$index',
            //             style: TextStyle(
            //                 fontWeight: FontWeight.normal,
            //                 fontSize: 50,
            //                 color: Colors.greenAccent[400]) //TextStyle
            //             ), //Text
            //       ), //Center
            //     ), //ListTile
            //     childCount: 2,
                
            //   ), //SliverChildBuildDelegate
            //    ) ,//SliverList
    
    
          SliverFillRemaining(
            child:
                About(translator),
                
          )  
            
           
          ], //<Widget>[]
        ),
        bottomSheet :_showBottomSheet(translator)
        
         //CustonScrollView
            )
      ,),
    );     

    
  }



  Widget About(translator){
return 
   SingleChildScrollView(
   
     child: Column(
               children: [
   
              Container(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          
                          translator.getCurrentLang()=="en"?
                          
                          "Images":    "الصور",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(
                          height: 12.0,
                        ),
   
                        Container(
                          height: 120.0,
                          child:
                  //         PhotoViewGallery.builder(
                  //   itemCount: imageList.length,
                  //   builder: (context, index) {
                  //     return PhotoViewGalleryPageOptions(
                  //       imageProvider: NetworkImage(imageList[index]),
                  //       minScale: PhotoViewComputedScale.contained * 0.8,
                  //       maxScale: PhotoViewComputedScale.covered * 2,
                  //     );
                  //   },
                  //   scrollPhysics: BouncingScrollPhysics(),
                  //   backgroundDecoration: BoxDecoration(
                  //     color: Theme.of(context).canvasColor,
                  //   ),
                  //   loadingBuilder: (ctx ,e)=> Center(
                  //     child: CircularProgressIndicator(),
                  //   ),
                  // ),
                          
                          
                           ListView(
                            scrollDirection: Axis.horizontal,
                            children: widget.location.locationPics
                                .map((e) =>
                                
                                GalleryExampleItemThumbnail(
                                  pic: e.pic,
                                  onTap: () {
                                    open(context, 0);
                                  },
                                )
                                //  CachedNetworkImage(
                                //       imageUrl: e.pic,
                                //       height: 120.0,
                                //       width: (MediaQuery.of(context).size.width -
                                //                   48) /
                                //               2 -
                                //           2,
                                //       fit: BoxFit.cover,
                                //     )

                                )

                                .toList(),
                          ),







                        ),
   
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: <Widget>[
                        //     CachedNetworkImage(
                        //       imageUrl:
                        //           "https://images.fineartamerica.com/images-medium-large-5/new-pittsburgh-emmanuel-panagiotakis.jpg",
                        //       height: 120.0,
                        //       width: (MediaQuery.of(context).size.width - 48) / 2 - 2,
                        //       fit: BoxFit.cover,
                        //     ),
                        //     CachedNetworkImage(
                        //       imageUrl:
                        //           "https://cdn.pixabay.com/photo/2016/08/11/23/48/pnc-park-1587285_1280.jpg",
                        //       width: (MediaQuery.of(context).size.width - 48) / 2 - 2,
                        //       height: 120.0,
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 36.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                           translator.getCurrentLang()=="en"?
                          
                          "About":"",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                        
                           translator.getCurrentLang()=="en"?
                          """ ${widget.location.enDesc}  """:
                           """ ${widget.location.arDesc}  """
                          
                          ,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
               ],
     ),
   );


  }

Widget Resturant() {
return Container(
  
  child: Text("resturant"),);

}





  Widget _button(String label, IconData icon, Color color) {
    return 
     Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            icon,
            color: Colors.white,
          ),
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              blurRadius: 8.0,
            )
          ]),
        ) ,
        SizedBox(
          height: 12.0,
        ),
        Text(label),
     ],
   );
  }


  // Widget _body( ) {
  //   return FlutterMap(
  //     options: MapOptions(
  //       center: LatLng(widget.location.lat,  widget.location.lng),
  //       zoom: 15,
  //       maxZoom: 15,
  //     ),
  //     layers: [
  //       TileLayerOptions(
  //           urlTemplate: "https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png"),
  //       MarkerLayerOptions(markers: [
  //         Marker(
  //             point: LatLng(widget.location.lat,  widget.location.lng),
  //             builder: (ctx) => Icon(
  //                   Icons.location_on,
  //                   color: Colors.red,
  //                   size: 48.0,
  //                 ),
  //             height: 60),
  //       ]),
  //     ],
  //   );
  // }




    void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: imageList,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: verticalGallery ? Axis.vertical : Axis.horizontal,
        ),
      ),
    );
  }

}
class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
     this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder loadingBuilder;
  final BoxDecoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
   int currentIndex =0;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Image ${currentIndex + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String  item = widget.galleryItems[index];
    return  PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(item),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item),
          );
  }
}


class GalleryExampleItem {
  GalleryExampleItem({
     this.id,
     this.resource,
    this.isSvg = false,
  });

  final String id;
  final String resource;
  final bool isSvg;
}

class GalleryExampleItemThumbnail extends StatelessWidget {
  const GalleryExampleItemThumbnail({
    Key key,
     this.pic,
     this.onTap,
  }) : super(key: key);

  final String pic;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag:PictureInfo,
          child: Image.network(pic, height: 80.0),
        ),
      ),
    );
  }
}

List<GalleryExampleItem> galleryItems = <GalleryExampleItem>[
  GalleryExampleItem(
    id: "tag1",
    resource: "assets/gallery1.jpg",
  ),
  GalleryExampleItem(id: "tag2", resource: "assets/firefox.svg", isSvg: true),
  GalleryExampleItem(
    id: "tag3",
    resource: "assets/gallery2.jpg",
  ),
  GalleryExampleItem(
    id: "tag4",
    resource: "assets/gallery3.jpg",
  ),
];