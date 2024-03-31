import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rioko_ni/core/config/app_sizes.dart';
import 'package:rioko_ni/core/extensions/iterable2.dart';
import 'package:rioko_ni/core/injector.dart';
import 'package:rioko_ni/core/presentation/cubit/revenue_cat_cubit.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:rioko_ni/core/extensions/double2.dart';

class ShareDialog extends StatefulWidget {
  const ShareDialog({super.key});

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  // WidgetsToImageController to access widget
  List<WidgetsToImageController> controllers =
      List.generate(11, (index) => WidgetsToImageController());

  List<GlobalKey> keys = List.generate(11, (index) => GlobalKey());

  final _cubit = locator<MapCubit>();
  final _revenueCatCubit = locator<RevenueCatCubit>();

  String get l10n => 'regions';

  double imageHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.8;

  int currentIndex = 0;

  List<int> freeOptions = [0, 1];

  bool get isOptionAvailable {
    if (freeOptions.contains(currentIndex)) return true;
    return _revenueCatCubit.isPremium;
  }

  Future<ShareResultStatus> _shareImage() async {
    final bytes = await controllers[currentIndex].capture();
    if (bytes == null) return ShareResultStatus.unavailable;
    final dir = await getTemporaryDirectory();
    String filePath = '${dir.path}/rioko_statistics.png';
    File file = File(filePath);
    await file.writeAsBytes(bytes);
    final result = await Share.shareXFiles([XFile(file.path)]);

    if (result.status == ShareResultStatus.success) {
      file.delete();
    }
    return result.status;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black26,
      child: BlocBuilder<RevenueCatCubit, RevenueCatState>(
        builder: (context, state) => _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
            items: [
              _buildGraphic(
                context,
                index: 0,
                backgroundColor: Colors.black,
                primaryColor: Colors.white,
                textColor: Colors.white,
              ),
              _buildGraphic(
                context,
                index: 1,
                backgroundColor: Colors.white,
                primaryColor: Colors.black,
                textColor: Colors.black,
              ),
              _buildGraphic(
                context,
                index: 2,
                primaryColor: Theme.of(context).colorScheme.onPrimary,
                textColor: Colors.white,
                fontFamily: 'Nasalization',
              ),
              _buildGraphic(
                context,
                index: 3,
                backgroundColor: Colors.black,
                primaryColor: Colors.blue,
                textColor: Colors.white,
                fontFamily: 'Nasalization',
              ),
              _buildGraphic(
                context,
                index: 4,
                backgroundColor: Colors.black,
                primaryColor: Colors.red,
                textColor: Colors.white,
                fontFamily: 'Nasalization',
              ),
              _buildGraphic(
                context,
                index: 5,
                backgroundColor: Colors.grey[300]!,
                primaryColor: Colors.black,
                textColor: Colors.black,
                fontFamily: 'Caveat',
                textScale: 1.5,
              ),
              _buildGraphic(
                context,
                index: 6,
                backgroundColor: Colors.black,
                primaryColor: Colors.white,
                textColor: Colors.white,
                fontFamily: 'Caveat',
                textScale: 1.5,
              ),
              _buildGraphic(
                context,
                index: 7,
                primaryColor: Colors.black,
                textColor: Colors.black,
                fontFamily: 'Caveat',
                textScale: 1.7,
                image: const AssetImage('assets/paper.jpg'),
              ),
              _buildGraphic(
                context,
                index: 8,
                backgroundColor: const Color.fromARGB(255, 241, 250, 238),
                primaryColor: const Color.fromARGB(255, 29, 53, 87),
                textColor: const Color.fromARGB(255, 29, 53, 87),
                fontFamily: 'Rajdhani',
                textScale: 1.2,
                secondaryColor: const Color.fromARGB(255, 230, 57, 70),
              ),
              _buildGraphic(
                context,
                index: 9,
                backgroundColor: const Color.fromARGB(255, 237, 242, 244),
                primaryColor: const Color.fromARGB(255, 43, 45, 66),
                textColor: const Color.fromARGB(255, 43, 45, 66),
                fontFamily: 'Rajdhani',
                textScale: 1.2,
                secondaryColor: const Color.fromARGB(255, 239, 35, 60),
              ),
              _buildGraphic(
                context,
                index: 10,
                backgroundColor: const Color.fromARGB(255, 244, 241, 222),
                primaryColor: const Color.fromARGB(255, 71, 122, 106),
                textColor: const Color.fromARGB(255, 61, 64, 91),
                fontFamily: 'Rajdhani',
                textScale: 1.2,
                secondaryColor: const Color.fromARGB(255, 224, 122, 95),
              ),
            ],
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              initialPage: 0,
              enableInfiniteScroll: false,
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              onPageChanged: (index, reason) =>
                  setState(() => currentIndex = index),
              scrollDirection: Axis.horizontal,
            )),
        Align(
          alignment: const Alignment(0.9, -0.85),
          child: GestureDetector(
            onTap: Navigator.of(context).pop,
            child: const Icon(FontAwesomeIcons.circleXmark),
          ),
        ),
        _buildShareButton(context),
      ],
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.paddingQuintuple),
        child: ElevatedButton(
          onPressed: () {
            if (!isOptionAvailable) {
              _revenueCatCubit.purchase();
              return;
            }
            _shareImage().then((result) {
              if (result == ShareResultStatus.success) {
                return Navigator.of(context).pop();
              }
              toastification.show(
                context: context,
                type: ToastificationType.error,
                style: ToastificationStyle.minimal,
                title: Text(tr('core.errorMessageTitle')),
                description: Text(tr('core.errors.shareUnavailable')),
                autoCloseDuration: const Duration(seconds: 5),
                alignment: Alignment.topCenter,
              );
            });
          },
          child: isOptionAvailable
              ? Text(tr('shareDialog.labels.share'))
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(tr('shareDialog.labels.buyPremium')),
                    const SizedBox(width: AppSizes.padding),
                    const Icon(FontAwesomeIcons.lock, size: 15),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildGraphic(
    BuildContext context, {
    required int index,
    required Color textColor,
    required Color primaryColor,
    Color? secondaryColor,
    String? fontFamily,
    Color backgroundColor = Colors.black,
    double textScale = 1,
    ImageProvider<Object>? image,
  }) {
    return Center(
      child: WidgetsToImage(
        key: keys[index],
        controller: controllers[index],
        child: Container(
          height: imageHeight(context),
          decoration: BoxDecoration(
            color: image == null ? backgroundColor : null,
            image: image != null
                ? DecorationImage(
                    image: image,
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: imageHeight(context) * 0.33,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingHalf),
                child: SimpleMap(
                  instructions: SMapWorld.instructionsMercator,
                  defaultColor: Colors.transparent,
                  countryBorder: CountryBorder(color: primaryColor),
                  colors: _cubit.beenCountries
                      .map(
                        (c) => {
                          c.alpha2.toLowerCase(): primaryColor.withOpacity(0.7),
                        },
                      )
                      .reduceOrNull((value, element) => {...value, ...element}),
                ),
              ),
              _buildContinentSummaryRow(
                context,
                label: tr('$l10n.northAmerica'),
                percentage: _cubit.beenNorthAmericaPercentage,
                number: _cubit.beenNorthAmericaCountriesNumber,
                all: _cubit.allNorthAmericaCountriesNumber,
                textColor: textColor,
                fontFamily: fontFamily,
                primaryColor: primaryColor,
                textScale: textScale,
                secondaryColor: secondaryColor,
              ),
              _buildContinentSummaryRow(
                context,
                label: tr('$l10n.southAmerica'),
                percentage: _cubit.beenSouthAmericaPercentage,
                number: _cubit.beenSouthAmericaCountriesNumber,
                all: _cubit.allSouthAmericaCountriesNumber,
                textColor: textColor,
                fontFamily: fontFamily,
                primaryColor: primaryColor,
                textScale: textScale,
                secondaryColor: secondaryColor,
              ),
              _buildContinentSummaryRow(
                context,
                label: tr('$l10n.europe'),
                percentage: _cubit.beenEuropePercentage,
                number: _cubit.beenEuropeCountriesNumber,
                all: _cubit.allEuropeCountriesNumber,
                textColor: textColor,
                fontFamily: fontFamily,
                primaryColor: primaryColor,
                textScale: textScale,
                secondaryColor: secondaryColor,
              ),
              _buildContinentSummaryRow(
                context,
                label: tr('$l10n.africa'),
                percentage: _cubit.beenAfricaPercentage,
                number: _cubit.beenAfricaCountriesNumber,
                all: _cubit.allAfricaCountriesNumber,
                textColor: textColor,
                fontFamily: fontFamily,
                primaryColor: primaryColor,
                textScale: textScale,
                secondaryColor: secondaryColor,
              ),
              _buildContinentSummaryRow(
                context,
                label: tr('$l10n.asia'),
                percentage: _cubit.beenAsiaPercentage,
                number: _cubit.beenAsiaCountriesNumber,
                all: _cubit.allAsiaCountriesNumber,
                textColor: textColor,
                fontFamily: fontFamily,
                primaryColor: primaryColor,
                textScale: textScale,
                secondaryColor: secondaryColor,
              ),
              _buildContinentSummaryRow(
                context,
                label: tr('$l10n.oceania'),
                percentage: _cubit.beenOceaniaPercentage,
                number: _cubit.beenOceaniaCountriesNumber,
                all: _cubit.allOceaniaCountriesNumber,
                textColor: textColor,
                fontFamily: fontFamily,
                primaryColor: primaryColor,
                textScale: textScale,
                secondaryColor: secondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinentSummaryRow(
    BuildContext context, {
    required String label,
    required double percentage,
    required int number,
    required int all,
    required Color textColor,
    required String? fontFamily,
    required Color primaryColor,
    required double textScale,
    required Color? secondaryColor,
  }) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: (imageHeight(context) * 0.11) - 1,
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingDouble,
          vertical: AppSizes.padding,
        ),
        child: Row(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: CircularPercentIndicator(
                key: Key(label),
                radius: 32.0,
                lineWidth: 5.0,
                percent: percentage / 100,
                center: Text(
                  "${percentage.toPrettyString()} %",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13 * textScale * .8,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
                progressColor: secondaryColor ?? primaryColor,
                circularStrokeCap: CircularStrokeCap.round,
                curve: Curves.fastEaseInToSlowEaseOut,
                animationDuration: 1000,
                animation: true,
                restartAnimation: false,
                arcType: ArcType.FULL,
                arcBackgroundColor:
                    (secondaryColor ?? primaryColor).withOpacity(0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingDouble),
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: fontFamily,
                      fontSize: (width / 30) * textScale,
                      color: textColor,
                    ),
              ),
            ),
            Expanded(
              child: Text(
                '$number/$all',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: fontFamily,
                      color: textColor,
                    ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
