import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_state.dart';
part 'theme_cubit.freezed.dart';

enum ThemeDataType {
  classic,
  dark,
  monochrome,
}

class ThemeCubit extends Cubit<ThemeDataType> {
  ThemeCubit() : super(ThemeDataType.classic);

  ThemeDataType type = ThemeDataType.classic;

  final ThemeData _default = ThemeData.light(
    useMaterial3: true,
  ).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 46, 196, 182),
    ).copyWith(
      background: const Color.fromARGB(255, 240, 244, 255),
      onBackground: const Color.fromARGB(255, 171, 211, 223),
      primary: const Color.fromARGB(255, 46, 196, 182),
      onPrimary: const Color.fromARGB(255, 152, 216, 250),
      secondary: const Color.fromARGB(255, 255, 89, 94),
      onSecondary: const Color.fromARGB(255, 247, 147, 147),
      tertiary: const Color.fromARGB(255, 255, 202, 58),
      onTertiary: const Color.fromARGB(255, 251, 229, 165),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color.fromARGB(255, 239, 239, 239),
      shadowColor: Colors.black,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    primaryColor: Colors.grey,
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        fontFamily: 'Nasalization',
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Nasalization',
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Nasalization',
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Nasalization',
        color: Colors.black,
        fontSize: 17,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontFamily: 'Nasalization',
      ),
      titleSmall: TextStyle(
        color: Colors.white70,
        fontFamily: 'Nasalization',
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Nasalization',
        color: Colors.black,
        fontSize: 22,
      ),
    ),
    outlinedButtonTheme: const OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(
          Color.fromARGB(255, 9, 143, 129),
        ),
      ),
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(
          Color.fromARGB(255, 9, 143, 129),
        ),
      ),
    ),
  );

  ThemeData appThemeData(ThemeDataType type) {
    switch (type) {
      case ThemeDataType.classic:
        return _default;
      case ThemeDataType.dark:
        return _default.copyWith(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Colors.tealAccent).copyWith(
            background: Colors.black,
            onBackground: const Color.fromARGB(255, 33, 70, 54),
            primary: Colors.teal,
            onPrimary: Colors.tealAccent,
            secondary: Colors.purple,
            onSecondary: Colors.purpleAccent,
            tertiary: Colors.lime,
            onTertiary: Colors.limeAccent,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Colors.black,
            shadowColor: Colors.tealAccent,
          ),
          primaryColor: Colors.teal,
          textTheme: const TextTheme(
            bodySmall: TextStyle(
              fontFamily: 'Nasalization',
              color: Colors.white,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Nasalization',
            ),
            titleLarge: TextStyle(
              fontFamily: 'Nasalization',
            ),
            titleMedium: TextStyle(
              color: Colors.white,
              fontFamily: 'Nasalization',
            ),
            titleSmall: TextStyle(
              color: Colors.white70,
              fontFamily: 'Nasalization',
            ),
          ),
        );
      case ThemeDataType.monochrome:
        return _default.copyWith();
    }
  }

  void changeTheme(ThemeDataType type) {
    this.type = type;
    emit(type);
  }
}
