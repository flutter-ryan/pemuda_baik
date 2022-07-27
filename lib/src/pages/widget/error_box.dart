import 'package:flutter/material.dart';

class Errorbox extends StatelessWidget {
  const Errorbox({
    Key? key,
    this.message,
    this.onTap,
    this.button = true,
  }) : super(key: key);

  final String? message;
  final VoidCallback? onTap;
  final bool button;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_rounded,
            color: Colors.red,
            size: 52,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            '$message',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(
            height: 22.0,
          ),
          if (button)
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: const Text('Coba Lagi'),
            )
        ],
      ),
    );
  }
}
