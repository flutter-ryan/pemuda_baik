import 'package:flutter/material.dart';

class SuccesBox extends StatelessWidget {
  const SuccesBox({
    Key? key,
    this.message,
    this.onTap,
  }) : super(key: key);

  final String? message;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.green,
            size: 80,
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            '$message',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 32.0,
          ),
          SizedBox(
            width: 150,
            height: 45,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: const Text('Tutup'),
            ),
          )
        ],
      ),
    );
  }
}
