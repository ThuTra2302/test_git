import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';

class ShowMorePopup {
  late double _popupWidth;
  late double _popupHeight;

  double arrowHeight = 10.0;
  bool _isDownArrow = true;

  bool _isVisible = false;

  late Widget _body;

  late OverlayEntry _entry;
  late Offset _offset;
  late Rect _showRect;



  VoidCallback? dismissCallback;

  late Size _screenSize;

  BuildContext context;
  late Color _backgroundColor;

  late BorderRadius _borderRadius;
  late EdgeInsetsGeometry _padding;

  ShowMorePopup(this.context,
      {double? height,
        double? width,
        VoidCallback? onDismiss,
        Color? backgroundColor,
        Widget? body,
        TextStyle? textStyle,
        BorderRadius? borderRadius,
        EdgeInsetsGeometry? padding}) {
    dismissCallback = onDismiss;
    _popupHeight = height ?? 200;
    _popupWidth = width ?? 200;
    _body = body ?? const SizedBox.shrink();
    _backgroundColor = backgroundColor ?? const Color(0xFFFFA500);
    _borderRadius = borderRadius ?? BorderRadius.circular(10.0);
    _padding = padding ??EdgeInsets.zero;
  }

  /// Shows a popup near a widget with key [widgetKey] or [rect].
  void show({Rect? rect, GlobalKey? widgetKey}) {
    if (rect == null && widgetKey == null) {
      return;
    }

    _showRect = rect ?? _getWidgetGlobalRect(widgetKey!);
    _screenSize = window.physicalSize / window.devicePixelRatio;

    _calculatePosition(context);

    _entry = OverlayEntry(builder: (context) {
      return buildPopupLayout(_offset);
    });

    Overlay.of(context).insert(_entry);
    _isVisible = true;
  }

  void _calculatePosition(BuildContext context) {
    _offset = _calculateOffset(context);
  }

  /// Returns globalRect of widget with key [key]
  Rect _getWidgetGlobalRect(GlobalKey key) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
        offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }

  /// Returns calculated widget offset using [context]
  Offset _calculateOffset(BuildContext context) {
    double dx = _showRect.left + _showRect.width / 2.0 - _popupWidth / 2.0;
    if (dx < 10.0) {
      dx = 10.0;
    }

    if (dx + _popupWidth > _screenSize.width && dx > 10.0) {
      double tempDx = _screenSize.width - _popupWidth - 10;
      if (tempDx > 10) dx = tempDx;
    }

    double dy = _showRect.top - _popupHeight;
    if (dy <= MediaQuery.of(context).padding.top + 10) {
      // not enough space above, show popup under the widget.
      dy = arrowHeight + _showRect.height + _showRect.top;
      _isDownArrow = false;
    } else {
      dy -= arrowHeight;
      _isDownArrow = true;
    }

    return Offset(dx, dy);
  }

  /// Builds Layout of popup for specific [offset]
  LayoutBuilder buildPopupLayout(Offset offset) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          dismiss();
        },
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              // triangle arrow
              Positioned(
                left: _showRect.left + _showRect.width / 2.0 - 7.5,
                top: _isDownArrow
                    ? offset.dy + _popupHeight
                    : offset.dy - arrowHeight,
                child: CustomPaint(
                  size: Size(15.0, arrowHeight),
                  painter: TrianglePainter(
                      isDownArrow: _isDownArrow, color: _backgroundColor),
                ),
              ),
              // popup content
              Positioned(
                left: offset.dx,
                top: offset.dy,
                child: Container(
                    padding: _padding,
                    width: _popupWidth,
                    height: _popupHeight,
                    decoration: BoxDecoration(
                        color: _backgroundColor,
                        borderRadius: _borderRadius,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF808080),
                            blurRadius: 1.0,
                          ),
                        ]),
                    child: SingleChildScrollView(
                      child: _body
                    )),
              )
            ],
          ),
        ),
      );
    });
  }

  /// Dismisses the popup
  void dismiss() {
    if (!_isVisible) {
      return;
    }
    _entry.remove();
    _isVisible = false;
    dismissCallback?.call();
  }
}

/// [TrianglePainter] is custom painter for drawing a triangle for popup
/// to point specific widget
class TrianglePainter extends CustomPainter {
  bool isDownArrow;
  Color color;

  TrianglePainter({this.isDownArrow = true, required this.color});

  /// Draws the triangle of specific [size] on [canvas]
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();
    paint.strokeWidth = 2.0;
    paint.color = color;
    paint.style = PaintingStyle.fill;

    if (isDownArrow) {
      path.moveTo(0.0, -1.0);
      path.lineTo(size.width, -1.0);
      path.lineTo(size.width / 2.0, size.height);
    } else {
      path.moveTo(size.width / 2.0, 0.0);
      path.lineTo(0.0, size.height + 1);
      path.lineTo(size.width, size.height + 1);
    }

    canvas.drawPath(path, paint);
  }

  /// Specifies to redraw for [customPainter]
  @override
  bool shouldRepaint(CustomPainter customPainter) {
    return true;
  }
}
