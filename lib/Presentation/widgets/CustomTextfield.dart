import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomTextField extends StatefulWidget {
  final String placeHolder;
  final String name;
  final String? labelName;
  final List<String>? autofillHints;
  final bool? loginField;
  final TextStyle? style;
  final Color? color;
  final bool? readOnly;
  final bool? enable;
  final int? Maxlength;
  final String? CounterText;
  final void Function()? onTap;
  final String? initialValue;
  final TextInputType? keyBoardType;
  final List<TextInputFormatter>? inputformat;
  final TextEditingController? textEditingController;
  final Icon? icon;
  final IconButton? suffixIcon;
  final List<String? Function(String?)>? validators;
  final Function(String?)? onChanged;
  final TextInputAction? textInputAction;
  final bool? required;
  final int? MaxLines;
  final bool? isLarge;
  final FocusNode? textfieldFocus;

  // 👇 New property
  final bool isPasswordField;

  const CustomTextField({
    super.key,
    required this.name,
    required this.placeHolder,
    this.icon,
    this.MaxLines,
    this.labelName,
    this.style,
    this.color,
    this.Maxlength,
    this.CounterText,
    this.loginField = false,
    this.validators,
    this.initialValue,
    this.keyBoardType,
    this.textEditingController,
    this.suffixIcon,
    this.inputformat,
    this.readOnly = false,
    this.onChanged,
    this.autofillHints,
    this.onTap,
    this.isLarge = false,
    this.enable = true,
    this.textInputAction,
    this.textfieldFocus,
    this.required = false,
    this.isPasswordField = false, // 👈 Default false
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPasswordField;
  }

  @override
  Widget build(BuildContext context) {
    final mergedValidators = [
      if (widget.validators != null) ...widget.validators!,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelName != null) ...[
          Row(
            children: [
              Text(widget.labelName!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorLight,
                  )),
              SizedBox(width: 5.w),
              if (widget.required!)
                Text('*', style: TextStyle(color: Colors.red.shade400)),
            ],
          ),
          SizedBox(height: 6.h),
        ],
        FormBuilderTextField(
          key: Key(widget.name),
          name: widget.name,
          focusNode: widget.textfieldFocus,
          maxLength: widget.Maxlength,
          maxLines: widget.isLarge! ? 5 : (widget.MaxLines ?? 1),
          onTap: widget.onTap,
          enabled: widget.enable!,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.textEditingController,
          autofillHints: widget.autofillHints,
          initialValue: widget.initialValue,
          style: widget.style,
          inputFormatters: widget.inputformat,
          keyboardType:
          widget.keyBoardType ?? TextInputType.text,
          textInputAction: widget.textInputAction,
          readOnly: widget.readOnly!,
          obscureText: widget.isPasswordField ? _obscureText : false, // 👈

          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: widget.color ?? Colors.black26,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Theme.of(context).focusColor,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.0,
              ),
            ),
            counterText: widget.CounterText,
            errorStyle: TextStyle(
              color: widget.loginField! ? Colors.red : Colors.red,
            ),
            hintText: widget.placeHolder,
            hintStyle: TextStyle(fontSize: 11.5.sp),
            prefixIcon: widget.icon,
            fillColor: Theme.of(context).cardColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.0).r,
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 7.0,
              horizontal: 10.0,
            ).r,

            // 👇 Password field toggle logic
            suffixIcon: widget.isPasswordField
                ? IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey,
              ),

              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : widget.suffixIcon,
          ),
          validator: FormBuilderValidators.compose(mergedValidators),
          onChanged: widget.onChanged,
        ),
        SizedBox(height: 15.h),
      ],
    );
  }
}
