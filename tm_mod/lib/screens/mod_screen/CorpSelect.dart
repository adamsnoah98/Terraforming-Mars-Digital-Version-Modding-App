import 'package:flutter/material.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:tm_modder/main.dart';
import 'package:tm_modder/style.dart';
import 'package:tm_modder/controller/TmSaveController.dart';


Widget corpSelectBuilder(context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.75,
    child: Column(
      children: <Widget>[
        Container(
          height: HeaderContainerHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: DefaultColor,
            borderRadius: BorderRadius.all(Radius.circular(DefaultRadius)),
          ),
          child: Text('Select Corporation', style: HeaderTextStyle,)
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) =>
              ListTile(
                title: Text(corps[index]),
                onTap: () async {
                  globalSC.selectCorp(index);
                  _startService();
                  if(await TmSaveController.getPerm()) {
                    new TmSaveController(path: await ExtStorage.getExternalStoragePublicDirectory('Android'));
                  }
                  Navigator.pop(context);
                },
              ),
            itemCount: corps.length,
          ),
        )
      ]
    ),
  );
}

Future<void> _startService() async {
  await platform.invokeMethod('start', 'cards');
}