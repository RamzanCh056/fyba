import 'dart:convert';

import 'package:app/consolePrintWithColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../model/item_model.dart';
import '/widgets/responsive_widget.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../constants/exports.dart';
import '../../providers/basic_provider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/small_image_widget.dart';
import '../Admin/Model/api_data_model.dart';

class ExpandHeadingWidget extends StatefulWidget {
  final Widget icon;
  final bool isExpand;
  final String compId;
  List<ChampModel> champList = [];

  // String? docId;
  ExpandHeadingWidget({
    Key? key,
    // this.docId,
    required this.compId,
    required this.icon,
    required this.isExpand,
    required this.champList,
  }) : super(key: key);

  @override
  State<ExpandHeadingWidget> createState() => _ExpandHeadingWidgetState();
}

class _ExpandHeadingWidgetState extends State<ExpandHeadingWidget> {
  String baseUrl = 'https://raw.communitydragon.org/latest/game/';

  ///
  ///         16-May-2023
  /// Image path changed
  ///
  String apiImageUrl =
      'https://raw.communitydragon.org/pbe/plugins/rcp-be-lol-game-data/global/default/assets/characters/';

  setChampList() {
    champList = widget.champList;
    dataFetched = true;
    setState(() {});
  }

  List<ChampModel> champ = [];
  List compCollectionList = [];

  // List<String> docIds=[];
  bool dataFetched = false;

  List<ChampModel> champList = [];

  List<String> traits = [];
  bool traitsFiltered = false;

  final Map traitsMap = {};

  // List mapKeys=[];
  // List mapValues=[];

  filterTraits() {
    for (int i = 0; i < widget.champList.length; i++) {
      for (int j = 0; j < widget.champList[i].champTraits.length; j++) {
        traits.add(widget.champList[i].champTraits[j]);
        print(widget.champList[i].champTraits[j]);
      }
    }

    traits
        .map(
            (e) => traitsMap.containsKey(e) ? traitsMap[e]++ : traitsMap[e] = 1)
        .toList();
    // print("Traits Length:${traits.length}");
    // print("Traits map Length:${traitsMap.length}");
    // print(traitsMap);
    traitsFiltered == true;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.champList.sort(
        (a, b) => int.parse(a.champCost).compareTo(int.parse(b.champCost)));
    // fetchFirestoreData();
    // champList=widget.champList;
    // setChampList();
    filterTraits();
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 3), () {
      // fetchImageData();
    });
    print("Init called");
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double smallImageWidgetSize = 40;
    double extraWebScreenSmallImageWidget = 50;
    // printLog("Expanded heading: ====>${widget.champItems!.length}");
    // champList=widget.champList;
    return ResponsiveWidget.isExtraWebScreen(context)
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///
                Expanded(
                  child: Container(
                    width: width(context),
                    padding: const EdgeInsets.only(
                        top: 7.0, bottom: 8.0, left: 10.0, right: 10),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          widget.isExpand == true
                              ? Colors.transparent
                              : AppColors.expandBoxColor,
                          widget.isExpand == true
                              ? Colors.transparent
                              : AppColors.expandBoxColor,
                          widget.isExpand == true
                              ? Colors.transparent
                              : AppColors.expandBoxDarkColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        /// image
                        const SmallImageWidget(
                          imageUrl: '',
                          imageHeight: 40,
                          imageWidth: 40,
                          boxHeight: 40,
                          boxWidth: 40,
                        ),
                        const SizedBox(width: 8),

                        /// name and desc
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Veronica King V',
                                style: poppinsSemiBold.copyWith(
                                  fontSize: 12,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              const SizedBox(height: 1.0),
                              Text(
                                'Hard',
                                style: poppinsRegular.copyWith(
                                  fontSize: 12,
                                  color: AppColors.whiteColor.withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * .02,
                        ),

                        /// image with stars
                        Expanded(
                          flex: 7,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (widget.champList.length >= 11)
                                for (int i = 0; i < 11; i++)
                                  Padding(
                                      // Provider.of<BasicProvider>(context).isVisibleDataFromFirebase?Padding(
                                      padding:
                                          const EdgeInsets.only(right: 6.0),
                                      // child: dataFetched?
                                      child: widget.champList[i].champItems
                                              .isNotEmpty
                                          ? Column(
    mainAxisSize:MainAxisSize.min,
                                            children: [
                                              Stack(
                                                  alignment: Alignment.bottomCenter,
                                                  children: [
                                                    SmallImageWidget(
                                                      // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                      ///
                                                      ///  16-May-2023
                                                      /// Fetching new image path
                                                      ///
                                                      ///
                                                      imageWidth: 40,
                                                      imageHeight: 40,
                                                      boxWidth: 40,
                                                      boxHeight: 40,
                                                      imageUrl: widget
                                                          .champList[i].imagePath,
                                                      // isBorder: i == 0 || i == 2 ? true : false,
                                                      // isShadow: i == 0 || i == 2 ? true : false,
                                                      // isStar: i == 2 || i == 3 ? true : false,
                                                      ///
                                                      /// Date : 14-May-2023
                                                      ///
                                                      /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                      ///
                                                      /// Different border colors of images
                                                      /// according to the cost of the champion
                                                      ///
                                                      /// This color representation is for popular
                                                      /// category on main screen
                                                      ///
                                                      borderColor: widget
                                                                  .champList[i]
                                                                  .champCost ==
                                                              '1'
                                                          ? Colors.grey
                                                          : widget.champList[i]
                                                                      .champCost ==
                                                                  '2'
                                                              ? Colors.green
                                                              : widget.champList[i]
                                                                          .champCost ==
                                                                      '3'
                                                                  ? Colors.blue
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '4'
                                                                      ? Colors
                                                                          .purple
                                                                      : widget.champList[i].champCost ==
                                                                              '5'
                                                                          ? Colors
                                                                              .yellow
                                                                          : Colors
                                                                              .red,
                                                      shadowColor: widget
                                                                  .champList[i]
                                                                  .champCost ==
                                                              '1'
                                                          ? const Color(0x609E9E9E)
                                                          : widget.champList[i]
                                                                      .champCost ==
                                                                  '2'
                                                              ? const Color(
                                                                  0x604CAF50)
                                                              : widget.champList[i]
                                                                          .champCost ==
                                                                      '3'
                                                                  ? const Color(
                                                                      0x602196F3)
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '4'
                                                                      ? const Color(
                                                                          0x609C27B0)
                                                                      : widget.champList[i].champCost ==
                                                                              '5'
                                                                          ? const Color(
                                                                              0x60FFEB3B)
                                                                          : const Color(
                                                                              0x60F44336),
                                                      isBorder: true,
                                                      isShadow: true,
                                                      isStar: i == 2 || i == 3
                                                          ? true
                                                          : false,
                                                    ),
                                                    Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                      children: List.generate(
                                                          widget
                                                              .champList[i]
                                                              .champItems
                                                              .length, (index) {
                                                        printLog(
                                                            "+++++*********=============== Items ");
                                                        // return Image.network(widget.champItems![widget.champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                        return Container(
                                                            height: 15,
                                                            width: 15,
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Image(
                                                                image: NetworkImage(widget
                                                                        .champList[i]
                                                                        .champItems[index]
                                                                    [
                                                                    "itemImageUrl"])));
                                                        // SmallImageWidget(
                                                        //     imageHeight: 10,
                                                        //     imageWidth: 10,
                                                        //     boxWidth: 10,
                                                        //     boxHeight: 10,
                                                        //     isBorder: false,
                                                        //     imageUrl: widget.champList[i].champItems[index]["itemImageUrl"]
                                                        //
                                                        // ),
                                                      }),
                                                    ),
                                                  ],
                                                ),
                                              Text(
                                                widget
                                                    .champList[
                                                i]
                                                    .champName
                                                    .length >
                                                    5
                                                    ? widget
                                                    .champList[
                                                i]
                                                    .champName
                                                    .substring(
                                                    0,
                                                    5)
                                                    : widget
                                                    .champList[
                                                i]
                                                    .champName,
                                                style: TextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontSize: 9),
                                              )
                                            ],
                                          )
                                          : Column(
    mainAxisSize:MainAxisSize.min,
    children: [
                                              SmallImageWidget(
                                                  // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                  ///
                                                  ///  16-May-2023
                                                  /// Fetching new image path
                                                  ///
                                                  imageHeight: 40,
                                                  imageWidth: 40,
                                                  boxHeight: 40,
                                                  boxWidth: 40,
                                                  imageUrl:
                                                      widget.champList[i].imagePath,
                                                  // isBorder: i == 0 || i == 2 ? true : false,
                                                  // isShadow: i == 0 || i == 2 ? true : false,
                                                  // isStar: i == 2 || i == 3 ? true : false,
                                                  ///
                                                  /// Date : 14-May-2023
                                                  ///
                                                  /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                  ///
                                                  /// Different border colors of images
                                                  /// according to the cost of the champion
                                                  ///
                                                  /// This color representation is for popular
                                                  /// category on main screen
                                                  ///
                                                  borderColor: widget.champList[i]
                                                              .champCost ==
                                                          '1'
                                                      ? Colors.grey
                                                      : widget.champList[i]
                                                                  .champCost ==
                                                              '2'
                                                          ? Colors.green
                                                          : widget.champList[i]
                                                                      .champCost ==
                                                                  '3'
                                                              ? Colors.blue
                                                              : widget.champList[i]
                                                                          .champCost ==
                                                                      '4'
                                                                  ? Colors.purple
                                                                  : widget.champList[i]
                                                                              .champCost ==
                                                                          '5'
                                                                      ? Colors.yellow
                                                                      : Colors.red,
                                                  shadowColor: widget.champList[i]
                                                              .champCost ==
                                                          '1'
                                                      ? const Color(0x609E9E9E)
                                                      : widget.champList[i]
                                                                  .champCost ==
                                                              '2'
                                                          ? const Color(0x604CAF50)
                                                          : widget.champList[i]
                                                                      .champCost ==
                                                                  '3'
                                                              ? const Color(
                                                                  0x602196F3)
                                                              : widget.champList[i]
                                                                          .champCost ==
                                                                      '4'
                                                                  ? const Color(
                                                                      0x609C27B0)
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '5'
                                                                      ? const Color(
                                                                          0x60FFEB3B)
                                                                      : const Color(
                                                                          0x60F44336),
                                                  isBorder: true,
                                                  isShadow: true,
                                                  isStar: i == 2 || i == 3
                                                      ? true
                                                      : false,
                                                ),
      Text(
        widget
            .champList[
        i]
            .champName
            .length >
            5
            ? widget
            .champList[
        i]
            .champName
            .substring(
            0,
            5)
            : widget
            .champList[
        i]
            .champName,
        style: TextStyle(
            color: Colors
                .white,
            fontSize: 9),
      )
                                            ],
                                          )),
                              if (widget.champList.length < 11)
                                for (int i = 0;
                                    i < widget.champList.length;
                                    i++)
                                  Padding(
                                      // Provider.of<BasicProvider>(context).isVisibleDataFromFirebase?Padding(
                                      padding:
                                          const EdgeInsets.only(right: 6.0),
                                      // child: dataFetched?
                                      child: widget.champList[i].champItems
                                              .isNotEmpty
                                          ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Stack(
                                                  alignment: Alignment.bottomCenter,
                                                  children: [
                                                    SmallImageWidget(
                                                      // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                      ///
                                                      ///  16-May-2023
                                                      /// Fetching new image path
                                                      ///
                                                      imageWidth: 40,
                                                      imageHeight: 40,
                                                      boxWidth: 40,
                                                      boxHeight: 40,
                                                      imageUrl: widget
                                                          .champList[i].imagePath,
                                                      // isBorder: i == 0 || i == 2 ? true : false,
                                                      // isShadow: i == 0 || i == 2 ? true : false,
                                                      // isStar: i == 2 || i == 3 ? true : false,
                                                      ///
                                                      /// Date : 14-May-2023
                                                      ///
                                                      /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                      ///
                                                      /// Different border colors of images
                                                      /// according to the cost of the champion
                                                      ///
                                                      /// This color representation is for popular
                                                      /// category on main screen
                                                      ///
                                                      borderColor: widget
                                                                  .champList[i]
                                                                  .champCost ==
                                                              '1'
                                                          ? Colors.grey
                                                          : widget.champList[i]
                                                                      .champCost ==
                                                                  '2'
                                                              ? Colors.green
                                                              : widget.champList[i]
                                                                          .champCost ==
                                                                      '3'
                                                                  ? Colors.blue
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '4'
                                                                      ? Colors
                                                                          .purple
                                                                      : widget.champList[i].champCost ==
                                                                              '5'
                                                                          ? Colors
                                                                              .yellow
                                                                          : Colors
                                                                              .red,
                                                      shadowColor: widget
                                                                  .champList[i]
                                                                  .champCost ==
                                                              '1'
                                                          ? const Color(0x609E9E9E)
                                                          : widget.champList[i]
                                                                      .champCost ==
                                                                  '2'
                                                              ? const Color(
                                                                  0x604CAF50)
                                                              : widget.champList[i]
                                                                          .champCost ==
                                                                      '3'
                                                                  ? const Color(
                                                                      0x602196F3)
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '4'
                                                                      ? const Color(
                                                                          0x609C27B0)
                                                                      : widget.champList[i].champCost ==
                                                                              '5'
                                                                          ? const Color(
                                                                              0x60FFEB3B)
                                                                          : const Color(
                                                                              0x60F44336),
                                                      isBorder: true,
                                                      isShadow: true,
                                                      isStar: i == 2 || i == 3
                                                          ? true
                                                          : false,
                                                    ),
                                                    Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                      children: List.generate(
                                                          widget
                                                              .champList[i]
                                                              .champItems
                                                              .length, (index) {
                                                        printLog(
                                                            "+++++*********=============== Items ");
                                                        // return Image.network(widget.champItems![widget.champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                        return Container(
                                                            height: 15,
                                                            width: 15,
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Image(
                                                                image: NetworkImage(widget
                                                                        .champList[i]
                                                                        .champItems[index]
                                                                    [
                                                                    "itemImageUrl"])));

                                                        // Container(
                                                        //     height: 10,
                                                        //     width: 10,
                                                        //     decoration: BoxDecoration(
                                                        //       border: Border.all(color: Colors.white),
                                                        //     ),
                                                        //     child: Image(image: NetworkImage(widget.champList[i].champItems[index]["itemImageUrl"]))
                                                        // );
                                                        //   SmallImageWidget(
                                                        //     imageHeight: 10,
                                                        //     imageWidth: 10,
                                                        //     boxWidth: 10,
                                                        //     boxHeight: 10,
                                                        //     isBorder: false,
                                                        //     imageUrl: widget.champList[i].champItems[index]["itemImageUrl"]
                                                        //
                                                        // );
                                                      }),
                                                    ),
                                                  ],
                                                ),
                                              Text(
                                                widget
                                                    .champList[
                                                i]
                                                    .champName
                                                    .length >
                                                    5
                                                    ? widget
                                                    .champList[
                                                i]
                                                    .champName
                                                    .substring(
                                                    0,
                                                    5)
                                                    : widget
                                                    .champList[
                                                i]
                                                    .champName,
                                                style: TextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontSize: 9),
                                              )
                                            ],
                                          )
                                          : Column(
                                        mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SmallImageWidget(
                                                  // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                  ///
                                                  ///  16-May-2023
                                                  /// Fetching new image path
                                                  ///
                                                  imageHeight: 40,
                                                  imageWidth: 40,
                                                  boxHeight: 40,
                                                  boxWidth: 40,
                                                  imageUrl:
                                                      widget.champList[i].imagePath,
                                                  // isBorder: i == 0 || i == 2 ? true : false,
                                                  // isShadow: i == 0 || i == 2 ? true : false,
                                                  // isStar: i == 2 || i == 3 ? true : false,
                                                  ///
                                                  /// Date : 14-May-2023
                                                  ///
                                                  /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                  ///
                                                  /// Different border colors of images
                                                  /// according to the cost of the champion
                                                  ///
                                                  /// This color representation is for popular
                                                  /// category on main screen
                                                  ///
                                                  borderColor: widget.champList[i]
                                                              .champCost ==
                                                          '1'
                                                      ? Colors.grey
                                                      : widget.champList[i]
                                                                  .champCost ==
                                                              '2'
                                                          ? Colors.green
                                                          : widget.champList[i]
                                                                      .champCost ==
                                                                  '3'
                                                              ? Colors.blue
                                                              : widget.champList[i]
                                                                          .champCost ==
                                                                      '4'
                                                                  ? Colors.purple
                                                                  : widget.champList[i]
                                                                              .champCost ==
                                                                          '5'
                                                                      ? Colors.yellow
                                                                      : Colors.red,
                                                  shadowColor: widget.champList[i]
                                                              .champCost ==
                                                          '1'
                                                      ? const Color(0x609E9E9E)
                                                      : widget.champList[i]
                                                                  .champCost ==
                                                              '2'
                                                          ? const Color(0x604CAF50)
                                                          : widget.champList[i]
                                                                      .champCost ==
                                                                  '3'
                                                              ? const Color(
                                                                  0x602196F3)
                                                              : widget.champList[i]
                                                                          .champCost ==
                                                                      '4'
                                                                  ? const Color(
                                                                      0x609C27B0)
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '5'
                                                                      ? const Color(
                                                                          0x60FFEB3B)
                                                                      : const Color(
                                                                          0x60F44336),
                                                  isBorder: true,
                                                  isShadow: true,
                                                  isStar: i == 2 || i == 3
                                                      ? true
                                                      : false,
                                                ),
                                              Text(
                                                widget
                                                    .champList[
                                                i]
                                                    .champName
                                                    .length >
                                                    5
                                                    ? widget
                                                    .champList[
                                                i]
                                                    .champName
                                                    .substring(
                                                    0,
                                                    5)
                                                    : widget
                                                    .champList[
                                                i]
                                                    .champName,
                                                style: TextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontSize: 9),
                                              )
                                            ],
                                          )),
                            ],
                          ),
                        ),

                        /// arrow down icon
                        const Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                              size: 30,
                            ))
                        // widget.icon,
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                /// pin icon
                InkWell(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    printLog(
                        "========> Pinned id: ====<${Provider.of<BasicProvider>(context, listen: false).pinnedCompChamps}");
                    await FirebaseFirestore.instance
                        .collection(pinnedCompCollection)
                        .doc("0123")
                        .update({'compId': jsonEncode(widget.champList)});
                    await Provider.of<BasicProvider>(context, listen: false)
                        .fetchCurrentPinnedComp();
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: isLoading
                          ? const Center(
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator()))
                          : Transform.rotate(
                              angle: math.pi / 4,
                              child: Icon(
                                Icons.push_pin,
                                color: Provider.of<BasicProvider>(context,
                                                listen: false)
                                            .pinnedCompChamps ==
                                        widget.champList
                                    ? Colors.yellowAccent
                                    : Colors.white,
                                size: 20,
                              ))
                      // SvgPicture.asset(AppIcons.pin, height: 20),
                      ),
                ),
              ],
            ),
          )
        : ResponsiveWidget.isWebScreen(context)
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///
                    Expanded(
                      child: Container(
                        width: width(context),
                        padding: const EdgeInsets.only(
                            top: 7.0, bottom: 8.0, left: 10.0, right: 10),
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              widget.isExpand == true
                                  ? Colors.transparent
                                  : AppColors.expandBoxColor,
                              widget.isExpand == true
                                  ? Colors.transparent
                                  : AppColors.expandBoxColor,
                              widget.isExpand == true
                                  ? Colors.transparent
                                  : AppColors.expandBoxDarkColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            /// image
                            const SmallImageWidget(
                              imageUrl: '',
                              imageHeight: 40,
                              imageWidth: 40,
                              boxHeight: 40,
                              boxWidth: 40,
                            ),
                            const SizedBox(width: 8),

                            /// name and desc
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Veronica King V',
                                    style: poppinsSemiBold.copyWith(
                                      fontSize: 12,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                  const SizedBox(height: 1.0),
                                  Text(
                                    'Hard',
                                    style: poppinsRegular.copyWith(
                                      fontSize: 12,
                                      color:
                                          AppColors.whiteColor.withOpacity(0.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .02,
                            ),

                            /// image with stars
                            Expanded(
                              flex: 7,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (widget.champList.length >= 11)
                                    for (int i = 0; i < 11; i++)
                                      Padding(
                                          // Provider.of<BasicProvider>(context).isVisibleDataFromFirebase?Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6.0),
                                          // child: dataFetched?
                                          child:
                                              widget.champList[i].champItems
                                                      .isNotEmpty
                                                  ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Stack(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          children: [
                                                            SmallImageWidget(
                                                              // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                              ///
                                                              ///  16-May-2023
                                                              /// Fetching new image path
                                                              ///
                                                              ///
                                                              imageWidth: 40,
                                                              imageHeight: 40,
                                                              boxWidth: 40,
                                                              boxHeight: 40,
                                                              imageUrl: widget
                                                                  .champList[i]
                                                                  .imagePath,
                                                              // isBorder: i == 0 || i == 2 ? true : false,
                                                              // isShadow: i == 0 || i == 2 ? true : false,
                                                              // isStar: i == 2 || i == 3 ? true : false,
                                                              ///
                                                              /// Date : 14-May-2023
                                                              ///
                                                              /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                              ///
                                                              /// Different border colors of images
                                                              /// according to the cost of the champion
                                                              ///
                                                              /// This color representation is for popular
                                                              /// category on main screen
                                                              ///
                                                              borderColor: widget
                                                                          .champList[
                                                                              i]
                                                                          .champCost ==
                                                                      '1'
                                                                  ? Colors.grey
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '2'
                                                                      ? Colors.green
                                                                      : widget.champList[i].champCost ==
                                                                              '3'
                                                                          ? Colors
                                                                              .blue
                                                                          : widget.champList[i].champCost ==
                                                                                  '4'
                                                                              ? Colors
                                                                                  .purple
                                                                              : widget.champList[i].champCost == '5'
                                                                                  ? Colors.yellow
                                                                                  : Colors.red,
                                                              shadowColor: widget
                                                                          .champList[
                                                                              i]
                                                                          .champCost ==
                                                                      '1'
                                                                  ? const Color(
                                                                      0x609E9E9E)
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '2'
                                                                      ? const Color(
                                                                          0x604CAF50)
                                                                      : widget.champList[i].champCost ==
                                                                              '3'
                                                                          ? const Color(
                                                                              0x602196F3)
                                                                          : widget.champList[i].champCost ==
                                                                                  '4'
                                                                              ? const Color(
                                                                                  0x609C27B0)
                                                                              : widget.champList[i].champCost == '5'
                                                                                  ? const Color(0x60FFEB3B)
                                                                                  : const Color(0x60F44336),
                                                              isBorder: true,
                                                              isShadow: true,
                                                              isStar:
                                                                  i == 2 || i == 3
                                                                      ? true
                                                                      : false,
                                                            ),
                                                            Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                              children: List.generate(
                                                                  widget
                                                                      .champList[i]
                                                                      .champItems
                                                                      .length,
                                                                  (index) {
                                                                printLog(
                                                                    "+++++*********=============== Items ");
                                                                // return Image.network(widget.champItems![widget.champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                                return Container(
                                                                    height: 15,
                                                                    width: 15,
                                                                    decoration:
                                                                        BoxDecoration(),
                                                                    child: Image(
                                                                        image: NetworkImage(widget
                                                                            .champList[
                                                                                i]
                                                                            .champItems[index]["itemImageUrl"])));

                                                                //   SmallImageWidget(
                                                                //     imageHeight: 10,
                                                                //     imageWidth: 10,
                                                                //     boxWidth: 10,
                                                                //     boxHeight: 10,
                                                                //     isBorder: false,
                                                                //     imageUrl: widget.champList[i].champItems[index].itemImageUrl
                                                                //
                                                                // );
                                                              }),
                                                            ),
                                                          ],
                                                        ),
                                                      Text(
                                                        widget
                                                            .champList[
                                                        i]
                                                            .champName
                                                            .length >
                                                            5
                                                            ? widget
                                                            .champList[
                                                        i]
                                                            .champName
                                                            .substring(
                                                            0,
                                                            5)
                                                            : widget
                                                            .champList[
                                                        i]
                                                            .champName,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontSize: 9),
                                                      )
                                                    ],
                                                  )
                                                  : Column(
    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SmallImageWidget(
                                                          // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                          ///
                                                          ///  16-May-2023
                                                          /// Fetching new image path
                                                          ///
                                                          imageHeight: 40,
                                                          imageWidth: 40,
                                                          boxHeight: 40,
                                                          boxWidth: 40,
                                                          imageUrl: widget
                                                              .champList[i]
                                                              .imagePath,
                                                          // isBorder: i == 0 || i == 2 ? true : false,
                                                          // isShadow: i == 0 || i == 2 ? true : false,
                                                          // isStar: i == 2 || i == 3 ? true : false,
                                                          ///
                                                          /// Date : 14-May-2023
                                                          ///
                                                          /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                          ///
                                                          /// Different border colors of images
                                                          /// according to the cost of the champion
                                                          ///
                                                          /// This color representation is for popular
                                                          /// category on main screen
                                                          ///
                                                          borderColor: widget
                                                                      .champList[i]
                                                                      .champCost ==
                                                                  '1'
                                                              ? Colors.grey
                                                              : widget.champList[i]
                                                                          .champCost ==
                                                                      '2'
                                                                  ? Colors.green
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '3'
                                                                      ? Colors.blue
                                                                      : widget.champList[i].champCost ==
                                                                              '4'
                                                                          ? Colors
                                                                              .purple
                                                                          : widget.champList[i].champCost ==
                                                                                  '5'
                                                                              ? Colors
                                                                                  .yellow
                                                                              : Colors
                                                                                  .red,
                                                          shadowColor: widget
                                                                      .champList[i]
                                                                      .champCost ==
                                                                  '1'
                                                              ? const Color(
                                                                  0x609E9E9E)
                                                              : widget.champList[i]
                                                                          .champCost ==
                                                                      '2'
                                                                  ? const Color(
                                                                      0x604CAF50)
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '3'
                                                                      ? const Color(
                                                                          0x602196F3)
                                                                      : widget.champList[i].champCost ==
                                                                              '4'
                                                                          ? const Color(
                                                                              0x609C27B0)
                                                                          : widget.champList[i].champCost ==
                                                                                  '5'
                                                                              ? const Color(
                                                                                  0x60FFEB3B)
                                                                              : const Color(
                                                                                  0x60F44336),
                                                          isBorder: true,
                                                          isShadow: true,
                                                          isStar: i == 2 || i == 3
                                                              ? true
                                                              : false,
                                                        ),
                                                      Text(
                                                        widget
                                                            .champList[
                                                        i]
                                                            .champName
                                                            .length >
                                                            5
                                                            ? widget
                                                            .champList[
                                                        i]
                                                            .champName
                                                            .substring(
                                                            0,
                                                            5)
                                                            : widget
                                                            .champList[
                                                        i]
                                                            .champName,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontSize: 9),
                                                      )
                                                    ],
                                                  )),
                                  if (widget.champList.length < 11)
                                    for (int i = 0;
                                        i < widget.champList.length;
                                        i++)
                                      Padding(
                                          // Provider.of<BasicProvider>(context).isVisibleDataFromFirebase?Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6.0),
                                          // child: dataFetched?
                                          child:
                                              widget.champList[i].champItems
                                                      .isNotEmpty
                                                  ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Stack(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          children: [
                                                            SmallImageWidget(
                                                              // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                              ///
                                                              ///  16-May-2023
                                                              /// Fetching new image path
                                                              ///
                                                              imageWidth: 40,
                                                              imageHeight: 40,
                                                              boxWidth: 40,
                                                              boxHeight: 40,
                                                              imageUrl: widget
                                                                  .champList[i]
                                                                  .imagePath,
                                                              // isBorder: i == 0 || i == 2 ? true : false,
                                                              // isShadow: i == 0 || i == 2 ? true : false,
                                                              // isStar: i == 2 || i == 3 ? true : false,
                                                              ///
                                                              /// Date : 14-May-2023
                                                              ///
                                                              /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                              ///
                                                              /// Different border colors of images
                                                              /// according to the cost of the champion
                                                              ///
                                                              /// This color representation is for popular
                                                              /// category on main screen
                                                              ///
                                                              borderColor: widget
                                                                          .champList[
                                                                              i]
                                                                          .champCost ==
                                                                      '1'
                                                                  ? Colors.grey
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '2'
                                                                      ? Colors.green
                                                                      : widget.champList[i].champCost ==
                                                                              '3'
                                                                          ? Colors
                                                                              .blue
                                                                          : widget.champList[i].champCost ==
                                                                                  '4'
                                                                              ? Colors
                                                                                  .purple
                                                                              : widget.champList[i].champCost == '5'
                                                                                  ? Colors.yellow
                                                                                  : Colors.red,
                                                              shadowColor: widget
                                                                          .champList[
                                                                              i]
                                                                          .champCost ==
                                                                      '1'
                                                                  ? const Color(
                                                                      0x609E9E9E)
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '2'
                                                                      ? const Color(
                                                                          0x604CAF50)
                                                                      : widget.champList[i].champCost ==
                                                                              '3'
                                                                          ? const Color(
                                                                              0x602196F3)
                                                                          : widget.champList[i].champCost ==
                                                                                  '4'
                                                                              ? const Color(
                                                                                  0x609C27B0)
                                                                              : widget.champList[i].champCost == '5'
                                                                                  ? const Color(0x60FFEB3B)
                                                                                  : const Color(0x60F44336),
                                                              isBorder: true,
                                                              isShadow: true,
                                                              isStar:
                                                                  i == 2 || i == 3
                                                                      ? true
                                                                      : false,
                                                            ),
                                                            Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                              children: List.generate(
                                                                  widget
                                                                      .champList[i]
                                                                      .champItems
                                                                      .length,
                                                                  (index) {
                                                                printLog(
                                                                    "+++++*********=============== Items ");
                                                                // return Image.network(widget.champItems![widget.champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                                return Container(
                                                                    height: 15,
                                                                    width: 15,
                                                                    decoration:
                                                                        BoxDecoration(),
                                                                    child: Image(
                                                                        image: NetworkImage(widget
                                                                            .champList[
                                                                                i]
                                                                            .champItems[index]["itemImageUrl"])));

                                                                //   SmallImageWidget(
                                                                //   imageHeight: 10,
                                                                //   imageWidth: 10,
                                                                //   boxWidth: 10,
                                                                //   boxHeight: 10,
                                                                //   isBorder: false,
                                                                //   imageUrl: widget.champList[i].champItems[index]["itemImageUrl"]
                                                                //
                                                                // );
                                                              }),
                                                            ),
                                                          ],
                                                        ),
                                                      Text(
                                                        widget
                                                            .champList[
                                                        i]
                                                            .champName
                                                            .length >
                                                            5
                                                            ? widget
                                                            .champList[
                                                        i]
                                                            .champName
                                                            .substring(
                                                            0,
                                                            5)
                                                            : widget
                                                            .champList[
                                                        i]
                                                            .champName,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontSize: 9),
                                                      )
                                                    ],
                                                  )
                                                  : Column(
                                                                                             mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SmallImageWidget(
                                                          // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                          ///
                                                          ///  16-May-2023
                                                          /// Fetching new image path
                                                          ///
                                                          imageHeight: 40,
                                                          imageWidth: 40,
                                                          boxHeight: 40,
                                                          boxWidth: 40,
                                                          imageUrl: widget
                                                              .champList[i]
                                                              .imagePath,
                                                          // isBorder: i == 0 || i == 2 ? true : false,
                                                          // isShadow: i == 0 || i == 2 ? true : false,
                                                          // isStar: i == 2 || i == 3 ? true : false,
                                                          ///
                                                          /// Date : 14-May-2023
                                                          ///
                                                          /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                          ///
                                                          /// Different border colors of images
                                                          /// according to the cost of the champion
                                                          ///
                                                          /// This color representation is for popular
                                                          /// category on main screen
                                                          ///
                                                          borderColor: widget
                                                                      .champList[i]
                                                                      .champCost ==
                                                                  '1'
                                                              ? Colors.grey
                                                              : widget.champList[i]
                                                                          .champCost ==
                                                                      '2'
                                                                  ? Colors.green
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '3'
                                                                      ? Colors.blue
                                                                      : widget.champList[i].champCost ==
                                                                              '4'
                                                                          ? Colors
                                                                              .purple
                                                                          : widget.champList[i].champCost ==
                                                                                  '5'
                                                                              ? Colors
                                                                                  .yellow
                                                                              : Colors
                                                                                  .red,
                                                          shadowColor: widget
                                                                      .champList[i]
                                                                      .champCost ==
                                                                  '1'
                                                              ? const Color(
                                                                  0x609E9E9E)
                                                              : widget.champList[i]
                                                                          .champCost ==
                                                                      '2'
                                                                  ? const Color(
                                                                      0x604CAF50)
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '3'
                                                                      ? const Color(
                                                                          0x602196F3)
                                                                      : widget.champList[i].champCost ==
                                                                              '4'
                                                                          ? const Color(
                                                                              0x609C27B0)
                                                                          : widget.champList[i].champCost ==
                                                                                  '5'
                                                                              ? const Color(
                                                                                  0x60FFEB3B)
                                                                              : const Color(
                                                                                  0x60F44336),
                                                          isBorder: true,
                                                          isShadow: true,
                                                          isStar: i == 2 || i == 3
                                                              ? true
                                                              : false,
                                                        ),
                                                      Text(
                                                        widget
                                                            .champList[
                                                        i]
                                                            .champName
                                                            .length >
                                                            5
                                                            ? widget
                                                            .champList[
                                                        i]
                                                            .champName
                                                            .substring(
                                                            0,
                                                            5)
                                                            : widget
                                                            .champList[
                                                        i]
                                                            .champName,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontSize: 9),
                                                      )
                                                    ],
                                                  )),
                                ],
                              ),
                            ),

                            /// arrow down icon
                            const Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: 30,
                                ))
                            // widget.icon,
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    /// pin icon
                    InkWell(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        printLog(
                            "========> Pinned id: ====<${Provider.of<BasicProvider>(context, listen: false).pinnedCompChamps}");
                        await FirebaseFirestore.instance
                            .collection(pinnedCompCollection)
                            .doc("0123")
                            .update({'compId': jsonEncode(widget.champList)});
                        await Provider.of<BasicProvider>(context, listen: false)
                            .fetchCurrentPinnedComp();
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: isLoading
                              ? const Center(
                                  child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator()))
                              : Transform.rotate(
                                  angle: math.pi / 4,
                                  child: Icon(
                                    Icons.push_pin,
                                    color: Provider.of<BasicProvider>(context,
                                                    listen: false)
                                                .pinnedCompChamps ==
                                            widget.champList
                                        ? Colors.yellowAccent
                                        : Colors.white,
                                    size: 20,
                                  ))
                          // SvgPicture.asset(AppIcons.pin, height: 20),
                          ),
                    ),
                  ],
                ),
              )
            : ResponsiveWidget.isTabletScreen(context)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ///
                        Expanded(
                          child: Container(
                            width: width(context),
                            padding: const EdgeInsets.only(
                                top: 7.0, bottom: 8.0, left: 10.0, right: 10),
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  widget.isExpand == true
                                      ? Colors.transparent
                                      : AppColors.expandBoxColor,
                                  widget.isExpand == true
                                      ? Colors.transparent
                                      : AppColors.expandBoxColor,
                                  widget.isExpand == true
                                      ? Colors.transparent
                                      : AppColors.expandBoxDarkColor,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                /// image
                                const SmallImageWidget(
                                  imageUrl: '',
                                  imageHeight: 30,
                                  imageWidth: 30,
                                  boxHeight: 30,
                                  boxWidth: 30,
                                ),
                                const SizedBox(width: 8),

                                /// name and desc
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Veronica\nKing V',
                                      style: poppinsSemiBold.copyWith(
                                        fontSize: 10,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                    const SizedBox(height: 1.0),
                                    Text(
                                      'Hard',
                                      style: poppinsRegular.copyWith(
                                        fontSize: 12,
                                        color: AppColors.whiteColor
                                            .withOpacity(0.4),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),

                                /// image with stars
                                Expanded(
                                  flex: 7,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (widget.champList.length >= 11)
                                        for (int i = 0; i < 11; i++)
                                          Padding(
                                              // Provider.of<BasicProvider>(context).isVisibleDataFromFirebase?Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 6.0),
                                              // child: dataFetched?
                                              child:
                                                  widget.champList[i].champItems
                                                          .isNotEmpty
                                                      ? Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Stack(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              children: [
                                                                SmallImageWidget(
                                                                  // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                                  ///
                                                                  ///  16-May-2023
                                                                  /// Fetching new image path
                                                                  ///
                                                                  ///
                                                                  imageWidth: 30,
                                                                  imageHeight: 30,
                                                                  boxWidth: 30,
                                                                  boxHeight: 30,
                                                                  imageUrl: widget
                                                                      .champList[i]
                                                                      .imagePath,
                                                                  // isBorder: i == 0 || i == 2 ? true : false,
                                                                  // isShadow: i == 0 || i == 2 ? true : false,
                                                                  // isStar: i == 2 || i == 3 ? true : false,
                                                                  ///
                                                                  /// Date : 14-May-2023
                                                                  ///
                                                                  /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                                  ///
                                                                  /// Different border colors of images
                                                                  /// according to the cost of the champion
                                                                  ///
                                                                  /// This color representation is for popular
                                                                  /// category on main screen
                                                                  ///
                                                                  borderColor: widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '1'
                                                                      ? Colors.grey
                                                                      : widget.champList[i].champCost ==
                                                                              '2'
                                                                          ? Colors
                                                                              .green
                                                                          : widget.champList[i].champCost ==
                                                                                  '3'
                                                                              ? Colors
                                                                                  .blue
                                                                              : widget.champList[i].champCost == '4'
                                                                                  ? Colors.purple
                                                                                  : widget.champList[i].champCost == '5'
                                                                                      ? Colors.yellow
                                                                                      : Colors.red,
                                                                  shadowColor: widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '1'
                                                                      ? const Color(
                                                                          0x609E9E9E)
                                                                      : widget.champList[i].champCost ==
                                                                              '2'
                                                                          ? const Color(
                                                                              0x604CAF50)
                                                                          : widget.champList[i].champCost ==
                                                                                  '3'
                                                                              ? const Color(
                                                                                  0x602196F3)
                                                                              : widget.champList[i].champCost == '4'
                                                                                  ? const Color(0x609C27B0)
                                                                                  : widget.champList[i].champCost == '5'
                                                                                      ? const Color(0x60FFEB3B)
                                                                                      : const Color(0x60F44336),
                                                                  isBorder: true,
                                                                  isShadow: true,
                                                                  isStar: i == 2 ||
                                                                          i == 3
                                                                      ? true
                                                                      : false,
                                                                ),
                                                                Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: List.generate(
                                                                      widget
                                                                          .champList[
                                                                              i]
                                                                          .champItems
                                                                          .length,
                                                                      (index) {
                                                                    printLog(
                                                                        "+++++*********=============== Items ");
                                                                    // return Image.network(widget.champItems![widget.champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                                    return Container(
                                                                        height: 15,
                                                                        width: 15,
                                                                        decoration:
                                                                            BoxDecoration(),
                                                                        child: Image(
                                                                            image: NetworkImage(widget
                                                                                .champList[i]
                                                                                .champItems[index]["itemImageUrl"])));
                                                                    //   SmallImageWidget(
                                                                    //     imageHeight: 10,
                                                                    //     imageWidth: 10,
                                                                    //     boxWidth: 10,
                                                                    //     boxHeight: 10,
                                                                    //     isBorder: false,
                                                                    //     imageUrl: widget.champList[i].champItems[index].itemImageUrl
                                                                    //
                                                                    // );
                                                                  }),
                                                                ),
                                                              ],
                                                            ),
                                                          Text(
                                                            widget
                                                                .champList[
                                                            i]
                                                                .champName
                                                                .length >
                                                                5
                                                                ? widget
                                                                .champList[
                                                            i]
                                                                .champName
                                                                .substring(
                                                                0,
                                                                5)
                                                                : widget
                                                                .champList[
                                                            i]
                                                                .champName,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 9),
                                                          )
                                                        ],
                                                      )
                                                      : Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          SmallImageWidget(
                                                              // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                              ///
                                                              ///  16-May-2023
                                                              /// Fetching new image path
                                                              ///
                                                              imageHeight: 30,
                                                              imageWidth: 30,
                                                              boxHeight: 30,
                                                              boxWidth: 30,
                                                              imageUrl: widget
                                                                  .champList[i]
                                                                  .imagePath,
                                                              // isBorder: i == 0 || i == 2 ? true : false,
                                                              // isShadow: i == 0 || i == 2 ? true : false,
                                                              // isStar: i == 2 || i == 3 ? true : false,
                                                              ///
                                                              /// Date : 14-May-2023
                                                              ///
                                                              /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                              ///
                                                              /// Different border colors of images
                                                              /// according to the cost of the champion
                                                              ///
                                                              /// This color representation is for popular
                                                              /// category on main screen
                                                              ///
                                                              borderColor: widget
                                                                          .champList[
                                                                              i]
                                                                          .champCost ==
                                                                      '1'
                                                                  ? Colors.grey
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '2'
                                                                      ? Colors.green
                                                                      : widget.champList[i].champCost ==
                                                                              '3'
                                                                          ? Colors
                                                                              .blue
                                                                          : widget.champList[i].champCost ==
                                                                                  '4'
                                                                              ? Colors
                                                                                  .purple
                                                                              : widget.champList[i].champCost == '5'
                                                                                  ? Colors.yellow
                                                                                  : Colors.red,
                                                              shadowColor: widget
                                                                          .champList[
                                                                              i]
                                                                          .champCost ==
                                                                      '1'
                                                                  ? const Color(
                                                                      0x609E9E9E)
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '2'
                                                                      ? const Color(
                                                                          0x604CAF50)
                                                                      : widget.champList[i].champCost ==
                                                                              '3'
                                                                          ? const Color(
                                                                              0x602196F3)
                                                                          : widget.champList[i].champCost ==
                                                                                  '4'
                                                                              ? const Color(
                                                                                  0x609C27B0)
                                                                              : widget.champList[i].champCost == '5'
                                                                                  ? const Color(0x60FFEB3B)
                                                                                  : const Color(0x60F44336),
                                                              isBorder: true,
                                                              isShadow: true,
                                                              isStar:
                                                                  i == 2 || i == 3
                                                                      ? true
                                                                      : false,
                                                            ),
                                                          Text(
                                                            widget
                                                                .champList[
                                                            i]
                                                                .champName
                                                                .length >
                                                                5
                                                                ? widget
                                                                .champList[
                                                            i]
                                                                .champName
                                                                .substring(
                                                                0,
                                                                5)
                                                                : widget
                                                                .champList[
                                                            i]
                                                                .champName,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 9),
                                                          )
                                                        ],
                                                      )),
                                      if (widget.champList.length < 11)
                                        for (int i = 0;
                                            i < widget.champList.length;
                                            i++)
                                          Padding(
                                              // Provider.of<BasicProvider>(context).isVisibleDataFromFirebase?Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 6.0),
                                              // child: dataFetched?
                                              child:
                                                  widget.champList[i].champItems
                                                          .isNotEmpty
                                                      ? Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Stack(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              children: [
                                                                SmallImageWidget(
                                                                  // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                                  ///
                                                                  ///  16-May-2023
                                                                  /// Fetching new image path
                                                                  ///
                                                                  imageWidth: 30,
                                                                  imageHeight: 30,
                                                                  boxWidth: 30,
                                                                  boxHeight: 30,
                                                                  imageUrl: widget
                                                                      .champList[i]
                                                                      .imagePath,
                                                                  // isBorder: i == 0 || i == 2 ? true : false,
                                                                  // isShadow: i == 0 || i == 2 ? true : false,
                                                                  // isStar: i == 2 || i == 3 ? true : false,
                                                                  ///
                                                                  /// Date : 14-May-2023
                                                                  ///
                                                                  /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                                  ///
                                                                  /// Different border colors of images
                                                                  /// according to the cost of the champion
                                                                  ///
                                                                  /// This color representation is for popular
                                                                  /// category on main screen
                                                                  ///
                                                                  borderColor: widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '1'
                                                                      ? Colors.grey
                                                                      : widget.champList[i].champCost ==
                                                                              '2'
                                                                          ? Colors
                                                                              .green
                                                                          : widget.champList[i].champCost ==
                                                                                  '3'
                                                                              ? Colors
                                                                                  .blue
                                                                              : widget.champList[i].champCost == '4'
                                                                                  ? Colors.purple
                                                                                  : widget.champList[i].champCost == '5'
                                                                                      ? Colors.yellow
                                                                                      : Colors.red,
                                                                  shadowColor: widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '1'
                                                                      ? const Color(
                                                                          0x609E9E9E)
                                                                      : widget.champList[i].champCost ==
                                                                              '2'
                                                                          ? const Color(
                                                                              0x604CAF50)
                                                                          : widget.champList[i].champCost ==
                                                                                  '3'
                                                                              ? const Color(
                                                                                  0x602196F3)
                                                                              : widget.champList[i].champCost == '4'
                                                                                  ? const Color(0x609C27B0)
                                                                                  : widget.champList[i].champCost == '5'
                                                                                      ? const Color(0x60FFEB3B)
                                                                                      : const Color(0x60F44336),
                                                                  isBorder: true,
                                                                  isShadow: true,
                                                                  isStar: i == 2 ||
                                                                          i == 3
                                                                      ? true
                                                                      : false,
                                                                ),
                                                                Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: List.generate(
                                                                      widget
                                                                          .champList[
                                                                              i]
                                                                          .champItems
                                                                          .length,
                                                                      (index) {
                                                                    printLog(
                                                                        "+++++*********=============== Items ");
                                                                    // return Image.network(widget.champItems![widget.champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                                    return Container(
                                                                        height: 15,
                                                                        width: 15,
                                                                        decoration:
                                                                            BoxDecoration(),
                                                                        child: Image(
                                                                            image: NetworkImage(widget
                                                                                .champList[i]
                                                                                .champItems[index]["itemImageUrl"])));
                                                                    //   SmallImageWidget(
                                                                    //     imageHeight: 10,
                                                                    //     imageWidth: 10,
                                                                    //     boxWidth: 10,
                                                                    //     boxHeight: 10,
                                                                    //     isBorder: false,
                                                                    //     imageUrl: widget.champList[i].champItems[index]["itemImageUrl"]
                                                                    //
                                                                    // );
                                                                  }),
                                                                ),
                                                              ],
                                                            ),
                                                          Text(
                                                            widget
                                                                .champList[
                                                            i]
                                                                .champName
                                                                .length >
                                                                5
                                                                ? widget
                                                                .champList[
                                                            i]
                                                                .champName
                                                                .substring(
                                                                0,
                                                                5)
                                                                : widget
                                                                .champList[
                                                            i]
                                                                .champName,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 9),
                                                          )
                                                        ],
                                                      )
                                                      : Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          SmallImageWidget(
                                                              // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                              ///
                                                              ///  16-May-2023
                                                              /// Fetching new image path
                                                              ///
                                                              imageHeight: 30,
                                                              imageWidth: 30,
                                                              boxHeight: 30,
                                                              boxWidth: 30,
                                                              imageUrl: widget
                                                                  .champList[i]
                                                                  .imagePath,
                                                              // isBorder: i == 0 || i == 2 ? true : false,
                                                              // isShadow: i == 0 || i == 2 ? true : false,
                                                              // isStar: i == 2 || i == 3 ? true : false,
                                                              ///
                                                              /// Date : 14-May-2023
                                                              ///
                                                              /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                              ///
                                                              /// Different border colors of images
                                                              /// according to the cost of the champion
                                                              ///
                                                              /// This color representation is for popular
                                                              /// category on main screen
                                                              ///
                                                              borderColor: widget
                                                                          .champList[
                                                                              i]
                                                                          .champCost ==
                                                                      '1'
                                                                  ? Colors.grey
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '2'
                                                                      ? Colors.green
                                                                      : widget.champList[i].champCost ==
                                                                              '3'
                                                                          ? Colors
                                                                              .blue
                                                                          : widget.champList[i].champCost ==
                                                                                  '4'
                                                                              ? Colors
                                                                                  .purple
                                                                              : widget.champList[i].champCost == '5'
                                                                                  ? Colors.yellow
                                                                                  : Colors.red,
                                                              shadowColor: widget
                                                                          .champList[
                                                                              i]
                                                                          .champCost ==
                                                                      '1'
                                                                  ? const Color(
                                                                      0x609E9E9E)
                                                                  : widget
                                                                              .champList[
                                                                                  i]
                                                                              .champCost ==
                                                                          '2'
                                                                      ? const Color(
                                                                          0x604CAF50)
                                                                      : widget.champList[i].champCost ==
                                                                              '3'
                                                                          ? const Color(
                                                                              0x602196F3)
                                                                          : widget.champList[i].champCost ==
                                                                                  '4'
                                                                              ? const Color(
                                                                                  0x609C27B0)
                                                                              : widget.champList[i].champCost == '5'
                                                                                  ? const Color(0x60FFEB3B)
                                                                                  : const Color(0x60F44336),
                                                              isBorder: true,
                                                              isShadow: true,
                                                              isStar:
                                                                  i == 2 || i == 3
                                                                      ? true
                                                                      : false,
                                                            ),
                                                          Text(
                                                            widget
                                                                .champList[
                                                            i]
                                                                .champName
                                                                .length >
                                                                5
                                                                ? widget
                                                                .champList[
                                                            i]
                                                                .champName
                                                                .substring(
                                                                0,
                                                                5)
                                                                : widget
                                                                .champList[
                                                            i]
                                                                .champName,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 9),
                                                          )
                                                        ],
                                                      )),
                                    ],
                                  ),
                                ),

                                /// arrow down icon
                                const Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                      size: 30,
                                    ))
                                // widget.icon,
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        /// pin icon
                        InkWell(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });

                            await FirebaseFirestore.instance
                                .collection(pinnedCompCollection)
                                .doc("0123")
                                .update(
                                    {'compId': jsonEncode(widget.champList)});
                            await Provider.of<BasicProvider>(context,
                                    listen: false)
                                .fetchCurrentPinnedComp();
                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: isLoading
                                  ? const Center(
                                      child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator()))
                                  : Transform.rotate(
                                      angle: math.pi / 4,
                                      child: Icon(
                                        Icons.push_pin,
                                        color: Provider.of<BasicProvider>(
                                                        context,
                                                        listen: false)
                                                    .pinnedCompChamps ==
                                                widget.champList
                                            ? Colors.yellowAccent
                                            : Colors.white,
                                        size: 20,
                                      ))
                              // SvgPicture.asset(AppIcons.pin, height: 20),
                              ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Container(
                        // height: width(context)>=700?60:widget.champList.length>10?height(context)*.3:height(context)*.2,
                        width: width(context),
                        padding: const EdgeInsets.only(
                            top: 7.0, bottom: 8.0, left: 6.0, right: 6),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              widget.isExpand == true
                                  ? Colors.transparent
                                  : AppColors.expandBoxColor,
                              widget.isExpand == true
                                  ? Colors.transparent
                                  : AppColors.expandBoxColor,
                              widget.isExpand == true
                                  ? Colors.transparent
                                  : AppColors.expandBoxDarkColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: width(context) >= 700
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /// image
                                  const SmallImageWidget(
                                    imageUrl: '',
                                    imageHeight: 30,
                                    imageWidth: 30,
                                  ),
                                  // const SizedBox(width: 5),

                                  /// name and desc
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Veronica King V'.length > 8
                                            ? 'Veronica King V'.substring(0, 8)
                                            : 'Veronica King V',
                                        style: poppinsSemiBold.copyWith(
                                          fontSize: 14,
                                          color: AppColors.whiteColor,
                                        ),
                                      ),
                                      const SizedBox(height: 1.0),
                                      Text(
                                        'Hard',
                                        style: poppinsRegular.copyWith(
                                          fontSize: 14,
                                          color: AppColors.whiteColor
                                              .withOpacity(0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),

                                  /// image with stars

                                  SizedBox(
                                      width: width(context) * .35,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          const SizedBox(height: 30),
                                          Wrap(
                                            alignment: WrapAlignment.center,
                                            runAlignment: WrapAlignment.center,
                                            spacing: 5,
                                            runSpacing: 5,
                                            children: [
                                              // for (int i = 0; i < champListFromFirebase.length; i++)
                                              for (int i = 0;
                                                  i < widget.champList.length;
                                                  i++)
                                                // for (int i = 0; i < Provider.of<SearchProvider>(context).champListFromFirebase.length; i++)
                                                ///
                                                widget.champList[i].champItems
                                                        .isNotEmpty
                                                    ? Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Stack(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            children: [
                                                              SmallImageWidget(
                                                                // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                                ///
                                                                ///  16-May-2023
                                                                /// Fetching new image path
                                                                ///
                                                                ///
                                                                imageWidth: 40,
                                                                imageHeight: 40,
                                                                boxWidth: 40,
                                                                boxHeight: 40,
                                                                imageUrl: widget
                                                                    .champList[
                                                                        i]
                                                                    .imagePath,
                                                                // isBorder: i == 0 || i == 2 ? true : false,
                                                                // isShadow: i == 0 || i == 2 ? true : false,
                                                                // isStar: i == 2 || i == 3 ? true : false,
                                                                ///
                                                                /// Date : 14-May-2023
                                                                ///
                                                                /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                                ///
                                                                /// Different border colors of images
                                                                /// according to the cost of the champion
                                                                ///
                                                                /// This color representation is for popular
                                                                /// category on main screen
                                                                ///
                                                                borderColor: widget
                                                                            .champList[
                                                                                i]
                                                                            .champCost ==
                                                                        '1'
                                                                    ? Colors
                                                                        .grey
                                                                    : widget.champList[i].champCost ==
                                                                            '2'
                                                                        ? Colors
                                                                            .green
                                                                        : widget.champList[i].champCost ==
                                                                                '3'
                                                                            ? Colors.blue
                                                                            : widget.champList[i].champCost == '4'
                                                                                ? Colors.purple
                                                                                : widget.champList[i].champCost == '5'
                                                                                    ? Colors.yellow
                                                                                    : Colors.red,
                                                                shadowColor: widget
                                                                            .champList[
                                                                                i]
                                                                            .champCost ==
                                                                        '1'
                                                                    ? const Color(
                                                                        0x609E9E9E)
                                                                    : widget.champList[i].champCost ==
                                                                            '2'
                                                                        ? const Color(
                                                                            0x604CAF50)
                                                                        : widget.champList[i].champCost ==
                                                                                '3'
                                                                            ? const Color(0x602196F3)
                                                                            : widget.champList[i].champCost == '4'
                                                                                ? const Color(0x609C27B0)
                                                                                : widget.champList[i].champCost == '5'
                                                                                    ? const Color(0x60FFEB3B)
                                                                                    : const Color(0x60F44336),
                                                                isBorder: true,
                                                                isShadow: true,
                                                                isStar: i ==
                                                                            2 ||
                                                                        i == 3
                                                                    ? true
                                                                    : false,
                                                              ),
                                                              Row(
                                                                children: List.generate(
                                                                    widget
                                                                        .champList[
                                                                            i]
                                                                        .champItems
                                                                        .length,
                                                                    (index) {
                                                                  printLog(
                                                                      "+++++*********=============== Items ");
                                                                  // return Image.network(widget.champItems![widget.champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                                  return Container(
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                      child: Image(
                                                                          image: NetworkImage(widget
                                                                              .champList[i]
                                                                              .champItems[index]["itemImageUrl"])));
                                                                  //   SmallImageWidget(
                                                                  //     imageHeight: 10,
                                                                  //     imageWidth: 10,
                                                                  //     boxWidth: 10,
                                                                  //     boxHeight: 10,
                                                                  //     isBorder: false,
                                                                  //     imageUrl: widget.champList[i].champItems[index].itemImageUrl
                                                                  //
                                                                  // );
                                                                }),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            widget
                                                                .champList[
                                                            i]
                                                                .champName
                                                                .length >
                                                                5
                                                                ? widget
                                                                .champList[
                                                            i]
                                                                .champName
                                                                .substring(
                                                                0,
                                                                5)
                                                                : widget
                                                                .champList[
                                                            i]
                                                                .champName,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 9),
                                                          )
                                                        ],
                                                      )
                                                    : Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          SmallImageWidget(
                                                            // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                            ///
                                                            ///  16-May-2023
                                                            /// Fetching new image path
                                                            ///
                                                            imageHeight: 40,
                                                            imageWidth: 40,
                                                            boxHeight: 40,
                                                            boxWidth: 40,
                                                            imageUrl: widget
                                                                .champList[i]
                                                                .imagePath,
                                                            // isBorder: i == 0 || i == 2 ? true : false,
                                                            // isShadow: i == 0 || i == 2 ? true : false,
                                                            // isStar: i == 2 || i == 3 ? true : false,
                                                            ///
                                                            /// Date : 14-May-2023
                                                            ///
                                                            /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                            ///
                                                            /// Different border colors of images
                                                            /// according to the cost of the champion
                                                            ///
                                                            /// This color representation is for popular
                                                            /// category on main screen
                                                            ///
                                                            borderColor: widget
                                                                        .champList[
                                                                            i]
                                                                        .champCost ==
                                                                    '1'
                                                                ? Colors.grey
                                                                : widget.champList[i].champCost ==
                                                                        '2'
                                                                    ? Colors
                                                                        .green
                                                                    : widget.champList[i].champCost ==
                                                                            '3'
                                                                        ? Colors
                                                                            .blue
                                                                        : widget.champList[i].champCost ==
                                                                                '4'
                                                                            ? Colors.purple
                                                                            : widget.champList[i].champCost == '5'
                                                                                ? Colors.yellow
                                                                                : Colors.red,
                                                            shadowColor: widget
                                                                        .champList[
                                                                            i]
                                                                        .champCost ==
                                                                    '1'
                                                                ? const Color(
                                                                    0x609E9E9E)
                                                                : widget.champList[i].champCost ==
                                                                        '2'
                                                                    ? const Color(
                                                                        0x604CAF50)
                                                                    : widget.champList[i].champCost ==
                                                                            '3'
                                                                        ? const Color(
                                                                            0x602196F3)
                                                                        : widget.champList[i].champCost ==
                                                                                '4'
                                                                            ? const Color(0x609C27B0)
                                                                            : widget.champList[i].champCost == '5'
                                                                                ? const Color(0x60FFEB3B)
                                                                                : const Color(0x60F44336),
                                                            isBorder: true,
                                                            isShadow: true,
                                                            isStar:
                                                                i == 2 || i == 3
                                                                    ? true
                                                                    : false,
                                                          ),
                                                          Text(
                                                            widget
                                                                .champList[
                                                            i]
                                                                .champName
                                                                .length >
                                                                5
                                                                ? widget
                                                                .champList[
                                                            i]
                                                                .champName
                                                                .substring(
                                                                0,
                                                                5)
                                                                : widget
                                                                .champList[
                                                            i]
                                                                .champName,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 9),
                                                          )
                                                        ],
                                                      )
                                              // SmallImageWidget(
                                              //   // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                              //   ///
                                              //   ///  16-May-2023
                                              //   /// Fetching new image path
                                              //   ///
                                              //   ///
                                              //   boxHeight: height(context) * 0.06,
                                              //   boxWidth: height(context) * 0.06,
                                              //   imageHeight: height(context) * 0.05,
                                              //   imageWidth: height(context) * 0.05,
                                              //   imageUrl: widget.champList[i].imagePath,
                                              //   // isBorder: i == 0 || i == 2 ? true : false,
                                              //   // isShadow: i == 0 || i == 2 ? true : false,
                                              //   // isStar: i == 2 || i == 3 ? true : false,
                                              //   ///
                                              //   /// Date : 14-May-2023
                                              //   ///
                                              //   /// Requirement # 2a, 2b, 2c, 2d, 2e
                                              //   ///
                                              //   /// Different border colors of images
                                              //   /// according to the cost of the champion
                                              //   ///
                                              //   /// This color representation is for popular
                                              //   /// category on main screen
                                              //   ///
                                              //   borderColor: widget.champList[i].champCost=='1'?
                                              //   Colors.grey:widget.champList[i].champCost=='2'?
                                              //   Colors.green:widget.champList[i].champCost=='3'?
                                              //   Colors.blue:widget.champList[i].champCost=='4'?
                                              //   Colors.purple:widget.champList[i].champCost=='5'?
                                              //   Colors.yellow:Colors.red
                                              //   ,
                                              //   shadowColor: widget.champList[i].champCost=='1'?
                                              //   const Color(0x609E9E9E):widget.champList[i].champCost=='2'?
                                              //   const Color(0x604CAF50):widget.champList[i].champCost=='3'?
                                              //   const Color(0x602196F3):widget.champList[i].champCost=='4'?
                                              //   const Color(0x609C27B0):widget.champList[i].champCost=='5'?
                                              //   const Color(0x60FFEB3B):const Color(0x60F44336),
                                              //   isBorder: true ,
                                              //   isShadow:  true ,
                                              //   // isStar: i == 2 || i == 3 ? true : false,
                                              // )

                                              ///
                                              ///
                                              //                       Container(
                                              //                         height: height(context) * 0.07,
                                              //                         width: height(context) * 0.07,
                                              //                         decoration: BoxDecoration(
                                              //                           borderRadius: BorderRadius.circular(17),
                                              //                           border: Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='1'
                                              //                             // border: Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='1'
                                              //                               ? Border.all(
                                              //                                   // color: AppColors.skyBorderColor,
                                              //                             color: Colors.grey,
                                              //                                   width: 2.27,
                                              //                                 )
                                              //                               : Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='2'?
                                              //                               // : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='2'?
                                              //                           Border.all(
                                              //                             // color: AppColors.skyBorderColor,
                                              //                             color: Colors.green,
                                              //                             width: 2.27,
                                              //                           )
                                              //                               :Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='3'?
                                              //                               // :Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='3'?
                                              //                           Border.all(
                                              //                             // color: AppColors.skyBorderColor,
                                              //                             color: Colors.blue,
                                              //                             width: 2.27,
                                              //
                                              //                           ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='4'?
                                              //                              // ):Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='4'?
                                              //                           Border.all(
                                              //                             // color: AppColors.skyBorderColor,
                                              //                             color: Colors.purple,
                                              //                             width: 2.27,
                                              //                           ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='5'?
                                              //                           Border.all(
                                              //                             // color: AppColors.skyBorderColor,
                                              //                             color: Colors.yellow,
                                              //                             width: 2.27,
                                              //                           ):
                                              //                           Border.all(
                                              //                             // color: AppColors.skyBorderColor,
                                              //                             color: Colors.red,
                                              //                             width: 2.27,
                                              //                           ),
                                              //                           boxShadow: [
                                              //                             Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='1'
                                              //                                 ? BoxShadow(
                                              //                                     color: Colors.grey
                                              //                                         .withOpacity(0.6),
                                              //                                     blurRadius: 10,
                                              //                                   ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='2'
                                              //                                 ? BoxShadow(
                                              //                               color: Colors.green
                                              //                                   .withOpacity(0.6),
                                              //                               blurRadius: 10,
                                              //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='3'
                                              //                                 ? BoxShadow(
                                              //                               color: Colors.blue
                                              //                                   .withOpacity(0.6),
                                              //                               blurRadius: 10,
                                              //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='4'
                                              //                                 ? BoxShadow(
                                              //                               color: Colors.purple
                                              //                                   .withOpacity(0.6),
                                              //                               blurRadius: 10,
                                              //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='5'
                                              //                                 ? BoxShadow(
                                              //                               color: Colors.yellow
                                              //                                   .withOpacity(0.6),
                                              //                               blurRadius: 10,
                                              //                             ):BoxShadow(
                                              //                               color: Colors.red
                                              //                                   .withOpacity(0.6),
                                              //                               blurRadius: 10,
                                              //                             )
                                              //
                                              //                           ]
                                              // ,
                                              //                           image: DecorationImage(
                                              //                             fit: BoxFit.fill,
                                              //                               // image: NetworkImage('${baseUrl + champListFromFirebase[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}'))
                                              //                               ///
                                              //                               ///  16-May-2023
                                              //                               ///  New Image path fetched from firebase
                                              //                               ///  and shown
                                              //                               ///
                                              //                               image: NetworkImage(apiImageUrl + Provider.of<BasicProvider>(context).champListFromFirebase[i].imagePath.toString().toLowerCase()))
                                              //
                                              //
                                              //                         ),
                                              //                         // child: Text(Provider.of<BasicProvider>(context).champListFromFirebase[i].champName,style: const TextStyle(color: Colors.white),),
                                              //                         // child: Image.network(
                                              //                         //     '${baseUrl + champListFromFirebase[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                              //                         //     height: 60,
                                              //                         //     width: 60,
                                              //                         //
                                              //                         //     fit: BoxFit
                                              //                         //         .fill),
                                              //                       )
                                            ],
                                          ),
                                        ],
                                      )

                                      // ListView.builder(
                                      //   // padding: EdgeInsets.zero,
                                      //   // itemExtent: 33,
                                      //     shrinkWrap: true,
                                      //     scrollDirection: Axis.horizontal,
                                      //     itemCount: widget.champList.length>=4?4:widget.champList.length,
                                      //     itemBuilder: (context,i)
                                      //     {
                                      //       return SmallImageWidget(
                                      //         // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                      //         ///
                                      //         ///  16-May-2023
                                      //         /// Fetching new image path
                                      //         ///
                                      //         ///
                                      //         imageUrl: "$apiImageUrl${widget.champList[i].imagePath}",
                                      //         // isBorder: i == 0 || i == 2 ? true : false,
                                      //         // isShadow: i == 0 || i == 2 ? true : false,
                                      //         // isStar: i == 2 || i == 3 ? true : false,
                                      //         ///
                                      //         /// Date : 14-May-2023
                                      //         ///
                                      //         /// Requirement # 2a, 2b, 2c, 2d, 2e
                                      //         ///
                                      //         /// Different border colors of images
                                      //         /// according to the cost of the champion
                                      //         ///
                                      //         /// This color representation is for popular
                                      //         /// category on main screen
                                      //         ///
                                      //         borderColor: widget.champList[i].champCost=='1'?
                                      //         Colors.grey:widget.champList[i].champCost=='2'?
                                      //         Colors.green:widget.champList[i].champCost=='3'?
                                      //         Colors.blue:widget.champList[i].champCost=='4'?
                                      //         Colors.purple:widget.champList[i].champCost=='5'?
                                      //         Colors.yellow:Colors.red
                                      //         ,
                                      //         shadowColor: widget.champList[i].champCost=='1'?
                                      //         const Color(0x609E9E9E):widget.champList[i].champCost=='2'?
                                      //         const Color(0x604CAF50):widget.champList[i].champCost=='3'?
                                      //         const Color(0x602196F3):widget.champList[i].champCost=='4'?
                                      //         const Color(0x609C27B0):widget.champList[i].champCost=='5'?
                                      //         const Color(0x60FFEB3B):const Color(0x60F44336),
                                      //         imageHeight: 30,
                                      //         imageWidth: 30,
                                      //         isBorder: true ,
                                      //         isShadow:  true ,
                                      //         // isStar: i == 2 || i == 3 ? true : false,
                                      //       );
                                      //     }),
                                      ),

                                  /// arrow down icon
                                  Spacer(),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                    size: 30,
                                  )
                                  // widget.icon,
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /// image
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: width(context) > 600
                                            ? width(context) * .9
                                            : width(context) * .84,
                                        child: Row(
                                          children: [
                                            const SmallImageWidget(
                                              imageUrl: '',
                                              imageHeight: 30,
                                              imageWidth: 30,
                                            ),
                                            // const SizedBox(width: 5),

                                            /// name and desc
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Veronica King V'.length > 8
                                                      ? 'Veronica King V'
                                                          .substring(0, 8)
                                                      : 'Veronica King V',
                                                  style:
                                                      poppinsSemiBold.copyWith(
                                                    fontSize: 10,
                                                    color: AppColors.whiteColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 1.0),
                                                Text(
                                                  'Hard',
                                                  style:
                                                      poppinsRegular.copyWith(
                                                    fontSize: 14,
                                                    color: AppColors.whiteColor
                                                        .withOpacity(0.4),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 10),

                                            /// image with stars
                                            Spacer(),

                                            /// arrow down icon
                                            const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          width: width(context) * .8,
                                          child: ListView(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            children: [
                                              // const SizedBox(height: 30),
                                              Wrap(
                                                alignment: WrapAlignment.start,
                                                runAlignment:
                                                    WrapAlignment.start,
                                                spacing: 5,
                                                runSpacing: 5,
                                                children: [
                                                  // for (int i = 0; i < champListFromFirebase.length; i++)
                                                  for (int i = 0;
                                                      i <
                                                          widget
                                                              .champList.length;
                                                      i++)
                                                    // for (int i = 0; i < Provider.of<SearchProvider>(context).champListFromFirebase.length; i++)
                                                    ///
                                                    widget
                                                            .champList[i]
                                                            .champItems
                                                            .isNotEmpty
                                                        ? Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Stack(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                children: [
                                                                  SmallImageWidget(
                                                                    // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                                    ///
                                                                    ///  16-May-2023
                                                                    /// Fetching new image path
                                                                    ///
                                                                    ///
                                                                    imageWidth:
                                                                        40,
                                                                    imageHeight:
                                                                        40,
                                                                    boxWidth:
                                                                        40,
                                                                    boxHeight:
                                                                        40,
                                                                    imageUrl: widget
                                                                        .champList[
                                                                            i]
                                                                        .imagePath,
                                                                    // isBorder: i == 0 || i == 2 ? true : false,
                                                                    // isShadow: i == 0 || i == 2 ? true : false,
                                                                    // isStar: i == 2 || i == 3 ? true : false,
                                                                    ///
                                                                    /// Date : 14-May-2023
                                                                    ///
                                                                    /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                                    ///
                                                                    /// Different border colors of images
                                                                    /// according to the cost of the champion
                                                                    ///
                                                                    /// This color representation is for popular
                                                                    /// category on main screen
                                                                    ///
                                                                    borderColor: widget.champList[i].champCost ==
                                                                            '1'
                                                                        ? Colors
                                                                            .grey
                                                                        : widget.champList[i].champCost ==
                                                                                '2'
                                                                            ? Colors.green
                                                                            : widget.champList[i].champCost == '3'
                                                                                ? Colors.blue
                                                                                : widget.champList[i].champCost == '4'
                                                                                    ? Colors.purple
                                                                                    : widget.champList[i].champCost == '5'
                                                                                        ? Colors.yellow
                                                                                        : Colors.red,
                                                                    shadowColor: widget.champList[i].champCost ==
                                                                            '1'
                                                                        ? const Color(
                                                                            0x609E9E9E)
                                                                        : widget.champList[i].champCost ==
                                                                                '2'
                                                                            ? const Color(0x604CAF50)
                                                                            : widget.champList[i].champCost == '3'
                                                                                ? const Color(0x602196F3)
                                                                                : widget.champList[i].champCost == '4'
                                                                                    ? const Color(0x609C27B0)
                                                                                    : widget.champList[i].champCost == '5'
                                                                                        ? const Color(0x60FFEB3B)
                                                                                        : const Color(0x60F44336),
                                                                    isBorder:
                                                                        true,
                                                                    isShadow:
                                                                        true,
                                                                    isStar: i ==
                                                                                2 ||
                                                                            i ==
                                                                                3
                                                                        ? true
                                                                        : false,
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: List.generate(
                                                                        widget
                                                                            .champList[
                                                                                i]
                                                                            .champItems
                                                                            .length,
                                                                        (index) {
                                                                      printLog(
                                                                          "+++++*********=============== Items ");
                                                                      // return Image.network(widget.champItems![widget.champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                                      return Container(
                                                                          height:
                                                                              15,
                                                                          width:
                                                                              15,
                                                                          decoration:
                                                                              BoxDecoration(),
                                                                          child:
                                                                              Image(image: NetworkImage(widget.champList[i].champItems[index]["itemImageUrl"])));
                                                                      //   SmallImageWidget(
                                                                      //     imageHeight: 10,
                                                                      //     imageWidth: 10,
                                                                      //     boxWidth: 10,
                                                                      //     boxHeight: 10,
                                                                      //     isBorder: false,
                                                                      //     imageUrl: widget.champList[i].champItems[index].itemImageUrl
                                                                      //
                                                                      // );
                                                                    }),
                                                                  ),
                                                                ],
                                                              ),


                                                              Text(
                                                                widget
                                                                            .champList[
                                                                                i]
                                                                            .champName
                                                                            .length >
                                                                        5
                                                                    ? widget
                                                                        .champList[
                                                                            i]
                                                                        .champName
                                                                        .substring(
                                                                            0,
                                                                            5)
                                                                    : widget
                                                                        .champList[
                                                                            i]
                                                                        .champName,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                fontSize: 9),
                                                              )
                                                            ],
                                                          )
                                                        : Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SmallImageWidget(
                                                                // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                                ///
                                                                ///  16-May-2023
                                                                /// Fetching new image path
                                                                ///
                                                                imageHeight: 40,
                                                                imageWidth: 40,
                                                                boxHeight: 40,
                                                                boxWidth: 40,
                                                                imageUrl: widget
                                                                    .champList[
                                                                        i]
                                                                    .imagePath,
                                                                // isBorder: i == 0 || i == 2 ? true : false,
                                                                // isShadow: i == 0 || i == 2 ? true : false,
                                                                // isStar: i == 2 || i == 3 ? true : false,
                                                                ///
                                                                /// Date : 14-May-2023
                                                                ///
                                                                /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                                ///
                                                                /// Different border colors of images
                                                                /// according to the cost of the champion
                                                                ///
                                                                /// This color representation is for popular
                                                                /// category on main screen
                                                                ///
                                                                borderColor: widget
                                                                            .champList[
                                                                                i]
                                                                            .champCost ==
                                                                        '1'
                                                                    ? Colors
                                                                        .grey
                                                                    : widget.champList[i].champCost ==
                                                                            '2'
                                                                        ? Colors
                                                                            .green
                                                                        : widget.champList[i].champCost ==
                                                                                '3'
                                                                            ? Colors.blue
                                                                            : widget.champList[i].champCost == '4'
                                                                                ? Colors.purple
                                                                                : widget.champList[i].champCost == '5'
                                                                                    ? Colors.yellow
                                                                                    : Colors.red,
                                                                shadowColor: widget
                                                                            .champList[
                                                                                i]
                                                                            .champCost ==
                                                                        '1'
                                                                    ? const Color(
                                                                        0x609E9E9E)
                                                                    : widget.champList[i].champCost ==
                                                                            '2'
                                                                        ? const Color(
                                                                            0x604CAF50)
                                                                        : widget.champList[i].champCost ==
                                                                                '3'
                                                                            ? const Color(0x602196F3)
                                                                            : widget.champList[i].champCost == '4'
                                                                                ? const Color(0x609C27B0)
                                                                                : widget.champList[i].champCost == '5'
                                                                                    ? const Color(0x60FFEB3B)
                                                                                    : const Color(0x60F44336),
                                                                isBorder: true,
                                                                isShadow: true,
                                                                isStar: i ==
                                                                            2 ||
                                                                        i == 3
                                                                    ? true
                                                                    : false,
                                                              ),
                                                              Text(
                                                                widget
                                                                    .champList[
                                                                i]
                                                                    .champName
                                                                    .length >
                                                                    5
                                                                    ? widget
                                                                    .champList[
                                                                i]
                                                                    .champName
                                                                    .substring(
                                                                    0,
                                                                    5)
                                                                    : widget
                                                                    .champList[
                                                                i]
                                                                    .champName,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 9),
                                                              )
                                                            ],
                                                          )
                                                  //  SmallImageWidget(
                                                  //    // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                  //    ///
                                                  //    ///  16-May-2023
                                                  //    /// Fetching new image path
                                                  //    ///
                                                  //    ///
                                                  //    boxHeight: height(context) * 0.06,
                                                  //    boxWidth: height(context) * 0.06,
                                                  //    imageHeight: height(context) * 0.05,
                                                  //    imageWidth: height(context) * 0.05,
                                                  //    imageUrl: widget.champList[i].imagePath,
                                                  //    // isBorder: i == 0 || i == 2 ? true : false,
                                                  //    // isShadow: i == 0 || i == 2 ? true : false,
                                                  //    // isStar: i == 2 || i == 3 ? true : false,
                                                  //    ///
                                                  //    /// Date : 14-May-2023
                                                  //    ///
                                                  //    /// Requirement # 2a, 2b, 2c, 2d, 2e
                                                  //    ///
                                                  //    /// Different border colors of images
                                                  //    /// according to the cost of the champion
                                                  //    ///
                                                  //    /// This color representation is for popular
                                                  //    /// category on main screen
                                                  //    ///
                                                  //    borderColor: widget.champList[i].champCost=='1'?
                                                  //    Colors.grey:widget.champList[i].champCost=='2'?
                                                  //    Colors.green:widget.champList[i].champCost=='3'?
                                                  //    Colors.blue:widget.champList[i].champCost=='4'?
                                                  //    Colors.purple:widget.champList[i].champCost=='5'?
                                                  //    Colors.yellow:Colors.red
                                                  //    ,
                                                  //    shadowColor: widget.champList[i].champCost=='1'?
                                                  //    const Color(0x609E9E9E):widget.champList[i].champCost=='2'?
                                                  //    const Color(0x604CAF50):widget.champList[i].champCost=='3'?
                                                  //    const Color(0x602196F3):widget.champList[i].champCost=='4'?
                                                  //    const Color(0x609C27B0):widget.champList[i].champCost=='5'?
                                                  //    const Color(0x60FFEB3B):const Color(0x60F44336),
                                                  //    isBorder: true ,
                                                  //    isShadow:  true ,
                                                  //    // isStar: i == 2 || i == 3 ? true : false,
                                                  //  )
                                                  ///
                                                  //                       Container(
                                                  //                         height: height(context) * 0.07,
                                                  //                         width: height(context) * 0.07,
                                                  //                         decoration: BoxDecoration(
                                                  //                           borderRadius: BorderRadius.circular(17),
                                                  //                           border: Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='1'
                                                  //                             // border: Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='1'
                                                  //                               ? Border.all(
                                                  //                                   // color: AppColors.skyBorderColor,
                                                  //                             color: Colors.grey,
                                                  //                                   width: 2.27,
                                                  //                                 )
                                                  //                               : Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='2'?
                                                  //                               // : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='2'?
                                                  //                           Border.all(
                                                  //                             // color: AppColors.skyBorderColor,
                                                  //                             color: Colors.green,
                                                  //                             width: 2.27,
                                                  //                           )
                                                  //                               :Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='3'?
                                                  //                               // :Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='3'?
                                                  //                           Border.all(
                                                  //                             // color: AppColors.skyBorderColor,
                                                  //                             color: Colors.blue,
                                                  //                             width: 2.27,
                                                  //
                                                  //                           ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='4'?
                                                  //                              // ):Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='4'?
                                                  //                           Border.all(
                                                  //                             // color: AppColors.skyBorderColor,
                                                  //                             color: Colors.purple,
                                                  //                             width: 2.27,
                                                  //                           ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='5'?
                                                  //                           Border.all(
                                                  //                             // color: AppColors.skyBorderColor,
                                                  //                             color: Colors.yellow,
                                                  //                             width: 2.27,
                                                  //                           ):
                                                  //                           Border.all(
                                                  //                             // color: AppColors.skyBorderColor,
                                                  //                             color: Colors.red,
                                                  //                             width: 2.27,
                                                  //                           ),
                                                  //                           boxShadow: [
                                                  //                             Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='1'
                                                  //                                 ? BoxShadow(
                                                  //                                     color: Colors.grey
                                                  //                                         .withOpacity(0.6),
                                                  //                                     blurRadius: 10,
                                                  //                                   ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='2'
                                                  //                                 ? BoxShadow(
                                                  //                               color: Colors.green
                                                  //                                   .withOpacity(0.6),
                                                  //                               blurRadius: 10,
                                                  //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='3'
                                                  //                                 ? BoxShadow(
                                                  //                               color: Colors.blue
                                                  //                                   .withOpacity(0.6),
                                                  //                               blurRadius: 10,
                                                  //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='4'
                                                  //                                 ? BoxShadow(
                                                  //                               color: Colors.purple
                                                  //                                   .withOpacity(0.6),
                                                  //                               blurRadius: 10,
                                                  //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='5'
                                                  //                                 ? BoxShadow(
                                                  //                               color: Colors.yellow
                                                  //                                   .withOpacity(0.6),
                                                  //                               blurRadius: 10,
                                                  //                             ):BoxShadow(
                                                  //                               color: Colors.red
                                                  //                                   .withOpacity(0.6),
                                                  //                               blurRadius: 10,
                                                  //                             )
                                                  //
                                                  //                           ]
                                                  // ,
                                                  //                           image: DecorationImage(
                                                  //                             fit: BoxFit.fill,
                                                  //                               // image: NetworkImage('${baseUrl + champListFromFirebase[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}'))
                                                  //                               ///
                                                  //                               ///  16-May-2023
                                                  //                               ///  New Image path fetched from firebase
                                                  //                               ///  and shown
                                                  //                               ///
                                                  //                               image: NetworkImage(apiImageUrl + Provider.of<BasicProvider>(context).champListFromFirebase[i].imagePath.toString().toLowerCase()))
                                                  //
                                                  //
                                                  //                         ),
                                                  //                         // child: Text(Provider.of<BasicProvider>(context).champListFromFirebase[i].champName,style: const TextStyle(color: Colors.white),),
                                                  //                         // child: Image.network(
                                                  //                         //     '${baseUrl + champListFromFirebase[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                  //                         //     height: 60,
                                                  //                         //     width: 60,
                                                  //                         //
                                                  //                         //     fit: BoxFit
                                                  //                         //         .fill),
                                                  //                       )
                                                ],
                                              ),
                                            ],
                                          )

                                          // ListView.builder(
                                          //   // padding: EdgeInsets.zero,
                                          //   // itemExtent: 33,
                                          //     shrinkWrap: true,
                                          //     scrollDirection: Axis.horizontal,
                                          //     itemCount: widget.champList.length>=4?4:widget.champList.length,
                                          //     itemBuilder: (context,i)
                                          //     {
                                          //       return SmallImageWidget(
                                          //         // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                          //         ///
                                          //         ///  16-May-2023
                                          //         /// Fetching new image path
                                          //         ///
                                          //         ///
                                          //         imageUrl: "$apiImageUrl${widget.champList[i].imagePath}",
                                          //         // isBorder: i == 0 || i == 2 ? true : false,
                                          //         // isShadow: i == 0 || i == 2 ? true : false,
                                          //         // isStar: i == 2 || i == 3 ? true : false,
                                          //         ///
                                          //         /// Date : 14-May-2023
                                          //         ///
                                          //         /// Requirement # 2a, 2b, 2c, 2d, 2e
                                          //         ///
                                          //         /// Different border colors of images
                                          //         /// according to the cost of the champion
                                          //         ///
                                          //         /// This color representation is for popular
                                          //         /// category on main screen
                                          //         ///
                                          //         borderColor: widget.champList[i].champCost=='1'?
                                          //         Colors.grey:widget.champList[i].champCost=='2'?
                                          //         Colors.green:widget.champList[i].champCost=='3'?
                                          //         Colors.blue:widget.champList[i].champCost=='4'?
                                          //         Colors.purple:widget.champList[i].champCost=='5'?
                                          //         Colors.yellow:Colors.red
                                          //         ,
                                          //         shadowColor: widget.champList[i].champCost=='1'?
                                          //         const Color(0x609E9E9E):widget.champList[i].champCost=='2'?
                                          //         const Color(0x604CAF50):widget.champList[i].champCost=='3'?
                                          //         const Color(0x602196F3):widget.champList[i].champCost=='4'?
                                          //         const Color(0x609C27B0):widget.champList[i].champCost=='5'?
                                          //         const Color(0x60FFEB3B):const Color(0x60F44336),
                                          //         imageHeight: 30,
                                          //         imageWidth: 30,
                                          //         isBorder: true ,
                                          //         isShadow:  true ,
                                          //         // isStar: i == 2 || i == 3 ? true : false,
                                          //       );
                                          //     }),
                                          ),
                                    ],
                                  )
                                  // widget.icon,
                                ],
                              )
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //
                        //   children: [
                        //     /// image
                        //     const SmallImageWidget(imageUrl: '',imageHeight: 30,imageWidth: 30,),
                        //     // const SizedBox(width: 5),
                        //
                        //     /// name and desc
                        //     Column(
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           'Veronica King V'.length>8?'Veronica King V'.substring(0,8):'Veronica King V',
                        //           style: poppinsSemiBold.copyWith(
                        //             fontSize: 14,
                        //             color: AppColors.whiteColor,
                        //           ),
                        //         ),
                        //         const SizedBox(height: 1.0),
                        //         Text(
                        //           'Hard',
                        //           style: poppinsRegular.copyWith(
                        //             fontSize: 14,
                        //             color: AppColors.whiteColor.withOpacity(0.4),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     const SizedBox(width: 6),
                        //     /// image with stars
                        //
                        //     SizedBox(
                        //       width: width(context)>320&&width(context)<700?
                        //       width(context)*.32:width(context)<320?width(context)*.25:
                        //       width(context)>700?width(context)*.4:null,
                        //       child: ListView.builder(
                        //         // padding: EdgeInsets.zero,
                        //         itemExtent: width(context)<372?width(context)*.1:null,
                        //         shrinkWrap: true,
                        //           scrollDirection: Axis.horizontal,
                        //           itemCount: widget.champList.length>=3?3:widget.champList.length,
                        //           itemBuilder: (context,i)
                        //           {
                        //             return SmallImageWidget(
                        //               // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                        //               ///
                        //               ///  16-May-2023
                        //               /// Fetching new image path
                        //               ///
                        //               ///
                        //               imageUrl: "$apiImageUrl${widget.champList[i].imagePath}",
                        //               // isBorder: i == 0 || i == 2 ? true : false,
                        //               // isShadow: i == 0 || i == 2 ? true : false,
                        //               // isStar: i == 2 || i == 3 ? true : false,
                        //               ///
                        //               /// Date : 14-May-2023
                        //               ///
                        //               /// Requirement # 2a, 2b, 2c, 2d, 2e
                        //               ///
                        //               /// Different border colors of images
                        //               /// according to the cost of the champion
                        //               ///
                        //               /// This color representation is for popular
                        //               /// category on main screen
                        //               ///
                        //               borderColor: widget.champList[i].champCost=='1'?
                        //               Colors.grey:widget.champList[i].champCost=='2'?
                        //               Colors.green:widget.champList[i].champCost=='3'?
                        //               Colors.blue:widget.champList[i].champCost=='4'?
                        //               Colors.purple:widget.champList[i].champCost=='5'?
                        //               Colors.yellow:Colors.red
                        //               ,
                        //               shadowColor: widget.champList[i].champCost=='1'?
                        //               const Color(0x609E9E9E):widget.champList[i].champCost=='2'?
                        //               const Color(0x604CAF50):widget.champList[i].champCost=='3'?
                        //               const Color(0x602196F3):widget.champList[i].champCost=='4'?
                        //               const Color(0x609C27B0):widget.champList[i].champCost=='5'?
                        //               const Color(0x60FFEB3B):const Color(0x60F44336),
                        //               imageHeight: 30,
                        //               imageWidth: 30,
                        //               isBorder: true ,
                        //               isShadow:  true ,
                        //               // isStar: i == 2 || i == 3 ? true : false,
                        //             );
                        //           }),
                        //     ),
                        //
                        //     /// arrow down icon
                        //     const Icon(Icons.arrow_drop_down,color: Colors.white,size: 30,)
                        //     // widget.icon,
                        //   ],
                        // ),
                        ),
                  );
  }
}
