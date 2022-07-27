import 'package:flutter/material.dart';

class LoadingBox extends StatelessWidget {
  const LoadingBox({
    Key? key,
    this.message,
  }) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
