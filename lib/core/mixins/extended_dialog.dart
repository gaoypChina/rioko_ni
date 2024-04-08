import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin ExtendedDialog {
  void show(
    BuildContext context,
  ) {
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => build(context),
          )
        : showDialog(
            context: context,
            builder: (BuildContext context) => build(context),
          );
  }

  Widget build(BuildContext context);
}

mixin StatefulExtendedDialog<StatefulWidget> {
  void show(BuildContext context) {
    Platform.isIOS
        ? showCupertinoDialog<String>(
            context: context,
            builder: (BuildContext context) => buildDialog(context),
          )
        : showDialog(
            context: context,
            builder: (BuildContext context) => buildDialog(context),
          );
  }

  Widget buildDialog(BuildContext context);
}
