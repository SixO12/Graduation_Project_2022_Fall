import 'package:flutter/material.dart';
import 'package:flutter_rubbish/cardStackedSharePage.dart';
import 'package:flutter_rubbish/entity/garbage_entity.dart';
import 'package:stacked_listview/stacked_listview.dart';

import '../../main.dart';
class CardStackedListPage extends StatefulWidget {
  final arguments;
  const CardStackedListPage({Key key, this.arguments}) : super(key: key);

  @override
  _CardStackedListPageState createState() => _CardStackedListPageState();
}

class _CardStackedListPageState extends State<CardStackedListPage> {

  int _index = 0;
  bool _click = false;
  var colors = [Colors.green, Colors.black, Colors.blue, Colors.red];
  String _needName = "";

  String _imageUrl = "assets/foodwaste.png";
  List<GarbageDataItems> _garbageDataInside = [];
  @override
  void initState() {
    super.initState();
    _needName = widget.arguments["needName"];
    _check();

  }

  void _check(){
    garbage.data.forEach((element) {
      element.items.forEach((item) {
        if (item.name.contains(_needName)) {
          _garbageDataInside.add(item);
        }
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
        body:Container(
          color: const Color.fromRGBO(0, 0, 0, 0.8),
          alignment: Alignment.topCenter,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: const SizedBox(),
                color: const Color.fromRGBO(233, 233, 233, 0.1),
                height: kToolbarHeight / 1.3,
                alignment: Alignment.center,
              ),
              GestureDetector(
                child: Container(
                  color: const Color.fromRGBO(233, 233, 233, 0.1),
                  height: kToolbarHeight,
                  child: const Icon(Icons.keyboard_arrow_down_rounded,size: 40,color: Colors.white,),
                  alignment: Alignment.center,
                ),
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Navigator.pop(context);
                },
                onVerticalDragEnd: (e){
                  Navigator.pop(context);
                },
              ),
              _garbageDataInside.isNotEmpty ?
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: _click ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                firstChild: Container(
                    height: MediaQuery.of(context).size.height - kToolbarHeight * 2,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: StackedListView(
                      padding: const EdgeInsets.all(10),
                      itemCount: _garbageDataInside == null ? 0 : _garbageDataInside.length,
                      itemExtent: 120,
                      heightFactor: 0.7,
                      fadeOutFrom: 0.7,
                      builder: (_, index) {
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                              color: colors[int.tryParse(_garbageDataInside[index].category) ?? 0 % colors.length],
                              boxShadow: [
                                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  child: Text(_garbageDataInside[index].name,style: const TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w600),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Container(
                                  child: Text(garbage.data[int.tryParse(_garbageDataInside[index].category) ?? 0].name,style: const TextStyle(fontSize: 14,color: Colors.white),),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                                ),
                                Container(
                                  child: Text(garbage.data[int.tryParse(_garbageDataInside[index].category) ?? 0].description,style:const TextStyle(fontSize: 14,color: Colors.white),overflow: TextOverflow.ellipsis,maxLines: 1,softWrap: false,),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                ),
                              ],
                            ),
                            padding:const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            setState(() {
                              _click = !_click;
                              _index = index;

                              String _categoryName = _garbageDataInside.isNotEmpty ? garbage.data[int.tryParse(_garbageDataInside[_index].category) ?? 0].name : "" ;
                              print(_categoryName);
                              if(_categoryName == "Food waste"){
                                _imageUrl = "assets/foodwaste.png";
                              }else if(_categoryName == "Other garbage"){
                                _imageUrl = "assets/othergarbage.png";
                              }else if(_categoryName == "Recyclable waste"){
                                _imageUrl = "assets/recyclable.png";
                              }else if(_categoryName == "Hazardous waste"){
                                _imageUrl = "assets/hazardouswaste.png";
                              }else{
                                _imageUrl = "assets/foodwaste.png";
                              }
                            });
                          },
                        );
                      },
                    )
                ),
                secondChild: GestureDetector(
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height - kToolbarHeight * 3,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10),
                        ],
                      ),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: colors[int.tryParse(_garbageDataInside[_index].category) ?? 0 % colors.length],
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0)),
                              ),
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(_garbageDataInside.isNotEmpty ? _garbageDataInside[_index].name : "",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w600),),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  Container(
                                    child: Text(_garbageDataInside.isNotEmpty ? garbage.data[int.tryParse(_garbageDataInside[_index].category) ?? 0].name : "",style: const TextStyle(fontSize: 14,color: Colors.white),),
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                                  ),
                                  Container(
                                    child: Text(_garbageDataInside.isNotEmpty ?  garbage.data[int.tryParse(_garbageDataInside[_index].category) ?? 0].description : "",style:const TextStyle(fontSize: 14,color: Colors.white),overflow: TextOverflow.ellipsis,maxLines: 2,softWrap: false,),
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  ),
                                ],
                              ),
                            ),
                             Expanded(
                              child: Container(
                                child: Image.asset(_imageUrl,fit: BoxFit.contain,),
                                padding: const EdgeInsets.all(70),
                              )
                            ),
                            Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.fromLTRB(0, 0, 30, 30),
                                child: GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Icon(Icons.share),
                                      Text("Share",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),),
                                    ],
                                  ),
                                  behavior: HitTestBehavior.opaque,
                                  onTap: (){
                                    showDialog(
                                      context: context,
                                        barrierDismissible : false,
                                      builder: (BuildContext context) {
                                        return Container(
                                          color:const Color.fromRGBO(0, 0, 0, 0.7),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const SizedBox(width: 20,),
                                                  const Icon(Icons.close,color: Colors.transparent,size: 30,),
                                                  Expanded(
                                                    child: Container(
                                                      child: const Text("Photo Sharing and Saving",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600),),
                                                      alignment: Alignment.center,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    child: const Icon(Icons.close,color: Colors.white,size: 30,),
                                                    behavior: HitTestBehavior.opaque,
                                                    onTap: (){
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  const SizedBox(width: 20,),
                                                ],
                                              ),
                                              CardStackedSharePage(
                                                arguments: {
                                                  "color" : colors[int.tryParse(_garbageDataInside[_index].category) ?? 0 % colors.length],
                                                  "name" : (_garbageDataInside.isNotEmpty ? _garbageDataInside[_index].name : ""),
                                                  "categoryName" : (_garbageDataInside.isNotEmpty ? garbage.data[int.tryParse(_garbageDataInside[_index].category) ?? 0].name : ""),
                                                  "categoryDescription" : (_garbageDataInside.isNotEmpty ?  garbage.data[int.tryParse(_garbageDataInside[_index].category) ?? 0].description : ""),
                                                  "imageUrl" : _imageUrl,
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                  },
                                )
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                      )
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    setState(() {
                      _click = !_click;
                    });
                  },
                ),
              ) :
                  Container(
                    child: const Text("No matching items at this time",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w600),),
                    alignment: Alignment.center,
                  )
            ],
          ),
        ),
      ),
    );
  }
}




