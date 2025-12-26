import 'package:flutter/material.dart';
import 'package:task_manager_frontend/enum/filter_enum.dart';

class FilterCard extends StatefulWidget {
  final FilterEnum type;
  final Function(String name) callBack;
  final String initialValue; 

  const FilterCard({
    required this.type,
    required this.callBack,
    this.initialValue = "any",
    super.key,
  });

  @override
  State<FilterCard> createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue; 
  }

  @override
  void didUpdateWidget(covariant FilterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.initialValue != widget.initialValue) {
      selectedValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCategory = widget.type == FilterEnum.category;
    final items = isCategory
        ? const [
            DropdownMenuItem(value: "any", child: Text("Any")),
            DropdownMenuItem(value: "scheduling", child: Text("Scheduling")),
            DropdownMenuItem(value: "finance", child: Text("Finance")),
            DropdownMenuItem(value: "technical", child: Text("Technical")),
            DropdownMenuItem(value: "safety", child: Text("Safety")),
            DropdownMenuItem(value: "general", child: Text("General")),
          ]
        : const [
            DropdownMenuItem(value: "any", child: Text("Any")),
            DropdownMenuItem(value: "high", child: Text("High")),
            DropdownMenuItem(value: "medium", child: Text("Medium")),
            DropdownMenuItem(value: "low", child: Text("Low")),
          ];

    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedValue,
          items: items,
          onChanged: (val) {
            if (val == null) return;
            setState(() => selectedValue = val);
            widget.callBack(val);
          },
          icon: const Icon(Icons.arrow_drop_down_rounded),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 14, height: 1.0),
        ),
      ),
    );
  }
}
