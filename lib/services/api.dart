// api.dart

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class API {

  // getUserDetails - Existing function to fetch user data from Microsoft Graph
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

  // getProfileImage - Existing function to fetch user profile image from Microsoft Graph
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

  // New function to fetch user data from your custom API (/user/get?userid={username})
  Future<Response> getUserByUsername(String username) async {
    var dio = Dio();
    try {
      final response = await dio.get('https://demo.gov-codex.com:8001/api/user/get?userid=$username');
      return response;
    } catch (e) {
      print("Http Error : ${e.toString()}");
      rethrow;
    }
  }

  Future<Response> getDashboardData({String? token}) async {
    var dio = Dio();
    try {
      final response = await dio.get(
        'https://demo.gov-codex.com:8001/api/user/dashboard',
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      print('Dashboard Data: ${response.data}');
      return response;
    } catch (e) {
      print("Http Error (getDashboardData): ${e.toString()}");
      rethrow;
    }
  }
}
