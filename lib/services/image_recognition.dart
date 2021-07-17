import 'dart:io';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';

Future loadModel() async {
  Tflite.close();

  String? res = await Tflite.loadModel(
    model: "assets/model/model.tflite",
    labels: 'assets/model/labels.txt',
  );

  print(res);
}

Future<String> getPrediction(String url) async {
  try {
    final uri = Uri.parse(url);

    final response = await get(uri);

    final dir = await getTemporaryDirectory();
    final tmpPath = dir.path;
    final file = new File('$tmpPath/image${url.substring(url.length - 4)}');
    await file.writeAsBytes(response.bodyBytes);

    final result = await Tflite.runModelOnImage(
      path: file.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 30,
      threshold: 0.05,
    );

    if (result == null) return '';

    return result[0]['label'];
  } catch (error) {
    print(error);
    return '';
  }
}
