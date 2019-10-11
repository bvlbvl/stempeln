import 'package:shared_preferences/shared_preferences.dart';


//This is used as a singelton for the entire app to have a single source of
//properties
class PersistentData {
  static final PersistentData _instance = PersistentData._internal();

  factory PersistentData() => _instance;

  List<int> _persistentDataCache = [40, 5, 45];

  List<String> _persistendDataKeys = [
    "workingHoursPerWeek",
    "numberOfWorkingDaysPerWeek",
    "numberOfMinutesBreak"
  ];

  //TODO: actually not needed
  bool valid = false;

  PersistentData._internal() {
    valid = true;
  }

  //shall be called in the first route asynchronously to be sure,
  // that the data is loaded
  Future<bool> init() async {
    for (var i = 0; i < _persistentDataCache.length; i++) {
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
    return _persistentDataCache[0];
  }

  void setWorkingHoursPerWeek(int value) {
    if (value > 1 && value < 24 * 7) {
      _save(_persistendDataKeys[0], value);
      _persistentDataCache[0] = value;
    } else {
      print("wrong number of working hours");
    }
  }

  int getWorkingDaysPerWeek() {
    return _persistentDataCache[1];
  }

  void setWorkingDaysPerWeek(int value) {
    if (value > 1 && value < 7) {
      _save(_persistendDataKeys[1], value);
      _persistentDataCache[1] = value;
    } else {
      print("wrong number of working days");
    }
  }

  int getBreak() {
    return _persistentDataCache[2];
  }

  void setBreak(int value) {
    if (value >= 0 && value < 60) {
      _save(_persistendDataKeys[2], value);
      _persistentDataCache[2] = value;
    } else {
      print("wrong number of minutes of break: $value");
    }
  }
}
