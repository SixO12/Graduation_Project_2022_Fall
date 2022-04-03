import 'package:flutter/material.dart';
import 'package:flutter_rubbish/cardStackedListPage.dart';
import 'package:flutter_rubbish/entity/garbage_entity.dart';
import 'package:flutter_rubbish/util/obx_widget.dart';
import 'package:flutter_rubbish/widgets/getx/scroll_with_list/view.dart';
import 'package:flutter_rubbish/widgets/only/garbage_category_card.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flip_card/flip_card.dart';
import 'package:stacked_listview/stacked_listview.dart';
import '../../../config.dart';
import '../../../main.dart';
import 'logic.dart';

class SearchPageComponent extends StatefulWidget {
  @override
  _SearchPageComponentState createState() => _SearchPageComponentState();
}

class _SearchPageComponentState extends State<SearchPageComponent> {
  final logic = Get.put(SearchPageLogic());
  final state = Get.find<SearchPageLogic>().state;



  Widget _buildText() {
    return Theme(
      data: ThemeData(
        primaryColor: Config.bottomBarColor,
        primaryColorDark: Config.bottomBarColor,
      ),
      child: Obx(() {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.only(left: 15, right: 15.0),
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        if (hasFocus) {
                          state.showCancel.value = hasFocus;
                        }
                        // state.showCancel.value = hasFocus;
                      },
                      child: TextField(
                        onChanged: (s) {
                          state.searchText.value = s;
                        },
                        controller: state.textEditingController,
                        decoration:  InputDecoration(
                          errorText: true ? (true ? null : 'Can not be Null') : null,
                          labelText: 'What Trash?',
                          focusedBorder:  OutlineInputBorder(
                            borderSide: BorderSide(color: Config.bottomBarColor),
                            borderRadius: const BorderRadius.all(Radius.circular(30.0),),
                          ),
                          border:  OutlineInputBorder(
                            borderSide: BorderSide(color: Config.bottomBarColor),
                            borderRadius: const BorderRadius.all(Radius.circular(30.0),),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Config.bottomBarColor),
                            borderRadius: const BorderRadius.all(Radius.circular(30.0),),
                          ),
                          // filled: true,
                          // hintStyle: new TextStyle(color: Colors.grey[800]),
                          // hintText: "UserName",
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {

                            state.showCancel.value = false;
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CardStackedListPage(arguments: {
                              "needName" : state.textEditingController.text,
                            },),fullscreenDialog: true),);
                          },
                          child: SizedBox(
                              width: state.showCancel.value ? state.cancelPad : 0,
                              child: const Text('Search',style: TextStyle(color: Colors.blue,fontSize: 13),)),
                        ),
                        GestureDetector(
                          onTap: () {
                            state.showCancel.value = false;

                            state.textEditingController.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: SizedBox(
                              width: state.showCancel.value ? state.cancelPad : 0,
                              child: const Text('Cancel',style: TextStyle(fontSize: 13),)),
                        )
                      ],
                    ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  var colors = [Colors.green, Colors.black, Colors.blue, Colors.red];
  var radius = 20.0;

  Future onItemTap(context, GarbageDataItems data) async {
    var category = int.parse(data.category);
    FocusScope.of(context).requestFocus( FocusNode());
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      // elevation: 500,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
          ),
          height: 700,
          // color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.name),
                          Text(garbage.data[category].name),
                          Text(garbage.data[category].description),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: colors[category % colors.length],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(radius),
                    topRight: Radius.circular(radius),
                  ),
                ),
                height: 150,
              ),
              Expanded(
                  child: Center(
                    child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.asset('assets/9k.png')),
                  )),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [Icon(Icons.ios_share), Text('Share')],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildText(),
          const SizedBox(height: 20,),
          Expanded(
            child: Obx(() {
              var builders = [
                    () => ObxObserveWidget([state.searchText], () {
                  List<GarbageDataItems> garbageData = [];
                  garbage.data.forEach((element) {
                    element.items.forEach((item) {
                      if (item.name.contains(state.textEditingController.text)) {
                        garbageData.add(item);
                      }
                    });
                  });
                  return ListView.builder(
                      itemCount: garbageData.length,
                      itemBuilder: (c, i) {
                        return ListTile(
                          onTap: () {

                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CardStackedListPage(arguments: {
                              "needName" : garbageData[i].name,
                            },),fullscreenDialog: true),);

                            // onItemTap(context, garbageData[i]);
                          },
                          title: Text(garbageData[i].name),
                        );
                      });
                }),
                    () => ScrollWithListComponent(
                  categories: List.generate(
                    garbage.data.length,

                        (index0){

                           String _title = garbage.data[index0].name;
                           Color _color = colors[index0 % colors.length];
                           String _describe1 = garbage.data[index0].description;
                           String _describe2 = garbage.data[index0].description1;
                           String _describe3 = garbage.data[index0].description2;
                           String _describe4 = garbage.data[index0].description3;

                      return CategoryScrollBinder(
                        title: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _color,
                          ),
                          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_title,style: const TextStyle(color: Colors.white,fontSize: 18),),
                                  const SizedBox(height: 4,),
                                  Text(_describe1,style: const TextStyle(color: Colors.white,fontSize: 12),),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_describe2,style: const TextStyle(color: Colors.white,fontSize: 12),),
                                  const SizedBox(height: 3,),
                                  Text(_describe3,style: const TextStyle(color: Colors.white,fontSize: 12),),
                                  const SizedBox(height: 3,),
                                  Text(_describe4,style: const TextStyle(color: Colors.white,fontSize: 12),),
                                ],
                              ),
                              const SizedBox(height: 4,),
                              // const Expanded(child: SizedBox(),),
                            ],
                          ),
                        ),

                        items: List.generate(
                          garbage.data[index0].items.length,
                              (index1) => ListTile(
                            onTap:(){

                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CardStackedListPage(arguments: {
                                "needName" : garbage.data[index0].items[index1].name,
                              },),fullscreenDialog: true),);
                            },
                            title: Text(garbage.data[index0].items[index1].name, style: TextStyle(color: colors[index0 % colors.length],),),
                          ),
                        ),
                      );
                        },
                  ),
                ),
              ];
              return builders[state.showCancel.value ? 0 : 1]();
            }),
          )
        ],
      ),
    );
  }


  @override
  void dispose() {
    Get.delete<SearchPageLogic>();
    super.dispose();
  }
}
