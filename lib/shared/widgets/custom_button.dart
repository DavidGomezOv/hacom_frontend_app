import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.buttonLabel,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Container(
          padding: EdgeInsets.all(6),
          height: 50,
          alignment: Alignment.center,
          child: isLoading ? CircularProgressIndicator() : Text(buttonLabel),
        ),
      ),
    );
  }
}
