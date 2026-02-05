import 'package:flutter/material.dart';
import 'dart:math' as math;

/// CRED-style animated flip tag widget
class FlipTag extends StatefulWidget {
  final String bottomTagText;
  final String footerText;
  final bool flipperConfig;

  const FlipTag({
    super.key,
    required this.bottomTagText,
    required this.footerText,
    required this.flipperConfig,
  });

  @override
  State<FlipTag> createState() => _FlipTagState();
}

class _FlipTagState extends State<FlipTag> {
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    if (widget.flipperConfig) {
      _startFlipping();
    }
  }

  void _startFlipping() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && widget.flipperConfig) {
        setState(() {
          _showFront = !_showFront;
        });
        _startFlipping();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.flipperConfig) {
      // Static display - show status tag
      return _buildStatusTag(widget.footerText, _getStatusColor(widget.footerText));
    }

    // Animated vertical flip between bottomTagText and footerText
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Vertical flip animation
        final rotateAnim = Tween(begin: math.pi / 2, end: 0.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        );
        
        return AnimatedBuilder(
          animation: rotateAnim,
          child: child,
          builder: (context, child) {
            final isUnder = (ValueKey(_showFront) != child!.key);
            final value = isUnder
                ? math.min(rotateAnim.value, math.pi / 2)
                : rotateAnim.value;
            
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateX(value),
              alignment: Alignment.center,
              child: child,
            );
          },
        );
      },
      child: _showFront
          ? _buildStatusTag(
              widget.bottomTagText,
              _getStatusColor(widget.bottomTagText),
              key: const ValueKey(true),
            )
          : _buildStatusTag(
              widget.footerText,
              _getStatusColor(widget.footerText),
              key: const ValueKey(false),
            ),
    );
  }

  Widget _buildStatusTag(String text, Color color, {Key? key}) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getStatusColor(String text) {
    final lowerText = text.toLowerCase();
    if (lowerText.contains('overdue')) {
      return const Color(0xFFE53935); // Red
    } else if (lowerText.contains('due today') || lowerText.contains('today')) {
      return const Color(0xFFFB8C00); // Orange
    } else if (lowerText.contains('paid')) {
      return const Color(0xFF43A047); // Green
    }
    return const Color(0xFFFB8C00); // Default orange
  }
}
