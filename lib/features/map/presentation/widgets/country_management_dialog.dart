import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rioko_ni/core/config/app_sizes.dart';
import 'package:rioko_ni/core/injector.dart';
import 'package:rioko_ni/features/map/domain/entities/country.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';

class CountryManagementDialog extends StatefulWidget {
  final Country country;

  const CountryManagementDialog({
    required this.country,
    super.key,
  });

  void show(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => this,
      );
      return;
    }
    showDialog(
      barrierDismissible: false,
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

  bool isPopping = false;

  String get l10n => 'map.countryManagement';

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
    isPopping = false;
    super.initState();
  }

  final GlobalKey _dialogKey = GlobalKey();

  final _cubit = locator<MapCubit>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: onTapOutsideDialog,
      child: _buildDialog(context),
    );
  }

  Dialog _buildDialog(BuildContext context) {
    return Dialog(
      child: Column(
        key: _dialogKey,
        mainAxisSize: MainAxisSize.min,
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
                    onPressed: () {
                      if (widget.country.status == CountryStatus.been) {
                        widget.country.status = CountryStatus.none;
                      } else {
                        widget.country.status = CountryStatus.been;
                      }
                      setState(() {});
                    },
                    label: tr('$l10n.labels.been'),
                    color: CountryStatus.been.color,
                    selected: widget.country.status == CountryStatus.been,
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
                    onPressed: () {
                      if (widget.country.status == CountryStatus.want) {
                        widget.country.status = CountryStatus.none;
                      } else {
                        widget.country.status = CountryStatus.want;
                      }
                      setState(() {});
                    },
                    label: tr('$l10n.labels.want'),
                    color: CountryStatus.want.color,
                    selected: widget.country.status == CountryStatus.want,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 150,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    50 * (1 - _animation.value),
                  ),
                  child: Opacity(opacity: _animation.value, child: child),
                );
              },
              child: _buildButton(
                context,
                icon: FontAwesomeIcons.houseFlag,
                onPressed: () {
                  if (widget.country.status == CountryStatus.lived) {
                    widget.country.status = CountryStatus.none;
                  } else {
                    widget.country.status = CountryStatus.lived;
                  }
                  setState(() {});
                },
                label: tr('$l10n.labels.lived'),
                color: CountryStatus.lived.color,
                selected: widget.country.status == CountryStatus.lived,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onTapOutsideDialog(TapDownDetails details) {
    final pos = details.globalPosition;
    final RenderBox renderBox =
        _dialogKey.currentContext?.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final globalSize = MediaQuery.of(context).size;
    final ({double min, double max}) x = (
      min: (globalSize.width - size.width) / 2,
      max: globalSize.width - (globalSize.width - size.width) / 2
    );
    final ({double min, double max}) y = (
      min: (globalSize.height - size.height) / 2,
      max: globalSize.height - (globalSize.height - size.height) / 2
    );
    final bool inside =
        pos.dx > x.min && pos.dx < x.max && pos.dy > y.min && pos.dy < y.max;
    if (!inside) pop(context);
  }

  void pop(BuildContext context) {
    if (isPopping) return;
    _cubit.updateCountryStatus(
        country: widget.country, status: widget.country.status);
    isPopping = true;
    _controller.reverse();
    Future.delayed(
        const Duration(milliseconds: 450), Navigator.of(context).pop);
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required void Function() onPressed,
    required String label,
    required Color color,
    required bool selected,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AspectRatio(
        aspectRatio: 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.1) : Colors.transparent,
            border: Border.all(
              color: selected ? color : Colors.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radius),
          ),
          margin: const EdgeInsets.all(AppSizes.paddingDouble),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppSizes.paddingDouble),
              Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 35,
              ),
              const SizedBox(height: AppSizes.paddingHalf),
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
              const SizedBox(height: AppSizes.paddingDouble),
            ],
          ),
        ),
      ),
    );
  }
}
