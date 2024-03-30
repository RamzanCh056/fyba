import 'package:app/consolePrintWithColor.dart';
import 'package:app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/constants/exports.dart';

class TraitItemWidget extends StatefulWidget {
  final int index;
  String trait;
  String traitsQuantity;
  TraitItemWidget({Key? key,required this.trait,required this.traitsQuantity, required this.index}) : super(key: key);

  @override
  State<TraitItemWidget> createState() => _TraitItemWidgetState();
}

class _TraitItemWidgetState extends State<TraitItemWidget> {
  @override
  Widget build(BuildContext context) {
    printLog("${widget.trait}");
    return Container(
      height: 40,
      width: 70,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: AppColors.mainDarkColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                // color: AppColors.whiteColor,
              ),
              child: Center(
                child: Image.network(widget.trait,
                height: 25,width: 25,)
                
                // SvgPicture.asset(
                //   widget.index == 0
                //       ? AppIcons.shield
                //       : widget.index == 1
                //       ? AppIcons.sword
                //       : widget.index == 2
                //       ? AppIcons.hand
                //       : AppIcons.fire,
                // ),
              )),
          const SizedBox(width: 10),
          Text(widget.traitsQuantity,
            style: poppinsSemiBold.copyWith(
              fontSize: 10,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      )
    );
  }
}
