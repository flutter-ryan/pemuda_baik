import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageNetWidget extends StatelessWidget {
  const ImageNetWidget({
    Key? key,
    required this.urlImg,
    this.fit = BoxFit.fitHeight,
  }) : super(key: key);

  final String urlImg;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: urlImg,
      placeholder: (context, url) => const CircleAvatar(
        radius: 8.0,
        backgroundColor: Colors.transparent,
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.broken_image,
        color: Colors.grey,
      ),
      fit: fit,
    );
  }
}
