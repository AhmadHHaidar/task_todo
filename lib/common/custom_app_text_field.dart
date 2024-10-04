import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:task_app/common/utils.dart';


class CustomTextField extends StatefulWidget {
  final String name;
  final String hint;
  final bool isPassword;
  final Color fillColor;
  final Widget? prefix;
  final AutovalidateMode autovalidateMode;
  final String? Function(String? value)? validator;
  final bool? obscure;
  final double? maxHeight;
  final int? minLines;
  final void Function(String? value)? onChanged;
  final FocusNode? focusNode;
  final Widget? suffix;
  final bool autoFocus;
  final TextEditingController? controller;
  final EdgeInsets? margin;
  final EdgeInsetsDirectional? padding;
  final String? initialValue;
  final TextInputAction? textInputAction;
  final TextInputType? inputType;
  final void Function(String?)? onSubmitted;

  const CustomTextField({
    super.key,
    required this.name,
    required this.hint,
    this.initialValue,
    this.onSubmitted,
    this.inputType,
    this.margin,
    this.padding,
    this.controller,
    this.suffix,
    this.minLines,
    this.focusNode,
    this.onChanged,
    this.maxHeight,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.validator,
    this.prefix,
    this.isPassword = false,
    this.autoFocus = false,
    Color? fillColor,
    this.obscure,
    this.textInputAction,
  }) : fillColor = fillColor ?? AppColors.greyLight;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = false;
  bool _thereIsSuffix = false;

  @override
  void initState() {
    if (widget.isPassword) _obscure = true;
    _thereIsSuffix = widget.suffix != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ?? EdgeInsets.only(bottom: 16),
      child: FormBuilderTextField(
        key: widget.key,
        name: widget.name,
        textInputAction: widget.textInputAction,
        initialValue: widget.initialValue,
        focusNode: widget.focusNode,
        autofocus: widget.autoFocus,
        minLines: widget.minLines,
        onChanged: widget.onChanged,
        keyboardType: widget.inputType,
        onSubmitted: widget.onSubmitted,
        inputFormatters: (widget.inputType == TextInputType.number)
            ? <TextInputFormatter>[
          // FilteringTextInputFormatter.deny(RegExp(r'^(?!0)\d+')),
          // FilteringTextInputFormatter.allow(RegExp(r'^0\d*')),
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10)
        ]
            : null,
        controller: widget.controller,
        maxLines: widget.minLines != null ? 3 : 1,
        autovalidateMode: widget.autovalidateMode,
        validator: widget.validator,
        cursorColor: AppColors.red,
        cursorHeight: 20,
        decoration: InputDecoration(
          constraints:
          BoxConstraints(maxHeight: widget.maxHeight ?? double.infinity),
          filled: true,
          fillColor: widget.fillColor,
          errorBorder: OutlineInputBorder(
            borderSide:
            const BorderSide(color: Color.fromARGB(255, 181, 21, 53)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide:
            const BorderSide(color: Color.fromARGB(255, 181, 21, 53)),
            borderRadius: BorderRadius.circular(8),
          ),
          hintText: widget.hint,
          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
            // height: widget.minLines != null ? 2 : null,
            color: AppColors.grey,
          ),
          isDense: true,
          contentPadding: widget.padding ??
              EdgeInsetsDirectional.only(top: 8, bottom: 8, start: 8),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.greyLight),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.red),
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: widget.prefix,
        ),
        textAlignVertical: TextAlignVertical.center,
        obscureText: widget.obscure ?? _obscure,
      ),
    );
  }
}
