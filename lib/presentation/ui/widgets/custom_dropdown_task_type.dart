import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef TaskTypeCallback = void Function(TaskType? selectedType);

class CustomDropdownType extends StatelessWidget {
  final String labelText;
  final List<TaskType> types;
  final TaskType? value;
  final TaskTypeCallback? onChanged;
  final double width;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double contentPadding;
  final double marginBottom;
  final IconData? icon;

  const CustomDropdownType({
    super.key,
    required this.labelText,
    required this.types,
    this.value,
    this.onChanged,
    this.width = 220,
    this.borderRadius = 8,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.contentPadding = 14,
    this.marginBottom = 12,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
    final effectiveBorderColor =
        borderColor ?? colorScheme.primary.withOpacity(0.4);
    final effectiveTextColor = textColor ?? colorScheme.onSurface;

    Color getIconColor() => borderColor ?? colorScheme.primary;

    return Container(
      width: width,
      margin: EdgeInsets.only(bottom: marginBottom),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: effectiveBorderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: DropdownButtonFormField<TaskType>(
        value: value,
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: contentPadding,
            horizontal: 12,
          ),
          prefixIcon:
              icon != null ? Icon(icon, color: getIconColor(), size: 20) : null,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: effectiveBorderColor.withOpacity(0.4),
              width: 0.6,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: effectiveBorderColor.withOpacity(0.4),
              width: 0.2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: effectiveBorderColor.withOpacity(0.4),
              width: 0.2,
            ),
          ),
          labelText: labelText,
          labelStyle: theme.textTheme.bodySmall?.copyWith(
                color: effectiveTextColor.withOpacity(0.6),
                fontSize: 14,
              ) ??
              GoogleFonts.inter(
                color: effectiveTextColor.withOpacity(0.6),
                fontSize: 14,
              ),
          floatingLabelStyle: TextStyle(color: effectiveBorderColor),
          hintStyle: theme.textTheme.bodySmall?.copyWith(
                color: effectiveTextColor.withOpacity(0.4),
                fontSize: 14,
              ) ??
              GoogleFonts.inter(
                color: effectiveTextColor.withOpacity(0.4),
                fontSize: 14,
              ),
          counterText: '',
          fillColor: effectiveBackgroundColor,
          filled: true,
        ),
        items: types.map((type) {
          return DropdownMenuItem<TaskType>(
            value: type,
            child: Text(
              type.toString().split('.').last.capitalize(),
              style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: effectiveTextColor,
                  ) ??
                  GoogleFonts.inter(
                    fontSize: 14,
                    color: effectiveTextColor,
                  ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
