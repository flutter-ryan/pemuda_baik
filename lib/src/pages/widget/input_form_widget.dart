import 'package:flutter/material.dart';

class InputFormWidget extends StatelessWidget {
  const InputFormWidget({
    Key? key,
    required this.hint,
    this.controller,
    this.obscure = false,
    this.icon,
    this.keyType = TextInputType.text,
    this.suffixicon,
    this.readOnly = false,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
    this.validate = true,
    this.textInputAction = TextInputAction.done,
  }) : super(key: key);

  final TextEditingController? controller;
  final bool obscure;
  final String? hint;
  final Widget? icon;
  final Widget? suffixicon;
  final TextInputType keyType;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextCapitalization textCapitalization;
  final bool validate;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      readOnly: readOnly,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14.0),
        prefixIcon: icon,
        hintText: hint,
        suffixIcon: suffixicon,
      ),
      validator: validate
          ? (val) {
              if (val!.isEmpty) {
                return 'Input required';
              }
              return null;
            }
          : null,
      textCapitalization: textCapitalization,
      keyboardType: keyType,
      onTap: onTap,
      textInputAction: textInputAction,
    );
  }
}
