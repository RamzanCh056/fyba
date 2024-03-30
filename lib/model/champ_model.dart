


import 'package:app/model/item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChampModelFieldsNew{
  static const String champCost='champCost';
  static const String champName='champName';
  static const String champTraits='champTraits';
  static const String imagePath='imagePath';
  static const String champPositionIndex='champPositionIndex';
  static const String champItems="champItems";
}

class ChampModelNew{
  String champCost;
  String champName;
  List<String> champTraits;
  String imagePath;
  String champPositionIndex;
  List<ItemModel> champItems;

  ChampModelNew({
      required this.champCost,
      required this.champName,
      required this.champTraits,
      required this.imagePath,
      required this.champPositionIndex,
      required this.champItems});

  Map<String,dynamic> toMap()=>{
    ChampModelFieldsNew.champName:champName,
    ChampModelFieldsNew.champCost:champCost,
    ChampModelFieldsNew.champPositionIndex:champPositionIndex,
    ChampModelFieldsNew.champItems:champItems,
    ChampModelFieldsNew.imagePath:imagePath,
    ChampModelFieldsNew.champTraits:champTraits
  };

  factory ChampModelNew.fromJson(DocumentSnapshot json)=>ChampModelNew(
      champCost: json[ChampModelFieldsNew.champCost],
      champName: json[ChampModelFieldsNew.champName],
      champTraits: json[ChampModelFieldsNew.champTraits],
      imagePath: json[ChampModelFieldsNew.imagePath],
      champPositionIndex: json[ChampModelFieldsNew.champPositionIndex],
      champItems: json[ChampModelFieldsNew.champItems]
  );

}

