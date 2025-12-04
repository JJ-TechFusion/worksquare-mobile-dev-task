import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';
import 'package:dreamdwell/core/shared/widgets/textfields/custom_field.dart';
import 'package:dreamdwell/core/theme/app_colors.dart';
import 'package:dreamdwell/core/utils/constant.dart';

class SearchFilterBar extends StatefulWidget {
  final Function(String query, String? location, String? propertyType) onSearch;
  final List<String> availableLocations;
  final List<String> availablePropertyTypes;

  const SearchFilterBar({
    super.key,
    required this.onSearch,
    required this.availableLocations,
    required this.availablePropertyTypes,
  });

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedLocation;
  String? _selectedPropertyType;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _performSearch() {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Start new timer with 500ms delay
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(
        _searchController.text,
        _selectedLocation,
        _selectedPropertyType,
      );
    });
  }

  void _performImmediateSearch() {
    _debounceTimer?.cancel();
    widget.onSearch(
      _searchController.text,
      _selectedLocation,
      _selectedPropertyType,
    );
  }

  void _clearFilters() {
    _debounceTimer?.cancel();
    setState(() {
      _searchController.clear();
      _selectedLocation = null;
      _selectedPropertyType = null;
    });
    widget.onSearch('', null, null);
  }

  bool get _hasActiveFilters {
    return _searchController.text.isNotEmpty ||
        _selectedLocation != null ||
        _selectedPropertyType != null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          TextInputField(
            hintText: 'Search properties by title or location...',
            controller: _searchController,
            prefixIcon: const Icon(Icons.search),
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {});
                        _performImmediateSearch();
                      },
                      child: const Icon(Icons.clear, color: Colors.grey),
                    )
                    : null,
            onChanged: (value) {
              setState(() {});
              _performSearch(); // Debounced search
            },
            onEditingDone: _performImmediateSearch,
          ),

          Row(
            children: [
              Expanded(
                child: _buildCompactDropdown(
                  label: 'Location',
                  hint: 'All Locations',
                  value: _selectedLocation,
                  items: ['All Locations', ...widget.availableLocations],
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation =
                          value == 'All Locations' ? null : value;
                    });
                    _performImmediateSearch();
                  },
                ),
              ),

              horizontalSpace(16),

              Expanded(
                child: _buildCompactDropdown(
                  label: 'Property Type',
                  hint: 'All Types',
                  value: _selectedPropertyType,
                  items: ['All Types', ...widget.availablePropertyTypes],
                  onChanged: (value) {
                    setState(() {
                      _selectedPropertyType =
                          value == 'All Types' ? null : value;
                    });
                    _performImmediateSearch();
                  },
                ),
              ),
            ],
          ),

          if (_hasActiveFilters) ...[
            verticalSpace(12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear, size: 18),
                label: const BodyText('Clear All Filters'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.primary,
                  side: BorderSide(
                    color: AppColor.primary.withValues(alpha: 0.3),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodySmall(
          label,
          color: AppColor.upholdGrey2,
          fontWeight: FontWeight.w500,
        ),
        verticalSpace(8),
        GestureDetector(
          onTap:
              () => _showDropdownModal(
                context: context,
                title: label,
                items: items,
                selectedValue: value,
                hint: hint,
                onSelected: onChanged,
              ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.upholdGrey.withAlpha(90)),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: BodySmall(
                    value ?? hint,
                    color:
                        value != null
                            ? AppColor.primaryText
                            : AppColor.upholdGrey,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: AppColor.upholdGrey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDropdownModal({
    required BuildContext context,
    required String title,
    required List<String> items,
    required String? selectedValue,
    required String hint,
    required Function(String?) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    H3(title),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Items list
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected =
                        item == selectedValue ||
                        (selectedValue == null && item == hint);

                    return ListTile(
                      title: BodyText(
                        item,
                        color:
                            isSelected
                                ? AppColor.primary
                                : AppColor.primaryText,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      trailing:
                          isSelected
                              ? Icon(
                                Icons.check,
                                color: AppColor.primary,
                                size: 20,
                              )
                              : null,
                      onTap: () {
                        Navigator.pop(context);
                        onSelected(item == hint ? null : item);
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        );
      },
    );
  }
}
