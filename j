import 'package:nice_intro/intro_screen.dart';
import 'package:nice_intro/intro_screens.dart';
Then, create a list of screens each one with the IntroSreen class:

////////////////////////////




 AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.RIGHSLIDE,
                        headerAnimationLoop: true,
                        title: 'Error',
                        desc:
                            'Dialog description here..................................................',
                        btnOkOnPress: () {},
                        btnOkIcon: Icons.cancel,
                        btnOkColor: Colors.red)
                      ..show();



AwesomeDialog(
                        context: context,
                        animType: AnimType.LEFTSLIDE,
                        headerAnimationLoop: false,
                        dialogType: DialogType.SUCCES,
                        showCloseIcon: true,
                        title: 'Succes',
                        desc:
                            'Dialog description here..................................................',
                        btnOkOnPress: () {
                          debugPrint('OnClcik');
                        },
                        btnOkIcon: Icons.check_circle,
                        onDissmissCallback: (type) {
                          debugPrint('Dialog Dissmiss from callback $type');
                        })
                      ..show();















////////////////////////////////////







List<IntroScreen> pages =  [
        IntroScreen(
          title: 'Search',
          imageAsset: 'assets/img/1.png',
          description: 'Quickly find all your messages',
          headerBgColor: Colors.white,
        ),
        IntroScreen(
          title: 'Focused Inbox',
          headerBgColor: Colors.white,
          imageAsset: 'assets/img/2.png',
          description: "We've put your most important, actionable emails here",
        ),
        IntroScreen(
          title: 'Social',
          headerBgColor: Colors.white,
          imageAsset: 'assets/img/3.png',
          description: "Keep talking with your mates",
        ),
      ];

You'll come up with a list of nice slides screens.

Finally, pass the pages to an instance of IntroScreens class:

IntroScreens introScreens = IntroScreens(
      footerBgColor: TinyColor(Colors.blue).lighten().color,
      activeDotColor: Colors.white,
      footerRadius: 18.0,
      indicatorType: IndicatorType.CIRCLE,
      pages:pages

    return Scaffold(
      body: introScreens,
    );


    //dropdown
    InputDecorator(
  decoration: InputDecoration(
    labelText: 'Fruit',
    labelStyle: Theme.of(context).primaryTextTheme.caption.copyWith(color: Colors.black),
    border: const OutlineInputBorder(),
  ),
  child: DropdownButtonHideUnderline(
    child: DropdownButton(
      isExpanded: true,
      isDense: true, // Reduces the dropdowns height by +/- 50%
      icon: Icon(Icons.keyboard_arrow_down),
      value: _selectedFruit,
      items: _fruits.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (selectedItem) => setState(() => _selectedFruit = selectedItem,
    ),
  ),
);