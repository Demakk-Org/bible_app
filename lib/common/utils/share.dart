import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bible_app/common/utils/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<Uint8List?> _captureWidget(GlobalKey globalKey) async {
  try {
    await Future.delayed(const Duration(milliseconds: 20), () {});

    final boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    final image = await boundary?.toImage(pixelRatio: 3);
    final byteData = await image?.toByteData(format: ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  } on Exception catch (e, stackTrace) {
    AppLogger.error(
      e.toString(),
      name: 'Share: captureWidget',
      stackTrace: stackTrace,
    );

    return null;
  }
}

Future<void> shareCapturedWidget(GlobalKey globalKey) async {
  final imageBytes = await _captureWidget(globalKey);
  if (imageBytes == null) return;

  final directory = await getTemporaryDirectory();
  final imagePath = '${directory.path}/shared_widget.png';
  await File(imagePath).writeAsBytes(imageBytes);

  await SharePlus.instance.share(ShareParams(files: [XFile(imagePath)]));
}
