import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/widgets/responsive_widget.dart';
import 'package:provider/provider.dart';

import '../../../constants/exports.dart';
import '../../../providers/basic_provider.dart';
import '../../../providers/search_provider.dart';
import '../../../widgets/small_image_widget.dart';
import '../Admin/Model/api_data_model.dart';

class PinnedHeadingWidget extends StatefulWidget {
  final Widget icon;
  final bool isExpand;
  final String compId;
  List<ChampModel> champList=[];
  // String? docId;
  PinnedHeadingWidget({
    Key? key,
    // this.docId,
    required this.compId,
    required this.icon,
    required this.isExpand,
    required this.champList
  }) : super(key: key);

  @override
  State<PinnedHeadingWidget> createState() => _PinnedHeadingWidgetState();
}

class _PinnedHeadingWidgetState extends State<PinnedHeadingWidget> {
  String baseUrl = 'https://raw.communitydragon.org/latest/game/';
  ///
  ///         16-May-2023
  /// Image path changed
  ///
  String apiImageUrl =  'https://raw.communitydragon.org/pbe/plugins/rcp-be-lol-game-data/global/default/assets/characters/';

  setChampList(){
    champList=widget.champList;
    dataFetched=true;
    setState(() {

    });
  }

  List<ChampModel> champ=[];
  List compCollectionList=[];
  // List<String> docIds=[];
  bool dataFetched=false;

  List<ChampModel> champList = [];

  List<String> traits=[];
  bool traitsFiltered=false;

  final Map traitsMap={};
  // List mapKeys=[];
  // List mapValues=[];

  filterTraits(){
    for(int i=0;i<widget.champList.length;i++){

      for(int j=0;j<widget.champList[i].champTraits.length;j++){
        traits.add(widget.champList[i].champTraits[j]);
        print(widget.champList[i].champTraits[j]);
      }
    }


    traits.map((e) =>
    traitsMap.containsKey(e)?traitsMap[e]++:traitsMap[e]=1).toList();
    // print("Traits Length:${traits.length}");
    // print("Traits map Length:${traitsMap.length}");
    // print(traitsMap);
    traitsFiltered==true;

    setState(() {

    });

  }



  @override
  void initState() {
    super.initState();
    widget.champList.sort((a,b)=>a.champName.compareTo(b.champName));
    // fetchFirestoreData();
    // champList=widget.champList;
    // setChampList();
    filterTraits();
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 3),(){
      // fetchImageData();
    });
    print("Init called");

  }


  bool isLoading=false;

  @override
  Widget build(BuildContext context) {
    // champList=widget.champList;
    return ResponsiveWidget.isWebScreen(context)
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
                  top: 7.0, bottom: 8.0, left: 15.0, right: 20),
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

                  /// image with stars
                  Expanded(
                    flex: 6,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if(widget.champList.length>=8)
                          for (int i = 0; i < 8 ; i++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SmallImageWidget(
                                  imageHeight: 30,
                                  imageWidth: 30,
                                  // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                  ///
                                  ///  16-May-2023
                                  /// Fetching new image path
                                  ///
                                  ///
                                  imageUrl: "${widget.champList[i].imagePath}",
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
                                  borderColor: widget.champList[i].champCost=='1'?
                                  Colors.grey:widget.champList[i].champCost=='2'?
                                  Colors.green:widget.champList[i].champCost=='3'?
                                  Colors.blue:widget.champList[i].champCost=='4'?
                                  Colors.purple:widget.champList[i].champCost=='5'?
                                  Colors.yellow:Colors.red
                                  ,
                                  shadowColor: widget.champList[i].champCost=='1'?
                                  const Color(0x609E9E9E):widget.champList[i].champCost=='2'?
                                  const Color(0x604CAF50):widget.champList[i].champCost=='3'?
                                  const Color(0x602196F3):widget.champList[i].champCost=='4'?
                                  const Color(0x609C27B0):widget.champList[i].champCost=='5'?
                                  const Color(0x60FFEB3B):const Color(0x60F44336),
                                  isBorder: true ,
                                  isShadow:  true ,
                                ),
                                Text(widget.champList[i].champName,textAlign:TextAlign.center,style: TextStyle(color: Colors.white),)
                              ],
                            ),
                        if(widget.champList.length<9)
                          for (int i = 0; i < widget.champList.length ; i++)
                            Padding(
                              // Provider.of<BasicProvider>(context).isVisibleDataFromFirebase?Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                // child: dataFetched?
                                child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SmallImageWidget(
                                      imageHeight: 30,
                                      imageWidth: 30,
                                      // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                      ///
                                      ///  16-May-2023
                                      /// Fetching new image path
                                      ///
                                      ///
                                      imageUrl: widget.champList[i].imagePath,
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
                                      borderColor: widget.champList[i].champCost=='1'?
                                      Colors.grey:widget.champList[i].champCost=='2'?
                                      Colors.green:widget.champList[i].champCost=='3'?
                                      Colors.blue:widget.champList[i].champCost=='4'?
                                      Colors.purple:widget.champList[i].champCost=='5'?
                                      Colors.yellow:Colors.red
                                      ,
                                      shadowColor: widget.champList[i].champCost=='1'?
                                      const Color(0x609E9E9E):widget.champList[i].champCost=='2'?
                                      const Color(0x604CAF50):widget.champList[i].champCost=='3'?
                                      const Color(0x602196F3):widget.champList[i].champCost=='4'?
                                      const Color(0x609C27B0):widget.champList[i].champCost=='5'?
                                      const Color(0x60FFEB3B):const Color(0x60F44336),
                                      isBorder: true ,
                                      isShadow:  true ,
                                    ),
                                    Text(widget.champList[i].champName,textAlign:TextAlign.center,style: TextStyle(color: Colors.white),)
                                  ],
                                )

                            ),
                      ],
                    ),
                  ),

                  /// arrow down icon
                  const Icon(Icons.arrow_drop_down,color: Colors.white,size: 30,)
                  // widget.icon,
                ],
              ),
            ),
          ),

          const SizedBox(width: 14),

          /// pin icon
          InkWell(
            onTap: ()async{
              setState(() {
                isLoading=true;
              });
              var check=await FirebaseFirestore.instance.collection(pinnedCompCollection).doc(widget.compId).get();
              if(check.exists){
                await FirebaseFirestore.instance.collection(pinnedCompCollection).doc(widget.compId).delete();
              }else{
                await FirebaseFirestore.instance.collection(pinnedCompCollection).doc(widget.compId).set(
                    {'compId':widget.compId});
              }
              setState(() {
                isLoading=false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: isLoading?const Center(child: SizedBox(height:20,width:20,child: CircularProgressIndicator())):SvgPicture.asset(AppIcons.pin, height: 20),
            ),
          ),
        ],
      ),
    )
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        height: 60,
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
        child: width(context)>=700?Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            /// image
            const SmallImageWidget(imageUrl: '',imageHeight: 30,imageWidth: 30,),
            // const SizedBox(width: 5),

            /// name and desc
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Veronica King V'.length>8?'Veronica King V'.substring(0,8):'Veronica King V',
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
                    color: AppColors.whiteColor.withOpacity(0.4),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            /// image with stars

            SizedBox(
              width: width(context)*.35,
              child: ListView.builder(
                // padding: EdgeInsets.zero,
                // itemExtent: 33,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.champList.length>=4?4:widget.champList.length,
                  itemBuilder: (context,i)
                  {
                    return SmallImageWidget(
                      // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                      ///
                      ///  16-May-2023
                      /// Fetching new image path
                      ///
                      ///
                      imageUrl: "${widget.champList[i].imagePath}",
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
                      borderColor: widget.champList[i].champCost=='1'?
                      Colors.grey:widget.champList[i].champCost=='2'?
                      Colors.green:widget.champList[i].champCost=='3'?
                      Colors.blue:widget.champList[i].champCost=='4'?
                      Colors.purple:widget.champList[i].champCost=='5'?
                      Colors.yellow:Colors.red
                      ,
                      shadowColor: widget.champList[i].champCost=='1'?
                      const Color(0x609E9E9E):widget.champList[i].champCost=='2'?
                      const Color(0x604CAF50):widget.champList[i].champCost=='3'?
                      const Color(0x602196F3):widget.champList[i].champCost=='4'?
                      const Color(0x609C27B0):widget.champList[i].champCost=='5'?
                      const Color(0x60FFEB3B):const Color(0x60F44336),
                      imageHeight: 30,
                      imageWidth: 30,
                      isBorder: true ,
                      isShadow:  true ,
                      // isStar: i == 2 || i == 3 ? true : false,
                    );
                  }),
            ),

            /// arrow down icon
            const Icon(Icons.arrow_drop_down,color: Colors.white,size: 30,)
            // widget.icon,
          ],
        ):
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            /// image
            const SmallImageWidget(imageUrl: '',imageHeight: 30,imageWidth: 30,),
            // const SizedBox(width: 5),

            /// name and desc
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Veronica King V'.length>8?'Veronica King V'.substring(0,8):'Veronica King V',
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
                    color: AppColors.whiteColor.withOpacity(0.4),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            /// image with stars

            SizedBox(
              width: width(context)>320&&width(context)<700?
              width(context)*.32:width(context)<320?width(context)*.25:
              width(context)>700?width(context)*.4:null,
              child: ListView.builder(
                // padding: EdgeInsets.zero,
                  itemExtent: width(context)<372?width(context)*.1:null,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.champList.length>=3?3:widget.champList.length,
                  itemBuilder: (context,i)
                  {
                    return SmallImageWidget(
                      // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                      ///
                      ///  16-May-2023
                      /// Fetching new image path
                      ///
                      ///
                      imageUrl: "${widget.champList[i].imagePath}",
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
                      borderColor: widget.champList[i].champCost=='1'?
                      Colors.grey:widget.champList[i].champCost=='2'?
                      Colors.green:widget.champList[i].champCost=='3'?
                      Colors.blue:widget.champList[i].champCost=='4'?
                      Colors.purple:widget.champList[i].champCost=='5'?
                      Colors.yellow:Colors.red
                      ,
                      shadowColor: widget.champList[i].champCost=='1'?
                      const Color(0x609E9E9E):widget.champList[i].champCost=='2'?
                      const Color(0x604CAF50):widget.champList[i].champCost=='3'?
                      const Color(0x602196F3):widget.champList[i].champCost=='4'?
                      const Color(0x609C27B0):widget.champList[i].champCost=='5'?
                      const Color(0x60FFEB3B):const Color(0x60F44336),
                      imageHeight: 30,
                      imageWidth: 30,
                      isBorder: true ,
                      isShadow:  true ,
                      // isStar: i == 2 || i == 3 ? true : false,
                    );
                  }),
            ),

            /// arrow down icon
            const Icon(Icons.arrow_drop_down,color: Colors.white,size: 30,)
            // widget.icon,
          ],
        ),
      ),
    );
  }
}
