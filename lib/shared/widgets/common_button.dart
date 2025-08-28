import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    this.isLoading = false,
    required this.onPressed,
    required this.buttonLabel,
    this.isOutlined = false,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final String buttonLabel;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: isOutlined
              ? BorderSide(color: Theme.of(context).colorScheme.primary)
              : BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: isOutlined ? Colors.white : Theme.of(context).colorScheme.primary,
        textStyle: Theme.of(context).textTheme.bodyLarge,
        foregroundColor: isOutlined ? Theme.of(context).colorScheme.primary : Colors.white,
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
