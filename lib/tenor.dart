import 'package:flutter/material.dart';

class DropdownTenor extends StatefulWidget {
  @override
  _DropdownTenorState createState() => _DropdownTenorState();
}

class _DropdownTenorState extends State<DropdownTenor>
    with SingleTickerProviderStateMixin {
  String? _selectedMonth;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpened = false;
  late AnimationController _arrowController;

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2), 
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), 
        child: Padding(
          padding: const EdgeInsets.only(top: 40), 
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.wallet_rounded, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        "Tenor",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  CompositedTransformTarget(
                    link: _layerLink,
                    child: GestureDetector(
                      onTap: () {
                        if (_isDropdownOpened) {
                          _arrowController.reverse(); 
                          _removeOverlay();
                        } else {
                          _arrowController.forward(); 
                          _showOverlay();
                        }
                        setState(() {
                          _isDropdownOpened = !_isDropdownOpened;
                        });
                      },
                      child: Container(
                        height: 40, 
                        width: double.infinity, 
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedMonth ?? "Pilih bulan",
                              style: TextStyle(
                                color: _isDropdownOpened || _selectedMonth != null
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _arrowController,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _arrowController.value * 3.14,
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: _isDropdownOpened ? Colors.green : Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 435, 
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, 50), 
          showWhenUnlinked: false,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: List.generate(12, (index) {
                String monthText = "Bulan ${index + 1}";
                return ListTile(
                  title: Text(
                    monthText,
                    style: TextStyle(
                      color: _selectedMonth == monthText
                          ? Colors.green
                          : Colors.black,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedMonth = monthText;
                      _isDropdownOpened = false;
                    });
                    _arrowController.reverse();
                    _removeOverlay();
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DropdownTenor(),
  ));
}
