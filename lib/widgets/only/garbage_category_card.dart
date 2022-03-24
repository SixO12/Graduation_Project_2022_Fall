import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  // final String img;
  final String title;
  final Color color;
  const CategoryCard({Key key, this.title, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child:Center(
      child: Stack(
        children: [
          // Center(child: Image.asset(img)),
          Padding(
            padding: const EdgeInsets.only(left: 3.0, right: 3.0,top: 10),
            child: Container(decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color,
              boxShadow: [
                BoxShadow(
                  // color: Colors.grey.withOpacity(0.5),
                  // spreadRadius: 5,
                  // blurRadius: 7,
                  // offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$title',style: TextStyle(color: Colors.white,fontSize: 20),),
                Text('$title',style: TextStyle(color: Colors.white,),),
                Text('$title',style: TextStyle(color: Colors.white,),),
              ],
            ),
          )
        ],
      ),
    ),);
  }
}
