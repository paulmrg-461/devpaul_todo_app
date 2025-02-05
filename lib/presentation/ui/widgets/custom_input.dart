import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInput extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final IconData? icon;
  final bool? passwordVisibility;
  final TextInputType? textInputType;
  final bool? obscureText;
  final TextCapitalization? textCapitalization;
  final bool? enabledInputInteraction;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? fontColor;
  final int? minLines;
  final int? maxLines;
  final int? maxLenght;
  final bool? expands;
  final double? width;
  final double? marginBottom;
  final double marginLeft;
  final double marginRight;
  final double marginTop;
  final double contentPadding;
  final bool isNumeric;

  const CustomInput({
    super.key,
    required this.hintText,
    required this.controller,
    this.onSaved,
    this.validator,
    this.icon,
    this.passwordVisibility = false,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    this.enabledInputInteraction = true,
    this.textCapitalization = TextCapitalization.none,
    this.borderRadius = 8,
    this.backgroundColor = Colors.white,
    this.borderColor = CustomTheme.primaryColor,
    this.fontColor = Colors.black87,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLenght,
    this.expands = false,
    this.width,
    this.marginBottom = 4,
    this.marginTop = 4,
    this.marginLeft = 4,
    this.marginRight = 4,
    this.contentPadding = 14,
    this.isNumeric = false,
  });

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool passwordObscure = true;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder getBorder({
      required Color borderColor,
      required double borderWidth,
    }) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius!),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );

    return Container(
      width: widget.width,
      margin: EdgeInsets.only(
        left: widget.marginLeft,
        top: widget.marginTop,
        right: widget.marginRight,
        bottom: widget.marginBottom!,
      ),
      decoration: BoxDecoration(
        color: widget.backgroundColor!,
        borderRadius: BorderRadius.circular(widget.borderRadius!),
      ),
      child: TextFormField(
        controller: widget.controller,
        onSaved: widget.onSaved,
        validator: widget.validator,
        minLines: widget.minLines!,
        maxLines: widget.maxLines!,
        maxLength: widget.maxLenght,
        expands: widget.expands!,
        style: GoogleFonts.inter(
          color: widget.fontColor!,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        autocorrect: false,
        keyboardType: widget.textInputType,
        obscureText: (widget.obscureText! && passwordObscure) ? true : false,
        enabled: widget.enabledInputInteraction,
        textCapitalization: widget.textCapitalization!,
        inputFormatters:
            widget.isNumeric
                ? <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*$')),
                ]
                : null,
        decoration: InputDecoration(
          isCollapsed: true,
          prefixIcon: Icon(widget.icon, color: widget.borderColor, size: 20),
          suffixIcon:
              widget.passwordVisibility!
                  ? IconButton(
                    color: widget.borderColor,
                    iconSize: 20,
                    icon: Icon(
                      passwordObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed:
                        () => setState(() {
                          passwordObscure = !passwordObscure;
                        }),
                  )
                  : null,
          contentPadding: EdgeInsets.symmetric(vertical: widget.contentPadding),
          focusedBorder: getBorder(
            borderColor: widget.borderColor!,
            borderWidth: 1.2,
          ),
          border: getBorder(
            borderColor: widget.borderColor ?? CustomTheme.primaryColor,
            borderWidth: 0.75,
          ),
          errorBorder: getBorder(
            borderColor: Colors.red.shade800,
            borderWidth: 0.75,
          ),
          focusedErrorBorder: getBorder(
            borderColor: Colors.red.shade800,
            borderWidth: 1.2,
          ),
          labelText: widget.hintText,
          labelStyle: TextStyle(color: widget.fontColor!, fontSize: 12),
          counterText: '',
        ),
      ),
    );
  }
}
