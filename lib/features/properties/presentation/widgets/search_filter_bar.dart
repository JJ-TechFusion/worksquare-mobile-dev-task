import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';
import 'package:dreamdwell/core/shared/widgets/dropdown.dart';
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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Field using TextInputField
          TextInputField(
            hintText: 'Search properties by title or location...',
            controller: _searchController,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
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
              setState(() {}); // Update UI for suffix icon
              _performSearch(); // Debounced search
            },
            onEditingDone: _performImmediateSearch,
          ),
          
          verticalSpace(16),
          
          // Filter Row
          Row(
            children: [
              // Location Filter using DropDownWidget
              Expanded(
                child: DropDownWidget(
                  hintText: 'All Locations',
                  label: 'Location',
                  initialValue: ['All Locations', ...widget.availableLocations],
                  showSearch: true,
                  onSelect: (value) {
                    setState(() {
                      _selectedLocation = value == 'All Locations' ? null : value;
                    });
                    _performImmediateSearch();
                  },
                ),
              ),
              
              horizontalSpace(16),
              
              // Property Type Filter using DropDownWidget
              Expanded(
                child: DropDownWidget(
                  hintText: 'All Types',
                  label: 'Property Type',
                  initialValue: ['All Types', ...widget.availablePropertyTypes],
                  showSearch: false,
                  onSelect: (value) {
                    setState(() {
                      _selectedPropertyType = value == 'All Types' ? null : value;
                    });
                    _performImmediateSearch();
                  },
                ),
              ),
            ],
          ),
          
          // Clear Filters Button - only show when there are active filters
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
                  side: BorderSide(color: AppColor.primary.withValues(alpha: 0.3)),
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
}