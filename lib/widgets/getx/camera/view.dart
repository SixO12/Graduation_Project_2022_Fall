import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rubbish/cardStackedListPage.dart';
import 'package:flutter_rubbish/util/getx_debug_tool.dart';
import 'package:flutter_rubbish/util/img_tool.dart';
import 'package:flutter_rubbish/util/tflite/tf.dart';
import 'package:flutter_rubbish/widgets/flip_view.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../main.dart';
import 'logic.dart';
import 'package:image/image.dart' as img;
import 'package:share_plus/share_plus.dart';
// import 'package:share/share.dart';

class CameraComponent extends StatefulWidget {
  @override
  _CameraComponentState createState() => _CameraComponentState();
}

class _CameraComponentState extends State<CameraComponent>
    with TickerProviderStateMixin {
  final logic = Get.put(CameraLogic());
  final state = Get
      .find<CameraLogic>()
      .state;
  CameraController controller;
  var running = false;
  var camSize = 50.0;
  Widget im;
  var results = ['paper', 'cardboard', 'glass', 'plastic', 'metal', 'trash'];


  final Map _translate = {//metal，plastic，paper，cardboard，trash,glass
    "glass" : "glass",
    "metal" : "metal",
    "plastic" : "plastic",
    "paper" : "paper",
    "cardboard" : "cardboard",
    "trash" : "trash",
  };

  // https://github.com/flutter/flutter/issues/26348
  Future<void> convertYUV420toImageColor(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      Dbg.log('width: $width, height: $height', 'yuv');
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel;
      print("uvRowStride: " + uvRowStride.toString());
      print("uvPixelStride: " + uvPixelStride.toString());
      var img0 = img.Image(width, height); // Create Image buffer
      // Fill image buffer with plane[0] from YUV420_888
      for (int x = 0; x < 560; x++) {
        for (int y = 0; y < 560; y++) {
          final int uvIndex =
              uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          final int index = y * width + x;
          final yp = image.planes[0].bytes[index];
          final up = image.planes[1].bytes[uvIndex];
          final vp = image.planes[2].bytes[uvIndex];
          int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
          int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
          img0.data[index] = (0xFF << 24) | (b << 16) | (g << 8) | r;
        }
      }
      // Dbg.log(img0.data.toString(),'yuv');
      img.PngEncoder pngEncoder = new img.PngEncoder(level: 0, filter: 0);
      Uint8List png = pngEncoder.encodeImage(img0);
      final originalImage = img.decodeImage(png);
      // final height1 = originalImage.height;
      // final width1 = originalImage.width;
      // img.Image fixedImage;
      // if (height1 < width1) {
      //   fixedImage = img.copyRotate(originalImage, 90);
      // }
      // return img.encodeJpg(fixedImage);
      im = Image.memory(img0.data.buffer.asUint8List());
      setState(() {});
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

  // CameraImage YUV420_888 -> PNG -> Image (compresion:0, filter: none)
  // Black
  Future<Image> convertYUV420toImage(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;

      // img -> Image package from https://pub.dartlang.org/packages/image
      var img0 = img.Image(width, height); // Create Image buffer

      // Fill image buffer with plane[0] from YUV420_888
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          final pixelColor = image.planes[0].bytes[y * width + x];
          // color: 0x FF  FF  FF  FF
          //           A   B   G   R
          // Calculate pixel color
          img0.data[y * width + x] = (0xFF << 24) |
          (pixelColor << 16) |
          (pixelColor << 8) |
          pixelColor;
        }
      }

      img.PngEncoder pngEncoder = new img.PngEncoder(level: 0, filter: 0);
      List<int> png = pngEncoder.encodeImage(img0);
      return Image.memory(png);
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
      value: 1.0,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    controller = CameraController(cameras[0], ResolutionPreset.max,
        imageFormatGroup: ImageFormatGroup.jpeg);
    controller.initialize().then((_) async {
      if (!mounted) {
        return;
      }
      await controller.setFlashMode(FlashMode.off);

      setState(() {});
      // controller.startImageStream((CameraImage image) async {
      //   if (running) return;
      //   running = true;
      //
      //   var img1 = img.Image.fromBytes(
      //     image.planes[0].bytesPerRow ~/ 4,
      //     image.height,
      //     image.planes[0].bytes,
      //     format: img.Format.bgra,
      //   );
      //
      //   Dbg.log('image.format: ${img1.width}, ${img1.height}', '${image.format.group}');
      //   // var bytes = image.planes[0].bytes;
      //   //
      //   im=Image.memory(img1.data.buffer.asUint8List());
      //   setState(() {
      //
      //   });
      //   // Dbg.log(image.format.group,'x');
      //   // // var data = await ImageTool().convertImageToPng(image);
      //   // // await convertYUV420toImageColor(image);
      //   // im=await convertYUV420toImage(image);
      //   // setState(() {
      //   //
      //   // });
      //   // img.Image photo = img.decodeImage(data);
      //   //
      //   //
      //   // Dbg.log(photo.width);
      //   Timer(Duration(milliseconds: 500), () {
      //     if (running) {
      //       running = false;
      //     }
      //   });
      //   // Dbg.log(image.planes[0].width);
      //   //get image rgba data
      //   // final data = image.planes.first.bytes;
      //   // img.Image photo = img.decodeImage(data);
      //   //
      //   // Dbg.log('${photo.width},${photo.height}');
      //
      //   // final rgba = List<int>.generate(buffer.lengthInBytes, (i) => buffer[i]);
      //   //
      //   //
      //   // Dbg.log(image.width.toString() + 'x' + image.height.toString());
      //   // Dbg.log(rgba.length);
      // });
    });
  }

  Widget roundBackGround({Widget child}) {
    return Container(
      child: child,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(camSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              // AnimatedBuilder(animation: _animation, builder: (ctx,child){
              //   return SizedBox(
              //     height: _animation.value * camSize,
              //     child: child,
              //   );
              // }),
              SizedBox(
                height: 100,
              ),
              // Expanded(child: AnimatedSize(child: SizedBox(height: 100,),)),
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      //Here the camera will automatically be scaled to reveal the top of the camera, and the rest of the bottom mask off
                      child: CameraPreview(
                        controller,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .width,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                        ),
                        Expanded(
                            child: Container(
                              color: Colors.white,
                              // Colors.transparent,
                              child: ListView(),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              im ?? Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  roundBackGround(
                    child: IconButton(
                        iconSize: camSize,
                        color: Colors.black,
                        onPressed: () async {
                          var xF = await controller.takePicture();

                          File file = File(xF.path);
                          Uint8List bytes = file.readAsBytesSync();
                          ByteData imageBytes = ByteData.view(bytes.buffer);
                          img.Image photo =
                          img.decodeImage(imageBytes.buffer.asUint8List());

                          // im = Image.memory(bytes);
                          // setState(() {});

                          Dbg.log('${photo.width},${photo.height}');

                          var rgba = photo.getBytes();
                          // Dbg.log('${rgba}');

                          List<List<List<double>>> data = [];
                          int step = photo.width ~/ 224;
                          for (int i = 0; i < photo.width; i += step) {
                            List<List<double>> row = [];
                            for (int j = 0; j < photo.width; j += step) {
                              List<double> pixel = [];
                              for (int k = 0; k < 3; k++) {
                                var x = i + 112;
                                var y = j + 112;
                                pixel.add(
                                    rgba[(x * photo.width + y) * 4 + k] * 1.0);
                              }
                              if (row.length == 224) {
                                break;
                              }
                              row.add(pixel);
                            }
                            if (data.length == 224) {
                              break;
                            }
                            data.add(row);
                          }
                          Dbg.log('${data.length}');
                          Dbg.log('${data[0].length}');

                          Directory tempDir = await getTemporaryDirectory();
                          String tempPath = tempDir.path;

                          Directory appDocDir =
                          await getApplicationDocumentsDirectory();
                          String appDocPath = appDocDir.path;
                          Dbg.log('${appDocPath}');
                          var t = DateTime
                              .now()
                              .millisecondsSinceEpoch;
                          File('$appDocPath/$t.txt')
                              .writeAsStringSync(data.toString());
                          // Share.shareFiles(['$appDocPath/$t.txt'],
                          //     subject: 'AAA');

                          // ByteData imageBytes = await rootBundle.load('assets/images/test.png');
                          // List<int> values = imageBytes.buffer.asUint8List();
                          // Image photo;
                          // photo = Image.decodeImage(values);
                          // // photo.getBytes()
                          var res = await TfliteRunner().runBatchOne(data, 6);
                          var max = res[0];
                          var maxIndex = 0;
                          for (var i = 0; i < res.length; i++) {
                            if (res[i] > max) {
                              max = res[i];
                              maxIndex = i;
                            }
                          }

                          Dbg.log(res, 'prediction-6');
                          Dbg.log(maxIndex, 'prediction-6');
                          Get.snackbar('AI classification', '${_translate[results[maxIndex]]}', onTap: (snk) {
                            print(_translate[results[maxIndex]]);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CardStackedListPage(arguments: {
                              "needName" : _translate[results[maxIndex]],
                              "imageUrl" : 'assets/9k.png',
                            },),fullscreenDialog: true),);
                          });
                          _animationController.reverse();
                        },
                        icon: Icon(Icons.photo_camera_rounded)),
                  )
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      iconSize: 50, onPressed: () {}, icon: Icon(Icons.photo))
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<CameraLogic>();
    controller?.dispose();
    _animationController.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        // onNewCameraSelected(controller.description);
      }
    }
  }
}
