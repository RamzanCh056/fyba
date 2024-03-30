import 'dart:html';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart'as http;



import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../consolePrintWithColor.dart';
import '../../../model/item_model.dart';
import '/providers/basic_provider.dart';
import 'package:provider/provider.dart';

import '../Model/api_data_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AdminFirestoreServices{
  FirebaseFirestore instance=FirebaseFirestore.instance;

  addSetValue(String setValue)async{
    CollectionReference setsCollection = instance.collection("Sets Value");
    setsCollection.doc('1').set({
      'current set value':setValue
    });
  }

  Future<String> uploadImage(String imgUrl) async {
    // InputElement for file picking
    http.Response response = await http.get(Uri.parse(imgUrl));
    final bytes = response.bodyBytes;
    printLog("Before compression: ${bytes.length} bytes");
    String fileName="${Random.secure().nextInt(999999).toString()}.png";

        // Firebase Storage reference
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('images/$fileName');


    // Create metadata and set the content type
    firebase_storage.SettableMetadata metadata = firebase_storage.SettableMetadata(
      contentType: 'image/png', // Set the content type to the appropriate one for your file
      customMetadata: <String, String>{
        'uploaded_by': 'FYBA', // Optional custom metadata
      },
    );


        // Upload task
        final uploadTask = await ref.putData(bytes,metadata);

        // Storage upload task event (progress, pause, resume)
        firebase_storage.TaskSnapshot snapshot = await uploadTask;

        // Get image URL
        final imageUrl = await snapshot.ref.getDownloadURL();
        print('Download URL: $imageUrl');
        return imageUrl;

        // You can store imageUrl to Firestore as the reference to the uploaded file

  }





    addChamp(
      List<ChampModel> champList,
      BuildContext context
      )async{
    CollectionReference championCollection = instance.collection(champCollection);
    bool forLoopExecuted=false;

    List<Map<String,dynamic>> champsMapList=[];
    // Call the function with the folder path you want to delete
    // deleteFolderContents('images/');

    for(int i=0;i<champList.length;i++){
      champList[i].imagePath=await uploadImage(champList[i].imagePath);
      champsMapList.add(champList[i].toJson());
    }

    await championCollection.add({"champs":champsMapList}).then((value)async{
      await Provider.of<BasicProvider>(context,listen: false).updateFirebaseDataAdded();
      Fluttertoast.showToast(msg: "Successfully added champions");
    });

    //   for (int i = 0; i < champList.length; i++) {
    //     await championCollection.add(champList[i].toJson()).then((value) => {
    //     if(i==champList.length-1){
    //     Provider.of<BasicProvider>(context,listen: false).updateFirebaseDataAdded(),
    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$i/${champList.length} Uploaded Successfully"),duration: const Duration(milliseconds: 300),)),
    //
    //
    //     }
    //     });
    //
    //
    // }

  }

  deleteChamp(
      BuildContext context
      )async {
    CollectionReference championCollection = instance.collection(
        champCollection);

    QuerySnapshot champ=await FirebaseFirestore.instance.collection(champCollection).get();

      for (int i = 0; i < champ.size; i++) {
        championCollection.doc(champ.docs[i].id).delete();
        if(i%2==0){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$i/${champ.docs.length} deleted"),duration: const Duration(milliseconds: 50),)
          );}
        // championCollection.doc(docIds[i]).delete();
        // if(i==champList.length-1){
        //   Provider.of<BasicProvider>(context,listen: false).updateFirebadeDataDeleted();
        // }

    }


  }


  Future<void> deleteFolderContents(String folderPath) async {
    final storageRef = FirebaseStorage.instance.ref();
    final folderRef = storageRef.child(folderPath);

    // List all items (files) in the folder
    final result = await folderRef.listAll();

    // loop over the files
    for (var item in result.items) {
      await item.delete().catchError((error) {
        // handle any errors in this deletion
        print(error);
      });
    }

    // Recursively delete all the subfolders
    for (var folder in result.prefixes) {
      await deleteFolderContents(folder.fullPath);
    }
  }




  deleteItem(BuildContext context)async {
    CollectionReference championCollection = instance.collection(
        itemCollection);
    QuerySnapshot snap=await FirebaseFirestore.instance.collection(itemCollection).get();
    for (int i = 0; i < snap.size; i++) {
      championCollection.doc(snap.docs[i].id).delete();
      if(i%8==0){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$i/${snap.docs.length} deleted"),duration: const Duration(milliseconds: 50),)
        );
      }
      // championCollection.doc(docIds[i]).delete();
      // if(i==champList.length-1){
      //   Provider.of<BasicProvider>(context,listen: false).updateFirebadeDataDeleted();
      // }

    }


  }

  addItem(
      List<ItemModel> itemList,
      BuildContext context
      )async{
    CollectionReference itemsCollection = instance.collection(itemCollection);
    bool forLoopExecuted=false;
    List<Map<String,dynamic>> itemsMapList=[];
    for(int i=0;i<itemList.length;i++){
      itemsMapList.add(itemList[i].toMap());
    }

    await itemsCollection.add({"items":itemsMapList}).then((value){
      Fluttertoast.showToast(msg: "Successfully Added items");
    });

    // for (int i = 0; i < itemList.length; i++) {
    //
    //   await itemsCollection.add(itemList[i].toMap()).then((value) => {
    //     if(i%8==0){
    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$i/${itemList.length} Uploaded Successfully"),duration: const Duration(milliseconds: 50),)),
    //
    //     }else
    //     if(i==itemList.length-1){
    //       Provider.of<BasicProvider>(context,listen: false).updateFirebaseDataAdded(),
    //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All Uploaded Successfully"))),
    //     }
    //
    //   });
    //
    //
    // }

  }






}