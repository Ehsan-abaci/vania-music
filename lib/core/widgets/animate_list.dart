import 'package:flutter/material.dart';

class AnimateList extends StatefulWidget {
   AnimateList({
    super.key,
    required this.child,
    required this.intervalStart,
    required this.keepAlive,
  });
  final Widget child;
  final double intervalStart;
  final bool keepAlive;
  @override
  State<AnimateList> createState() => _AnimateListState();
}

class _AnimateListState extends State<AnimateList>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController animationController;
  late final Animation<Offset> offsetAnimation;
  late final Animation<double> fadeAnimation;
@override
void dispose() {
  animationController.dispose();
  super.dispose();
}
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    Future.delayed(
      const Duration(milliseconds: 100),
    ).then(
      (_) {
      if(mounted) animationController.forward();
      }
        
    );

    Curve intervalCurve = Interval(
      widget.intervalStart,
      1,
      curve: Curves.easeOut,
    );

    offsetAnimation =
        Tween<Offset>(begin: const Offset(0, 30), end: Offset.zero).animate(
      CurvedAnimation(parent: animationController, curve: intervalCurve),
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: intervalCurve),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => FadeTransition(
        opacity: fadeAnimation,
        child: Transform.translate(
          offset: offsetAnimation.value,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
