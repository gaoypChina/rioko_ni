import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rioko_ni/core/config/app_sizes.dart';
import 'package:rioko_ni/core/extensions/iterable2.dart';
import 'package:rioko_ni/features/map/domain/entities/country.dart';

class WorldStatisticsMap extends StatefulWidget {
  final double asiaPercentage;
  final int asiaNumber;
  final int asiaAll;
  final double europePercentage;
  final int europeNumber;
  final int europeAll;
  final double africaPercentage;
  final int africaNumber;
  final int africaAll;
  final double northAmericaPercentage;
  final int northAmericaNumber;
  final int northAmericaAll;
  final double southAmericaPercentage;
  final int southAmericaNumber;
  final int southAmericaAll;
  final double oceaniaPercentage;
  final int oceaniaNumber;
  final int oceaniaAll;
  final List<Country> beenCountries;

  const WorldStatisticsMap({
    required this.africaPercentage,
    required this.africaNumber,
    required this.africaAll,
    required this.asiaPercentage,
    required this.asiaNumber,
    required this.asiaAll,
    required this.europePercentage,
    required this.europeNumber,
    required this.europeAll,
    required this.northAmericaPercentage,
    required this.northAmericaNumber,
    required this.northAmericaAll,
    required this.oceaniaPercentage,
    required this.oceaniaNumber,
    required this.oceaniaAll,
    required this.southAmericaPercentage,
    required this.southAmericaNumber,
    required this.southAmericaAll,
    required this.beenCountries,
    super.key,
  });

  @override
  State<WorldStatisticsMap> createState() => _WorldStatisticsMapState();
}

class _WorldStatisticsMapState extends State<WorldStatisticsMap> {
  String get l10n => 'worldStatisticsMap';

  bool showPercentage = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              top: AppSizes.paddingQuintuple,
              bottom: AppSizes.paddingQuadruple,
              left: AppSizes.paddingSextuple,
              right: AppSizes.paddingQuadruple,
            ),
            child: SimpleMap(
              instructions: SMapWorld.instructionsMercator,
              defaultColor: Colors.black,
              countryBorder: CountryBorder(color: CountryStatus.been.color),
              colors: widget.beenCountries
                  .map(
                    (c) => {
                      c.alpha2.toLowerCase(): c.status.color.withOpacity(0.3),
                    },
                  )
                  .reduceOrNull((value, element) => {...value, ...element}),
            ),
          ),
          _buildContinentSummary(
            alignment: const Alignment(-0.9, -0.3),
            label: tr('$l10n.northAmerica'),
            percentage: widget.northAmericaPercentage,
            number: widget.northAmericaNumber,
            all: widget.northAmericaAll,
          ),
          _buildContinentSummary(
            alignment: const Alignment(-0.6, 1),
            label: tr('$l10n.southAmerica'),
            percentage: widget.southAmericaPercentage,
            number: widget.southAmericaNumber,
            all: widget.southAmericaAll,
            footer: true,
          ),
          _buildContinentSummary(
            alignment: const Alignment(0.05, -0.7),
            label: tr('$l10n.europe'),
            percentage: widget.europePercentage,
            number: widget.europeNumber,
            all: widget.europeAll,
          ),
          _buildContinentSummary(
            alignment: const Alignment(0.15, 1),
            label: tr('$l10n.africa'),
            percentage: widget.africaPercentage,
            number: widget.africaNumber,
            all: widget.africaAll,
            footer: true,
          ),
          _buildContinentSummary(
            alignment: const Alignment(0.5, -0.4),
            label: tr('$l10n.asia'),
            percentage: widget.asiaPercentage,
            number: widget.asiaNumber,
            all: widget.asiaAll,
          ),
          _buildContinentSummary(
            alignment: const Alignment(0.85, 1),
            label: tr('$l10n.oceania'),
            percentage: widget.oceaniaPercentage,
            number: widget.oceaniaNumber,
            all: widget.oceaniaAll,
            footer: true,
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingDouble),
                child: GestureDetector(
                  onTap: () => setState(() => showPercentage = !showPercentage),
                  child: Icon(
                    showPercentage
                        ? FontAwesomeIcons.six
                        : FontAwesomeIcons.percent,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: GestureDetector(
              onTap: () {
                // Displaying share statistics page with
                // https://medium.com/flutter-community/export-your-widget-to-image-with-flutter-dc7ecfa6bafb
              },
              child: const Padding(
                padding: const EdgeInsets.all(AppSizes.paddingDouble),
                child: Icon(FontAwesomeIcons.arrowUpFromBracket),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContinentSummary({
    required Alignment alignment,
    required String label,
    required double percentage,
    required int number,
    required int all,
    bool footer = false,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingDouble),
        child: CircularPercentIndicator(
          key: Key(label),
          radius: 30.0,
          lineWidth: 5.0,
          percent: percentage / 100,
          center: Text(
            showPercentage
                ? "${percentage.toStringAsPrecision(3)}%"
                : "$number/$all",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          progressColor: Colors.tealAccent,
          backgroundColor: Colors.tealAccent.withOpacity(0.15),
          circularStrokeCap: CircularStrokeCap.round,
          curve: Curves.fastEaseInToSlowEaseOut,
          animationDuration: 1000,
          animation: true,
          restartAnimation: true,
          header: footer
              ? null
              : Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.padding),
                  child: Text(
                    label,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
          footer: footer
              ? Padding(
                  padding: const EdgeInsets.only(top: AppSizes.padding),
                  child: Text(
                    label,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
