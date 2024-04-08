import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rioko_ni/core/config/app_sizes.dart';
import 'package:rioko_ni/core/mixins/extended_dialog.dart';
import 'package:rioko_ni/core/utils/assets_handler.dart';

class AboutAppDialog extends StatefulWidget with StatefulExtendedDialog {
  const AboutAppDialog({super.key});

  @override
  State<AboutAppDialog> createState() => _AboutAppDialogState();

  @override
  Widget buildDialog(BuildContext context) => this;
}

class _AboutAppDialogState extends State<AboutAppDialog> {
  PackageInfo? packageInfo;
  @override
  void initState() {
    getAppInfo();
    super.initState();
  }

  void getAppInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: const EdgeInsets.all(AppSizes.paddingDouble),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingDouble),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Rioko ${packageInfo?.version ?? ''}'),
            Container(
              margin: const EdgeInsets.symmetric(vertical: AppSizes.padding),
              child: CircleAvatar(
                backgroundImage: AssetImage(AssetsHandler.authorPicture),
                radius: 50,
              ),
            ),
            Text('Author', style: Theme.of(context).textTheme.bodySmall),
            Text('Patryk Bożek', style: Theme.of(context).textTheme.bodyLarge),
            Divider(
              indent: size.width / 10,
              endIndent: size.width / 10,
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppSizes.paddingTriple,
                right: AppSizes.paddingDouble,
              ),
              child: LicensesPageListTile(
                icon: Icon(
                  FontAwesomeIcons.idCard,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  'Licences',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Icon(
                  FontAwesomeIcons.chevronRight,
                  color: Theme.of(context).iconTheme.color,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
