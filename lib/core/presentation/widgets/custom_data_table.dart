import 'package:flutter/material.dart';

class CustomDataTableColumn {
  final String label;
  final String? tooltip;
  final bool numeric;
  final Widget Function(dynamic)? customCell;

  const CustomDataTableColumn({
    required this.label,
    this.tooltip,
    this.numeric = false,
    this.customCell,
  });
}

class CustomDataTable extends StatelessWidget {
  final List<CustomDataTableColumn> columns;
  final List<Map<String, dynamic>> rows;
  final double? columnSpacing;
  final double? horizontalMargin;
  final Color borderColor;

  const CustomDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.columnSpacing = 20,
    this.horizontalMargin = 12,
    this.borderColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
          ),
          child: DataTable(
            border: TableBorder(
              horizontalInside: BorderSide(color: borderColor),
              verticalInside: BorderSide(color: borderColor),
              bottom: BorderSide(color: borderColor),
            ),
            columnSpacing: columnSpacing,
            horizontalMargin: horizontalMargin,
            columns: columns.map((column) => DataColumn(
              label: Expanded(
                child: Text(
                  column.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              tooltip: column.tooltip,
              numeric: column.numeric,
            )).toList(),
            rows: rows.map((row) => DataRow(
              cells: columns.map((column) {
                if (column.customCell != null) {
                  return DataCell(
                    Center(child: column.customCell!(row[column.label.toLowerCase()])),
                  );
                }
                return DataCell(
                  Center(
                    child: Text(
                      row[column.label.toLowerCase()]?.toString() ?? '',
                    ),
                  ),
                );
              }).toList(),
            )).toList(),
          ),
        ),
      ),
    );
  }
}
