import 'package:flutter/material.dart';

typedef TypeSelectedCallback = void Function(String type);

class EmergencyTypeSelector extends StatelessWidget {
  final String selectedType;
  final TypeSelectedCallback onTypeSelected;

  const EmergencyTypeSelector({
    Key? key,
    required this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);

  static const List<String> _defaultTypes = <String>[
    'Fire',
    'Accident',
    'Medical',
    'Crime',
    'Missing Person',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _defaultTypes.map((type) {
        final bool isSelected = type == selectedType;
        return ChoiceChip(
          label: Text(type),
          selected: isSelected,
          onSelected: (_) => onTypeSelected(type),
          selectedColor: Colors.red.shade400,
          backgroundColor: Colors.grey.shade200,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}