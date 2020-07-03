import 'dart:math';


typedef bool Predict<T>(T e);

extension ListHelpers<T> on List<T> {
  T getRandom() {
    Random rand = Random(DateTime.now().microsecondsSinceEpoch);
    return this[rand.nextInt(this.length)];
  }

  bool hasWhere(Predict<T> test){
    var temp = this.where(test);
    if(temp.isEmpty){
      return false;
    }else{
      return true;
    }
  }
}
