import 'package:shared_preferences/shared_preferences.dart';

class PersistentData {
  static final PersistentData _instance = PersistentData._internal();

  factory PersistentData() => _instance;

  List<int> _persistentDataCache = [40, 5, 45];

  List<String> _persistendDataKeys = [
    "workingHoursPerWeek",
    "numberOfWorkingDaysPerWeek",
    "numberOfMinutesBreak"
  ];

  bool valid = false;

  PersistentData._internal() {
    // init things inside this

    valid = true;
  }

  Future<bool> init() async {
    for (var i = 0; i < _persistentDataCache.length; i++) {
/*      _read(_persistendDataKeys[i])
          .then((onValue) => _persistentDataCache[i] = onValue);*/
      _persistentDataCache[i] = await _read(_persistendDataKeys[i]);
    }
    print("init of persistent data");
    valid = true;
    return valid;
  }

  Future<int> _read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(key) ?? 1;
    print('read: $key = $value');
    return value;
  }

  _save(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
    print('saved: $key = $value');
  }

  int getWorkingHoursPerWeek() {
    //_read(_persistendDataKeys[0]).then((onValue)=>_persistentDataCache[0] = onValue);
    //return _read(_persistendDataKeys[0]);
    return _persistentDataCache[0];
  }

  void setWorkingHoursPerWeek(int value) {
    _save(_persistendDataKeys[0], value);
    _persistentDataCache[0] = value;
  }
}
