
//core model  for loading cards into game
class SelectionData {
    List<List<int>> selections = [[]];
    int currentGen = 1;
    int corp = -1;

    void addCard(int id) {
      this.selections[this.currentGen-1].add(id);
    }

    void rmCard(int gen, int id) {
      this.selections[gen-1].remove(id);
    }

    bool pass() {
      if(this.currentGen > 14)
        return false;
      this.currentGen++;
      if(this.currentGen - 1 == this.selections.length) {
        selections.add([]);
        return true;
      }
      return false;
    }

    void goToGen(int gen) {
      if(gen < 1 || gen > selections.length)
        throw RangeError.range(gen, 1, selections.length);
      currentGen = gen;
    }

    //for background service
    String next() {
      var res = '';
      for(int id in this.selections[this.currentGen-1])
        res += '$id,';
      if(res.length > 0)
        res = res.substring(0, res.length-1);
      return res;
    }
}