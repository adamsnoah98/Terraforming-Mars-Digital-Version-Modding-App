import 'package:tm_modder/model/SelectionData.dart';

class SelectionController {

  final SelectionData _data = new SelectionData();
  Function _mainUpdate;
  List<Function> _updates = [];

  int initRootState(Function update) {
    _mainUpdate = update;
    return _data.currentGen;
  }

  void addUpdate(Function update) {
    _updates.add(update);
  }

  void addCard(int id) {
    _data.addCard(id);
    _updates[_data.currentGen - 1]('+', id);
  }

  void rmCard(int gen, int id) {
    print("Removing: ${_data.currentGen} $id");
    _data.rmCard(gen, id);
    _updates[gen-1]('-', id);
  }

  void setGen(int gen) {
    _data.goToGen(gen);
    _mainUpdate(gen);
    _updates[gen-1]('.', -1);
  }

  int getCurrentGen() {
    return _data.currentGen;
  }

  void pass() async {
    _data.pass();
    _mainUpdate(_data.currentGen);
    if(_data.currentGen <= _updates.length) //newest gen doesn't need an update (if created)
      _updates[_data.currentGen-1]('.', -1);
  }

  void selectCorp(int id) {
    setGen(1);
    _data.corp = id;
  }

  int getCorp() {
    return _data.corp;
  }

  List<int> getCards(int gen) {
    assert (0 < gen && gen < 15);
    if(_data.selections.length < gen)
      return <int>[];
    return <int>[]..addAll(_data.selections[gen-1]);
  }
}