import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:flutter/material.dart';

typedef SingleSelectCallbackDropdown = void Function(String selectedItem);

class CustomDropdownSearcher extends StatefulWidget {
  final SingleSelectCallbackDropdown? action;
  final String hintText;
  final List<String> optionList;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? textColor;
  final double width;
  final bool? hasTrailing;
  final double marginLeft;
  final double marginTop;
  final double marginRight;
  final double marginBottom;
  final double contentPadding; // vertical padding
  final String? initialValue;
  final double? borderRadius;
  final Color? borderColor;

  const CustomDropdownSearcher({
    super.key,
    required this.hintText,
    required this.optionList,
    this.icon,
    this.iconColor = CustomTheme.primaryColor,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    required this.action,
    required this.width,
    this.hasTrailing = false,
    this.borderRadius = 8,
    this.marginLeft = 4,
    this.marginTop = 4,
    this.marginRight = 4,
    this.marginBottom = 4,
    this.contentPadding = 14,
    this.initialValue,
    this.borderColor,
  });

  @override
  State<CustomDropdownSearcher> createState() => _CustomDropdownSearcherState();
}

class _CustomDropdownSearcherState extends State<CustomDropdownSearcher> {
  late String selectedItem;
  late List<String> filteredOptions;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialValue ?? '';
    filteredOptions = widget.optionList;
    _searchController = TextEditingController();
  }

  @override
  void didUpdateWidget(CustomDropdownSearcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        selectedItem = widget.initialValue ?? '';
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void filterOptions(String query) {
    setState(() {
      filteredOptions = widget.optionList
          .where(
            (option) => option.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  void _showSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(widget.hintText),
            content: SizedBox(
              height: MediaQuery.of(context).size.width * 0.5,
              width: widget.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar...',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onChanged: (query) {
                        setStateDialog(() {
                          filterOptions(query);
                        });
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Divider(thickness: 0.5),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredOptions.length,
                      itemBuilder: (context, index) {
                        final String option = filteredOptions[index];
                        final isSelected = selectedItem == option;
                        return RadioListTile<String>(
                          title: Text(
                            option,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          value: option,
                          groupValue: selectedItem,
                          onChanged: (String? value) {
                            setStateDialog(() {
                              if (value != null) {
                                setState(() => selectedItem = value);
                              }
                            });
                          },
                          dense: true,
                          selected: isSelected,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _clearSearchAndResetOptions();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  _clearSearchAndResetOptions();
                  if (widget.action != null) {
                    widget.action!(selectedItem);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        });
      },
    );
  }

  void _clearSearchAndResetOptions() {
    setState(() {
      _searchController.clear();
      filteredOptions = widget.optionList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveBorderColor =
        widget.borderColor ?? colorScheme.primary.withOpacity(0.4);
    return Stack(
      children: [
        Tooltip(
          message:
              selectedItem.isEmpty ? 'Seleccione una opción' : selectedItem,
          child: GestureDetector(
            onTap: () => _showSelectionDialog(context),
            child: Container(
              width: widget.width,
              margin: EdgeInsets.only(
                left: widget.marginLeft,
                top: widget.marginTop,
                right: widget.marginRight,
                bottom: widget.marginBottom,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: widget.contentPadding,
              ),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius!),
                border: Border.all(color: effectiveBorderColor, width: 1.2),
                boxShadow: [
                  BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  if (widget.icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child:
                          Icon(widget.icon, color: widget.iconColor, size: 20),
                    ),
                  Expanded(
                    child: Text(
                      selectedItem.isEmpty ? widget.hintText : selectedItem,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: widget.textColor),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 20),
                ],
              ),
            ),
          ),
        ),
        // Etiqueta flotante similar a CustomInput
        Positioned(
          left: widget.marginLeft + 12,
          top: widget.marginTop - 8,
          child: Container(
            color: widget.backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              widget.hintText,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: widget.textColor, fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }
}
