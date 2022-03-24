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
            child: Stack(
              children: [
                AnimatedPadding(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.only(
                      left: 15,
                      right: 15.0 + (state.showCancel.value ? state.cancelPad * 2 : 0)),
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
                              "imageUrl" : 'assets/9k.png',

                            },),fullscreenDialog: true),);
                          },
                          child: SizedBox(
                              width: state.showCancel.value ? state.cancelPad : 0,
                              child: const Text('Search',style: TextStyle(color: Colors.blue),)),
                        ),
                        GestureDetector(
                          onTap: () {
                            state.showCancel.value = false;

                            state.textEditingController.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: SizedBox(
                              width: state.showCancel.value ? state.cancelPad : 0,
                              child: const Text('Cancel')),
                        )
                      ],
                    )),
                // AnimatedClipRect(
                //   open: state.showCancel.value,
                //   horizontalAnimation: true,
                //   verticalAnimation: false,
                //   alignment: Alignment.center,
                //   duration: const Duration(milliseconds: 1000),
                //   curve: Curves.bounceOut,
                //   reverseCurve: Curves.bounceIn,
                //   child: Container(
                //     color: Colors.lightGreenAccent,
                //     padding: const EdgeInsets.all(8),
                //     child: const Text(
                //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
                //   ),
                // ),
              ],
            ),
          ),
        );
      }),
    );
  }

  var colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow];
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
                    children: [Icon(Icons.ios_share), Text('Share')],
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
                              "imageUrl" : 'assets/9k.png',
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
                        (index0) => CategoryScrollBinder(
                      title: CategoryCard(
                        color: colors[index0 % colors.length],
                        title: garbage.data[index0].name,
                      ),
                      items: List.generate(
                        garbage.data[index0].items.length,
                            (index1) => ListTile(
                          onTap:(){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CardStackedListPage(arguments: {
                              "needName" : garbage.data[index0].items[index1].name,
                              "imageUrl" : 'assets/9k.png',
                            },),fullscreenDialog: true),);

                          },
                          title: Text('${garbage.data[index0].items[index1].name}', style: TextStyle(color: colors[index0 % colors.length],),),
                        ),
                      ),
                    ),
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
