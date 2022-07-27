import 'package:flutter/material.dart';

class LoadingSheet extends StatelessWidget {
  const LoadingSheet({
    Key? key,
    this.message,
  }) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            height: 12.0,
          ),
          Text('$message')
        ],
      ),
    );
  }
}
