import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rioko_ni/features/map/data/datasources/map_local_data_source_impl.dart';
import 'package:rioko_ni/features/map/data/repositories/map_repository_impl.dart';
import 'package:rioko_ni/features/map/domain/usecases/get_countries.dart';
import 'package:rioko_ni/features/map/domain/usecases/read_countries_locally.dart';
import 'package:rioko_ni/features/map/domain/usecases/save_countries_locally.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

Future registerDependencies() async {
  const connectTimeout = Duration(seconds: 60);
  const receiveTimeout = Duration(seconds: 120);
  final gadmDio = Dio(
    BaseOptions(
      baseUrl: 'https://geodata.ucdavis.edu/',
      receiveDataWhenStatusError: true,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    ),
  );
  final countriesDio = Dio(
    BaseOptions(
      baseUrl: 'https://restcountries.com/',
      receiveDataWhenStatusError: true,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    ),
  );
  if (kDebugMode == true) {
    final prettyDioLogger = PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      request: false,
      compact: false,
    );
    gadmDio.interceptors.add(prettyDioLogger);
    countriesDio.interceptors.add(prettyDioLogger);
  }
  locator.registerSingleton<Dio>(gadmDio, instanceName: 'gadm');
  locator.registerSingleton<Dio>(countriesDio, instanceName: 'countries');

  locator.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());
  locator.registerSingleton<MapLocalDataSourceImpl>(
    MapLocalDataSourceImpl(sharedPreferences: locator<SharedPreferences>()),
  );
  locator.registerSingleton<MapRepositoryImpl>(MapRepositoryImpl(
    localDataSource: locator<MapLocalDataSourceImpl>(),
  ));
  locator.registerSingleton<GetCountries>(
      GetCountries(locator<MapRepositoryImpl>()));
  locator.registerSingleton<ReadCountriesLocally>(
      ReadCountriesLocally(locator<MapRepositoryImpl>()));
  locator.registerSingleton<SaveCountriesLocally>(
      SaveCountriesLocally(locator<MapRepositoryImpl>()));
  locator.registerSingleton<MapCubit>(
    MapCubit(
      getCountryPolygonUsecase: locator<GetCountries>(),
      saveCountriesLocallyUsecase: locator<SaveCountriesLocally>(),
      readCountriesLocallyUsecase: locator<ReadCountriesLocally>(),
    ),
  );
}
