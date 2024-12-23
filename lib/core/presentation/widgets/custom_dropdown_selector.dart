import 'package:flutter/material.dart';

class DropdownController extends ChangeNotifier {
  String? _expandedId;

  String? get expandedId => _expandedId;

  void expand(String id) {
    _expandedId = id;
    notifyListeners();
  }

  void collapse() {
    _expandedId = null;
    notifyListeners();
  }

  bool isExpanded(String id) => _expandedId == id;
}

class CustomDropdownSelector extends StatefulWidget {
  final List<String> items;
  final String title;
  final Function(String) onItemSelected;
  final String? initialValue;
  final DropdownController? controller;

  const CustomDropdownSelector({
    super.key,
    required this.items,
    required this.title,
    required this.onItemSelected,
    this.initialValue,
    this.controller,
  });

  @override
  State<CustomDropdownSelector> createState() => _CustomDropdownSelectorState();
}

class _CustomDropdownSelectorState extends State<CustomDropdownSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late String _selectedItem;
  OverlayEntry? _overlayEntry;
  final String _id = UniqueKey().toString();

  bool get _isExpanded => widget.controller?.isExpanded(_id) ?? false;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue ?? widget.items.first;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    widget.controller?.addListener(_handleControllerChange);
  }

  void _handleControllerChange() {
    final bool shouldBeExpanded = widget.controller?.isExpanded(_id) ?? false;
    if (shouldBeExpanded) {
      _open();
    } else {
      _close();
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChange);
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isExpanded) {
      widget.controller?.collapse();
    } else {
      widget.controller?.expand(_id);
    }
  }

  void _close() {
    _animationController.reverse().whenComplete(() {
      _removeOverlay();
    });
  }

  void _open() {
    _showOverlay();
    _animationController.forward();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _expandAnimation,
                builder: (context, child) => GestureDetector(
                  onTap: () => widget.controller?.collapse(),
                  child: Container(
                    color:
                        Colors.black.withOpacity(0.3 * _expandAnimation.value),
                  ),
                ),
              ),
            ),
            Positioned(
              top: offset.dy + size.height,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _expandAnimation,
                builder: (context, child) {
                  return ClipRect(
                    child: Align(
                      heightFactor: _expandAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  color: Colors.white,
                  child: _buildDropdownList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedItem,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.items.map((item) => _buildDropdownItem(item)).toList(),
    );
  }

  Widget _buildDropdownItem(String item) {
    final bool isSelected = _selectedItem == item;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedItem = item;
        });
        widget.onItemSelected(item);
        widget.controller?.collapse();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.1),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: Colors.blue,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
