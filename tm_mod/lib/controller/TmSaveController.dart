import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'SelectionController.dart';
import 'package:tm_modder/main.dart';

///This class handles foreground service calls to load cards
///Each instance handles a single save file through the duration of a run
//Class as is is overbuilt, for future file system ui in app.
class TmSaveController {
  final String _tmDirMatch = 'com.asmodeedigital.terraformingmars/files/Saves/LocalGameSave';
  Directory _tmSavesDir;
  File _save;
  int _gen = 1;
  SelectionController sc;

  static Future<bool> getPerm() async {
    PermissionHandler ph = PermissionHandler();
    if(await ph.checkPermissionStatus(PermissionGroup.storage) != PermissionStatus.granted)
      return PermissionStatus.granted == (await ph.requestPermissions([PermissionGroup.storage]))[PermissionGroup.storage];
    return true;
  }

  TmSaveController({String path, this.sc}) {
    _initChannel();
    var root = Directory(path);
    if(sc == null)
      sc = globalSC;
    for(FileSystemEntity fse in root.listSync(recursive: true))
      if(fse.path.endsWith(_tmDirMatch)) {
        _tmSavesDir = fse as Directory;
      }
    assert (_tmSavesDir is Directory);
    _save = _getSave();
    this.pass(); //Auto load gen 1
    print(_save);
  }

  //get (the) save from dir
  File _getSave() {
    List<FileSystemEntity> fseList = _tmSavesDir.listSync(recursive: false);
    assert (fseList.length > 0 && fseList[0] is File);
    return fseList[0] as File;
  }

  //setup MethodChannel callback for foreground service
  void _initChannel() {
    platform.setMethodCallHandler(
            (call) {
          if(call.method == "inGamePass") {
            print("onPressed: this.pass");
            return this.pass() as Future<dynamic>;
          } else
            throw MissingPluginException('notImplemented');}
    );
  }

  //TODO add json prop checking to be robust
  bool pass() {
    var saveAsJson = json.decode(_save.readAsStringSync());
    var inGameCards;
    if(_gen == 1) {
      var event = saveAsJson['GameState']['Base']['Events']['\$values'][0];
      print(sc.getCorp());
      if(sc.getCorp() > 0 ) //if not default
        event['Corporation']=sc.getCorp();
      inGameCards = event['SelectedCards']['\$values'].cast<int>();
      inGameCards.addAll(sc.getCards(_gen));
      print(event);
    } else if(_gen < 15) {
      var events = saveAsJson['GameState']['Base']['Events']['\$values'] as List;
      var eventInd = events.lastIndexWhere((element) => (element['\$type'] as String).contains('SelectResearchCardsEvent'));
      inGameCards = events[eventInd]['SelectedCards']['\$values'].cast<int>();
      inGameCards.addAll(sc.getCards(_gen));
      print(events[eventInd]);
    } else {
      return false;
    }
    _save.writeAsStringSync(json.encode(saveAsJson));
    _gen += 1;
    return true;
  }


}

