import 'package:get_storage/get_storage.dart';

class AppStorage {
  static final GetStorage _box = GetStorage();

  /// ==========================
  /// Write Data
  /// ==========================
  static Future<void> write<T>(String key, T value) async {
    await _box.write(key, value);
  }

  /// ==========================
  /// Read Data
  /// ==========================
  static T? read<T>(String key) {
    return _box.read<T>(key);
  }

  /// ==========================
  /// Remove Key
  /// ==========================
  static Future<void> remove(String key) async {
    await _box.remove(key);
  }

  /// ==========================
  /// Clear All
  /// ==========================
  static Future<void> clear() async {
    await _box.erase();
  }

  /// ==========================
  /// Check if Key Exists
  /// ==========================
  static bool hasData(String key) {
    return _box.hasData(key);
  }
}