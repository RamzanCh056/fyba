


import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModelFields{
  static const String apiName="apiName";
  static const String itemImageUrl="itemImageUrl";
  // static const String itemIndex="itemIndex";
  static const String itemDescription="itemDescription";
  static const String itemId="itemId";
  static const String itemName="itemName";

}

class ItemModel{
  String apiName;
  String itemId;
  String itemName;
  String itemImageUrl;
  String itemDescription;
  // String itemIndex;

  ItemModel({
    required this.itemId,
    required this.apiName,
    required this.itemName,
    required this.itemImageUrl,
    required this.itemDescription,
    // required this.itemIndex
});

  Map<String,dynamic> toMap()=>{
    ItemModelFields.apiName:apiName,
    ItemModelFields.itemDescription:itemDescription,
    ItemModelFields.itemImageUrl:itemImageUrl,
    ItemModelFields.itemId:itemId,
    ItemModelFields.itemName:itemName
    // ItemModelFields.itemIndex:itemIndex
  };

  factory ItemModel.fromJson(Map<String,dynamic> json)=>ItemModel(
      apiName: json[ItemModelFields.apiName]??"",
      itemImageUrl: json[ItemModelFields.itemImageUrl]??"",
      itemDescription: json[ItemModelFields.itemDescription]??"",
    itemName: json[ItemModelFields.itemName]??"",
    itemId: json[ItemModelFields.itemId]??""
    // itemIndex: json[ItemModelFields.itemIndex]
  );

}