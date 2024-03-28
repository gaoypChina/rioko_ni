import 'package:flutter/material.dart';
import 'package:rioko_ni/core/injector.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';
import 'package:rioko_ni/features/map/presentation/pages/map_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await registerDependencies();
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider<MapCubit>(
        create: (BuildContext context) => locator<MapCubit>(),
      ),
    ], child: const RiokoNi()),
  );
}

class RiokoNi extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const RiokoNi({super.key});

  @override
  State<RiokoNi> createState() => _RiokoNiState();
}

class _RiokoNiState extends State<RiokoNi> {
  final _mapCubit = locator<MapCubit>();
  @override
  void initState() {
    _mapCubit.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: RiokoNi.navigatorKey,
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.tealAccent).copyWith(
          background: Colors.black,
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
        primaryColor: Colors.teal,
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white70),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapPage();
  }
}
