import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';
import 'package:dreamdwell/core/theme/app_colors.dart';

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
  final FocusNode _searchFocusNode = FocusNode();
  String? _selectedLocation;
  String? _selectedPropertyType;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
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
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: _searchController.text.isNotEmpty
                  ? Border.all(color: AppColor.primary.withValues(alpha: 0.3))
                  : null,
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (value) {
                setState(() {}); // Only update UI, don't search yet
                _performSearch(); // Debounced search
              },
              onSubmitted: (value) => _performImmediateSearch(),
              decoration: InputDecoration(
                hintText: 'Search properties...',
                prefixIcon: Icon(
                  Icons.search, 
                  color: _searchController.text.isNotEmpty 
                      ? AppColor.primary 
                      : Colors.grey,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {});
                          _performImmediateSearch();
                        },
                        child: Icon(
                          Icons.clear,
                          color: Colors.grey[600],
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Filter Row
          Row(
            children: [
              // Location Filter
              Expanded(
                child: _buildFilterDropdown(
                  'Location',
                  _selectedLocation,
                  ['All Locations', ...widget.availableLocations],
                  (value) {
                    setState(() {
                      _selectedLocation = value == 'All Locations' ? null : value;
                    });
                    _performImmediateSearch();
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Property Type Filter
              Expanded(
                child: _buildFilterDropdown(
                  'Type',
                  _selectedPropertyType,
                  ['All Types', ...widget.availablePropertyTypes],
                  (value) {
                    setState(() {
                      _selectedPropertyType = value == 'All Types' ? null : value;
                    });
                    _performImmediateSearch();
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Clear Filters Button - only show when there are active filters
              if (_hasActiveFilters)
                GestureDetector(
                  onTap: _clearFilters,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.clear,
                      color: AppColor.primary,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String hint,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: BodySmall(hint, color: Colors.grey[600]),
          value: selectedValue,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item == 'All Locations' || item == 'All Types' ? null : item,
              child: BodySmall(
                item,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
