import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tm_modder/main.dart';
import 'package:tm_modder/screens/mod_screen/GenItem.dart';
import 'package:tm_modder/style.dart';

class GenSelections extends StatefulWidget {
  State<StatefulWidget> createState() => _GenSelectionsState();
}

class _GenSelectionsState extends State<GenSelections> {
  List<GenItem> _gens = [];
  int _currentGen = 1;

  _GenSelectionsState() {
    _gens.add(new GenItem(globalSC.initRootState(this._update), key: UniqueKey()));
  }

  void _update(gen) {
    setState(() {
      _currentGen = gen;
      if(gen > _gens.length)
        _gens.add(new GenItem(gen, key: UniqueKey()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => Container(
        color: index == _currentGen - 1 ? SelectedBackgroundColor : DefaultColor,
        child: _gens[index],
      ),
      itemCount: _gens.length,
      shrinkWrap: true,
      reverse: true,
    );
  }
}

