import 'package:flutter/material.dart';
import 'package:rioko_ni/core/config/app_sizes.dart';

class StatsUI extends StatelessWidget {
  final int been;
  final int want;
  final int notWant;
  final void Function() toggleTopBehindDrawer;
  final bool lowerTopUI;

  const StatsUI({
    required this.been,
    required this.want,
    required this.notWant,
    required this.toggleTopBehindDrawer,
    required this.lowerTopUI,
    super.key,
  });

  TextStyle get style => const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      );

  double getTopMargin(BuildContext context) =>
      AppSizes.paddingTriple +
      (lowerTopUI ? MediaQuery.of(context).size.height * 0.3 : 0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: AnimatedContainer(
            duration: Duration(milliseconds: lowerTopUI ? 500 : 700),
            curve: Curves.fastEaseInToSlowEaseOut,
            margin: EdgeInsets.symmetric(
              vertical: getTopMargin(context),
              horizontal: AppSizes.paddingDouble,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(right: AppSizes.padding),
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
                            'Not want: $notWant',
                            style: style,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: toggleTopBehindDrawer,
                  child: Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(left: AppSizes.padding),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      border: Border.all(
                          color: Colors.tealAccent.withOpacity(0.7), width: 1),
                      borderRadius: BorderRadius.circular(AppSizes.radius),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.menu_book,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
