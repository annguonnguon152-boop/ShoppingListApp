import 'package:flutter/material.dart';

Widget newCategory({required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFB7D8C5)),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: Color(0xFF12B76A),
            child: Icon(Icons.add, size: 30, color: Colors.white),
          ),

          SizedBox(height: 10),
          Text(
            'New\nCategory',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF039855),
            ),
          ),
        ],
      ),
    ),
  );
}
