

import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/Preferences  Services/preferences_keys.dart';
class PreferencesServices{

  setPreferences(String email,String password,String userId)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    await prefs.setString(PreferencesKey.emailKey, email);
    await prefs.setString(PreferencesKey.passwordKey, password);
    await prefs.setString('userId', userId);
  }


  getEmailPreferences()async{
    print("Get email");
    SharedPreferences prefs=await SharedPreferences.getInstance();
    print("initialized");
    String? email = prefs.getString(PreferencesKey.emailKey);
    print("Email");
    print(email);
    return email;
  }
  getPasswordPreferences()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String? password = prefs.getString(PreferencesKey.passwordKey);
    return password;
  }

  getUserIdPreferences()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    return userId;
  }



}