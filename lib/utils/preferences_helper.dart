import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PreferencesHelper {
  
  // String Methods
  static Future<void> setStringValue(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getStringValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Integer Methods
  static Future<void> setIntValue(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<int?> getIntValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // JSON Methods
  static Future<void> setJsonValue(String key, Map<String, dynamic> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(value));
  }

  static Future<Map<String, dynamic>?> getJsonValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        return json.decode(jsonString);
      } catch (e) {
        print('Error decoding JSON for key $key: $e');
        return null;
      }
    }
    return null;
  }

  // Boolean Methods
  static Future<void> setBoolValue(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBoolValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  // Double Methods
  static Future<void> setDoubleValue(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  static Future<double?> getDoubleValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  // List<String> Methods
  static Future<void> setStringListValue(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  static Future<List<String>?> getStringListValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  // Utility Methods
  static Future<void> removeValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> containsKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  static Future<Set<String>> getAllKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys();
  }

  // Specific helper methods for common use cases
  
  // Token Management
  static Future<void> setAuthToken(String token) async {
    await setStringValue('auth_token', token);
  }

  static Future<String?> getAuthToken() async {
    return await getStringValue('auth_token');
  }

  static Future<void> removeAuthToken() async {
    await removeValue('auth_token');
  }

  static Future<bool> hasAuthToken() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // User ID Management
  static Future<void> setUserId(int userId) async {
    await setIntValue('user_id', userId);
  }

  static Future<int?> getUserId() async {
    return await getIntValue('user_id');
  }

  // User Data Management
  static Future<void> setUserData(Map<String, dynamic> userData) async {
    await setJsonValue('user_data', userData);
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    return await getJsonValue('user_data');
  }

  // Login Status
  static Future<void> setLoginStatus(bool isLoggedIn) async {
    await setBoolValue('is_logged_in', isLoggedIn);
  }

  static Future<bool> getLoginStatus() async {
    final status = await getBoolValue('is_logged_in');
    return status ?? false;
  }

  // Company ID Management
  static Future<void> setCompanyId(int companyId) async {
    await setIntValue('company_id', companyId);
  }

  static Future<int?> getCompanyId() async {
    return await getIntValue('company_id');
  }

  // App Settings
  static Future<void> setDarkMode(bool isDarkMode) async {
    await setBoolValue('dark_mode', isDarkMode);
  }

  static Future<bool> getDarkMode() async {
    final darkMode = await getBoolValue('dark_mode');
    return darkMode ?? false;
  }

  static Future<void> setAppVersion(String version) async {
    await setStringValue('app_version', version);
  }

  static Future<String?> getAppVersion() async {
    return await getStringValue('app_version');
  }

  // Clear specific data groups
  static Future<void> clearAuthData() async {
    await removeValue('auth_token');
    await removeValue('user_id');
    await removeValue('user_data');
    await removeValue('company_id');
    await setBoolValue('is_logged_in', false);
  }

  static Future<void> clearUserData() async {
    await removeValue('user_data');
    await removeValue('user_id');
  }
}