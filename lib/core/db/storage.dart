import 'package:hive/hive.dart';

import '../utils/constants.dart';

class Storage {
  static Future<void> save(String key, dynamic data) async {
    Box storage = await Hive.openBox(Constants.DB);
    storage.put(key, data);
  }
  static Future<dynamic> load(String key) async {
    Box storage = await Hive.openBox(Constants.DB);
    return storage.get(key);
  }

}
