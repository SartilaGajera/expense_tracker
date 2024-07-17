import 'package:flutter/material.dart';

class CommonTextFormField extends StatelessWidget {
  const CommonTextFormField({
    this.controller,
    this.validator,
    this.hineText,
    super.key,
    this.keyboardType = TextInputType.text,
    this.isReadOnly = false, this.prefixIcon, this.suffixIcon,
  });
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hineText;
  final TextInputType keyboardType;
  final bool isReadOnly;  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      controller: controller,
      keyboardType: keyboardType,
      readOnly: isReadOnly,
      validator: validator,
      style: const TextStyle(
        fontSize: 12,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        // isDense: true,
        hintText: hineText,
        hintStyle: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon, errorStyle: const TextStyle(color: Color(0xffFF3D32)),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xffCBCACA)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xffCBCACA)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xff1E346F)),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xffFF3D32)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xffCBCACA)),
        ),
        filled: true,
        fillColor: const Color(0xffEDF3FF),
      ),
    );
  }
}
