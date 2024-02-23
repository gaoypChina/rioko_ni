import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'countries_client.g.dart';

@RestApi()
abstract class CountriesClient {
  factory CountriesClient(Dio dio, {String baseUrl}) = _CountriesClient;

  static const api = 'v3.1/';

  /// Using [ISO 3166-1 alpha-3](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes) code as a parameter.
  @GET('$api/alpha/{isoA3Code}')
  Future<HttpResponse> getCountryInfo({
    @Path('isoA3Code') required String countryCode,
    @Queries() Map<String, dynamic>? queries,
  });

  @GET('$api/all')
  Future<HttpResponse> getAllCountries({
    @Queries() Map<String, dynamic>? queries = const {"fields": "name,cca3"},
  });
}
