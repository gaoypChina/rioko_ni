import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'theme_state.dart';
part 'theme_cubit.freezed.dart';
part 'theme_cubit.g.dart';

@HiveType(typeId: 0)
enum ThemeDataType {
  @HiveField(0)
  classic,
  @HiveField(1)
  dark,
  @HiveField(2)
  monochrome,
}

class ThemeCubit extends Cubit<ThemeDataType> {
  ThemeCubit({ThemeDataType? type})
      : type = type ?? ThemeDataType.classic,
        super(type ?? ThemeDataType.classic);

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
      tertiary: Colors.grey,
      onTertiary: Colors.grey,
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
      titleSmall: TextStyle(
        color: Colors.white70,
        fontFamily: 'Nasalization',
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontFamily: 'Nasalization',
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
        return ThemeData.dark(
          useMaterial3: true,
        ).copyWith(
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
            titleSmall: TextStyle(
              color: Colors.white70,
              fontFamily: 'Nasalization',
            ),
            titleMedium: TextStyle(
              color: Colors.white,
              fontFamily: 'Nasalization',
            ),
            titleLarge: TextStyle(
              fontFamily: 'Nasalization',
            ),
            headlineMedium: TextStyle(
              fontFamily: 'Nasalization',
              color: Colors.white,
              fontSize: 17,
            ),
            headlineLarge: TextStyle(
              fontFamily: 'Nasalization',
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        );
      case ThemeDataType.monochrome:
        return ThemeData.dark(
          useMaterial3: true,
        ).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey).copyWith(
            background: Colors.black,
            onBackground: const Color.fromARGB(255, 27, 27, 27),
            primary: const Color.fromARGB(250, 67, 116, 146),
            onPrimary: const Color.fromARGB(76, 15, 163, 255),
            secondary: const Color.fromARGB(255, 203, 109, 238),
            onSecondary: const Color.fromARGB(76, 255, 102, 133),
            tertiary: Colors.white,
            onTertiary: Colors.white30,
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
          primaryColor: Colors.grey,
          textTheme: const TextTheme(
            bodySmall: TextStyle(
              fontFamily: 'Nasalization',
              color: Colors.white,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Nasalization',
            ),
            titleSmall: TextStyle(
              color: Colors.white70,
              fontFamily: 'Nasalization',
            ),
            titleMedium: TextStyle(
              color: Colors.white,
              fontFamily: 'Nasalization',
            ),
            titleLarge: TextStyle(
              fontFamily: 'Nasalization',
            ),
            headlineMedium: TextStyle(
              fontFamily: 'Nasalization',
              color: Colors.white,
              fontSize: 17,
            ),
            headlineLarge: TextStyle(
              fontFamily: 'Nasalization',
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        );
    }
  }

  void changeTheme(ThemeDataType type) {
    this.type = type;
    var box = Hive.box('theme_data');
    box.put('type', type);
    emit(type);
  }
}
