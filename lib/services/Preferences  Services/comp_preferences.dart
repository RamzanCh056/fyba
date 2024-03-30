




import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/Preferences  Services/preferences_keys.dart';

class AppPreferencesServices{


  setPopularCompPreferences(String popularComps)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    await prefs.setString(PreferencesKey.popularComps, popularComps);


  }

  getPopularCompPreferences()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(PreferencesKey.popularComps);

  }

  setUserCompPreferences(String userComps)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    await prefs.setString(PreferencesKey.userComps, userComps);
  }

  getUserCompPreferences()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(PreferencesKey.userComps);
  }

  setChampsPreferences(String champs)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    await prefs.setString(PreferencesKey.champs, champs);
  }
  setItemsPreferences(String items)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    await prefs.setString(PreferencesKey.items, items);
  }

  getChampsPreferences()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    Map<String,dynamic> champsData={
      PreferencesKey.champs: prefs.getString(PreferencesKey.champs),
      PreferencesKey.items:prefs.getString(PreferencesKey.items)
    };
    return champsData;
  }

  setCompUpdateDatesPreferences(String compUpdateDate)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    await prefs.setString(PreferencesKey.compUpdateDate, compUpdateDate);
  }

  setChampUpdateDatesPreferences(String champUpdateDate)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    await prefs.setString(PreferencesKey.champUpdateDate, champUpdateDate);
  }

  getCompUpdateDatesPreferences()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String? compUpdate= prefs.getString(PreferencesKey.compUpdateDate);

    return compUpdate;
  }

  getChampUpdateDatesPreferences()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();

    String? champUpdate= prefs.getString(PreferencesKey.champUpdateDate);
    return champUpdate;
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