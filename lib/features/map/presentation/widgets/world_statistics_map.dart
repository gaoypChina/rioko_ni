import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rioko_ni/core/config/app_sizes.dart';
import 'package:rioko_ni/features/map/domain/entities/country.dart';

class WorldStatisticsMap extends StatelessWidget {
  final double asiaPercentage;
  final double europePercentage;
  final double africaPercentage;
  final double northAmericaPercentage;
  final double southAmericaPercentage;
  final double oceaniaPercentage;
  final List<Country> beenCountries;

  const WorldStatisticsMap({
    required this.africaPercentage,
    required this.asiaPercentage,
    required this.europePercentage,
    required this.northAmericaPercentage,
    required this.oceaniaPercentage,
    required this.southAmericaPercentage,
    required this.beenCountries,
    super.key,
  });

  String get l10n => 'worldStatisticsMap';

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
              colors: beenCountries
                  .map(
                    (c) => {
                      c.alpha2.toLowerCase(): c.status.color.withOpacity(0.5),
                    },
                  )
                  .reduce((value, element) => {...value, ...element}),
            ),
          ),
          _buildContinentSummary(
            alignment: const Alignment(-0.9, -0.3),
            label: tr('$l10n.northAmerica'),
            percentage: northAmericaPercentage,
          ),
          _buildContinentSummary(
            alignment: const Alignment(-0.6, 1),
            label: tr('$l10n.southAmerica'),
            percentage: southAmericaPercentage,
            footer: true,
          ),
          _buildContinentSummary(
            alignment: const Alignment(0.05, -0.7),
            label: tr('$l10n.europe'),
            percentage: europePercentage,
          ),
          _buildContinentSummary(
            alignment: const Alignment(0.15, 1),
            label: tr('$l10n.africa'),
            percentage: africaPercentage,
            footer: true,
          ),
          _buildContinentSummary(
            alignment: const Alignment(0.5, -0.4),
            label: tr('$l10n.asia'),
            percentage: asiaPercentage,
          ),
          _buildContinentSummary(
            alignment: const Alignment(0.85, 1),
            label: tr('$l10n.oceania'),
            percentage: oceaniaPercentage,
            footer: true,
          ),
        ],
      ),
    );
  }

  Widget _buildContinentSummary({
    required Alignment alignment,
    required String label,
    required double percentage,
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
            "${percentage.toStringAsPrecision(3)}%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          progressColor: Colors.tealAccent,
          backgroundColor: Colors.tealAccent.withOpacity(0.1),
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
