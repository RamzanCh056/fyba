import 'package:flutter/material.dart';

import '../../constants/exports.dart';
import '../Admin/Model/api_data_model.dart';

class CustomSearchBar extends StatefulWidget {
  List<ChampModel> champs;
  CustomSearchBar({required this. champs});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  TextEditingController searchController = TextEditingController();

  List<ChampModel> foundData=[];
  bool visibleSearchData = false;
  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    setState(() {
      visibleSearchData=true;
    });
    List<ChampModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = widget.champs;
    } else {
      results = widget.champs.where((user) =>
          user.champName!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      foundData = results;
    });
  }

  @override
  initState() {
    // at the beginning, all users are shown
    foundData = widget.champs;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) => _runFilter(value),
      controller: searchController,
      keyboardType: TextInputType.text,
      style: poppinsRegular.copyWith(
        fontSize: 14,
        color: AppColors.whiteColor,
      ),
      decoration: InputDecoration(
        filled: true,
        hintText: 'Search',
        hintStyle: poppinsRegular.copyWith(
          fontSize: 14,
          color: AppColors.whiteColor.withOpacity(0.4),
        ),
        fillColor: AppColors.fieldColor.withOpacity(0.4),
        contentPadding: const EdgeInsets.only(top: 8.0),
        prefixIcon: SvgPicture.asset(AppIcons.search, fit: BoxFit.scaleDown),
        constraints: const BoxConstraints(
          minHeight: 36,
          maxHeight: 36,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.fieldColor.withOpacity(0.4),
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.fieldColor.withOpacity(0.4),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.fieldColor.withOpacity(0.4),
            width: 1.0,
          ),
        ),
      ),
    );  }
}
