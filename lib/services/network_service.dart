import 'package:dio/dio.dart';

typedef InterceptorProvider = List<Interceptor> Function();

class NetworkService {
  static NetworkService? _instance;

  static NetworkService getInstance({
    BaseOptions? baseOptions,
    InterceptorProvider? interceptorProvider,
  }) {
    _instance ??= NetworkService._init(baseOptions, interceptorProvider);
    return _instance!;
  }

  final Dio _dio = Dio();

  NetworkService._init(BaseOptions? baseOptions, InterceptorProvider? interceptorProvider) {
    _initializeDio(baseOptions, interceptorProvider);
  }

  void _initializeDio(BaseOptions? baseOptions, InterceptorProvider? interceptorProvider) {
    _dio.options = baseOptions ?? _getDefaultOptions();
    _dio.interceptors.addAll(interceptorProvider?.call() ?? _getDefaultInterceptors());
  }

  BaseOptions _getDefaultOptions() {
    return BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    );
  }

  List<Interceptor> _getDefaultInterceptors() {
    return [
      LogInterceptor(
        responseBody: true,
        requestBody: true,
      ),
    ];
  }

  Dio get dio => _dio;
}
