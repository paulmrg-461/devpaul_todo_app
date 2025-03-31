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
    this.backgroundColor,
    this.borderColor,
    this.fontColor,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLenght,
    this.expands = false,
    this.width,
    this.marginBottom = 8,
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color getBackgroundColor() => widget.backgroundColor ?? colorScheme.surface;
    Color getBorderColor() => widget.borderColor ?? colorScheme.primary;
    Color getFontColor() => widget.fontColor ?? colorScheme.onSurface;
    Color getIconColor() => widget.borderColor ?? colorScheme.primary;

    OutlineInputBorder getBorder({
      required Color borderColor,
      required double borderWidth,
    }) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius!),
          borderSide: BorderSide(
            color: borderColor,
            width: borderWidth,
          ),
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
        color: getBackgroundColor(),
        borderRadius: BorderRadius.circular(widget.borderRadius!),
        boxShadow: [
          BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        onSaved: widget.onSaved,
        validator: widget.validator,
        minLines: widget.minLines!,
        maxLines: widget.maxLines!,
        maxLength: widget.maxLenght,
        expands: widget.expands!,
        style: textTheme.bodyMedium?.copyWith(
              color: getFontColor(),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ) ??
            GoogleFonts.inter(
              color: getFontColor(),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
        autocorrect: false,
        keyboardType: widget.textInputType,
        obscureText: (widget.obscureText! && passwordObscure),
        enabled: widget.enabledInputInteraction,
        textCapitalization: widget.textCapitalization!,
        inputFormatters: widget.isNumeric
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*$')),
              ]
            : null,
        decoration: InputDecoration(
          isCollapsed: true,
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: getIconColor(), size: 20)
              : null,
          suffixIcon: widget.passwordVisibility!
              ? IconButton(
                  color: getIconColor(),
                  iconSize: 20,
                  icon: Icon(
                    passwordObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() {
                    passwordObscure = !passwordObscure;
                  }),
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            vertical: widget.contentPadding,
            horizontal: 12,
          ),
          focusedBorder: getBorder(
            borderColor: getBorderColor().withOpacity(0.8),
            borderWidth: 1.5,
          ),
          border: getBorder(
            borderColor: getBorderColor().withOpacity(0.4),
            borderWidth: 1.0,
          ),
          enabledBorder: getBorder(
            borderColor: getBorderColor().withOpacity(0.4),
            borderWidth: 1.0,
          ),
          errorBorder: getBorder(
            borderColor: colorScheme.error,
            borderWidth: 1.2,
          ),
          focusedErrorBorder: getBorder(
            borderColor: colorScheme.error,
            borderWidth: 1.5,
          ),
          labelText: widget.hintText,
          labelStyle: textTheme.bodySmall?.copyWith(
            color: getFontColor().withOpacity(0.6),
          ),
          floatingLabelStyle: TextStyle(color: getBorderColor()),
          hintStyle: textTheme.bodySmall?.copyWith(
            color: getFontColor().withOpacity(0.4),
          ),
          counterText: '',
          fillColor: getBackgroundColor(),
          filled: true,
        ),
      ),
    );
  }
}
