import 'package:boma/auth/auth.dart';
import 'package:dio/dio.dart';

enum StatusCode {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  internalServerError,
}

extension StatusCodeExtension on StatusCode {
  static StatusCode? fromCode(int code) {
    switch (code) {
      case 400:
        return StatusCode.badRequest;
      case 401:
        return StatusCode.unauthorized;
      case 403:
        return StatusCode.forbidden;
      case 404:
        return StatusCode.notFound;
      case 409:
        return StatusCode.conflict;
      case 500:
        return StatusCode.internalServerError;
      default:
        return null;
    }
  }
}

class DioClient {
  final Dio _dio;
  final TokenService _tokenService = TokenService();
  static const baseUrl = 'http://10.53.82.140:8000/';
  
  static BaseOptions opts = BaseOptions(
    baseUrl: baseUrl,
    responseType: ResponseType.json,
    connectTimeout: const Duration(milliseconds: 30000),
    receiveTimeout: const Duration(milliseconds: 30000),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  static final DioClient _instance = DioClient._internal();
  
  factory DioClient() {
    return _instance;
  }

  DioClient._internal() : _dio = Dio(opts) {
    _dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
    ));
      _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
       
        String? token = await _tokenService.getAccessToken();
         options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
    ));
  }

  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      rethrow;
    }
  }
 
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  static String handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return "Timeout occurred while sending or receiving";
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          switch (statusCode) {
            case 400:
              return "Bad Request";
            case 401:
            case 403:
              return "Unauthorized";
            case 404:
              return "Not Found";
            case 409:
              return 'Conflict';
            case 500:
              return "Internal Server Error";
          }
        }
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        return "No Internet Connection";
      case DioExceptionType.badCertificate:
        return "Internal Server Error";
      case DioExceptionType.connectionError:
        return "Connection Error";
      default:
        return "Unknown Error";
    }
    return "Unknown Error";
  }
}