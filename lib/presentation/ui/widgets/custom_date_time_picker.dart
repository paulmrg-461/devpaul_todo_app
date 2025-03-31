import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef DateTimeChangedCallback = void Function(DateTime newDateTime);

class CustomDateTimePicker extends StatefulWidget {
  final String hintText;
  final DateTime? initialDateTime;
  final DateTimeChangedCallback onDateTimeChanged;
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

  const CustomDateTimePicker({
    super.key,
    required this.hintText,
    this.initialDateTime,
    required this.onDateTimeChanged,
    this.width,
    this.borderRadius = 8,
    this.backgroundColor,
    this.borderColor,
    this.fontColor,
    this.contentPadding = 14,
    this.marginLeft = 4,
    this.marginTop = 4,
    this.marginRight = 4,
    this.marginBottom = 8,
    this.icon,
  });

  @override
  State<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  Future<void> _pickDateTime() async {
    // Seleccionar fecha
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Seleccionar hora
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedDateTime != null
            ? TimeOfDay.fromDateTime(_selectedDateTime!)
            : TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _selectedDateTime = newDateTime;
        });
        widget.onDateTimeChanged(newDateTime);
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    // Formato dd/MM/yyyy HH:mm (puedes utilizar intl para un formateo más avanzado)
    return "${dateTime.day.toString().padLeft(2, '0')}/"
        "${dateTime.month.toString().padLeft(2, '0')}/"
        "${dateTime.year} "
        "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveBackgroundColor =
        widget.backgroundColor ?? colorScheme.surface;
    final effectiveBorderColor =
        widget.borderColor ?? colorScheme.primary.withOpacity(0.4);
    final effectiveFontColor = widget.fontColor ?? colorScheme.onSurface;
    Color getIconColor() => widget.borderColor ?? colorScheme.primary;

    return GestureDetector(
      onTap: _pickDateTime,
      child: Container(
        width: widget.width,
        margin: EdgeInsets.only(
          left: widget.marginLeft,
          top: widget.marginTop,
          right: widget.marginRight,
          bottom: widget.marginBottom,
        ),
        padding: EdgeInsets.symmetric(
          vertical: widget.contentPadding,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: effectiveBorderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            if (widget.icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(widget.icon, color: getIconColor(), size: 20),
              ),
            Expanded(
              child: Text(
                _selectedDateTime != null
                    ? _formatDateTime(_selectedDateTime!)
                    : widget.hintText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: effectiveFontColor,
                        ) ??
                    GoogleFonts.inter(
                      fontSize: 12,
                      color: effectiveFontColor,
                    ),
              ),
            ),
            const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
