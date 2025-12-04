import 'package:flutter/material.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';
import 'package:dreamdwell/core/theme/app_colors.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({
    super.key,
    this.onSelect,
    required this.initialValue,
    this.validator,
    required this.hintText,
    this.showSearch = true,
    this.label,
  });

  final String hintText;
  final Function(String?)? onSelect;
  final List<String> initialValue;
  final String? Function(String?)? validator;
  final bool showSearch;
  final String? label;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  TextEditingController searchController = TextEditingController();
  bool isMenuOpen = false;
  List<String> filteredItems = [];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    filteredItems = widget.initialValue;
    if (widget.showSearch) {
      searchController.addListener(_filterItems);
    }
  }

  void _filterItems() {
    setState(() {
      filteredItems =
          widget.initialValue
              .where(
                (value) => value.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          BodySmall(
            widget.label ?? '',
            color: AppColor.upholdGrey2,
            fontWeight: FontWeight.w500,
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.neutral),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isMenuOpen = !isMenuOpen;
                  });
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColor.upholdGrey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    suffixIcon: Icon(
                      isMenuOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    ),
                    contentPadding: EdgeInsets.only(left: 10, top: 12),
                  ),
                  child: BodySmall(
                    selectedValue ?? widget.hintText,
                    color:
                        selectedValue != null
                            ? Colors.black
                            : AppColor.upholdGrey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (isMenuOpen)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      if (widget.showSearch) // Conditional search field
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(color: AppColor.lightText),
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.withAlpha(40),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.withAlpha(40),
                                ),
                              ),
                              fillColor: AppColor.neutral.withAlpha(60),
                              filled: true,
                            ),
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final value = filteredItems[index];
                            return ListTile(
                              title: BodySmall(value),
                              onTap: () {
                                setState(() {
                                  selectedValue = value;
                                  isMenuOpen = false;
                                });
                                widget.onSelect?.call(value);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
