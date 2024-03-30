import 'package:app/screens/pinned_comp_screen/pinned_comp_heading.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import '/screens/components/traits_box.dart';
import '/widgets/responsive_widget.dart';
import 'package:provider/provider.dart';

import '../../../constants/exports.dart';
import '../../../providers/basic_provider.dart';
import '../../../widgets/small_image_widget.dart';
import '../Admin/Model/api_data_model.dart';
import '../components/carousal_box.dart';
import '../components/early_camp_box.dart';
import '../components/expand_heading_widget.dart';
import '../components/option_box.dart';

class PinnedCompScreen extends StatefulWidget {

  bool? isExpanded=false;
  String? compId;
  List<ChampModel> champList=[];

  // Key key;

  PinnedCompScreen({this.isExpanded,this.compId,required this.champList});


  @override
  State<PinnedCompScreen> createState() => _PinnedCompScreenState();
}

class _PinnedCompScreenState extends State<PinnedCompScreen> {

  List<String> traits = [];
  bool traitsFiltered = false;
  List<String?> champPosition = [];
  final Map traitsMap = {};
  List mapKeys = [];
  List mapValues = [];
  int k = 0;
  int j = 6;
  bool newLine = false;

  List<String> nonRepeatedTraits = [];

  filterTraits() {
    // print("=============> Begin Filter traits at expanded item widget  <=============");
    // print("Champlist length: ${widget.champList.length}");
    for (int i = 0; i < widget.champList.length; i++) {
      champPosition.add(widget.champList[i].champPositionIndex);
      for (int j = 0; j < widget.champList[i].champTraits.length; j++) {
        traits.add(widget.champList[i].champTraits[j]);
      }
    }
    for (int i = 0; i < traits.length; i++) {
      print(traits[i]);
    }
    traits.map((e) =>
    traitsMap.containsKey(e) ? traitsMap[e]++ : traitsMap[e] = 1).toList();

    traits.removeDuplicates();
    print(traits);
    traitsFiltered == true;
    // print("=============> End Filter traits at expanded item widget  <=============");
    setState(() {

    });
  }

  List<ChampModel?> row1 = [null, null, null, null, null, null, null];
  List<ChampModel?> row2 = [null, null, null, null, null, null, null];
  List<ChampModel?> row3 = [null, null, null, null, null, null, null];
  List<ChampModel?> row4 = [null, null, null, null, null, null, null];

  convertList() {
    int fullList = 28 - widget.champList.length;
    int length = fullList + widget.champList.length;
    for (int i = 0; i < length; i++) {
      if (i < widget.champList.length) {
        print("i < champlength");
        print(widget.champList[i].champPositionIndex.substring(0));
        if (widget.champList[i].champPositionIndex.startsWith('1')) {
          int index = int.parse(
              widget.champList[i].champPositionIndex.substring(1, 2));
          row1.removeAt(index);
          row1.insert(index,
              widget.champList[i]);
        }
      }
      if (i < widget.champList.length) {
        if (widget.champList[i].champPositionIndex.startsWith('2')) {
          int index = int.parse(
              widget.champList[i].champPositionIndex.substring(1, 2));
          row2.removeAt(index);
          row2.insert(index,
              widget.champList[i]);
        }
      }
      if (i < widget.champList.length) {
        if (widget.champList[i].champPositionIndex.startsWith('3')) {
          int index = int.parse(
              widget.champList[i].champPositionIndex.substring(1, 2));
          row3.removeAt(index);
          row3.insert(index,
              widget.champList[i]);
        }
      }
      if (i < widget.champList.length) {
        if (widget.champList[i].champPositionIndex.startsWith('4')) {
          int index = int.parse(
              widget.champList[i].champPositionIndex.substring(1, 2));
          row4.removeAt(index);
          row4.insert(index,
              widget.champList[i]);
        }
      }
    }

    print("Row 1: ${row1.length}");
    print("Row 2: ${row2.length}");
    print("Row 3: ${row3.length}");
    print("Row 4: ${row4.length}");
    for (int i = 0; i < 7; i++) {
      print(row1[i]);
      print(row2[i]);
      print(row3[i]);
      print(row4[i]);
    }
  }


  @override
  void initState() {
    filterTraits();
    convertList();

    print("Expand item widget init");
    // TODO: implement initState
    super.initState();
  }

  final controller = ExpandableController();

  bool isExpand = true;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BasicProvider>(context);
    var size = MediaQuery
        .of(context)
        .size;
    return ResponsiveWidget.isExtraWebScreen(context)
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        PinnedHeadingWidget(
          champList: widget.champList,
          compId: widget.compId!,
          // docId: widget.docId,
          icon: IconButton(
            onPressed: () {
              controller.toggle();
              setState(() {
                isExpand = !isExpand;
              });
            },
            icon: isExpand == true
                ? const Icon(
                Icons.keyboard_arrow_up, color: AppColors.whiteColor)
                : SvgPicture.asset(AppIcons.arrowDown),
          ),
          isExpand: isExpand,
        ),

        /// 3 boxes
        widget.isExpanded!?Column(
          children: [
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 22.0, right: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  /// early camp
                  SizedBox(
                    width: width(context)*.18,
                    child: const EarlyCampBox(),
                  ),


                  /// trails
                  SizedBox(
                    width: width(context)*.18,
                    child: TraitsBox(traits: traitsMap, traitNamesList: traits,),
                  ),

                  /// caroousel
                  SizedBox(
                      width: width(context)*.18,
                      child: CarouselBox()),


                ],
              ),
            ),

            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 22.0, right: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                ],
              ),
            ),
            const SizedBox(height: 10.0),

            /// 2 box
            Padding(
              padding: const EdgeInsets.only(left: 22.0, right: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /// option box
                  Container(
                    width: width(context)*.25,
                    height: height(context) * 0.35,
                    decoration:
                    threeBoxDecoration(context, isBorder: false),
                    child: const OptionsBox(),
                  ),
                  const SizedBox(width: 40),

                  /// positioning box
                  Container(
                    width: width(context)*.25,
                    height: height(context) * 0.35,
                    decoration:
                    threeBoxDecoration(context, isBorder: false),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        /// options text
                        const SizedBox(height: 16.0),
                        Text(
                          'Positioning',
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        ///
                        const SizedBox(height: 10.0),
                        Padding(
                          padding:
                          ResponsiveWidget.isMobileScreen(context)
                              ? EdgeInsets.symmetric(
                              horizontal:
                              height(context) * 0.18)
                              : ResponsiveWidget.isTabletScreen(
                              context)
                              ? EdgeInsets.symmetric(
                              horizontal:
                              height(context) * 0.16)
                              : EdgeInsets.symmetric(
                              horizontal:
                              height(context) * 0.02),

                          child:

                          Center(
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: height(context) * .12,
                                      left: height(context) * .032),
                                  child: Row(
                                      children: List.generate(7, (index3) =>
                                          SizedBox(
                                              height: height(context) * .06,
                                              width: height(context) * .06,
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  // child
                                                  /// Here I used chosen team indexes for reference if the player exist in team
                                                  /// We will show the icon of player else will show blank polygon icon
                                                  child: row3[index3] != null
                                                      ? SmallImageWidget(
                                                    isBorder: true,
                                                    imageUrl:
                                                        row3[index3]!.imagePath,
                                                    borderColor: row3[index3]!
                                                        .champCost == '1' ?
                                                    Colors.grey : row3[index3]!
                                                        .champCost == '2' ?
                                                    Colors.green : row3[index3]!
                                                        .champCost == '3' ?
                                                    Colors.blue : row3[index3]!
                                                        .champCost == '4' ?
                                                    Colors.purple : row3[index3]!
                                                        .champCost == '5' ?
                                                    Colors.yellow : Colors.red
                                                    ,

                                                  ) :
                                                  // ?  Image.network(
                                                  // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                  // height: 60,
                                                  // width: 60,
                                                  // fit: BoxFit
                                                  //     .fill):
                                                  Image.asset(
                                                      'assets/images/Polygon 7.png')

                                                  ,
                                                ),
                                              )
                                          )
                                      )
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(
                                      top: height(context) * .06,
                                      right: height(context) * .032),
                                  child: Row(
                                      children: List.generate(7, (index2) =>
                                          SizedBox(
                                              height: height(context) * .06,
                                              width: height(context) * .06,
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  // child
                                                  /// Here I used chosen team indexes for reference if the player exist in team
                                                  /// We will show the icon of player else will show blank polygon icon
                                                  child: row2[index2] != null
                                                      ? SmallImageWidget(
                                                    isBorder: true,
                                                    imageUrl:
                                                        row2[index2]!.imagePath,
                                                    borderColor: row2[index2]!
                                                        .champCost == '1' ?
                                                    Colors.grey : row2[index2]!
                                                        .champCost == '2' ?
                                                    Colors.green : row2[index2]!
                                                        .champCost == '3' ?
                                                    Colors.blue : row2[index2]!
                                                        .champCost == '4' ?
                                                    Colors.purple : row2[index2]!
                                                        .champCost == '5' ?
                                                    Colors.yellow : Colors.red
                                                    ,

                                                  ) :
                                                  // ?  Image.network(
                                                  // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                  // height: 60,
                                                  // width: 60,
                                                  // fit: BoxFit
                                                  //     .fill):
                                                  Image.asset(
                                                      'assets/images/Polygon 7.png')

                                                  ,
                                                ),
                                              )
                                          ))
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    // top: height(context) * .12,
                                      left: height(context) * .032),
                                  child: Row(
                                      children: List.generate(7, (index3) =>
                                          SizedBox(
                                              height: height(context) * .06,
                                              width: height(context) * .06,
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  // child
                                                  /// Here I used chosen team indexes for reference if the player exist in team
                                                  /// We will show the icon of player else will show blank polygon icon
                                                  child: row3[index3] != null
                                                      ? SmallImageWidget(
                                                    isBorder: true,
                                                    imageUrl:
                                                        row3[index3]!.imagePath,
                                                    borderColor: row3[index3]!
                                                        .champCost == '1' ?
                                                    Colors.grey : row3[index3]!
                                                        .champCost == '2' ?
                                                    Colors.green : row3[index3]!
                                                        .champCost == '3' ?
                                                    Colors.blue : row3[index3]!
                                                        .champCost == '4' ?
                                                    Colors.purple : row3[index3]!
                                                        .champCost == '5' ?
                                                    Colors.yellow : Colors.red
                                                    ,

                                                  ) :
                                                  // ?  Image.network(
                                                  // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                  // height: 60,
                                                  // width: 60,
                                                  // fit: BoxFit
                                                  //     .fill):
                                                  Image.asset(
                                                      'assets/images/Polygon 7.png')

                                                  ,
                                                ),
                                              )
                                          )
                                      )
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: height(context) * .18,
                                      right: height(context) * .032),
                                  child: Row(
                                      children: List.generate(7, (index4) =>
                                          SizedBox(
                                              height: height(context) * .06,
                                              width: height(context) * .06,
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  // child
                                                  /// Here I used chosen team indexes for reference if the player exist in team
                                                  /// We will show the icon of player else will show blank polygon icon
                                                  child: row4[index4] != null
                                                      ? SmallImageWidget(
                                                    isBorder: true,
                                                    imageUrl:
                                                        row4[index4]!.imagePath,
                                                    borderColor: row4[index4]!
                                                        .champCost == '1' ?
                                                    Colors.grey : row4[index4]!
                                                        .champCost == '2' ?
                                                    Colors.green : row4[index4]!
                                                        .champCost == '3' ?
                                                    Colors.blue : row4[index4]!
                                                        .champCost == '4' ?
                                                    Colors.purple : row4[index4]!
                                                        .champCost == '5' ?
                                                    Colors.yellow : Colors.red
                                                    ,

                                                  ) :
                                                  // ?  Image.network(
                                                  // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                  // height: 60,
                                                  // width: 60,
                                                  // fit: BoxFit
                                                  //     .fill):
                                                  Image.asset(
                                                      'assets/images/Polygon 7.png')

                                                  ,
                                                ),
                                              )
                                          )
                                      )
                                  ),
                                ),

                              ],
                            ),
                          ),

                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ):
        SizedBox(),
      ],
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        PinnedHeadingWidget(
          champList: widget.champList,
          compId: widget.compId!,
          // docId: widget.docId,
          icon: IconButton(
            onPressed: () {
              controller.toggle();
              setState(() {
                isExpand = !isExpand;
              });
            },
            icon: isExpand == true
                ? const Icon(
                Icons.keyboard_arrow_up, color: AppColors.whiteColor)
                : SvgPicture.asset(AppIcons.arrowDown),
          ),
          isExpand: isExpand,
        ),

        /// 3 boxes
        widget.isExpanded!?Column(
          children: [
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 22.0, right: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  /// early camp
                  SizedBox(
                    width: width(context)*.18,
                    child: const EarlyCampBox(),
                  ),


                  /// trails
                  SizedBox(
                    width: width(context)*.18,
                    child: TraitsBox(traits: traitsMap, traitNamesList: traits,),
                  ),

                  /// caroousel
                  SizedBox(
                      width: width(context)*.18,
                      child: CarouselBox()),


                ],
              ),
            ),

            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 22.0, right: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                ],
              ),
            ),
            const SizedBox(height: 10.0),

            /// 2 box
            Padding(
              padding: const EdgeInsets.only(left: 22.0, right: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /// option box
                  Container(
                    width: width(context)*.25,
                    height: height(context) * 0.35,
                    decoration:
                    threeBoxDecoration(context, isBorder: false),
                    child: const OptionsBox(),
                  ),
                  const SizedBox(width: 40),

                  /// positioning box
                  Container(
                    width: width(context)*.25,
                    height: height(context) * 0.35,
                    decoration:
                    threeBoxDecoration(context, isBorder: false),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        /// options text
                        const SizedBox(height: 16.0),
                        Text(
                          'Positioning',
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        ///
                        const SizedBox(height: 10.0),
                        Padding(
                          padding:
                          ResponsiveWidget.isMobileScreen(context)
                              ? EdgeInsets.symmetric(
                              horizontal:
                              height(context) * 0.18)
                              : ResponsiveWidget.isTabletScreen(
                              context)
                              ? EdgeInsets.symmetric(
                              horizontal:
                              height(context) * 0.16)
                              : EdgeInsets.symmetric(
                              horizontal:
                              height(context) * 0.02),

                          child:

                          Center(
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: height(context) * .12,
                                      left: height(context) * .032),
                                  child: Row(
                                      children: List.generate(7, (index3) =>
                                          SizedBox(
                                              height: height(context) * .06,
                                              width: height(context) * .06,
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  // child
                                                  /// Here I used chosen team indexes for reference if the player exist in team
                                                  /// We will show the icon of player else will show blank polygon icon
                                                  child: row3[index3] != null
                                                      ? SmallImageWidget(
                                                    isBorder: true,
                                                    imageUrl:
                                                        row3[index3]!.imagePath,
                                                    borderColor: row3[index3]!
                                                        .champCost == '1' ?
                                                    Colors.grey : row3[index3]!
                                                        .champCost == '2' ?
                                                    Colors.green : row3[index3]!
                                                        .champCost == '3' ?
                                                    Colors.blue : row3[index3]!
                                                        .champCost == '4' ?
                                                    Colors.purple : row3[index3]!
                                                        .champCost == '5' ?
                                                    Colors.yellow : Colors.red
                                                    ,

                                                  ) :
                                                  // ?  Image.network(
                                                  // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                  // height: 60,
                                                  // width: 60,
                                                  // fit: BoxFit
                                                  //     .fill):
                                                  Image.asset(
                                                      'assets/images/Polygon 7.png')

                                                  ,
                                                ),
                                              )
                                          )
                                      )
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(
                                      top: height(context) * .06,
                                      right: height(context) * .032),
                                  child: Row(
                                      children: List.generate(7, (index2) =>
                                          SizedBox(
                                              height: height(context) * .06,
                                              width: height(context) * .06,
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  // child
                                                  /// Here I used chosen team indexes for reference if the player exist in team
                                                  /// We will show the icon of player else will show blank polygon icon
                                                  child: row2[index2] != null
                                                      ? SmallImageWidget(
                                                    isBorder: true,
                                                    imageUrl:
                                                        row2[index2]!.imagePath,
                                                    borderColor: row2[index2]!
                                                        .champCost == '1' ?
                                                    Colors.grey : row2[index2]!
                                                        .champCost == '2' ?
                                                    Colors.green : row2[index2]!
                                                        .champCost == '3' ?
                                                    Colors.blue : row2[index2]!
                                                        .champCost == '4' ?
                                                    Colors.purple : row2[index2]!
                                                        .champCost == '5' ?
                                                    Colors.yellow : Colors.red
                                                    ,

                                                  ) :
                                                  // ?  Image.network(
                                                  // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                  // height: 60,
                                                  // width: 60,
                                                  // fit: BoxFit
                                                  //     .fill):
                                                  Image.asset(
                                                      'assets/images/Polygon 7.png')

                                                  ,
                                                ),
                                              )
                                          ))
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    // top: height(context) * .12,
                                      left: height(context) * .032),
                                  child: Row(
                                      children: List.generate(7, (index3) =>
                                          SizedBox(
                                              height: height(context) * .06,
                                              width: height(context) * .06,
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  // child
                                                  /// Here I used chosen team indexes for reference if the player exist in team
                                                  /// We will show the icon of player else will show blank polygon icon
                                                  child: row3[index3] != null
                                                      ? SmallImageWidget(
                                                    isBorder: true,
                                                    imageUrl:
                                                        row3[index3]!.imagePath,
                                                    borderColor: row3[index3]!
                                                        .champCost == '1' ?
                                                    Colors.grey : row3[index3]!
                                                        .champCost == '2' ?
                                                    Colors.green : row3[index3]!
                                                        .champCost == '3' ?
                                                    Colors.blue : row3[index3]!
                                                        .champCost == '4' ?
                                                    Colors.purple : row3[index3]!
                                                        .champCost == '5' ?
                                                    Colors.yellow : Colors.red
                                                    ,

                                                  ) :
                                                  // ?  Image.network(
                                                  // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                  // height: 60,
                                                  // width: 60,
                                                  // fit: BoxFit
                                                  //     .fill):
                                                  Image.asset(
                                                      'assets/images/Polygon 7.png')

                                                  ,
                                                ),
                                              )
                                          )
                                      )
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: height(context) * .18,
                                      right: height(context) * .032),
                                  child: Row(
                                      children: List.generate(7, (index4) =>
                                          SizedBox(
                                              height: height(context) * .06,
                                              width: height(context) * .06,
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  // child
                                                  /// Here I used chosen team indexes for reference if the player exist in team
                                                  /// We will show the icon of player else will show blank polygon icon
                                                  child: row4[index4] != null
                                                      ? SmallImageWidget(
                                                    isBorder: true,
                                                    imageUrl:
                                                        row4[index4]!.imagePath,
                                                    borderColor: row4[index4]!
                                                        .champCost == '1' ?
                                                    Colors.grey : row4[index4]!
                                                        .champCost == '2' ?
                                                    Colors.green : row4[index4]!
                                                        .champCost == '3' ?
                                                    Colors.blue : row4[index4]!
                                                        .champCost == '4' ?
                                                    Colors.purple : row4[index4]!
                                                        .champCost == '5' ?
                                                    Colors.yellow : Colors.red
                                                    ,

                                                  ) :
                                                  // ?  Image.network(
                                                  // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                  // height: 60,
                                                  // width: 60,
                                                  // fit: BoxFit
                                                  //     .fill):
                                                  Image.asset(
                                                      'assets/images/Polygon 7.png')

                                                  ,
                                                ),
                                              )
                                          )
                                      )
                                  ),
                                ),

                              ],
                            ),
                          ),

                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ):
        SizedBox(),
      ],
    );
  }
}