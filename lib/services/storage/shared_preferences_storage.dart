// import 'dart:convert';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'storage_service.dart';

// class SharedPreferencesStorage implements StorageService {
//   final SharedPreferences _preferences;
//   final FlutterSecureStorage _secureStorage;

//   // Secure keys that should be stored in FlutterSecureStorage
//   static final Set<String> _secureKeys = {
//     StorageKeys.authToken,
//     StorageKeys.userId,
//     StorageKeys.userProfile,
//   };

//   SharedPreferencesStorage(this._preferences, this._secureStorage);

//   static Future<SharedPreferencesStorage> init() async {
//     final preferences = await SharedPreferences.getInstance();
//     const secureStorage = FlutterSecureStorage();
//     return SharedPreferencesStorage(preferences, secureStorage);
//   }

//   bool _isSecureKey(String key) => _secureKeys.contains(key);

//   @override
//   Future<void> write(String key, String value) async {
//     if (_isSecureKey(key)) {
//       await _secureStorage.write(key: key, value: value);
//     } else {
//       await _preferences.setString(key, value);
//     }
//   }

//   //secureWrite
//   Future<void> secureWrite(String key, String value) async {
//     await _secureStorage.write(key: key, value: value);
//   }

//   @override
//   Future<String?> read(String key) async {
//     if (_isSecureKey(key)) {
//       return await _secureStorage.read(key: key);
//     } else {
//       return _preferences.getString(key);
//     }
//   }

//   //secureRead
//   Future<String?> secureRead(String key) async {
//     return await _secureStorage.read(key: key);
//   }

//   //read user_data
//   Future<String?> readUserData({String key = 'user_data'}) async {
//     final data = await _secureStorage.read(key: key);
//     return data;
//   }

//   @override
//   Future<void> delete(String key) async {
//     if (_isSecureKey(key)) {
//       await _secureStorage.delete(key: key);
//     } else {
//       await _preferences.remove(key);
//     }
//   }

//   //secureDelete
//   Future<void> secureDelete(String key) async {
//     //checkContainKey
//     if (await secureContainsKey(key)) {
//       await _secureStorage.delete(key: key);
//     }
//   }

//   @override
//   Future<void> clear() async {
//     await Future.wait([
//       _preferences.clear(),
//       _secureStorage.deleteAll(),
//     ]);
//   }

//   @override
//   Future<bool> containsKey(String key) async {
//     if (_isSecureKey(key)) {
//       final allSecureKeys = await _secureStorage.readAll();
//       return allSecureKeys.containsKey(key);
//     } else {
//       return _preferences.containsKey(key);
//     }
//   }

//   //secureContainsKey
//   Future<bool> secureContainsKey(String key) async {
//     final allSecureKeys = await _secureStorage.readAll();
//     return allSecureKeys.containsKey(key);
//   }

//   @override
//   Future<List<String>?> getStringList(String key) async {
//     if (_isSecureKey(key)) {
//       final value = await _secureStorage.read(key: key);
//       if (value == null) return null;
//       try {
//         final List<dynamic> decoded = jsonDecode(value);
//         return decoded.map((e) => e.toString()).toList();
//       } catch (_) {
//         return null;
//       }
//     } else {
//       return _preferences.getStringList(key);
//     }
//   }

//   @override
//   Future<void> setStringList(String key, List<String> values) async {
//     if (_isSecureKey(key)) {
//       final encoded = jsonEncode(values);
//       await _secureStorage.write(key: key, value: encoded);
//     } else {
//       await _preferences.setStringList(key, values);
//     }
//   }
// }
