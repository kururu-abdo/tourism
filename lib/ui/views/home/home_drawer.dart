import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/shared_prefs.dart';
import 'package:tourapp/ui/shared/my_theme_data.dart';
import 'package:tourapp/ui/shared/transition.dart';
import 'package:tourapp/ui/views/companies/company_page.dart';
import 'package:tourapp/ui/views/location/near_places.dart';
import 'package:tourapp/ui/views/map/map_view.dart';
import 'package:tourapp/ui/views/settings/settings_page.dart';
import 'package:tourapp/ui/views/trip/new_trip.dart';
import 'package:tourapp/ui/views/trip/trips.dart';
import 'package:tourapp/ui/views/user/change_photo.dart';
import 'package:tourapp/ui/views/user/login.dart';
import 'package:tourapp/ui/views/user/profile_page.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer({Key key}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  /// drwer items
  ///
  /// [Profile]
  /// [new Trip]
  /// [scheduled trips]
  /// [trip reminder]
  /// [About app]
  @override
  Widget build(BuildContext context) {
    var translator = Provider.of<TranslationProvider>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: MyThemeData.buildLightTheme().primaryColor,
              ),
              child: Center(
                  child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(API.url +
                        sharedPrefs.getUserIMage().replaceAll("\\", "/")),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.amberAccent),
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(CustomPageRoute(EditPicture()));
                            },
                            icon: Icon(Icons.edit)),
                      ))
                ],
              ))
              //  Text(
              //   'Drawer Header',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 24,
              //   ),
              // ),
              ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => ProfilePage()));
            },
            leading: Container(
              width: 30,
              height: 30,
              child: SvgPicture.asset(
                "assets/images/avatar2.svg",
//1592651892user2
              ),
            ),

            // Icon(Icons.account_circle),
            title: Text(translator.getString("profile_txt")),
          ),

          ListTile(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => NewTrip()));
            },
            leading: Container(
              width: 30,
              height: 30,
              child: InkResponse(
                child: Image.asset("assets/images/icons8-go-64.png"),
                onTap: () {},
              ),
            ),
            title: Text(translator.getString("new_trip")),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => NearPlaces()));
            },
            leading: Container(
              width: 30,
              height: 30,
              child: InkResponse(
                child: Image.asset("assets/images/near.png"),
                onTap: () {},
              ),
            ),
            title: Text(translator.getString("near_txt")),
          ),

          ListTile(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => CompanyPage()));
            },
            leading: Container(
              width: 30,
              height: 30,
              child: InkResponse(
                child: Image.asset("assets/images/ic_company.png"),
                onTap: () {},
              ),
            ),

            // Icon(Icons.account_circle),
            title: Text(translator.getCurrentLang() == "en"
                ? "Tourism Agents"
                : "وكالات وشركات السياحة"),
          ),

          ListTile(
            leading: Container(
              width: 30,
              height: 30,
              child: InkResponse(
                child: Image.asset("assets/images/settings.png"),
                onTap: () {},
              ),
            ),
            title: Text(translator.getString("settings_txt")),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SettingsScreen()));
            },
          ),
          // ListTile(
          //   onTap: (){
          //     Navigator.of(context).push(MaterialPageRoute(builder: (_)=>MapView()));
          //   },
          //   leading: Icon(Icons.settings),
          //   title: Text('Map'),
          // ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(CustomPageRoute(ScheduledTrips()));
            },
            leading: Container(
              width: 30,
              height: 30,
              child: InkResponse(
                child: Image.asset("assets/images/schedule.png"),
                onTap: () {},
              ),
            ),
            title: Text(translator.getString("trips_txt")),
          ),
          Divider(),
          ListTile(
            onTap: () {
              sharedPrefs.changeLoggedIn(false);
              Navigator.pushAndRemoveUntil(
                  context, CustomPageRoute(LoginPage()), (route) => false);
            },
            leading: Container(
              width: 30,
              height: 30,
              child: SvgPicture.asset(
                "assets/power.svg",
              ),
            ),
            title:
                Text(translator.getCurrentLang() == "en" ? "Logout" : "خروج"),
          ),
        ],
      ),
    );
  }
}
