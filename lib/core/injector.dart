import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rioko_ni/core/data/countries_client.dart';
import 'package:rioko_ni/core/data/gadm_client.dart';
import 'package:rioko_ni/features/map/data/datasources/map_remote_data_source_impl.dart';
import 'package:rioko_ni/features/map/data/repositories/map_repository_impl.dart';
import 'package:rioko_ni/features/map/domain/usecases/get_country_polygons.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';

final locator = GetIt.instance;

void registerDependencies() {
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

  locator.registerSingleton<GADMClient>(
      GADMClient(locator.get<Dio>(instanceName: 'gadm')));
  locator.registerSingleton<CountriesClient>(
      CountriesClient(locator.get<Dio>(instanceName: 'countries')));
  locator.registerSingleton<MapRemoteDataSourceImpl>(
      MapRemoteDataSourceImpl(client: locator<GADMClient>()));
  locator.registerSingleton<MapRepositoryImpl>(
      MapRepositoryImpl(remoteDataSource: locator<MapRemoteDataSourceImpl>()));
  locator.registerSingleton<GetCountryPolygons>(
      GetCountryPolygons(locator<MapRepositoryImpl>()));
  locator.registerSingleton<MapCubit>(
    MapCubit(getCountryPolygonUsecase: locator<GetCountryPolygons>()),
  );
}
