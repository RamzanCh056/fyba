


import 'package:app/Static/static.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/comp_model.dart';
import '../../model/item_model.dart';
import '../../providers/basic_provider.dart';
import '../../providers/comp_list_provider.dart';
import '../../screens/Admin/Model/api_data_model.dart';

class FirestoreCompServices{
  FirebaseFirestore instance = FirebaseFirestore.instance;

  addCompToPopular(
      String docId,
      List<ChampModel> champList,
      Map<String,List<ItemModel>> champItemsList,
      String champListLength,
      BuildContext context
      )async{
    CollectionReference comp_Collection = instance.collection(compCollection);

    print(docId);
    comp_Collection.doc(docId).set({
      CompCollectionFields.docId:docId,
      CompCollectionFields.champList:[
        for(int i=0;i<champList.length;i++){
          champList[i].toJson()
        }
      ]
    });
    // for(int i=0; i<champList.length;i++){
    //   champList[i].docId=docId;
    //   await comp_Collection.doc(docId).collection(champCollection).add(champList[i].toJson()).then(
    //           (value)async{
    //         if(champItemsList.containsKey(champList[i].champPositionIndex)){
    //           for(int j=0;j<champItemsList[champList[i].champPositionIndex]!.length;j++){
    //             await comp_Collection.doc(docId).collection(champCollection).doc(value.id).
    //             collection(StaticInfo.champItemsCollection).add(
    //                 champItemsList[champList[i].champPositionIndex]![j].toMap());
    //           }
    //           await comp_Collection.doc(docId).collection(champCollection).doc(value.id).update(
    //               {ChampModelFields.hasItems:true});
    //         }
    //       });
    //
    // }

  }

  addCompToPopularAdmin(
      String userId,
      String docId,
      List<ChampModel> champList,
      Map<String,List<ItemModel>> champItemsList,
      String champListLength,
      BuildContext context
      )async{
    CollectionReference compCollection = instance.collection(StaticInfo.compCollection);

    List champListMap=[];
    for(int i=0; i<champList.length;i++){
      champListMap.add(champList[i].toJson());
    }

    print(docId);
    await compCollection.doc(docId).set({
      CompCollectionFields.docId:docId,
      CompCollectionFields.champList:champListMap});

  }


  addCompToMyTeams(
      String userId,
      String docId,
      List<ChampModel> champList,
      Map<String,List<ItemModel>> champItemsList,
      String champListLength,
      BuildContext context
      )async{
    CollectionReference compCollection = instance.collection(StaticInfo.userCollection).doc(userId).collection(StaticInfo.compCollection);

    List champListMap=[];
    for(int i=0; i<champList.length;i++){
      champListMap.add(champList[i].toJson());
    }

    print(docId);
    await compCollection.doc(docId).set({
      CompCollectionFields.docId:docId,
      CompCollectionFields.champList:champListMap});

  }



  List<CompModel> compCollectionList=[];
  List<String> docIds=[];
  List<List<ChampModel>> compChampionsList=[];
  fetchFirestoreData(BuildContext context)async{
    QuerySnapshot compQuery=await instance.collection(compCollection).get();
    if(compQuery.docs.isNotEmpty){

      for(int i=0;i<compQuery.docs.length;i++){
        CompModel singleComp= CompModel.fromJson(compQuery.docs[i]);
        compCollectionList.add(singleComp);
        docIds.add(compQuery.docs[i].id);
        QuerySnapshot champQuery=await instance.collection(compCollection).doc(compQuery.docs[i].id).collection(champCollection).get();
        List<ChampModel> champListFromQurey=[];
        for(int j=0;j<champQuery.docs.length;j++){
          // ChampModel champFromQuery=ChampModel.fromJsonFirebase(champQuery.docs[j]);
          // champListFromQurey.add(champFromQuery);
        }
        compChampionsList.add(champListFromQurey);
      }

    }
    Provider.of<CompListProvider>(context,listen: false).updateCompList(compCollectionList, docIds,true);
  }





}