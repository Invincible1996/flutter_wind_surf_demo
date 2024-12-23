import 'package:flutter/material.dart';

class CustomDataTableColumn {
  final String label;
  final String? tooltip;
  final bool numeric;
  final bool filterable;
  final Widget Function(dynamic)? customCell;

  const CustomDataTableColumn({
    required this.label,
    this.tooltip,
    this.numeric = false,
    this.filterable = true,
    this.customCell,
  });
}

class CustomDataTable extends StatefulWidget {
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
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  final Map<String, TextEditingController> _filterControllers = {};
  List<Map<String, dynamic>> _filteredRows = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each filterable column
    for (var column in widget.columns) {
      if (column.filterable && column.customCell == null) {
        _filterControllers[column.label.toLowerCase()] =
            TextEditingController();
      }
    }
    _filteredRows = widget.rows;
  }

  @override
  void dispose() {
    for (final controller in _filterControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredRows = widget.rows.where((row) {
        return _filterControllers.entries.every((entry) {
          final value = row[entry.key]?.toString().toLowerCase() ?? '';
          final filter = entry.value.text.toLowerCase();
          return filter.isEmpty || value.contains(filter);
        });
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      for (final controller in _filterControllers.values) {
        controller.clear();
      }
      _filteredRows = widget.rows;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_filterControllers.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        ..._filterControllers.entries.map(
                          (entry) => SizedBox(
                            width: 200,
                            child: TextField(
                              controller: entry.value,
                              decoration: InputDecoration(
                                labelText: widget.columns
                                    .firstWhere((col) =>
                                        col.label.toLowerCase() == entry.key)
                                    .label,
                                border: const OutlineInputBorder(),
                                isDense: true,
                              ),
                              onChanged: (_) => _applyFilters(),
                            ),
                          ),
                        ),
                        // apply button
                        ElevatedButton.icon(
                          onPressed: _applyFilters,
                          icon: const Icon(Icons.search),
                          label: const Text('Apply'),
                        ),
                        // reset button
                        ElevatedButton.icon(
                          onPressed: _resetFilters,
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  // 添加 Card 包装
                  elevation: 1, // 设置阴影
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: widget.borderColor.withOpacity(0.1)), // 减淡边框颜色
                      borderRadius: BorderRadius.circular(12), // 圆角
                    ),
                    child: ClipRRect(
                      // 使用 ClipRRect 确保内容不会超出圆角
                      borderRadius: BorderRadius.circular(12),
                      child: DataTable(
                        headingRowHeight: 56, // 增加表头高度
                        dataRowMinHeight: 52, // 更新为 dataRowMinHeight
                        dataRowMaxHeight: 52, // 添加 dataRowMaxHeight
                        headingRowColor: WidgetStateProperty.all(
                            Colors.grey.shade50), // 更新为 WidgetStateProperty
                        border: TableBorder(
                          horizontalInside: BorderSide(
                              color: widget.borderColor.withOpacity(0.1)),
                          verticalInside: BorderSide(
                              color: widget.borderColor.withOpacity(0.1)),
                        ),
                        columnSpacing: widget.columnSpacing,
                        horizontalMargin: widget.horizontalMargin,
                        columns: widget.columns
                            .map((column) => DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      column.label,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14, // 调整字体大小
                                        color: Colors.black87, // 调整文字颜色
                                      ),
                                    ),
                                  ),
                                  tooltip: column.tooltip,
                                  numeric: column.numeric,
                                ))
                            .toList(),
                        rows: _filteredRows
                            .map((row) => DataRow(
                                  cells: widget.columns.map((column) {
                                    if (column.customCell != null) {
                                      return DataCell(
                                        Center(
                                            child: column.customCell!(row[
                                                column.label.toLowerCase()])),
                                      );
                                    }
                                    return DataCell(
                                      Center(
                                        child: Text(
                                          row[column.label.toLowerCase()]
                                                  ?.toString() ??
                                              '',
                                          style: const TextStyle(
                                            fontSize: 14, // 调整数据文字大小
                                            color: Colors.black54, // 调整数据文字颜色
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
