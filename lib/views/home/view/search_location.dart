import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourapp/core/models/founded_locations.dart';
import 'package:tourapp/core/utils/constants.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/locator.dart';
import 'package:tourapp/services/API.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/services/shared_prefs.dart';
import 'package:tourapp/ui/shared/app.dart';
import 'package:tourapp/ui/shared/loading_widget.dart';
import 'package:tourapp/ui/shared/transition.dart';
import 'package:tourapp/ui/views/error_page.dart';
import 'package:tourapp/ui/views/location/location_details_by_id.dart';
import 'package:tourapp/ui/views/no_data_found.dart';
import 'package:tourapp/ui/widgets/circular_loading.dart';

class SearchLocation extends SearchDelegate<FoundedLocations> {
  List<FoundedLocations>  locations=[];
List<FoundedLocations> _history = [];
Future<List<FoundedLocations>> serachdb(searchData , int page) async {
  print(sharedPrefs.getBaseUrl());
    var url = await API.search(query);
    if(!url.error){
  locations=  url.data;
  _history=locations;
    }

    return locations;
  }



  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<FoundedLocations> suggestions = query.isEmpty
        ? _history
        : locations.where(( i) => i.locationArName.startsWith(query)||  i.locationEnName.startsWith(query));
    return _SuggestionList(
      query: query,
      suggestions: suggestions.map<FoundedLocations>(( i) => i).toList(),
      onSelected: (FoundedLocations  suggestion) {
        query = suggestion.locationEnName;
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // final int searched = int.tryParse(query);
    // if (searched == null || !_data.contains(searched)) {
    //   return Center(
    //     child: Text(
    //       '"$query"\n is not a valid integer between 0 and 100,000.\nTry again.',
    //       textAlign: TextAlign.center,
    //     ),
    //   );
    // }
    var translator = Provider.of<TranslationProvider>(context);
      return FutureBuilder(
      future: serachdb(query ,3),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
  
       if(snapshot.hasData){
           if (snapshot.data.length > 0) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _ResultCard(
                      location: snapshot.data[index],
                      searchDelegate: this,
                      title: "Search result:",
                    );
                  }
                  //   Column(
                  //   children: [
                  //     Text(snapshot.data[0].locationArName),
                  //   ],
                  // );

                  );
            } else {
              return NoData(
                asset: NORESULT,
                msg: translator.getString(NOTFOUND_ERR),
              );
            }
       }
       if(snapshot.hasError){


return Text(snapshot.error.toString());

       }
       
       
       
       
       else{
         return NoData(
              asset: NORESULT,
              msg: translator.getString(NOTFOUND_ERR),
            );   
       }
        } else {
          return LoadingWidget();
        }
      },
    );
    return  ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
         return FutureBuilder(
      future: serachdb(query ,  index),
      builder: (context, snapshot) {
          switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    var productInfo = snapshot.data;

                    return ListTile(
                      leading: Icon(Icons.shopping_cart),
                      title: Text(productInfo['name']),
                      subtitle: Text('price: ${productInfo['price']}USD'),
                    );
                  }
                  break;
                  default:
                    return CircularProgressIndicator();
              }
       }
    );
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? IconButton(
              tooltip: 'Voice Search',
              icon: const Icon(Icons.mic),
              onPressed: () {
                query = '';
              },
            )
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            ),
    ];
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({this.location, this.title, this.searchDelegate});
  final FoundedLocations  location;
  final String title;
  final SearchDelegate<FoundedLocations> searchDelegate;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final translator =Provider.of<TranslationProvider>(context);
    return Directionality(textDirection: translator.getCurrentLang()=="en"?TextDirection.ltr:TextDirection.rtl,
      child: GestureDetector(
        onTap: () {
         // searchDelegate.close(context, location);
          Navigator.of(App.navigatorKey.currentContext).push(
CustomPageRoute(LoactionDetailsScreen(location_id: location.locationId,))

          );
        },
        child: Card(
          elevation: 5.0 ,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: 
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround ,
              children: [
                 CircleAvatar(
                   backgroundImage: NetworkImage(location.locationPics[0].pic)
                 ),

                Column(
                  children: <Widget>[
                    Text(
                      translator.getCurrentLang()=="en"?
                      location.locationEnName:location.locationArName ,
                       style: theme.textTheme.headline1.copyWith(fontSize: 20.0),
                      ),
                    Text(
                      translator.getCurrentLang() == "en"
                        ? location.state.stateEnName
                        : location.state.stateArName
                     
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {



  const _SuggestionList({this.suggestions, this.query, this.onSelected});
  final List<FoundedLocations> suggestions;
  final String query;
  final ValueChanged<FoundedLocations> onSelected;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
        final translator = Provider.of<TranslationProvider>(context);

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final FoundedLocations suggestion = suggestions[i];
       
       
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.locationEnName,
              style:
                  theme.textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.locationEnName,
                  style: theme.textTheme.subtitle1,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
