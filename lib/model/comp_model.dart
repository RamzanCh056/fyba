



import 'package:app/model/champ_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompCollectionFields{
  static const String docId="docId";
  static const String champList="champList";
}

class CompModel{
  final String docId;
  final List<ChampModelNew> champList;

  CompModel({
   required this.docId,
   required this.champList
});

  Map<String,dynamic> toMap()=>{
    CompCollectionFields.docId:docId,
    CompCollectionFields.champList:champList
  };

  factory CompModel.fromJson(DocumentSnapshot json)=>CompModel(
      docId: json[CompCollectionFields.docId],
      champList: json[CompCollectionFields.champList]
  );


}