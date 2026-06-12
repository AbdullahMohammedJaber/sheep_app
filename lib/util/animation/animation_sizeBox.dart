// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/widgets.dart';

class AnimatedSizeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  const AnimatedSizeWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  _AnimatedSizeWidgetState createState() => _AnimatedSizeWidgetState();
}

class _AnimatedSizeWidgetState extends State<AnimatedSizeWidget>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      //vsync: this,
      duration: widget.duration,
      curve: Curves.easeInOut,
      child: widget.child,
    );
  }
}
