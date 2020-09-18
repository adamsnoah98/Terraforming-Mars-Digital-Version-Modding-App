import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tm_modder/Widgets/ExtendableBox.dart';
import 'package:tm_modder/screens/mod_screen/GenSelections.dart';
import 'package:tm_modder/main.dart';
import 'package:tm_modder/Widgets/Search.dart' as mySearch;

import '../../style.dart';
import 'CorpSelect.dart';

class ModScreen extends StatelessWidget {

  //TODO refactor GlobalSC to GlobalKey in ModScreen
  //TODO tighter ListView layouts
  //TODO disable select corp if foreground service already active

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(Icons.keyboard_arrow_left),
        actions: [IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: SheetColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DefaultRadius)
                ),
                context: context,
                builder: corpSelectBuilder,
                isScrollControlled: true,
              );
            }
        ),],
        title: Text('Card Selection',),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ExtendableBox(
            minHeight: size.height * 0.1,
            maxHeight: size.height * 0.8,
            startHeight: size.height * 0.35,
            child: mySearch.SearchTile<String>(_ItemSearch(cards)),
          ),
          Expanded(
            child: GenSelections(),
          ),
        ],
      ),
    );
  }
}

class _ItemSearch extends mySearch.SearchDelegate<String> {

  final List<String> _items;
  final RegExp reNum = RegExp(r'\(([0-9]+)\)');

  _ItemSearch(this._items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {query = '';},
      ),
      IconButton(
        icon: Icon(Icons.local_parking),
        onPressed: () { globalSC.pass(); },
        tooltip: "pass",
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //return Icon(Icons.search);
    var suggestions = query.isEmpty ?
    cards.sublist(1) :
    this._items.where(
            (s)=>s.toLowerCase().contains(query.toLowerCase())).toList();
    return Text("${suggestions.length}");
  }

  @override
  Widget buildResults(BuildContext context) {
    var results = this._items.where(
            (s)=>s.toLowerCase().contains(query.toLowerCase())).toList();

    var numQ = query == null ? null : int.tryParse(query);
    if(numQ != null  && numQ > 0 && numQ < cards.length) // Exact card id
      _asyncAdd(numQ);
    if(results.length == 1) // Only one suggestion
      _asyncAdd(_numFromName(results[0]));
    var namedResults = results.where((s)=> s[query.length+1]=='(').toList();
    if(namedResults.length == 1) // Specific search result
      _asyncAdd(_numFromName(namedResults[0]));
    return _getLV(context, results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = query.isEmpty ?
      cards.sublist(1) :
      this._items.where(
              (s)=>s.toLowerCase().contains(query.toLowerCase())).toList();
    return _getLV(context, suggestions);
  }

  ListView _getLV(context, items) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) => ListTile(
          leading: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              globalSC.addCard(_numFromName(items[index]));
              query = '';
            },
          ),
          title: Text(items[index])
      ),
      itemCount: items.length,
    );
  }

  //TODO decouple index from name (store in Li)
  int _numFromName(String name) {
    return int.parse(reNum.firstMatch(name).group(1));
  }

  //TODO extract state to avoid async setState calls
  void _asyncAdd(int id) async {
    Timer(Duration(microseconds: 1), () {globalSC.addCard(id);});
  }
}
