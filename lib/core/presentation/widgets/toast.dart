import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rioko_ni/core/injector.dart';
import 'package:rioko_ni/core/presentation/cubit/theme_cubit.dart';
import 'package:toastification/toastification.dart';

class ToastBuilder {
  final String message;
  final String? title;
  final ToastificationType type;

  ToastBuilder({
    required this.message,
    this.type = ToastificationType.error,
    this.title,
  });

  String get defaultTitle {
    switch (type) {
      case ToastificationType.error:
        return tr('core.toast.titles.error');
      case ToastificationType.info:
        return tr('core.toast.titles.info');
      case ToastificationType.success:
        return tr('core.toast.titles.success');
      case ToastificationType.warning:
        return tr('core.toast.titles.warning');
    }
  }

  ToastificationStyle get style {
    final themeCubit = locator<ThemeCubit>();
    switch (themeCubit.type) {
      case ThemeDataType.classic:
        return ToastificationStyle.minimal;
      case ThemeDataType.humani:
        return ToastificationStyle.minimal;
      case ThemeDataType.neoDark:
        return ToastificationStyle.flatColored;
      case ThemeDataType.monochrome:
        return ToastificationStyle.flat;
    }
  }

  void show(BuildContext context, {int seconds = 5}) {
    toastification.show(
      context: context,
      type: type,
      style: style,
      title: Text(title ?? defaultTitle),
      description: Text(message),
      autoCloseDuration: Duration(seconds: seconds),
      alignment: Alignment.topCenter,
      backgroundColor: Theme.of(context).colorScheme.background,
      primaryColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).snackBarTheme.actionTextColor,
      progressBarTheme: ProgressIndicatorThemeData(
        color: Theme.of(context).colorScheme.primary,
        linearTrackColor: Theme.of(context).colorScheme.onBackground,
      ),
      closeOnClick: true,
    );
  }
}
