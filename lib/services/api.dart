import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class API {

  // getUserDetails
  Future<Response> getUserDetails({required String token}) async {
    var dio = Dio();
    Map<String, String> headers = {'Authorization': 'Bearer $token'};
    dio.options.headers = headers;
    dio.options.method = "GET";
    dio.interceptors.add(PrettyDioLogger());
    try {
      return await dio.request('https://graph.microsoft.com/v1.0/me');
    } catch (e) {
      print('Http Error : ${e.toString()}');
      rethrow;
    }
  }

  // getProfileImage
  Future<Response> getProfileImage({required String token}) async {
    var dio = Dio();
    Map<String, String> headers = {'Authorization': 'Bearer $token'};
    dio.options.headers = headers;
    dio.options.method = "GET";
    dio.interceptors.add(PrettyDioLogger());

    try {
      return await dio.get('https://graph.microsoft.com/v1.0/me/photo/\$value', options: Options(responseType: ResponseType.bytes));
    } catch (e) {
      print('Http Error: ${e.toString()}');
      rethrow;
    }
  }

}
