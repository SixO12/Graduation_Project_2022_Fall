import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;
import '../../main.dart';
class CardStackedSharePage extends StatefulWidget {
  final arguments;
  const CardStackedSharePage({Key key, this.arguments}) : super(key: key);

  @override
  _CardStackedSharePageState createState() => _CardStackedSharePageState();
}

class _CardStackedSharePageState extends State<CardStackedSharePage> {

  GlobalKey rootWidgetKey1 = GlobalKey();

  Color _color = Colors.white;
  String _name = "";
  String _categoryName = "";
  String _categoryDescription = "";
  String _imageUrl = "";

  @override
  void initState() {
    super.initState();
    _color = widget.arguments["color"];
    _name = widget.arguments["name"];
    _categoryName = widget.arguments["categoryName"];
    _categoryDescription = widget.arguments["categoryDescription"];
    _imageUrl = widget.arguments["imageUrl"];
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
            child: Stack(
              alignment: const Alignment(0.0, 0.9),
              children: [
                RepaintBoundary(
                  key: rootWidgetKey1,
                  child:Container(
                    decoration:const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: _color,
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0)),
                          ),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Column(
                            children: [
                              Container(
                                child: Text(_name,style: const TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w600),),
                                alignment: Alignment.centerLeft,
                              ),
                              Container(
                                child: Text(_categoryName,style: const TextStyle(fontSize: 14,color: Colors.white),),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                              ),
                              Container(
                                child: Text(_categoryDescription,style:const TextStyle(fontSize: 14,color: Colors.white),overflow: TextOverflow.ellipsis,maxLines: 2,softWrap: false,),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                              child: Image.asset(_imageUrl,fit: BoxFit.contain,),
                              padding:const EdgeInsets.all(70),
                            )
                        ),
                      ],
                    ),

                  ),
                ),
                GestureDetector(
                  child: const SizedBox(
                    height: 50,
                    width: 50,
                    child: Icon(Icons.arrow_circle_down_rounded,color: Colors.blue,size: 50,),
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: () async{
                    print("保存中");
                    BuildContext buildContext = rootWidgetKey1.currentContext;
                    if (null != buildContext){
                      RenderRepaintBoundary boundary = buildContext.findRenderObject();
                      var dpr = ui.window.devicePixelRatio;
                      var image = await boundary.toImage(pixelRatio: dpr);
                      ByteData byteData1 = await image.toByteData(format: ui.ImageByteFormat.png);
                      final result = await ImageGallerySaver.saveImage(byteData1.buffer.asUint8List());
                      print(result);
                      if(result["isSuccess"].toString() == "true"){
                        Get.snackbar('Save Picture',"Saved successfully, saved to album",backgroundColor: Colors.white, onTap: (snk) {

                        });
                        Future.delayed(const Duration(milliseconds: 100)).then((onValue) async{
                          Navigator.pop(context);
                        });
                      }else{
                        Get.snackbar('Save Picture',"Save failed",backgroundColor: Colors.white, onTap: (snk) {

                        });
                      }
                    }
                  },
                ),
              ],
            ),
            alignment: Alignment.center,
          ),
      ),
    );
  }
}
