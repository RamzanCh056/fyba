import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../auth screens/user_signup_screen.dart';
import '/constants/app_colors.dart';
import 'package:image_picker/image_picker.dart';

import '../../Static/static.dart';
import 'Model/admin_model.dart';
import '../auth screens/login_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {


  CollectionReference usersPhoto =
      FirebaseFirestore.instance.collection(StaticInfo.addFormData);
  TextEditingController heading = TextEditingController();
  TextEditingController subheading = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var tempImage;
  var downloadUrl;
  var imagedata;
  var tempImage1;
  var downloadUrl1;
  var imagedata1;
  var tempImage2;
  var downloadUrl2;
  var imagedata2;
  var tempImage3;
  var downloadUrl3;
  var imagedata3;
  var imagedata4;
  uploadData() async {
    int id = DateTime.now().millisecondsSinceEpoch;
    AddFormData dataModel = AddFormData(
      heading: heading.text,
      subheading: subheading.text,
      doc: id.toString(),
      earlycamp: imagedata.toString(),
      trails: imagedata1.toString(),
      carousel: imagedata2.toString(),
      options: downloadUrl3.toString(),
    );
    try {
      await FirebaseFirestore.instance
          .collection(StaticInfo.addFormData)
          .doc('$id')
          .set(dataModel.toJson());
      setState(() {});
      Fluttertoast.showToast(msg: 'Data added successfully');
      //showDialogForSuccess();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Some error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainColor,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Center(
                  child: Text(
                    'Admin Page',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 55,
                ),
                Row(
                  children: [
                    Text(
                      'Enter Heading',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                ReusableTextForm(
                  hintText: 'Enter Heading..',
                  controller: heading,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'This field is required';
                    }
                  },
                ),
                SizedBox(
                  height: 22,
                ),
                Row(
                  children: [
                    Text(
                      'Enter Subheading',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                ReusableTextForm(
                  hintText: 'Enter Subheading..',
                  controller: subheading,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'This field is required';
                    }
                  },
                ),
                SizedBox(
                  height: 22,
                ),
                Row(
                  children: [
                    Text(
                      'Early Camp',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    pickImage1();
                  },
                  child: Icon(
                    Icons.camera_alt,
                    size: 55,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                Row(
                  children: [
                    Text(
                      'Trails',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    pickImage2();
                  },
                  child: Icon(
                    Icons.camera_alt,
                    size: 55,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                Row(
                  children: [
                    Text(
                      'Carousel',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    pickImage3();
                  },
                  child: Icon(
                    Icons.camera_alt,
                    size: 55,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                Row(
                  children: [
                    Text(
                      'Options',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    pickImage4();
                  },
                  child: Icon(
                    Icons.camera_alt,
                    size: 55,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                buttonWidget()
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget buttonWidget() {
    return ButtonTheme(
      height: 47,
      minWidth: MediaQuery.of(context).size.width,
      child: MaterialButton(
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            uploadData();
          }
        },
        child: const Text(
          'Save',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }

  pickImage1() async {
    try {
      var photo = await ImagePicker().pickImage(source: ImageSource.camera);
      if (photo != null) {
        tempImage = File(photo.path);
        print("Image is selected");
        uploadFile1();
      } else {
        print("No image selected");
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future uploadFile1() async {
    if (tempImage != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("EarlyCamp")
          .child("earlycamp")
          .putFile(tempImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      downloadUrl = await taskSnapshot.ref.getDownloadURL();
      imagedata = downloadUrl;
    } else {
      return;
    }
  }

  pickImage2() async {
    try {
      var photo = await ImagePicker().pickImage(source: ImageSource.camera);
      if (photo != null) {
        tempImage1 = File(photo.path);
        print("Image is selected");
        uploadFile2();
      } else {
        print("No image selected");
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future uploadFile2() async {
    if (tempImage1 != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("Trails")
          .child("trails")
          .putFile(tempImage1!);
      TaskSnapshot taskSnapshot = await uploadTask;
      downloadUrl1 = await taskSnapshot.ref.getDownloadURL();
      imagedata1 = downloadUrl1;
    } else {
      return;
    }
  }

  pickImage3() async {
    try {
      var photo = await ImagePicker().pickImage(source: ImageSource.camera);
      if (photo != null) {
        tempImage2 = File(photo.path);
        print("Image is selected");
        uploadFile3();
      } else {
        print("No image selected");
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future uploadFile3() async {
    if (tempImage2 != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("Carousel")
          .child("carousel")
          .putFile(tempImage2!);
      TaskSnapshot taskSnapshot = await uploadTask;
      downloadUrl2 = await taskSnapshot.ref.getDownloadURL();
      imagedata2 = downloadUrl2;
    } else {
      return;
    }
  }

  pickImage4() async {
    try {
      var photo = await ImagePicker().pickImage(source: ImageSource.camera);
      if (photo != null) {
        tempImage3 = File(photo.path);
        print("Image is selected");
        uploadFile4();
      } else {
        print("No image selected");
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future uploadFile4() async {
    if (tempImage3 != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("Options")
          .child("options")
          .putFile(tempImage3!);
      TaskSnapshot taskSnapshot = await uploadTask;
      downloadUrl3 = await taskSnapshot.ref.getDownloadURL();
      imagedata3 = downloadUrl3;
    } else {
      return;
    }
  }
}
