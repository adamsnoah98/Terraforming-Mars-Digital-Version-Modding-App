import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:tm_modder/main.dart';
import 'package:tm_modder/controller/TmSaveController.dart';
import './InfoSection.dart';

class InfoScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [Icon(Icons.keyboard_arrow_right)],
        title: Text('Info'),
      ),
      body: ListView(
        children: <Widget>[
          InfoSection('General', globalStrs['general'], initiallyExpanded: true,),
          InfoSection('Selecting Corporations', globalStrs['corps']),
          InfoSection('Selecting Cards', globalStrs['cards']),
          InfoSection('Dynamic Card Loading', globalStrs['loading']),
          InfoSection('Upcoming', globalStrs['upcoming'])
        ]
      ),
    );
  }
}