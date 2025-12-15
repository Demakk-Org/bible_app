import 'dart:io';
import 'package:flutter/material.dart';

class CachedImage extends StatefulWidget {
  const CachedImage({
    required this.imageUrl,
    required this.placeholderImageUrl,
    super.key,
  });
  final String imageUrl;
  final String placeholderImageUrl;

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  File? _localImageFile;

  @override
  void initState() {
    super.initState();
    _loadOrDownloadImage();
  }

  Future<void> _loadOrDownloadImage() async {
    final file = File(widget.imageUrl);

    if (file.existsSync()) {
      setState(() {
        _localImageFile = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: AssetImage(widget.placeholderImageUrl),
      image: _getImage(widget.imageUrl),
      fit: BoxFit.cover,
    );
  }

  ImageProvider _getImage(String imageUrl) {
    final isFromNetwork = imageUrl.startsWith('http');

    if (isFromNetwork) {
      return NetworkImage(widget.imageUrl);
    }
    if (_localImageFile == null) {
      return AssetImage(widget.placeholderImageUrl);
    }
    return FileImage(
      _localImageFile!,
    );
  }
}
