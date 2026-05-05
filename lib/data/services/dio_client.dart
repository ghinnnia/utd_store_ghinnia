import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DioClient {
  late Dio dio;
  final Logger logger = Logger();

  DioClient() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://fakestoreapi.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        logger.i('REQUEST: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        logger.i('RESPONSE: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (error, handler) {
        logger.e('ERROR: ${error.message}');
        return handler.next(error);
      },
    ));
  }
}