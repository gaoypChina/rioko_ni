import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rioko_ni/core/config/app_sizes.dart';

class CountryManagementDialog extends StatefulWidget {
  const CountryManagementDialog({super.key});

  void show(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => this,
      );
      return;
    }
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => this,
    );
  }

  @override
  State<CountryManagementDialog> createState() =>
      _CountryManagementDialogState();
}

class _CountryManagementDialogState extends State<CountryManagementDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastEaseInToSlowEaseOut,
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      _controller.forward();
    });

    _animation.addListener(() {
      if (_animation.value >= 0.4) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      -50 * (1 - _animation.value),
                      0,
                    ),
                    child: Opacity(opacity: _animation.value, child: child),
                  );
                },
                child: _buildButton(
                  context,
                  icon: FontAwesomeIcons.trophy,
                  onPressed: () {},
                  label: "Been",
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    -50 * (1 - _animation.value),
                  ),
                  child: Opacity(opacity: _animation.value, child: child),
                );
              },
              child: const SizedBox(
                height: 50,
                child: VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),
              ),
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      50 * (1 - _animation.value),
                      0,
                    ),
                    child: Opacity(opacity: _animation.value, child: child),
                  );
                },
                child: _buildButton(
                  context,
                  icon: FontAwesomeIcons.suitcase,
                  onPressed: () {},
                  label: "Want to",
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required void Function() onPressed,
    required String label,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingQuintuple),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 35,
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: _animation.value > 0.4 ? 1 : 0,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                label,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
