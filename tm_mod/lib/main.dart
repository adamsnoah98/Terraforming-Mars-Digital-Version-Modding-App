import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tm_modder/controller/SelectionController.dart';
import 'package:tm_modder/screens/mod_screen/ModScreen.dart';
import 'dart:convert';
import 'style.dart';
import 'screens/info_screen/InfoScreen.dart';

Map<String, String> globalStrs;
List<String> corps;
List<String> cards;
SelectionController globalSC;
const platform = const MethodChannel('com.example.tm_mod/service');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadStaticData();
  globalSC = SelectionController();
  runApp(TmModder());
}

Future<Object> loadStaticData() async {
  globalStrs = new Map<String, String>();
  for(String file in ['cards', 'corps', 'general', 'loading', 'upcoming'])
    globalStrs[file] =
        await rootBundle.loadString('assets/static_text/info/$file.txt');

  var str = await rootBundle.loadString('assets/game_data/corporation_cards.txt');
  corps = new List<String>(13);
  corps[0] = 'Default';
  for(List corp in json.decode(str))
    corps[corp[1]] = corp[0] + ' (${corp[1]})';
  str = await rootBundle.loadString('assets/game_data/project_cards.txt');
  cards = new List<String>(209);
  cards[0] = '';
  for(List card in json.decode(str))
    cards[card[1]] = card[0] + ' (${card[1]})';
  return null;
}

class TmModder extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TM Digital Card Loader',
      theme: _theme(),
      home: PageView(
        children: <Widget>[
          InfoScreen(),
          ModScreen(),
        ],
        scrollDirection: Axis.horizontal,
        controller: PageController(initialPage: 1), //1?
      ),
    );
  }

  ThemeData _theme() {
    return ThemeData(
      primarySwatch: PrimaryColor,
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(headline6: AppBarTextStyle),
      ),
      textTheme: TextTheme(
        headline6: TitleTextStyle,
        bodyText2: BodyTextStyle,
        subtitle1: HeaderTextStyle,
      ),

      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

