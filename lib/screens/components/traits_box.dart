import 'package:flutter/material.dart';
import '../../widgets/responsive_widget.dart';
import '/screens/components/trails_item_widget.dart';

import '../../constants/exports.dart';

class TraitsBox extends StatefulWidget {
  Map<dynamic,dynamic> traits;
  List<String> traitNamesList;
  TraitsBox({required this.traits,required this.traitNamesList,Key? key}) : super(key: key);

  @override
  State<TraitsBox> createState() => _TraitsBoxState();
}

class _TraitsBoxState extends State<TraitsBox> {

  List mapKeys=[];
  List mapValues=[];

  convertMapToLists(){

    for (int i=0;i< widget.traits.length;i++) {


      mapKeys.add(widget.traits.keys);



    }
    for (var element in widget.traits.keys) {
      mapKeys.add(element);

    }

  }
  @override
  void initState() {
    convertMapToLists();

    // TODO: implement initState
    super.initState();
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
          Text('Traits',
            style: GoogleFonts.poppins(
              fontSize: 12.0,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 65,
            width: ResponsiveWidget.isMobileScreen(context)?MediaQuery.of(context).size.width*.78:MediaQuery.of(context).size.width*.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:widget.traits.length,
              itemBuilder: (context,index){

                for (var element in widget.traits.values) {
                  mapValues.add(element);
                }
                for (var element in widget.traits.keys) {
                  mapValues.add(element);
                }
                return TraitItemWidget(trait:"https://raw.communitydragon.org/latest/game/${widget.traitNamesList[index].toLowerCase().replaceAll(".tex",".png")}",traitsQuantity: mapValues[index].toString(),index: index);
                // return TrailItemWidget(trait:mapKeys[index].toString(),index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}