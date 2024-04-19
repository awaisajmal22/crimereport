
import 'package:flutter/material.dart';

class AnimationWidget extends StatefulWidget {
  final Widget widget;
  final Duration duration;
  AnimationWidget({
    required this.widget,
    required this.duration
  });
  @override
  _AnimationWidgetState createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
@override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);


    _animation.addListener(() {
      setState(() {});
    });

   
    _controller.forward();
  }

  @override
  void dispose() {

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: _animation.value,
        child: widget.widget
      
    );
  }
}