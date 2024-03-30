import 'package:flutter/material.dart';
class CustomListTile extends StatelessWidget {
  final String title;
  final bool isBackground;
  final bool isDesktop;
  const CustomListTile({
    super.key, required this.title,  this.isBackground = false,this.isDesktop = true
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: isBackground ? const Color(0xFF1B1746) :  Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
      child:  ListTile(
        leading: const Icon(
          Icons.done,
          color: Colors.white,
        ),
        title: Text(
          title,
          style:  TextStyle(
              fontSize: isDesktop ? 18 : 11,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
    );
  }
}