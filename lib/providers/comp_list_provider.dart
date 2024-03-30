
import 'package:flutter/material.dart';

import '../model/comp_model.dart';
import '../screens/Admin/Model/api_data_model.dart';

class CompListProvider with ChangeNotifier{
  List<CompModel> compCollection=[];
  List<String> docIds=[];
  List<List<ChampModel>> compChampionsList=[];
  bool isDataFetched=false;

  updateCompList(var compList,var docIdList,bool dataFetched){
    compCollection=compList;
    docIds=docIdList;
    isDataFetched=dataFetched;
    notifyListeners();
  }

}