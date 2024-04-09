import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'gadm_client.g.dart';

@RestApi()
abstract class GADMClient {
  factory GADMClient(Dio dio, {String baseUrl}) = _GADMClient;

  static const api = 'gadm/gadm4.1/json';

  /// Using [ISO 3166-1 alpha-3](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes) code as a parameter.
  @GET('$api/gadm41_{isoA3Code}_1.json')
  Future<HttpResponse> getCountryRegions({
    @Path('isoA3Code') required String countryCode,
  });
}
