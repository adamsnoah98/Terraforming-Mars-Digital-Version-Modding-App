import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tm_modder/main.dart';

class GenItem extends StatefulWidget {
  final int gen;

  GenItem(this.gen, {Key key}) : super(key: key);

  State<StatefulWidget> createState() => _GenItemState();
}

class _GenItemState extends State<GenItem> {
  List<int> _selections = [];
  String _subtitle = '';

  _GenItemState() {
    globalSC.addUpdate(this._update);
  }

  void _update(String op, int card) {
    setState(() {
      if(op == '-')
        _selections.remove(card);
      else if(op == '+')
        _selections.add(card);
      if(_subtitle.length > 0)
        _subtitle = "- ${_selections.length} card" +
            "${_selections.length == 1 ? "" : "s"}";
    });
  }

  Widget _getBody() {
    if(_selections.length > 0) {
      var tiles = <Widget>[];
      for(int i = 0; i < _selections.length; i++)
        tiles.add(ListTile(
          leading: IconButton(
            icon: Icon(Icons.remove),
            onPressed: () { globalSC.rmCard(widget.gen, _selections[i]); },
          ),
          title: Text(cards[_selections[i]]),
        ),);
      return Column(children: tiles,);
    }
    return Container(height: 20,);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Row(
        children: <Widget>[ // Gen number + edit btn
          Text("Gen ${widget.gen} $_subtitle"),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () { globalSC.setGen(widget.gen); },
            tooltip: 'set current',
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      children: <Widget>[_getBody()], //List of selected cards
      onExpansionChanged: (exp) { // Only show subtitle if closed
        setState(() {
          if(!exp)
            _subtitle = "- ${_selections.length} card" +
                "${_selections.length == 1 ? "" : "s"}";
          else
            _subtitle = '';
        });
      },
    );
  }
}