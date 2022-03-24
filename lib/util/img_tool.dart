import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as imglib;

class ImageTool {
  //singleton
  static final ImageTool _singleton = new ImageTool._internal();

  factory ImageTool() => _singleton;

  ImageTool._internal();

  //  instance
  ImageTool get instance => _singleton;

  Future<Uint8List> convertImageToPng(CameraImage image) async {
    Uint8List bytes;
    try {
      imglib.Image img;
      if (image.format.group == ImageFormatGroup.yuv420) {
        bytes = await convertYUV420toImageColor(image);
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        img = _convertBGRA8888(image);
        imglib.PngEncoder pngEncoder = new imglib.PngEncoder();
        bytes = pngEncoder.encodeImage(img);
      }
      return bytes;
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

  imglib.Image _convertBGRA8888(CameraImage image) {
    return imglib.Image.fromBytes(
      image.width,
      image.height,
      image.planes[0].bytes,
      format: imglib.Format.bgra,
    );
  }

  Future<Uint8List> convertYUV420toImageColor(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel;
      print("uvRowStride: " + uvRowStride.toString());
      print("uvPixelStride: " + uvPixelStride.toString());
      var img = imglib.Image(width, height); // Create Image buffer
      // Fill image buffer with plane[0] from YUV420_888
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
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
          img.data[index] = (0xFF << 24) | (b << 16) | (g << 8) | r;
        }
      }
      imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
      Uint8List png = pngEncoder.encodeImage(img);
      final originalImage = imglib.decodeImage(png);
      final height1 = originalImage.height;
      final width1 = originalImage.width;
      imglib.Image fixedImage;
      if (height1 < width1) {
        fixedImage = imglib.copyRotate(originalImage, 90);
      }

      return imglib.encodeJpg(fixedImage);
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }
}
