import 'package:flutter/material.dart';
import 'package:rioko_ni/core/config/app_sizes.dart';

class AnimatedFAB extends StatefulWidget {
  final Widget icon;
  final void Function() onPressed;
  const AnimatedFAB({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  State<AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 10).chain(
            CurveTween(curve: Curves.easeIn),
          ),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 10, end: 0).chain(
            CurveTween(curve: Curves.easeOut),
          ),
          weight: 50,
        ),
      ],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_animation.value),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          if (!_controller.isAnimating) {
            _controller.reset();
            _controller.forward();
          }
          widget.onPressed();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background.withOpacity(0.7),
            border: Border.all(color: Theme.of(context).colorScheme.onPrimary),
            borderRadius: BorderRadius.circular(AppSizes.bigRadius),
          ),
          padding: const EdgeInsets.all(AppSizes.paddingDouble),
          child: widget.icon,
        ),
      ),
    );
  }
}
