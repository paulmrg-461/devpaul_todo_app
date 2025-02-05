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
  final (double, double, double, double) marginsTBRL;
  final (double, double, double, double) paddingsTBRL;
  final String? initialValue;
  final double? borderRadius;

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
    this.borderRadius = 10,
    this.marginsTBRL = const (4, 4, 4, 4),
    this.paddingsTBRL = const (11, 11, 6, 6),
    this.initialValue,
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
    // Si el initialValue cambia externamente, actualizamos el selectedItem
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
      filteredOptions =
          widget.optionList
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
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(widget.hintText),
              content: SizedBox(
                height: MediaQuery.of(context).size.width * 0.5,
                width: 420,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
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
          },
        );
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
    return Stack(
      children: [
        Tooltip(
          message:
              selectedItem.isEmpty ? 'Seleccione una opción' : selectedItem,
          child: GestureDetector(
            onTap: () => _showSelectionDialog(context),
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius!),
                border: Border.all(color: Colors.black45, width: 1.2),
                color: widget.backgroundColor,
              ),
              margin: EdgeInsets.only(
                top: widget.marginsTBRL.$1,
                bottom: widget.marginsTBRL.$2,
                right: widget.marginsTBRL.$3,
                left: widget.marginsTBRL.$4,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  if (widget.icon != null)
                    Padding(
                      padding: EdgeInsets.only(
                        top: widget.paddingsTBRL.$1,
                        bottom: widget.paddingsTBRL.$2,
                        right: widget.paddingsTBRL.$3,
                        left: widget.paddingsTBRL.$4,
                      ),
                      child: Icon(widget.icon, color: widget.iconColor),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: widget.paddingsTBRL.$1,
                        bottom: widget.paddingsTBRL.$2,
                        right: widget.paddingsTBRL.$3,
                        left: widget.paddingsTBRL.$4,
                      ),
                      child: Text(
                        selectedItem.isEmpty ? 'Seleccione' : selectedItem,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: -16 + widget.marginsTBRL.$4,
          top: -6 + widget.marginsTBRL.$1,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16, right: 6),
            child: Text(
              widget.hintText,
              style: TextStyle(fontSize: 11, color: widget.textColor),
            ),
          ),
        ),
      ],
    );
  }
}
