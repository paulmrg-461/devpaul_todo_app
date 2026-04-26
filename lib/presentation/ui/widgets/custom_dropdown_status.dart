import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef TaskStatusCallback = void Function(TaskStatus? selectedStatus);

class CustomDropdownStatus extends StatelessWidget {
  final String labelText;
  final List<TaskStatus> statuses;
  final TaskStatus? value;
  final TaskStatusCallback? onChanged;
  final double? width;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? fontColor;
  final double contentPadding;
  final double marginLeft;
  final double marginTop;
  final double marginRight;
  final double marginBottom;
  final IconData? icon;

  const CustomDropdownStatus({
    super.key,
    required this.labelText,
    required this.statuses,
    this.value,
    this.onChanged,
    this.width,
    this.borderRadius = 8,
    this.backgroundColor,
    this.borderColor,
    this.fontColor,
    this.contentPadding = 14,
    this.marginLeft = 4,
    this.marginTop = 4,
    this.marginRight = 4,
    this.marginBottom = 12,
    this.icon,
  });

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pendiente';
      case TaskStatus.inProgress:
        return 'En Progreso';
      case TaskStatus.completed:
        return 'Realizada';
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.pending;
      case TaskStatus.inProgress:
        return Icons.play_circle;
      case TaskStatus.completed:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
    final effectiveBorderColor =
        borderColor ?? colorScheme.primary.withOpacity(0.4);
    Color getIconColor() => borderColor ?? colorScheme.primary;
    Color getFontColor() => fontColor ?? colorScheme.onSurface;

    return Container(
      width: width,
      margin: EdgeInsets.only(
        left: marginLeft,
        top: marginTop,
        right: marginRight,
        bottom: marginBottom,
      ),
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
      child: DropdownButtonFormField<TaskStatus>(
        value: value,
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: contentPadding,
            horizontal: 12,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: effectiveBorderColor.withOpacity(0.8),
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
          labelStyle: textTheme.bodySmall?.copyWith(
                color: getFontColor().withOpacity(0.6),
              ) ??
              GoogleFonts.inter(
                color: getFontColor().withOpacity(0.6),
              ),
          floatingLabelStyle: TextStyle(color: effectiveBorderColor),
          hintStyle: textTheme.bodySmall?.copyWith(
                color: getFontColor().withOpacity(0.4),
              ) ??
              GoogleFonts.inter(
                color: getFontColor().withOpacity(0.4),
              ),
          counterText: '',
          fillColor: effectiveBackgroundColor,
          filled: true,
        ),
        items: statuses.map((status) {
          return DropdownMenuItem<TaskStatus>(
            value: status,
            child: Row(
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(icon, color: getIconColor(), size: 20),
                  ),
                Text(
                  _getStatusText(status),
                  style: textTheme.bodySmall?.copyWith(
                        color: getFontColor(),
                        fontSize: 12,
                      ) ??
                      GoogleFonts.inter(
                        color: getFontColor(),
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
