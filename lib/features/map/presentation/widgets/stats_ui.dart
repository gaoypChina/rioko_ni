import 'package:flutter/material.dart';
import 'package:rioko_ni/core/config/app_sizes.dart';

class StatsUI extends StatelessWidget {
  final int been;
  final int want;
  final int notWant;

  const StatsUI({
    required this.been,
    required this.want,
    required this.notWant,
    super.key,
  });

  TextStyle get style => const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Container(
            height: 50,
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.all(AppSizes.paddingTriple),
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.padding,
              horizontal: AppSizes.paddingTriple,
            ),
            decoration: BoxDecoration(
              color: Colors.black45,
              border: Border.all(
                  color: Colors.tealAccent.withOpacity(0.7), width: 1),
              borderRadius: BorderRadius.circular(AppSizes.radius),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Been: $been',
                    style: style,
                  ),
                  Text(
                    'Want: $want',
                    style: style,
                  ),
                  Text(
                    'Do not want: $notWant',
                    style: style,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
