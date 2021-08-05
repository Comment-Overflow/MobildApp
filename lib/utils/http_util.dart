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

  final _options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  final _longConnOptions = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: 30 * 1000,
    receiveTimeout: 10 * 1000,
  );

  late final _dio;
  late final _longConnDio;

  Dio get dio => _dio;
  Dio get longConnDio => _longConnDio;

  HttpUtil._internal() {
    _dio = Dio(_options);
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      String? token = await StorageUtil().storage.read(key: 'token');
      if (token != null) {
        options.headers['Authorization'] = token;
      }
      return handler.next(options);
    }, onResponse: (response, handler) {
      return handler.next(response);
    }, onError: (DioError e, handler) {
      return handler.next(e);
    }));

    _longConnDio = Dio(_longConnOptions);
    _longConnDio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      String? token = await StorageUtil().storage.read(key: 'token');
      if (token != null) {
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
