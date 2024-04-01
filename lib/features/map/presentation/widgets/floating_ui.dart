import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rioko_ni/core/config/app_sizes.dart';
import 'package:rioko_ni/core/injector.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';

class FloatingUI extends StatelessWidget {
  final bool lowerTopUI;

  final void Function() openTopBehindDrawer;

  FloatingUI({
    required this.lowerTopUI,
    required this.openTopBehindDrawer,
    super.key,
  });

  final _cubit = locator<MapCubit>();

  double getTopMargin(BuildContext context) =>
      AppSizes.paddingTriple +
      (lowerTopUI ? MediaQuery.of(context).size.height * 0.3 : 0);

  String get l10n => 'map.statsUI';

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
                GestureDetector(
                  onTap: Scaffold.of(context).openDrawer,
                  child: Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(left: AppSizes.padding),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.7),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.onPrimary,
                          width: 1),
                      borderRadius: BorderRadius.circular(AppSizes.radius),
                    ),
                    padding: const EdgeInsets.only(bottom: 1),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.bars,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(left: AppSizes.padding),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.padding,
                      horizontal: AppSizes.paddingTriple,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.7),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.onPrimary,
                          width: 1),
                      borderRadius: BorderRadius.circular(AppSizes.radius),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: openTopBehindDrawer,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${tr('$l10n.labels.been')}: ${_cubit.beenCountries.length}",
                            ),
                            Text(
                              "${tr('$l10n.labels.want')}: ${_cubit.wantCountries.length}",
                            ),
                            Text(
                              "${tr('$l10n.labels.lived')}: ${_cubit.livedCountries.length}",
                            ),
                          ],
                        ),
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
