import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {

  final String _title;
  final String _info;
  final bool initiallyExpanded;
  static const double _hPad = 16.0;
  static const double _vPad = 4.0;

  InfoSection(this._title, this._info, {bool this.initiallyExpanded = false});

  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(_title),
      children: <Widget>[Container(
          padding: const EdgeInsets.fromLTRB(_hPad, _vPad, _hPad, _vPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text(this._info)]
          ),
      ),],
      initiallyExpanded: initiallyExpanded,
    );
  }
}
