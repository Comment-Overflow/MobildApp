import 'package:comment_overflow/utils/storage_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String baseUrl = dotenv.env['HTTP_BASE_URL']!;

class HttpUtil {
  // Singleton method.
  factory HttpUtil() => _getInstance();
  static HttpUtil _instance = HttpUtil._internal();

  static HttpUtil _getInstance() {
    return _instance;
  }

  final options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  late final _dio;

  Dio get dio => _dio;

  HttpUtil._internal() {
    _dio = Dio(options);
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      String? token = await StorageUtil().storage.read(key: 'token');
      if (token != null) {
        print(token);
        options.headers['Authorization'] = token;
      }
      return handler.next(options);
    }, onResponse: (response, handler) {
      return handler.next(response);
    }, onError: (DioError e, handler) {
      return handler.next(e);
    }));
  }
}
