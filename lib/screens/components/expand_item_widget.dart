import 'package:app/model/item_model.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import '../../consolePrintWithColor.dart';
import '../../widgets/responsive_widget.dart';
import '../../widgets/small_image_widget.dart';
import '/screens/components/traits_box.dart';
import 'package:provider/provider.dart';

import '../../constants/exports.dart';
import '../../providers/basic_provider.dart';
import '../Admin/Model/api_data_model.dart';
import 'carousal_box.dart';
import 'early_camp_box.dart';
import 'expand_heading_widget.dart';
import 'option_box.dart';

class ExpandItemWidget extends StatefulWidget {

  // var champItems;
  String? compId;
  List<ChampModel> champList;
  bool? isExpanded;



  ExpandItemWidget({this.isExpanded=false,this.compId,this.champList=const[]});


  @override
  State<ExpandItemWidget> createState() => _ExpandItemWidgetState();
}

class _ExpandItemWidgetState extends State<ExpandItemWidget> {

  List<String> traits=[];
  bool traitsFiltered=false;
  List<String?> champPosition=[];
  final Map traitsMap={};
  List mapKeys=[];
  List mapValues=[];

  List<ChampModel> champList=[];

  convertChampList(){
    printLog(champList.length.toString());
    for(int i=0;i<widget.champList.length;i++){
      printLog("==================>${widget.champList[i]}");
      champList.add(widget.champList[i]);
      // printLog("><><><>><><><><><<><><>${widget.champList[i].}")

    }
  }

  List<String> nonRepeatedTraits=[];

  filterTraits(){

    // print("=============> Begin Filter traits at expanded item widget  <=============");
    // print("Champlist length: ${champList.length}");
    for(int i=0;i<champList.length;i++){
      champPosition.add(champList[i].champPositionIndex);
      for(int j=0;j<champList[i].champTraits.length;j++){
        traits.add(champList[i].champTraits[j]);
      }
    }
    for(int i=0;i<traits.length;i++){
      print(traits[i]);

    }
    traits.map((e) =>
        traitsMap.containsKey(e)?traitsMap[e]++:traitsMap[e]=1).toList();

    traits.removeDuplicates();
    print(traits);
    traitsFiltered==true;
    // print("=============> End Filter traits at expanded item widget  <=============");
    setState(() {

    });

  }

  List<ChampModel?> row1=[null,null,null,null,null,null,null];
  List<ChampModel?> row2=[null,null,null,null,null,null,null];
  List<ChampModel?> row3=[null,null,null,null,null,null,null];
  List<ChampModel?> row4=[null,null,null,null,null,null,null];

  convertList(){
    int fullList=28-champList.length;
    int length=fullList+champList.length;
    for(int i=0;i<length;i++){
      if(i<champList.length){
        print("i < champlength");
        print(champList[i].champPositionIndex.substring(0));
        if(champList[i].champPositionIndex.startsWith('1')) {
          int index=int.parse(champList[i].champPositionIndex.substring(1,2));
          row1.removeAt(index);
          row1.insert(index,
              champList[i]);
        }
      }
      if(i<champList.length){
        if(champList[i].champPositionIndex.startsWith('2')) {
          int index=int.parse(champList[i].champPositionIndex.substring(1,2));
          row2.removeAt(index);
          row2.insert(index,
              champList[i]);

        }
      }
      if(i<champList.length){
        if(champList[i].champPositionIndex.startsWith('3')) {
          int index=int.parse(champList[i].champPositionIndex.substring(1,2));
          row3.removeAt(index);
          row3.insert(index,
              champList[i]);

        }
      }
      if(i<champList.length){
        if(champList[i].champPositionIndex.startsWith('4')) {
          int index=int.parse(champList[i].champPositionIndex.substring(1,2));
          row4.removeAt(index);
          row4.insert(index,
              champList[i]);
        }

      }
    }

    print("Row 1: ${row1.length}");
    print("Row 2: ${row2.length}");
    print("Row 3: ${row3.length}");
    print("Row 4: ${row4.length}");
    for(int i=0;i<7;i++){
      print(row1[i]);
      print(row2[i]);
      print(row3[i]);
      print(row4[i]);
    }

  }


  @override
  void initState() {
    printLog("Expanded item called");
    printLog("======<<<<<<<<<<<+++++++Champ list length+++${widget.champList.length}");
    convertChampList();
    filterTraits();
    convertList();
    isExpand=widget.isExpanded!;
    print("Expand item widget init");
    // TODO: implement initState
    super.initState();
  }

  final controller = ExpandableController();

  bool isExpand = false;
  double heightConstraint850=850;
  double heightConstraint1000=1000;
  double heightConstraint1200=1200;
  double heightConstraint1400=1400;


  @override
  Widget build(BuildContext context) {
    var provider=Provider.of<BasicProvider>(context);
    var size = MediaQuery.of(context).size;
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return ExpandablePanel(
      controller: controller,
      theme: const ExpandableThemeData(
        useInkWell: false,
        hasIcon: false,
        //iconColor: AppColors.textColor,
        iconPadding: EdgeInsets.only(right: 20.0, top: 24.0),
        tapBodyToCollapse: false,
        tapBodyToExpand: false,
        tapHeaderToExpand: false,

      ),

      ///
      ///       Date 14-May-2023
      ///       Requirement # 1
      ///       Team comp now expands on pressing any where in the
      ///       target Team comp
      ///
      header: InkWell(
        onTap: (){
          controller.toggle();
          setState(() {
            isExpand = !isExpand;
          });
        },
        child: ExpandHeadingWidget(
          champList: champList,
          compId: widget.compId!,
          // docId: docId,
          icon: IconButton(
            onPressed: () {
              controller.toggle();
              setState(() {
                isExpand = !isExpand;
              });
            },
            icon: isExpand == true
                ? const Icon(Icons.keyboard_arrow_up, color: AppColors.whiteColor)
                : SvgPicture.asset(AppIcons.arrowDown),
          ),
          isExpand: isExpand,
        ),
      ),
      collapsed: const SizedBox(),
      expanded: ResponsiveWidget.isExtraWebScreen(context)
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// 3 boxes
          // const SizedBox(height: 10.0),
          // Padding(
          //   padding: const EdgeInsets.only(left: 22.0, right: 24),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: const [
          //       /// early camp
          //       Expanded(
          //         child: EarlyCampBox(),
          //       ),
          //     ],
          //   ),
          // ),

          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 22.0, right: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                /// traits
                Expanded(
                  child: TraitsBox(traits: traitsMap,traitNamesList: traits,),
                ),
                // SizedBox(width: 24),

                // /// caroousel
                // const Expanded(
                //   flex: 1,
                //   child: CarouselBox(),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),

          /// 2 box
          Padding(
            padding: const EdgeInsets.only(left: 22.0, right: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// option box
                // Expanded(
                //   child: Container(
                //     width: width,
                //     height: height * 0.35,
                //     decoration:
                //     threeBoxDecoration(context, isBorder: false),
                //     child: const OptionsBox(),
                //   ),
                // ),
                // const SizedBox(width: 40),

                /// positioning box
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    width: width,
                    height: height * 0.35,
                    decoration:
                    threeBoxDecoration(context, isBorder: false),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          padding: EdgeInsets.only(left: height*.06),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(7, (index1) =>
                                  SizedBox(
                                      height: height*.06,
                                      width: height*.06,
                                      child: row1[index1]!=null
                                          ?Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          SmallImageWidget(
                                            isPolygon: true,
                                            imageHeight: height*.06,
                                            imageWidth: height*.06,
                                            boxHeight: height*.06,
                                            boxWidth: height*.06,
                                            isBorder: true,

                                            imageUrl: row1[index1]!.imagePath,
                                            borderColor: row1[index1]!.champCost=='1'?
                                            Colors.grey:row1[index1]!.champCost=='2'?
                                            Colors.green:row1[index1]!.champCost=='3'?
                                            Colors.blue:row1[index1]!.champCost=='4'?
                                            Colors.purple:row1[index1]!.champCost=='5'?
                                            Colors.yellow:Colors.red
                                            ,

                                          ),
                                          // champItems!.containsKey(row1[index1]!.champPositionIndex)
                                              row1[index1]!.champItems.isNotEmpty
                                              ?
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: List.generate(row1[index1]!.champItems.length, (index){
                                              printLog("+++++*********=============== Items ");
                                              // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                              return
                                                Container(
                                                    height: height*.015,
                                                    width: height*.015,
                                                    decoration: BoxDecoration(

                                                    ),
                                                    child: Image(image: NetworkImage(row1[index1]!.champItems[index]["itemImageUrl"]))
                                                );
                                              //   SmallImageWidget(
                                              //   isPolygon: true,
                                              //     imageHeight: height*.02,
                                              //     imageWidth: height*.02,
                                              //     boxHeight: height*.02,
                                              //     boxWidth: height*.02,
                                              //     isBorder: false,
                                              //     imageUrl: row1[index1]!.champItems[index]["itemImageUrl"]
                                              //
                                              // );
                                            }),
                                          )
                                              :const SizedBox()
                                        ],
                                      ):

                                      Image.asset(
                                          'assets/images/Polygon 7.png')
                                  )
                              )
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(7, (index2) =>
                                SizedBox(
                                    height: height*.06,
                                    width: height*.06,
                                    child: row2[index2]!=null
                                        ?Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        SmallImageWidget(
                                          isPolygon: true,
                                          imageHeight: height*.06,
                                          imageWidth: height*.06,
                                          boxHeight: height*.06,
                                          boxWidth: height*.06,
                                          isBorder: true,
                                          imageUrl: row2[index2]!.imagePath,
                                          borderColor: row2[index2]!.champCost=='1'?
                                          Colors.grey:row2[index2]!.champCost=='2'?
                                          Colors.green:row2[index2]!.champCost=='3'?
                                          Colors.blue:row2[index2]!.champCost=='4'?
                                          Colors.purple:row2[index2]!.champCost=='5'?
                                          Colors.yellow:Colors.red,
                                        ),
                                        row2[index2]!.champItems.isNotEmpty?
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(row2[index2]!.champItems.length, (index){
                                            printLog("+++++*********=============== Items ");
                                            // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                            return
                                              Container(
                                                  height: height*.015,
                                                  width: height*.015,
                                                  decoration: BoxDecoration(

                                                  ),
                                                  child: Image(image: NetworkImage(row2[index2]!.champItems[index]["itemImageUrl"]))
                                              );
                                            //   SmallImageWidget(
                                            //   isPolygon: true,
                                            //     imageHeight: height*.02,
                                            //     imageWidth: height*.02,
                                            //     boxHeight: height*.02,
                                            //     boxWidth: height*.02,
                                            //     isBorder: false,
                                            //     imageUrl: row2[index2]!.champItems[index]["itemImageUrl"]
                                            //
                                            // );
                                          }),
                                        )
                                            :SizedBox()
                                      ],
                                    ):
                                    // ?  Image.network(
                                    // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                    // height: 60,
                                    // width: 60,
                                    // fit: BoxFit
                                    //     .fill):
                                    Image.asset(
                                        'assets/images/Polygon 7.png')
                                ))
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: height*.06),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(7, (index3) =>
                                  SizedBox(
                                      height: height*.06,
                                      width: height*.06,
                                      child: row3[index3]!=null
                                          ?Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          SmallImageWidget(
                                            isPolygon: true,
                                            imageHeight: height*.06,
                                            imageWidth: height*.06,
                                            boxHeight: height*.06,
                                            boxWidth: height*.06,
                                            isBorder: true,
                                            imageUrl: row3[index3]!.imagePath,
                                            borderColor: row3[index3]!.champCost=='1'?
                                            Colors.grey:row3[index3]!.champCost=='2'?
                                            Colors.green:row3[index3]!.champCost=='3'?
                                            Colors.blue:row3[index3]!.champCost=='4'?
                                            Colors.purple:row3[index3]!.champCost=='5'?
                                            Colors.yellow:Colors.red
                                            ,

                                          ),
                                          row3[index3]!.champItems.isNotEmpty?
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: List.generate(row3[index3]!.champItems.length, (index){
                                              printLog("+++++*********=============== Items ");
                                              // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                              return
                                                Container(
                                                    height: height*.015,
                                                    width: height*.015,
                                                    decoration: BoxDecoration(

                                                    ),
                                                    child: Image(image: NetworkImage(row3[index3]!.champItems[index]["itemImageUrl"]))
                                                );
                                              //   SmallImageWidget(
                                              //   isPolygon: true,
                                              //     imageHeight: height*.02,
                                              //     imageWidth: height*.02,
                                              //     boxHeight: height*.02,
                                              //     boxWidth: height*.02,
                                              //     isBorder: false,
                                              //     imageUrl: row3[index3]!.champItems[index]["itemImageUrl"]
                                              //
                                              // );
                                            }),
                                          )
                                              :SizedBox()
                                        ],
                                      ):
                                      // ?  Image.network(
                                      // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                      // height: 60,
                                      // width: 60,
                                      // fit: BoxFit
                                      //     .fill):
                                      Image.asset(
                                          'assets/images/Polygon 7.png')
                                  )
                              )
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(7, (index4) =>
                                SizedBox(
                                    height: height*.06,
                                    width: height*.06,
                                    child: row4[index4]!=null
                                        ?Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        SmallImageWidget(
                                          isPolygon: true,
                                          imageHeight: height*.06,
                                          imageWidth: height*.06,
                                          boxHeight: height*.06,
                                          boxWidth: height*.06,
                                          isBorder: true,
                                          imageUrl: row4[index4]!.imagePath,
                                          borderColor: row4[index4]!.champCost=='1'?
                                          Colors.grey:row4[index4]!.champCost=='2'?
                                          Colors.green:row4[index4]!.champCost=='3'?
                                          Colors.blue:row4[index4]!.champCost=='4'?
                                          Colors.purple:row4[index4]!.champCost=='5'?
                                          Colors.yellow:Colors.red
                                          ,

                                        ),
                                        row4[index4]!.champItems.isNotEmpty?
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(row4[index4]!.champItems.length, (index){
                                            printLog("+++++*********=============== Items ");
                                            // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                            return

                                              Container(
                                                  height: height*.015,
                                                  width: height*.015,
                                                  decoration: BoxDecoration(

                                                  ),
                                                  child: Image(image: NetworkImage(row4[index4]!.champItems[index]["itemImageUrl"]))
                                              );
                                            //   SmallImageWidget(
                                            //   isPolygon: true,
                                            //     imageHeight: height*.02,
                                            //     imageWidth: height*.02,
                                            //     boxHeight: height*.02,
                                            //     boxWidth: height*.02,
                                            //     isBorder: false,
                                            //     imageUrl: row4[index4]!.champItems[index]["itemImageUrl"]
                                            //
                                            // );
                                          }),
                                        )
                                            :SizedBox()
                                      ],
                                    ):
                                    // ?  Image.network(
                                    // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                    // height: 60,
                                    // width: 60,
                                    // fit: BoxFit
                                    //     .fill):
                                    Image.asset(
                                        'assets/images/Polygon 7.png')
                                )
                            )
                        ),
                        const SizedBox(height: 15.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
          : ResponsiveWidget.isWebScreen(context)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// 3 boxes
                    const SizedBox(height: 10.0),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 22.0, right: 24),
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: const [
                    //       /// early camp
                    //       Expanded(
                    //         child: EarlyCampBox(),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0, right: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          /// traits
                          Expanded(
                            child: TraitsBox(traits: traitsMap,traitNamesList: traits,),
                          ),
                          SizedBox(width: 24),

                          /// caroousel
                          // const Expanded(
                          //   flex: 1,
                          //   child: CarouselBox(),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    /// 2 box
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0, right: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// option box
                          // Expanded(
                          //   child: Container(
                          //     width: width,
                          //     height: height * 0.35,
                          //     decoration:
                          //         threeBoxDecoration(context, isBorder: false),
                          //     child: const OptionsBox(),
                          //   ),
                          // ),
                          // const SizedBox(width: 40),

                          /// positioning box
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              width: width,
                              height: height * 0.35,
                              decoration:
                                  threeBoxDecoration(context, isBorder: false),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                    padding: EdgeInsets.only(left: height*.06),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: List.generate(7, (index1) =>
                                            SizedBox(
                                              height: height*.06,
                                              width: height*.06,
                                              child: row1[index1]!=null
                                                  ?Stack(
                                                alignment: Alignment.bottomCenter,
                                                    children: [
                                                      SmallImageWidget(
                                                        isPolygon: true,
                                                        imageHeight: height*.06,
                                                        imageWidth: height*.06,
                                                        boxWidth: height*.06,
                                                        boxHeight: height*.06,
                                                isBorder: true,

                                                imageUrl: row1[index1]!.imagePath,
                                                borderColor: row1[index1]!.champCost=='1'?
                                                Colors.grey:row1[index1]!.champCost=='2'?
                                                Colors.green:row1[index1]!.champCost=='3'?
                                                Colors.blue:row1[index1]!.champCost=='4'?
                                                Colors.purple:row1[index1]!.champCost=='5'?
                                                Colors.yellow:Colors.red
                                                ,

                                              ),
                                                      row1[index1]!.champItems.isNotEmpty?
                                                      Row(
                                                        children: List.generate(row1[index1]!.champItems.length, (index){
                                                          printLog("+++++*********=============== Items ");
                                                          // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                          return
                                                            Container(
                                                                height: height*.015,
                                                                width: height*.015,
                                                                decoration: BoxDecoration(

                                                                ),
                                                                child: Image(image: NetworkImage(row1[index1]!.champItems[index]["itemImageUrl"]))
                                                            );
                                                          //   SmallImageWidget(
                                                          //     isPolygon: true,
                                                          //     imageHeight: height*.03,
                                                          //     imageWidth: height*.03,
                                                          //     boxWidth: height*.03,
                                                          //     boxHeight: height*.03,
                                                          //     isBorder: false,
                                                          //     imageUrl: row1[index1]!.champItems[index]["itemImageUrl"]
                                                          //
                                                          // );
                                                        }),
                                                      )
                                                    :const SizedBox()
                                                    ],
                                                  ):

                                              Image.asset(
                                                  'assets/images/Polygon 7.png')
                                            )
                                        )
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: List.generate(7, (index2) =>
                                          SizedBox(
                                              height: height*.06,
                                              width: height*.06,
                                              child: row2[index2]!=null
                                                  ?Stack(
                                                alignment: Alignment.bottomCenter,
                                                    children: [
                                                      SmallImageWidget(
                                                        isPolygon: true,
                                                        imageHeight: height*.06,
                                                        imageWidth: height*.06,
                                                        boxWidth: height*.06,
                                                        boxHeight: height*.06,
                                                isBorder: true,
                                                imageUrl: row2[index2]!.imagePath,
                                                borderColor: row2[index2]!.champCost=='1'?
                                                Colors.grey:row2[index2]!.champCost=='2'?
                                                Colors.green:row2[index2]!.champCost=='3'?
                                                Colors.blue:row2[index2]!.champCost=='4'?
                                                Colors.purple:row2[index2]!.champCost=='5'?
                                                Colors.yellow:Colors.red,
                                              ),
                                                      row2[index2]!.champItems.isNotEmpty?
                                                      Row(
                                                        children: List.generate(row2[index2]!.champItems.length, (index){
                                                          printLog("+++++*********=============== Items ");
                                                          // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                          return
                                                            Container(
                                                                height: height*.015,
                                                                width: height*.015,
                                                                decoration: BoxDecoration(

                                                                ),
                                                                child: Image(image: NetworkImage(row2[index2]!.champItems[index]["itemImageUrl"]))
                                                            );
                                                          //   SmallImageWidget(
                                                          //     isPolygon: true,
                                                          //     imageHeight: height*.03,
                                                          //     imageWidth: height*.03,
                                                          //     boxWidth: height*.03,
                                                          //     boxHeight: height*.03,
                                                          //     isBorder: false,
                                                          //     imageUrl: row2[index2]!.champItems[index]["itemImageUrl"]
                                                          //
                                                          // );
                                                        }),
                                                      )
                                                          :SizedBox()
                                                    ],
                                                  ):
                                              // ?  Image.network(
                                              // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                              // height: 60,
                                              // width: 60,
                                              // fit: BoxFit
                                              //     .fill):
                                              Image.asset(
                                                  'assets/images/Polygon 7.png')
                                          ))
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: height*.06),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: List.generate(7, (index3) =>
                                            SizedBox(
                                                height: height*.06,
                                                width: height*.06,
                                                child: row3[index3]!=null
                                                    ?Stack(
                                                  alignment: Alignment.bottomCenter,
                                                      children: [
                                                        SmallImageWidget(
                                                          isPolygon: true,
                                                          imageHeight: height*.06,
                                                          imageWidth: height*.06,
                                                          boxWidth: height*.06,
                                                          boxHeight: height*.06,
                                                  isBorder: true,
                                                  imageUrl: row3[index3]!.imagePath,
                                                  borderColor: row3[index3]!.champCost=='1'?
                                                  Colors.grey:row3[index3]!.champCost=='2'?
                                                  Colors.green:row3[index3]!.champCost=='3'?
                                                  Colors.blue:row3[index3]!.champCost=='4'?
                                                  Colors.purple:row3[index3]!.champCost=='5'?
                                                  Colors.yellow:Colors.red
                                                  ,

                                                ),
                                                        row3[index3]!.champItems.isNotEmpty?
                                                        Row(
                                                          children: List.generate(row3[index3]!.champItems.length, (index){
                                                            printLog("+++++*********=============== Items ");
                                                            // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                            return
                                                              Container(
                                                                  height: height*.015,
                                                                  width: height*.015,
                                                                  decoration: BoxDecoration(

                                                                  ),
                                                                  child: Image(image: NetworkImage(row3[index3]!.champItems[index]["itemImageUrl"]))
                                                              );
                                                            //   SmallImageWidget(
                                                            //     isPolygon: true,
                                                            //     imageHeight: height*.02,
                                                            //     imageWidth: height*.02,
                                                            //     boxWidth: height*.02,
                                                            //     boxHeight: height*.02,
                                                            //     isBorder: false,
                                                            //     imageUrl: row3[index3]!.champItems[index]["itemImageUrl"]
                                                            //
                                                            // );
                                                          }),
                                                        )
                                                            :const SizedBox()
                                                      ],
                                                    ):
                                                // ?  Image.network(
                                                // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                // height: 60,
                                                // width: 60,
                                                // fit: BoxFit
                                                //     .fill):
                                                Image.asset(
                                                    'assets/images/Polygon 7.png')
                                            )
                                        )
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: List.generate(7, (index4) =>
                                          SizedBox(
                                              height: height*.06,
                                              width: height*.06,
                                              child: row4[index4]!=null
                                                  ?Stack(
                                                alignment: Alignment.bottomCenter,
                                                    children: [
                                                      SmallImageWidget(
                                                        isPolygon: true,
                                                        imageHeight: height*.06,
                                                        imageWidth: height*.06,
                                                        boxWidth: height*.06,
                                                        boxHeight: height*.06,
                                                isBorder: true,
                                                imageUrl: row4[index4]!.imagePath,
                                                borderColor: row4[index4]!.champCost=='1'?
                                                Colors.grey:row4[index4]!.champCost=='2'?
                                                Colors.green:row4[index4]!.champCost=='3'?
                                                Colors.blue:row4[index4]!.champCost=='4'?
                                                Colors.purple:row4[index4]!.champCost=='5'?
                                                Colors.yellow:Colors.red
                                                ,

                                              ),
                                                      row4[index4]!.champItems.isNotEmpty?
                                                      Row(
                                                        children: List.generate(row4[index4]!.champItems.length, (index){
                                                          printLog("+++++*********=============== Items ");
                                                          // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                          return

                                                            Container(
                                                                height: height*.015,
                                                                width: height*.015,
                                                                decoration: BoxDecoration(

                                                                ),
                                                                child: Image(image: NetworkImage(row4[index4]!.champItems[index]["itemImageUrl"]))
                                                            );
                                                          //   SmallImageWidget(
                                                          //     isPolygon: true,
                                                          //     imageHeight: height*.03,
                                                          //     imageWidth: height*.03,
                                                          //     boxWidth: height*.03,
                                                          //     boxHeight: height*.03,
                                                          //     isBorder: false,
                                                          //     imageUrl: row4[index4]!.champItems[index]["itemImageUrl"]
                                                          // );
                                                        }),
                                                      )
                                                          :SizedBox()
                                                    ],
                                                  ):
                                              // ?  Image.network(
                                              // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                              // height: 60,
                                              // width: 60,
                                              // fit: BoxFit
                                              //     .fill):
                                              Image.asset(
                                                  'assets/images/Polygon 7.png')
                                          )
                                      )
                                  ),
                                  const SizedBox(height: 15.0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : ResponsiveWidget.isTabletScreen(context)?
      Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// 3 boxes
                    const SizedBox(height: 10.0),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 16.0, right: 16),
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: const[
                    //       /// early camp
                    //       Expanded(
                    //         flex: 5,
                    //         child: EarlyCampBox(),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Row(
                        children: [
                          /// trails
                          Expanded(
                            child: TraitsBox(traits: traitsMap,traitNamesList: traits,),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 16.0, right: 16),
                    //   child: Row(
                    //     children: const[
                    //       /// caroousel
                    //       Expanded(
                    //         child: CarouselBox(),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    /// 2 box
                    const SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 16.0, right: 16),
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       /// option box
                    //       Expanded(
                    //         child: Container(
                    //           width: width,
                    //           height: height * 0.35,
                    //           decoration:
                    //               threeBoxDecoration(context, isBorder: false),
                    //           child: const OptionsBox(),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// positioning box
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              width: width,
                              height: height * 0.35,
                              decoration:
                              threeBoxDecoration(context, isBorder: false),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                  const SizedBox(height: 8.0),

                                  Padding(
                                    padding: EdgeInsets.only(left: height>heightConstraint1000?height*.04:height*.06),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: List.generate(7, (index1) =>
                                            SizedBox(
                                                height: height>heightConstraint850 &&
                                                    height<heightConstraint1000?height*.05:
                                                height>heightConstraint1000&&height<heightConstraint1200?height*.04:
                                                height>heightConstraint1200&&height<heightConstraint1400?height*.03:
                                                height>heightConstraint1400?height*.02:height*.06,
                                                width: height>heightConstraint850 &&
                                                    height<heightConstraint1000?height*.05:
                                                height>heightConstraint1000&&height<heightConstraint1200?height*.04:
                                                height>heightConstraint1200&&height<heightConstraint1400?height*.03:
                                                height>heightConstraint1400?height*.02:height*.06,
                                                child: row1[index1]!=null
                                                    ?Stack(
                                                  alignment: Alignment.bottomCenter,
                                                  children: [
                                                    SmallImageWidget(
                                                      isBorder: true,
                                                      isPolygon: true,
                                                      imageHeight: height*.06,
                                                      imageWidth: height*.06,
                                                      boxWidth: height*.06,
                                                      boxHeight: height*.06,
                                                      imageUrl: row1[index1]!.imagePath,
                                                      borderColor: row1[index1]!.champCost=='1'?
                                                      Colors.grey:row1[index1]!.champCost=='2'?
                                                      Colors.green:row1[index1]!.champCost=='3'?
                                                      Colors.blue:row1[index1]!.champCost=='4'?
                                                      Colors.purple:row1[index1]!.champCost=='5'?
                                                      Colors.yellow:Colors.red
                                                      ,

                                                    ),
                                                    row1[index1]!.champItems.isNotEmpty?
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: List.generate(row1[index1]!.champItems.length, (index){
                                                        printLog("+++++*********=============== Items ");
                                                        // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                        return
                                                          Container(
                                                              height: height*.015,
                                                              width: height*.015,
                                                              decoration: BoxDecoration(

                                                              ),
                                                              child: Image(image: NetworkImage(row1[index1]!.champItems[index]["itemImageUrl"]))
                                                          );

                                                        //   SmallImageWidget(
                                                        //     isPolygon: true,
                                                        //     imageHeight: height*.03,
                                                        //     imageWidth: height*.03,
                                                        //     boxWidth: height*.03,
                                                        //     boxHeight: height*.03,
                                                        //     isBorder: false,
                                                        //     imageUrl: row1[index1]!.champItems[index]["itemImageUrl"]
                                                        //
                                                        // );
                                                      }),
                                                    )
                                                        :const SizedBox()
                                                  ],
                                                ):

                                                Image.asset(
                                                    'assets/images/Polygon 7.png')
                                            )
                                        )
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: List.generate(7, (index2) =>
                                          SizedBox(
                                              height: height>heightConstraint850 &&
                                                  height<heightConstraint1000?height*.05:
                                              height>heightConstraint1000&&height<heightConstraint1200?height*.04:
                                              height>heightConstraint1200&&height<heightConstraint1400?height*.03:
                                              height>heightConstraint1400?height*.02:height*.06,
                                              width: height>heightConstraint850 &&
                                                  height<heightConstraint1000?height*.05:
                                              height>heightConstraint1000&&height<heightConstraint1200?height*.04:
                                              height>heightConstraint1200&&height<heightConstraint1400?height*.03:
                                              height>heightConstraint1400?height*.02:height*.06,
                                              child: row2[index2]!=null
                                                  ?Stack(
                                                alignment: Alignment.bottomCenter,
                                                children: [
                                                  SmallImageWidget(
                                                    isPolygon: true,
                                                    imageHeight: height*.06,
                                                    imageWidth: height*.06,
                                                    boxWidth: height*.06,
                                                    boxHeight: height*.06,
                                                    isBorder: true,
                                                    imageUrl: row2[index2]!.imagePath,
                                                    borderColor: row2[index2]!.champCost=='1'?
                                                    Colors.grey:row2[index2]!.champCost=='2'?
                                                    Colors.green:row2[index2]!.champCost=='3'?
                                                    Colors.blue:row2[index2]!.champCost=='4'?
                                                    Colors.purple:row2[index2]!.champCost=='5'?
                                                    Colors.yellow:Colors.red,
                                                  ),
                                                  row2[index2]!.champItems.isNotEmpty?
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: List.generate(row2[index2]!.champItems.length, (index){
                                                      printLog("+++++*********=============== Items ");
                                                      // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                      return
                                                        Container(
                                                            height: height*.015,
                                                            width: height*.015,
                                                            decoration: BoxDecoration(

                                                            ),
                                                            child: Image(image: NetworkImage(row2[index2]!.champItems[index]["itemImageUrl"]))
                                                        );
                                                      //   SmallImageWidget(
                                                      //     isPolygon: true,
                                                      //     imageHeight: height*.03,
                                                      //     imageWidth: height*.03,
                                                      //     boxWidth: height*.03,
                                                      //     boxHeight: height*.03,
                                                      //     isBorder: false,
                                                      //     imageUrl: row2[index2]!.champItems[index]["itemImageUrl"]
                                                      //
                                                      // );
                                                    }),
                                                  )
                                                      :SizedBox()
                                                ],
                                              ):
                                              // ?  Image.network(
                                              // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                              // height: 60,
                                              // width: 60,
                                              // fit: BoxFit
                                              //     .fill):
                                              Image.asset(
                                                  'assets/images/Polygon 7.png')
                                          ))
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: height>heightConstraint1000?height*.04:height*.06),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: List.generate(7, (index3) =>
                                            SizedBox(
                                                height: height>heightConstraint850 &&
                                                    height<heightConstraint1000?height*.05:
                                                height>heightConstraint1000&&height<heightConstraint1200?height*.04:
                                                height>heightConstraint1200&&height<heightConstraint1400?height*.03:
                                                height>heightConstraint1400?height*.02:height*.06,
                                                width: height>heightConstraint850 &&
                                                    height<heightConstraint1000?height*.05:
                                                height>heightConstraint1000&&height<heightConstraint1200?height*.04:
                                                height>heightConstraint1200&&height<heightConstraint1400?height*.03:
                                                height>heightConstraint1400?height*.02:height*.06,
                                                child: Center(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(12),
                                                    // child
                                                    /// Here I used chosen team indexes for reference if the player exist in team
                                                    /// We will show the icon of player else will show blank polygon icon
                                                    child: row3[index3]!=null
                                                        ?Stack(
                                                      alignment: Alignment.bottomCenter,
                                                      children: [
                                                        SmallImageWidget(
                                                          isBorder: true,
                                                          isPolygon: true,
                                                          imageHeight: height*.06,
                                                          imageWidth: height*.06,
                                                          boxWidth: height*.06,
                                                          boxHeight: height*.06,
                                                          imageUrl: row3[index3]!.imagePath,
                                                          borderColor: row3[index3]!.champCost=='1'?
                                                          Colors.grey:row3[index3]!.champCost=='2'?
                                                          Colors.green:row3[index3]!.champCost=='3'?
                                                          Colors.blue:row3[index3]!.champCost=='4'?
                                                          Colors.purple:row3[index3]!.champCost=='5'?
                                                          Colors.yellow:Colors.red
                                                          ,

                                                        ),
                                                        row3[index3]!.champItems.isNotEmpty?
                                                        Row(
                                                          children: List.generate(row3[index3]!.champItems.length, (index){
                                                            printLog("+++++*********=============== Items ");
                                                            // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                            return
                                                              Container(
                                                                  height: height*.015,
                                                                  width: height*.015,
                                                                  decoration: BoxDecoration(

                                                                  ),
                                                                  child: Image(image: NetworkImage(row3[index3]!.champItems[index]["itemImageUrl"]))
                                                              );
                                                            //   SmallImageWidget(
                                                            //     isPolygon: true,
                                                            //     imageHeight: height*.03,
                                                            //     imageWidth: height*.03,
                                                            //     boxWidth: height*.03,
                                                            //     boxHeight: height*.03,
                                                            //     isBorder: false,
                                                            //     imageUrl: row3[index3]!.champItems[index]["itemImageUrl"]
                                                            //
                                                            // );
                                                          }),
                                                        )
                                                            :const SizedBox()
                                                      ],
                                                    ):
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
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: List.generate(7, (index4) =>
                                          SizedBox(
                                              height: height>heightConstraint850 &&
                                                  height<heightConstraint1000?height*.05:
                                              height>heightConstraint1000&&height<heightConstraint1200?height*.04:
                                              height>heightConstraint1200&&height<heightConstraint1400?height*.03:
                                              height>heightConstraint1400?height*.02:height*.06,
                                              width: height>heightConstraint850 &&
                                                  height<heightConstraint1000?height*.05:
                                              height>heightConstraint1000&&height<heightConstraint1200?height*.04:
                                              height>heightConstraint1200&&height<heightConstraint1400?height*.03:
                                              height>heightConstraint1400?height*.02:height*.06,
                                              child: row4[index4]!=null
                                                  ?Stack(
                                                alignment: Alignment.bottomCenter,
                                                children: [
                                                  SmallImageWidget(
                                                    isBorder: true,
                                                    isPolygon: true,
                                                    imageHeight: height*.06,
                                                    imageWidth: height*.06,
                                                    boxWidth: height*.06,
                                                    boxHeight: height*.06,
                                                    imageUrl: row4[index4]!.imagePath,
                                                    borderColor: row4[index4]!.champCost=='1'?
                                                    Colors.grey:row4[index4]!.champCost=='2'?
                                                    Colors.green:row4[index4]!.champCost=='3'?
                                                    Colors.blue:row4[index4]!.champCost=='4'?
                                                    Colors.purple:row4[index4]!.champCost=='5'?
                                                    Colors.yellow:Colors.red
                                                    ,

                                                  ),
                                                  row4[index4]!.champItems.isNotEmpty?
                                                  Row(
                                                    children: List.generate(row4[index4]!.champItems.length, (index){
                                                      printLog("+++++*********=============== Items ");
                                                      // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                                      return
                                                        Container(
                                                            height: height*.015,
                                                            width: height*.015,
                                                            decoration: BoxDecoration(

                                                            ),
                                                            child: Image(image: NetworkImage(row4[index4]!.champItems[index]["itemImageUrl"]))
                                                        );
                                                      //   SmallImageWidget(
                                                      //     isPolygon: true,
                                                      //     imageHeight: height*.03,
                                                      //     imageWidth: height*.03,
                                                      //     boxWidth: height*.03,
                                                      //     boxHeight: height*.03,
                                                      //     isBorder: false,
                                                      //     imageUrl: row4[index4]!.champItems[index]["itemImageUrl"]
                                                      // );
                                                    }),
                                                  )
                                                      :SizedBox()
                                                ],
                                              ):
                                              // ?  Image.network(
                                              // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                              // height: 60,
                                              // width: 60,
                                              // fit: BoxFit
                                              //     .fill):
                                              Image.asset(
                                                  'assets/images/Polygon 7.png')
                                          )
                                      )
                                  ),
                                  const SizedBox(height: 10.0),
                                ],
                              ),
                            ),
                          ),
                          // Expanded(
                          //   child: Container(
                          //     width: width,
                          //     height: height * 0.4,
                          //     decoration:
                          //         threeBoxDecoration(context, isBorder: false),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         /// options text
                          //         const SizedBox(height: 16.0),
                          //         Text(
                          //           'Positioning',
                          //           style: GoogleFonts.poppins(
                          //             fontSize: 16.0,
                          //             color: AppColors.whiteColor,
                          //             fontWeight: FontWeight.w600,
                          //           ),
                          //         ),
                          //
                          //         ///
                          //         const SizedBox(height: 10.0),
                          //
                          //         SizedBox(
                          //           width: width,
                          //           height: height * 0.3,
                          //           child: Padding(
                          //             padding:
                          //             ResponsiveWidget.isMobileScreen(context)
                          //                 ? EdgeInsets.symmetric(
                          //                 horizontal:
                          //                 width * 0.08)
                          //                 : ResponsiveWidget.isTabletScreen(
                          //                 context)
                          //                 ? EdgeInsets.symmetric(
                          //                 horizontal:
                          //                 height * 0.16)
                          //                 : EdgeInsets.symmetric(
                          //                 horizontal:
                          //                 height * 0.1),
                          //             child: Stack(
                          //               alignment: Alignment.topCenter,
                          //               children: [
                          //                 Row(
                          //                   mainAxisAlignment: MainAxisAlignment.center,
                          //                     children: List.generate(7, (index1) =>
                          //                         SizedBox(
                          //                             height: 30,
                          //                             width: 30,
                          //                             child: Center(
                          //                               child: ClipRRect(
                          //                                 borderRadius:
                          //                                 BorderRadius
                          //                                     .circular(12),
                          //                                 // child
                          //                                 /// Here I used chosen team indexes for reference if the player exist in team
                          //                                 /// We will show the icon of player else will show blank polygon icon
                          //                                 child: row1[index1]!=null
                          //                                     ?SmallImageWidget(
                          //                                   isBorder: true,
                          //                                   imageUrl: provider.apiImageUrl + row1[index1]!.imagePath,
                          //                                   borderColor: row1[index1]!.champCost=='1'?
                          //                                   Colors.grey:row1[index1]!.champCost=='2'?
                          //                                   Colors.green:row1[index1]!.champCost=='3'?
                          //                                   Colors.blue:row1[index1]!.champCost=='4'?
                          //                                   Colors.purple:row1[index1]!.champCost=='5'?
                          //                                   Colors.yellow:Colors.red
                          //                                   ,
                          //
                          //                                 ):
                          //                                 // ?  Image.network(
                          //                                 // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                          //                                 // height: 60,
                          //                                 // width: 60,
                          //                                 // fit: BoxFit
                          //                                 //     .fill):
                          //                                 Image.asset(
                          //                                     'assets/images/Polygon 7.png')
                          //
                          //                                 ,
                          //                               ),
                          //                             )
                          //                         )
                          //                     )
                          //                 ),
                          //                 Padding(
                          //                   padding: const EdgeInsets.only(top: 30.0,left: 30),
                          //                   child: Row(
                          //                       mainAxisAlignment: MainAxisAlignment.center,
                          //                       children: List.generate(7, (index2) =>
                          //                           SizedBox(
                          //                               height: 30,
                          //                               width: 30,
                          //                               child: Center(
                          //                                 child: ClipRRect(
                          //                                   borderRadius:
                          //                                   BorderRadius
                          //                                       .circular(12),
                          //                                   // child
                          //                                   /// Here I used chosen team indexes for reference if the player exist in team
                          //                                   /// We will show the icon of player else will show blank polygon icon
                          //                                   child: row2[index2]!=null
                          //                                       ?SmallImageWidget(
                          //                                     isBorder: true,
                          //                                     imageUrl: provider.apiImageUrl + row2[index2]!.imagePath,
                          //                                     borderColor: row2[index2]!.champCost=='1'?
                          //                                     Colors.grey:row2[index2]!.champCost=='2'?
                          //                                     Colors.green:row2[index2]!.champCost=='3'?
                          //                                     Colors.blue:row2[index2]!.champCost=='4'?
                          //                                     Colors.purple:row2[index2]!.champCost=='5'?
                          //                                     Colors.yellow:Colors.red
                          //                                     ,
                          //
                          //                                   ):
                          //                                   // ?  Image.network(
                          //                                   // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                          //                                   // height: 60,
                          //                                   // width: 60,
                          //                                   // fit: BoxFit
                          //                                   //     .fill):
                          //                                   Image.asset(
                          //                                       'assets/images/Polygon 7.png')
                          //
                          //                                   ,
                          //                                 ),
                          //                               )
                          //                           ))
                          //                   ),
                          //                 ),
                          //                 Padding(
                          //                   padding: const EdgeInsets.only(top: 60.0),
                          //                   child: Row(
                          //                       mainAxisAlignment: MainAxisAlignment.center,
                          //                       children: List.generate(7, (index3) =>
                          //                           SizedBox(
                          //                               height: 30,
                          //                               width: 30,
                          //                               child: Center(
                          //                                 child: ClipRRect(
                          //                                   borderRadius:
                          //                                   BorderRadius
                          //                                       .circular(12),
                          //                                   // child
                          //                                   /// Here I used chosen team indexes for reference if the player exist in team
                          //                                   /// We will show the icon of player else will show blank polygon icon
                          //                                   child: row3[index3]!=null
                          //                                       ?SmallImageWidget(
                          //                                     isBorder: true,
                          //                                     imageUrl: provider.apiImageUrl + row3[index3]!.imagePath,
                          //                                     borderColor: row3[index3]!.champCost=='1'?
                          //                                     Colors.grey:row3[index3]!.champCost=='2'?
                          //                                     Colors.green:row3[index3]!.champCost=='3'?
                          //                                     Colors.blue:row3[index3]!.champCost=='4'?
                          //                                     Colors.purple:row3[index3]!.champCost=='5'?
                          //                                     Colors.yellow:Colors.red
                          //                                     ,
                          //
                          //                                   ):
                          //                                   // ?  Image.network(
                          //                                   // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                          //                                   // height: 60,
                          //                                   // width: 60,
                          //                                   // fit: BoxFit
                          //                                   //     .fill):
                          //                                   Image.asset(
                          //                                       'assets/images/Polygon 7.png')
                          //
                          //                                   ,
                          //                                 ),
                          //                               )
                          //                           )
                          //                       )
                          //                   ),
                          //                 ),
                          //                 Padding(
                          //                   padding: const EdgeInsets.only(top: 90.0,left: 30),
                          //                   child: Row(
                          //                       mainAxisAlignment: MainAxisAlignment.center,
                          //                       children: List.generate(7, (index4) =>
                          //                           SizedBox(
                          //                               height: 30,
                          //                               width: 30,
                          //                               child: Center(
                          //                                 child: ClipRRect(
                          //                                   borderRadius:
                          //                                   BorderRadius
                          //                                       .circular(12),
                          //                                   // child
                          //                                   /// Here I used chosen team indexes for reference if the player exist in team
                          //                                   /// We will show the icon of player else will show blank polygon icon
                          //                                   child: row4[index4]!=null
                          //                                       ?SmallImageWidget(
                          //                                     isBorder: true,
                          //                                     imageUrl: provider.apiImageUrl + row4[index4]!.imagePath,
                          //                                     borderColor: row4[index4]!.champCost=='1'?
                          //                                     Colors.grey:row4[index4]!.champCost=='2'?
                          //                                     Colors.green:row4[index4]!.champCost=='3'?
                          //                                     Colors.blue:row4[index4]!.champCost=='4'?
                          //                                     Colors.purple:row4[index4]!.champCost=='5'?
                          //                                     Colors.yellow:Colors.red
                          //                                     ,
                          //
                          //                                   ):
                          //                                   // ?  Image.network(
                          //                                   // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                          //                                   // height: 60,
                          //                                   // width: 60,
                          //                                   // fit: BoxFit
                          //                                   //     .fill):
                          //                                   Image.asset(
                          //                                       'assets/images/Polygon 7.png')
                          //
                          //                                   ,
                          //                                 ),
                          //                               )
                          //                           )
                          //                       )
                          //                   ),
                          //                 ),
                          //
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ):

      ///
      /// Mobile Layout
      ///
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// 3 boxes
          const SizedBox(height: 10.0),
          // Padding(
          //   padding: const EdgeInsets.only(left: 16.0, right: 16),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: const[
          //       /// early camp
          //       Expanded(
          //         flex: 5,
          //         child: EarlyCampBox(),
          //       ),
          //     ],
          //   ),
          // ),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Row(
              children: [
                /// trails
                Expanded(
                  child: TraitsBox(traits: traitsMap,traitNamesList: traits,),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          // Padding(
          //   padding: const EdgeInsets.only(left: 16.0, right: 16),
          //   child: Row(
          //     children: const[
          //       /// caroousel
          //       Expanded(
          //         child: CarouselBox(),
          //       ),
          //     ],
          //   ),
          // ),

          /// 2 box
          const SizedBox(height: 10),
          // Padding(
          //   padding: const EdgeInsets.only(left: 16.0, right: 16),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       /// option box
          //       Expanded(
          //         child: Container(
          //           width: width,
          //           // height: height * 0.35,
          //           decoration:
          //           threeBoxDecoration(context, isBorder: false),
          //           child: const OptionsBox(),
          //         ),
          //
          //       ),
          //     ],
          //   ),
          // ),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// positioning box
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    width: width,
                    height: height * 0.35,
                    decoration:
                    threeBoxDecoration(context, isBorder: false),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        const SizedBox(height: 8.0),

                        Padding(
                          padding: EdgeInsets.only(left: height*.037),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(7, (index1) =>
                                  SizedBox(
                                      height: height*.045,
                                      width: height*.045,
                                      child: row1[index1]!=null
                                          ?Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          SmallImageWidget(
                                            isBorder: true,
                                            isPolygon: true,
                                            imageHeight: height*.045,
                                            imageWidth: height*.045,
                                            boxWidth: height*.045,
                                            boxHeight: height*.045,
                                            imageUrl: row1[index1]!.imagePath,
                                            borderColor: row1[index1]!.champCost=='1'?
                                            Colors.grey:row1[index1]!.champCost=='2'?
                                            Colors.green:row1[index1]!.champCost=='3'?
                                            Colors.blue:row1[index1]!.champCost=='4'?
                                            Colors.purple:row1[index1]!.champCost=='5'?
                                            Colors.yellow:Colors.red
                                            ,

                                          ),
                                          row1[index1]!.champItems.isNotEmpty?
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: List.generate(row1[index1]!.champItems.length, (index){
                                              printLog("+++++*********=============== Items ");
                                              // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                              return
                                                Container(
                                                    height: height*.015,
                                                    width: height*.015,
                                                    decoration: BoxDecoration(

                                                    ),
                                                    child: Image(image: NetworkImage(row1[index1]!.champItems[index]["itemImageUrl"]))
                                                );
                                              //   SmallImageWidget(
                                              //     // isPolygon: true,
                                              //     imageHeight: height*.015,
                                              //     imageWidth: height*.015,
                                              //     boxWidth: height*.015,
                                              //     boxHeight: height*.015,
                                              //     isBorder: false,
                                              //     imageUrl: row1[index1]!.champItems[index]["itemImageUrl"]
                                              //
                                              // );
                                            }),
                                          )
                                              :const SizedBox()
                                        ],
                                      ):

                                      Image.asset(
                                          'assets/images/Polygon 7.png')
                                  )
                              )
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(7, (index2) =>
                                SizedBox(
                                    height: height*.045,
                                    width: height*.045,
                                    child: row2[index2]!=null
                                        ?Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        SmallImageWidget(
                                          isPolygon: true,
                                          imageHeight: height*.045,
                                          imageWidth: height*.045,
                                          boxWidth: height*.045,
                                          boxHeight: height*.045,
                                          isBorder: true,
                                          imageUrl: row2[index2]!.imagePath,
                                          borderColor: row2[index2]!.champCost=='1'?
                                          Colors.grey:row2[index2]!.champCost=='2'?
                                          Colors.green:row2[index2]!.champCost=='3'?
                                          Colors.blue:row2[index2]!.champCost=='4'?
                                          Colors.purple:row2[index2]!.champCost=='5'?
                                          Colors.yellow:Colors.red,
                                        ),
                                        row2[index2]!.champItems.isNotEmpty?
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(row2[index2]!.champItems.length, (index){
                                            printLog("+++++*********=============== Items ");
                                            // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                            return
                                              Container(
                                                  height: height*.015,
                                                  width: height*.015,
                                                  decoration: BoxDecoration(

                                                  ),
                                                  child: Image(image: NetworkImage(row2[index2]!.champItems[index]["itemImageUrl"]))
                                              );
                                            //   SmallImageWidget(
                                            //     imageHeight: height*.015,
                                            //     imageWidth: height*.015,
                                            //     boxWidth: height*.015,
                                            //     boxHeight: height*.015,
                                            //     isBorder: false,
                                            //     imageUrl: row2[index2]!.champItems[index]["itemImageUrl"]
                                            //
                                            // );
                                          }),
                                        )
                                            :SizedBox()
                                      ],
                                    ):
                                    // ?  Image.network(
                                    // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                    // height: 60,
                                    // width: 60,
                                    // fit: BoxFit
                                    //     .fill):
                                    Image.asset(
                                        'assets/images/Polygon 7.png')
                                ))
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: height*.037),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(7, (index3) =>
                                  SizedBox(
                                      height: height*.045,
                                      width: height*.045,
                                      child: row3[index3]!=null
                                          ?Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          SmallImageWidget(
                                            isBorder: true,
                                            isPolygon: true,
                                            imageHeight: height*.045,
                                            imageWidth: height*.045,
                                            boxWidth: height*.045,
                                            boxHeight: height*.045,
                                            imageUrl: row3[index3]!.imagePath,
                                            borderColor: row3[index3]!.champCost=='1'?
                                            Colors.grey:row3[index3]!.champCost=='2'?
                                            Colors.green:row3[index3]!.champCost=='3'?
                                            Colors.blue:row3[index3]!.champCost=='4'?
                                            Colors.purple:row3[index3]!.champCost=='5'?
                                            Colors.yellow:Colors.red
                                            ,

                                          ),
                                          row3[index3]!.champItems.isNotEmpty?
                                          Row(
                                            children: List.generate(row3[index3]!.champItems.length, (index){
                                              printLog("+++++*********=============== Items ");
                                              // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                              return
                                                Container(
                                                    height: height*.015,
                                                    width: height*.015,
                                                    decoration: BoxDecoration(

                                                    ),
                                                    child: Image(image: NetworkImage(row3[index3]!.champItems[index]["itemImageUrl"]))
                                                );
                                              //   SmallImageWidget(
                                              //     imageHeight: height*.015,
                                              //     imageWidth: height*.015,
                                              //     boxWidth: height*.015,
                                              //     boxHeight: height*.015,
                                              //     isBorder: false,
                                              //     imageUrl: row3[index3]!.champItems[index]["itemImageUrl"]
                                              //
                                              // );
                                            }),
                                          )
                                              :const SizedBox()
                                        ],
                                      ):
                                      // ?  Image.network(
                                      // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                      // height: 60,
                                      // width: 60,
                                      // fit: BoxFit
                                      //     .fill):
                                      Image.asset(
                                          'assets/images/Polygon 7.png')
                                  )
                              )
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(7, (index4) =>
                                SizedBox(
                                    height: height*.045,
                                    width: height*.045,
                                    child: row4[index4]!=null
                                        ?Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        SmallImageWidget(
                                          isBorder: true,
                                          isPolygon: true,
                                          imageHeight: height*.045,
                                          imageWidth: height*.045,
                                          boxWidth: height*.045,
                                          boxHeight: height*.045,
                                          imageUrl: row4[index4]!.imagePath,
                                          borderColor: row4[index4]!.champCost=='1'?
                                          Colors.grey:row4[index4]!.champCost=='2'?
                                          Colors.green:row4[index4]!.champCost=='3'?
                                          Colors.blue:row4[index4]!.champCost=='4'?
                                          Colors.purple:row4[index4]!.champCost=='5'?
                                          Colors.yellow:Colors.red
                                          ,

                                        ),
                                        row4[index4]!.champItems.isNotEmpty?
                                        Row(
                                          children: List.generate(row4[index4]!.champItems.length, (index){
                                            printLog("+++++*********=============== Items ");
                                            // return Image.network(champItems![champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);

                                            return
                                              Container(
                                                  height: height*.015,
                                                  width: height*.015,
                                                  decoration: BoxDecoration(

                                                  ),
                                                  child: Image(image: NetworkImage(row4[index4]!.champItems[index]["itemImageUrl"]))
                                              );

                                            //   SmallImageWidget(
                                            //     imageHeight: height*.015,
                                            //     imageWidth: height*.015,
                                            //     boxWidth: height*.015,
                                            //     boxHeight: height*.015,
                                            //     isBorder: false,
                                            //     imageUrl: row4[index4]!.champItems[index]["itemImageUrl"]
                                            // );
                                          }),
                                        )
                                            :SizedBox()
                                      ],
                                    ):
                                    // ?  Image.network(
                                    // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                    // height: 60,
                                    // width: 60,
                                    // fit: BoxFit
                                    //     .fill):
                                    Image.asset(
                                        'assets/images/Polygon 7.png')
                                )
                            )
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
                // Expanded(
                //   child: Container(
                //     width: width,
                //     height: height * 0.4,
                //     decoration:
                //         threeBoxDecoration(context, isBorder: false),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         /// options text
                //         const SizedBox(height: 16.0),
                //         Text(
                //           'Positioning',
                //           style: GoogleFonts.poppins(
                //             fontSize: 16.0,
                //             color: AppColors.whiteColor,
                //             fontWeight: FontWeight.w600,
                //           ),
                //         ),
                //
                //         ///
                //         const SizedBox(height: 10.0),
                //
                //         SizedBox(
                //           width: width,
                //           height: height * 0.3,
                //           child: Padding(
                //             padding:
                //             ResponsiveWidget.isMobileScreen(context)
                //                 ? EdgeInsets.symmetric(
                //                 horizontal:
                //                 width * 0.08)
                //                 : ResponsiveWidget.isTabletScreen(
                //                 context)
                //                 ? EdgeInsets.symmetric(
                //                 horizontal:
                //                 height * 0.16)
                //                 : EdgeInsets.symmetric(
                //                 horizontal:
                //                 height * 0.1),
                //             child: Stack(
                //               alignment: Alignment.topCenter,
                //               children: [
                //                 Row(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                     children: List.generate(7, (index1) =>
                //                         SizedBox(
                //                             height: 30,
                //                             width: 30,
                //                             child: Center(
                //                               child: ClipRRect(
                //                                 borderRadius:
                //                                 BorderRadius
                //                                     .circular(12),
                //                                 // child
                //                                 /// Here I used chosen team indexes for reference if the player exist in team
                //                                 /// We will show the icon of player else will show blank polygon icon
                //                                 child: row1[index1]!=null
                //                                     ?SmallImageWidget(
                //                                   isBorder: true,
                //                                   imageUrl: provider.apiImageUrl + row1[index1]!.imagePath,
                //                                   borderColor: row1[index1]!.champCost=='1'?
                //                                   Colors.grey:row1[index1]!.champCost=='2'?
                //                                   Colors.green:row1[index1]!.champCost=='3'?
                //                                   Colors.blue:row1[index1]!.champCost=='4'?
                //                                   Colors.purple:row1[index1]!.champCost=='5'?
                //                                   Colors.yellow:Colors.red
                //                                   ,
                //
                //                                 ):
                //                                 // ?  Image.network(
                //                                 // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                //                                 // height: 60,
                //                                 // width: 60,
                //                                 // fit: BoxFit
                //                                 //     .fill):
                //                                 Image.asset(
                //                                     'assets/images/Polygon 7.png')
                //
                //                                 ,
                //                               ),
                //                             )
                //                         )
                //                     )
                //                 ),
                //                 Padding(
                //                   padding: const EdgeInsets.only(top: 30.0,left: 30),
                //                   child: Row(
                //                       mainAxisAlignment: MainAxisAlignment.center,
                //                       children: List.generate(7, (index2) =>
                //                           SizedBox(
                //                               height: 30,
                //                               width: 30,
                //                               child: Center(
                //                                 child: ClipRRect(
                //                                   borderRadius:
                //                                   BorderRadius
                //                                       .circular(12),
                //                                   // child
                //                                   /// Here I used chosen team indexes for reference if the player exist in team
                //                                   /// We will show the icon of player else will show blank polygon icon
                //                                   child: row2[index2]!=null
                //                                       ?SmallImageWidget(
                //                                     isBorder: true,
                //                                     imageUrl: provider.apiImageUrl + row2[index2]!.imagePath,
                //                                     borderColor: row2[index2]!.champCost=='1'?
                //                                     Colors.grey:row2[index2]!.champCost=='2'?
                //                                     Colors.green:row2[index2]!.champCost=='3'?
                //                                     Colors.blue:row2[index2]!.champCost=='4'?
                //                                     Colors.purple:row2[index2]!.champCost=='5'?
                //                                     Colors.yellow:Colors.red
                //                                     ,
                //
                //                                   ):
                //                                   // ?  Image.network(
                //                                   // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                //                                   // height: 60,
                //                                   // width: 60,
                //                                   // fit: BoxFit
                //                                   //     .fill):
                //                                   Image.asset(
                //                                       'assets/images/Polygon 7.png')
                //
                //                                   ,
                //                                 ),
                //                               )
                //                           ))
                //                   ),
                //                 ),
                //                 Padding(
                //                   padding: const EdgeInsets.only(top: 60.0),
                //                   child: Row(
                //                       mainAxisAlignment: MainAxisAlignment.center,
                //                       children: List.generate(7, (index3) =>
                //                           SizedBox(
                //                               height: 30,
                //                               width: 30,
                //                               child: Center(
                //                                 child: ClipRRect(
                //                                   borderRadius:
                //                                   BorderRadius
                //                                       .circular(12),
                //                                   // child
                //                                   /// Here I used chosen team indexes for reference if the player exist in team
                //                                   /// We will show the icon of player else will show blank polygon icon
                //                                   child: row3[index3]!=null
                //                                       ?SmallImageWidget(
                //                                     isBorder: true,
                //                                     imageUrl: provider.apiImageUrl + row3[index3]!.imagePath,
                //                                     borderColor: row3[index3]!.champCost=='1'?
                //                                     Colors.grey:row3[index3]!.champCost=='2'?
                //                                     Colors.green:row3[index3]!.champCost=='3'?
                //                                     Colors.blue:row3[index3]!.champCost=='4'?
                //                                     Colors.purple:row3[index3]!.champCost=='5'?
                //                                     Colors.yellow:Colors.red
                //                                     ,
                //
                //                                   ):
                //                                   // ?  Image.network(
                //                                   // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                //                                   // height: 60,
                //                                   // width: 60,
                //                                   // fit: BoxFit
                //                                   //     .fill):
                //                                   Image.asset(
                //                                       'assets/images/Polygon 7.png')
                //
                //                                   ,
                //                                 ),
                //                               )
                //                           )
                //                       )
                //                   ),
                //                 ),
                //                 Padding(
                //                   padding: const EdgeInsets.only(top: 90.0,left: 30),
                //                   child: Row(
                //                       mainAxisAlignment: MainAxisAlignment.center,
                //                       children: List.generate(7, (index4) =>
                //                           SizedBox(
                //                               height: 30,
                //                               width: 30,
                //                               child: Center(
                //                                 child: ClipRRect(
                //                                   borderRadius:
                //                                   BorderRadius
                //                                       .circular(12),
                //                                   // child
                //                                   /// Here I used chosen team indexes for reference if the player exist in team
                //                                   /// We will show the icon of player else will show blank polygon icon
                //                                   child: row4[index4]!=null
                //                                       ?SmallImageWidget(
                //                                     isBorder: true,
                //                                     imageUrl: provider.apiImageUrl + row4[index4]!.imagePath,
                //                                     borderColor: row4[index4]!.champCost=='1'?
                //                                     Colors.grey:row4[index4]!.champCost=='2'?
                //                                     Colors.green:row4[index4]!.champCost=='3'?
                //                                     Colors.blue:row4[index4]!.champCost=='4'?
                //                                     Colors.purple:row4[index4]!.champCost=='5'?
                //                                     Colors.yellow:Colors.red
                //                                     ,
                //
                //                                   ):
                //                                   // ?  Image.network(
                //                                   // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                //                                   // height: 60,
                //                                   // width: 60,
                //                                   // fit: BoxFit
                //                                   //     .fill):
                //                                   Image.asset(
                //                                       'assets/images/Polygon 7.png')
                //
                //                                   ,
                //                                 ),
                //                               )
                //                           )
                //                       )
                //                   ),
                //                 ),
                //
                //               ],
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildHexagon(Size size) {
  //   var w = height * 0.055;
  //   var h = height * 0.055;
  //   return Hexagonpointy(
  //     width: w,
  //     height: h,
  //     child: AspectRatio(
  //       aspectRatio: HexagonType.POINTY.ratio,
  //       child: Image.asset(
  //         AppImages.userImage,
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //   );
  // }
}
