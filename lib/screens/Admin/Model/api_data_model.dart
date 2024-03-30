

import 'package:app/consolePrintWithColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../model/item_model.dart';

String champCollection= 'Champ';
String compCollection = 'Comp Collection';
String champTraitsCollection='Comp_Collection_Champ_Traits';
String pinnedCompCollection='Pinned Comp Collection';
String itemCollection="Item Collection";


// class CompCollectionFields{
//   String docId = 'Document Id';
//   ///
//   /// Champlist length is used for position champ on main screen according
//   /// to the position of team builder
//   ///
//   ///     String champListLength = ChampList Length
//   String champListLength="ChampList Length";
//
//   // List<String> localDbColumns=[CompCollectionFields().docId,CompCollectionFields().champListLength];
//
// }
//



// class CompCollectionModel{
//   String docId;
//   String champListLength;
//   CompCollectionModel({
//     required this.docId,
//     required this.champListLength
//   });
//
//   Map<String,dynamic> toMap()=>{
//     CompCollectionFields().docId:docId,
//     CompCollectionFields().champListLength:champListLength
//   };
//
//
//   CompCollectionModel copy({
//     docId,
//     champListLength
// })=>CompCollectionModel(docId: docId, champListLength: champListLength);
//
//   factory CompCollectionModel.fromJson(DocumentSnapshot json)=>
//       CompCollectionModel(
//           docId: json[CompCollectionFields().docId],
//         champListLength: json[CompCollectionFields().champListLength]
//
//       );
//
//   factory CompCollectionModel.fromLocalDbJson(Map<String,dynamic> json)=>CompCollectionModel(
//       docId: json[CompCollectionFields().docId],
//       champListLength: json[CompCollectionFields().champListLength]
//   );
//
// }



class ChampModelFields{

  static const String champName='champName';
  static const String imagePath = 'imagePath';
  static const String champCost = 'champCost';
  static const String champItems="champItems";
  static const String champTraits='champTraits';
  static const String champPositionIndex="champPositionIndex";

}

class ChampModel{

  String champName;
  String imagePath;
  String champCost;
  List champItems;
  List champTraits;
  String champPositionIndex;


  ChampModel({

    required this.champName,
    required this.imagePath,
    required this.champCost,
    required this.champTraits,
    required  this.champPositionIndex,
    required this.champItems

  });

  Map<String, dynamic> toJson() {
    return{
      ChampModelFields.champName: champName,
      ChampModelFields.imagePath:imagePath,
      ChampModelFields.champCost:champCost,
      ChampModelFields.champTraits:champTraits,
      ChampModelFields.champItems:champItems,
      ChampModelFields.champPositionIndex:champPositionIndex,

    };
  }


  factory ChampModel.fromJson(Map<String, dynamic> json){
    print(json[ChampModelFields.champTraits].runtimeType);
    print(json[ChampModelFields.champName]);
    print(json[ChampModelFields.champCost].runtimeType);
    print(json[ChampModelFields.champPositionIndex]);
    print(json[ChampModelFields.champItems].runtimeType);
    print(json[ChampModelFields.imagePath].runtimeType);

    return ChampModel(
      champName: json[ChampModelFields.champName],
      imagePath: json[ChampModelFields.imagePath],
    champCost: json[ChampModelFields.champCost],
    champTraits: json[ChampModelFields.champTraits],
    champPositionIndex: json[ChampModelFields.champPositionIndex].toString(),
    champItems: json[ChampModelFields.champItems]
  );
  }

  factory ChampModel.fromJsonFirebase(DocumentSnapshot json)=>ChampModel(
      champName: json[ChampModelFields.champName],
      imagePath: json[ChampModelFields.imagePath],
      champCost: json[ChampModelFields.champCost],
      champTraits: json[ChampModelFields.champTraits],
      champPositionIndex: json[ChampModelFields.champPositionIndex],
      champItems: json[ChampModelFields.champItems]


  );
  // factory ChampModel.fromJsonFirebase(DocumentSnapshot json)=>ChampModel(
  //   docId: json[ChampModelFields.compId],
  //     champName: json[ChampModelFields.champName],
  //     imagePath: json[ChampModelFields.imagePath],
  //   hasItems: json[ChampModelFields.hasItems],
  //   champCost: json[ChampModelFields.champCost],
  //   champTraits: json[ChampModelFields.champTraits],
  //     champPositionIndex: json[ChampModelFields.champPositionIndex],
  // );

}



