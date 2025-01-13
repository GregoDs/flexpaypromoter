import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key, required this.name, required this.profession, required bool isDarkModeOn,
  });

  final String name, profession;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(
            CupertinoIcons.person,
            color: Color(0xFF337687),
          ),
        ),
        title: Text(name,style: const TextStyle(color:Color(0xFF337687)),),
        subtitle: Text(profession,style: const TextStyle(color:  Color(0xFF337687)),),
      
      
      ),
    );
  }
}