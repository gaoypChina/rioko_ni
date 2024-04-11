import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rioko_ni/core/config/app_sizes.dart';
import 'package:rioko_ni/core/extensions/iterable2.dart';
import 'package:rioko_ni/core/injector.dart';
import 'package:rioko_ni/core/presentation/about_app_dialog.dart';
import 'package:rioko_ni/core/presentation/cubit/theme_cubit.dart';
import 'package:rioko_ni/core/presentation/widgets/change_theme_dialog.dart';
import 'package:rioko_ni/core/presentation/widgets/toast.dart';
import 'package:rioko_ni/features/map/domain/entities/country.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';
import 'package:rioko_ni/features/map/presentation/widgets/share_dialog.dart';
import 'package:rioko_ni/main.dart';
import 'package:url_launcher/url_launcher.dart';

class RiokoDrawer extends StatelessWidget {
  final bool showWorldStatistics;
  final void Function() openTopBehindDrawer;
  final void Function() updateMap;

  RiokoDrawer({
    required this.openTopBehindDrawer,
    required this.showWorldStatistics,
    required this.updateMap,
    super.key,
  });

  String get l10n => 'drawer';

  final _cubit = locator<MapCubit>();
  final _themeCubit = locator<ThemeCubit>();

  Widget get divider => const Divider(
        endIndent: AppSizes.paddingDouble,
        indent: AppSizes.paddingDouble,
      );

  Color mapBorderColor(BuildContext context) {
    switch (_themeCubit.type) {
      case ThemeDataType.classic:
      case ThemeDataType.humani:
        return Colors.black;
      case ThemeDataType.neoDark:
      case ThemeDataType.monochrome:
        return Theme.of(context).colorScheme.onPrimary.withOpacity(1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: AppSizes.paddingSeptuple,
          top: AppSizes.paddingQuadruple,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSizes.padding),
                child: SimpleMap(
                  instructions: SMapWorld.instructionsMercator,
                  defaultColor: Theme.of(context).colorScheme.background,
                  countryBorder: CountryBorder(color: mapBorderColor(context)),
                  colors: _cubit.countries
                      .where((c) => c.status != CountryStatus.none)
                      .map(
                        (c) => {
                          c.alpha2.toLowerCase():
                              c.status.color(context).withOpacity(0.3),
                        },
                      )
                      .reduceOrNull((value, element) => {...value, ...element}),
                ),
              ),
              divider,
              ListTile(
                leading: const Icon(FontAwesomeIcons.chartPie),
                title: Text(
                  tr('$l10n.labels.showStatistics'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  openTopBehindDrawer();
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.shareNodes),
                title: Text(
                  tr('$l10n.labels.shareStatistics'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    context: context,
                    pageBuilder: (context, animation1, animation2) =>
                        const ShareDialog(),
                  );
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.paintRoller),
                title: Text(
                  tr('$l10n.labels.changeTheme'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  ChangeThemeDialog(updateMap: updateMap).show(context);
                },
              ),
              divider,
              ListTile(
                leading: const Icon(FontAwesomeIcons.circleInfo),
                title: Text(
                  tr('$l10n.labels.aboutApp'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  const AboutAppDialog().show(context);
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.shieldHalved),
                title: Text(
                  tr('$l10n.labels.privacyPolicy'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                onTap: () async {
                  try {
                    await launchUrl(Uri.parse(
                        'https://www.freeprivacypolicy.com/live/a5ed11ff-966d-4ba8-97f7-ede0a81bfb62'));
                  } catch (e) {
                    ToastBuilder(
                      message: tr(
                        'core.errors.launchUrl',
                        args: [tr('$l10n.labels.privacyPolicy')],
                      ),
                    ).show(RiokoNi.navigatorKey.currentContext!);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
