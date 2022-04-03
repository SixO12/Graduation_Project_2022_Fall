import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  // final String img;
  final String title;
  final Color color;
  final String describe1;
  final String describe2;
  final String describe3;
  final String describe4;
  final String imageUrl;

  const CategoryCard({Key key, this.title, this.color,this.describe1,this.describe2,this.describe3,this.describe4,this.imageUrl}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,style: const TextStyle(color: Colors.white,fontSize: 20),),
                      const SizedBox(height: 4,),
                      Text(describe1,style: const TextStyle(color: Colors.white,),),
                    ],
                  ),
                ),
              ),
              Container(
                child: Image(image: AssetImage(imageUrl),height: 30,width: 30,),
                padding:const EdgeInsets.fromLTRB(20, 20, 20, 20),
              )
            ],
          ),
          Container(
            child: Text(describe2,style: const TextStyle(color: Colors.white,),),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
          Container(
            child: Text(describe3,style: const TextStyle(color: Colors.white,),),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
          Container(
            child: Text(describe4,style: const TextStyle(color: Colors.white,),),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
        ],
      ),);
  }
}

