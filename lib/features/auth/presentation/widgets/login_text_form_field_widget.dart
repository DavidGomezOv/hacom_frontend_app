import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginTextFormFieldWidget extends StatelessWidget {
  const LoginTextFormFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.obscureText = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;
  final bool obscureText;
  final AutovalidateMode autovalidateMode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      autovalidateMode: autovalidateMode,
      builder: (state) {
        final hasError = state.hasError && state.errorText != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: hasError ? Colors.redAccent : Colors.blueGrey,
                ),
              ),
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                inputFormatters: [
                  if (inputFormatters != null) ...inputFormatters!,
                  if (maxLength != null)
                    LengthLimitingTextInputFormatter(maxLength),
                ],
                decoration: InputDecoration(
                  hintText: hintText,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
                onChanged: (value) => state.didChange(value),
              ),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 8),
                child: Text(
                  state.errorText!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.redAccent),
                ),
              ),
          ],
        );
      },
    );
  }
}
