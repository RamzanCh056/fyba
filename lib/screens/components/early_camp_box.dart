import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/Static/static.dart';
import '/constants/app_colors.dart';
import '/screens/Admin/Model/admin_model.dart';
import '/widgets/small_image_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/app_sizes.dart';
import '../../constants/box_decorations.dart';

class EarlyCampBox extends StatefulWidget {
  const EarlyCampBox({Key? key}) : super(key: key);

  @override
  State<EarlyCampBox> createState() => _EarlyCampBoxState();
}

class _EarlyCampBoxState extends State<EarlyCampBox> {
  List<AddFormData> FormData = [];

  @override
  void initState() {
    getFormData();
    super.initState();
  }

  getFormData() {
    try {
      FormData.clear();
      setState(() {});
      FirebaseFirestore.instance
          .collection(StaticInfo.addFormData)
          .snapshots()
          .listen((event) {
        FormData.clear();
        // setState(() {});
        for (int i = 0; i < event.docs.length; i++) {
          AddFormData dataModel = AddFormData.fromJson(event.docs[i].data());
          FormData.add(dataModel);
        }
        setState(() {});
      });
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context),
      height: 100,
      decoration: threeBoxDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Early Camp',
            style: GoogleFonts.poppins(
              fontSize: 12.0,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: FormData.length,
              itemBuilder: (_, index) {
                return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.network(FormData[index].earlycamp.toString()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // for (int i = 0; i < 5; i++)
                //   const SmallImageWidget(
                //     imageWidth: 45,
                //     imageHeight: 45,
                //     boxWidth: 45,
                //     boxHeight: 45,
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
