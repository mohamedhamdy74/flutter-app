import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:routing/api/constant-urls.dart';

class ApiClient {
  Dio dio = Dio(BaseOptions(baseUrl: BaseUrls.authUrl,
      headers: {'Content-Type': 'application/json'},
    ));
  // Optional: Set default headers

   ApiClient() {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
      ),
    );
  } 

    Future<Response> getData(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final response = await dio.get(
      path,
      queryParameters: query,
      options: Options(headers: headers),
    );
    return response;
  }

  Future<Response> postData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    final response = await dio.post(
      uri,
      data: body,
      options: Options(headers: headers),
    );
    return response;
  }

}
