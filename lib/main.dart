import 'package:flutter/material.dart';
import 'package:rioko_ni/core/injector.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';
import 'package:rioko_ni/features/map/presentation/pages/map_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  registerDependencies();
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
  @override
  void initState() {
    locator<MapCubit>().getCountryPolygons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: RiokoNi.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
    return MapPage();
  }
}
