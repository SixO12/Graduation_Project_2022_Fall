import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rubbish/config.dart';
import 'package:flutter_rubbish/entity/garbage_entity.dart';
import 'package:flutter_rubbish/generated/json/base/json_convert_content.dart';
import 'package:flutter_rubbish/util/getx_debug_tool.dart';
import 'package:flutter_rubbish/widgets/getx/camera/view.dart';
import 'package:flutter_rubbish/widgets/getx/scroll_with_list/view.dart';
import 'package:flutter_rubbish/widgets/getx/search_page/view.dart';
import 'package:flutter_rubbish/widgets/only/cam.dart';
import 'package:flutter_rubbish/widgets/only/garbage_category_card.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

List<CameraDescription> cameras;
GarbageEntity garbage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String data = await rootBundle.loadString('assets/hB.json');
  // String data = await DefaultAssetBundle.of(context).loadString(
  //     "assets/hB.json");
  final jsonResult = jsonDecode(data); //latest Dart
  // Dbg.log(jsonResult);
  garbage = JsonConvert.fromJsonAsT<GarbageEntity>(jsonResult);
  cameras = await availableCameras();

  runApp(const MyApp());
  // runApp( CameraApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: (BuildContext context, Widget child) {
        return FlutterSmartDialog(child: child);
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentIndex = 0;
  var pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Config.selectedItemColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Snapshot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: 'Categories',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   title: Text(''),
          // ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          currentIndex = index;
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 200), curve: Curves.ease);
          setState(() {});
        },
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: PageView(
          onPageChanged: (index) {
            currentIndex = index;
            setState(() {});
          },
          controller: pageController,
          children: [
            CameraComponent(),
            SearchPageComponent(),

            // UserProfilePage(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}
