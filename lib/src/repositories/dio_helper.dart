import 'package:dio/dio.dart';
import 'package:pemuda_baik/src/repositories/responseApi/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioHelper {
  late Dio dio;

  DioHelper() {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://613d-180-251-162-209.ngrok.io/api',
      headers: {
        "Accept": "application/json",
      },
      connectTimeout: 90000,
      receiveTimeout: 90000,
    );
    dio = Dio(options);
  }

  Future<dynamic> get(String? url) async {
    dynamic responseJson;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      if (token != null || token != '') {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
      final response = await dio.get('$url');
      responseJson = response.data;
    } catch (e) {
      if (e is DioError) {
        if (e.type == DioErrorType.other) {
          throw NoInternetException(
              'Server tidak dapat terhubung.\nPastikan Anda terhubung ke internet atau coba beberapa saat lagi');
        }
        if (e.response!.data == '') {
          throw NoInternetException(
              'Server tidak dapat terhubung.\nPastikan Anda terhubung ke internet atau coba beberapa saat lagi');
        }
        _returnResponse(e.response);
      }
    }
    return responseJson;
  }

  Future<dynamic> post(String? url, String? request) async {
    dynamic responseJson;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
      dio.options.headers['Content-Type'] = 'application/json';
      final response = await dio.post('$url', data: request);
      responseJson = response.data;
    } catch (e) {
      if (e is DioError) {
        if (e.type == DioErrorType.other) {
          throw NoInternetException(
              'Server tidak dapat terhubung.\nPastikan Anda terhubung ke internet atau coba beberapa saat lagi');
        }
        if (e.response!.data == '') {
          throw NoInternetException(
              'Server tidak dapat terhubung.\nPastikan Anda terhubung ke internet atau coba beberapa saat lagi');
        }
        _returnResponse(e.response);
      }
    }

    return responseJson;
  }

  Future<dynamic> put(String? url, String? request) async {
    dynamic responseJson;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Accept'] = 'application/json';
      final response = await dio.put('$url', data: request);
      responseJson = response.data;
    } catch (e) {
      if (e is DioError) {
        if (e.type == DioErrorType.other) {
          throw NoInternetException(
              'Server tidak dapat terhubung.\nPastikan Anda terhubung ke internet atau coba beberapa saat lagi');
        }
        if (e.response!.data == '') {
          throw NoInternetException(
              'Server tidak dapat terhubung.\nPastikan Anda terhubung ke internet atau coba beberapa saat lagi');
        }
        _returnResponse(e.response);
      }
    }

    return responseJson;
  }

  Future<dynamic> delete(String? url) async {
    dynamic responseJson;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
      dio.options.headers['Accept'] = 'application/json';
      final response = await dio.delete('$url');
      responseJson = response.data;
    } catch (e) {
      if (e is DioError) {
        if (e.type == DioErrorType.other) {
          throw NoInternetException(
              'Server tidak dapat terhubung.\nPastikan Anda terhubung ke internet atau coba beberapa saat lagi');
        }
        if (e.response!.data == '') {
          throw NoInternetException(
              'Server tidak dapat terhubung.\nPastikan Anda terhubung ke internet atau coba beberapa saat lagi');
        }
        _returnResponse(e.response);
      }
    }

    return responseJson;
  }

  dynamic _returnResponse(Response<dynamic>? response) {
    if (response!.data != null) {
      final errorData = exceptionModelFromJson(response.data);
      switch (response.statusCode) {
        case 401:
        case 403:
          throw UnauthorisedException(
              '${response.statusCode} - Unauthorized\n${errorData.messages}');
        case 404:
          if (errorData.messages!.isEmpty) {
            throw FetchDataException(
                '${response.statusCode} -${response.statusMessage}');
          }
          throw FetchDataException('${errorData.messages}');
        case 422:
          if (errorData.messages!.isEmpty) {
            throw BadRequestException(
                '${response.statusCode} - Unprocessable Entity\n${response.statusMessage}');
          }
          throw BadRequestException(
              '${response.statusCode} - Unprocessable Entity\n${errorData.messages}');
        case 500:
        default:
          throw FetchDataException(
              '${response.statusCode} - Internal Server Error\nTerjadi kesalahan pada server.\nSilahkan menghubungi Administrator melalui email:\nrhean.achmad@gmail.com');
      }
    } else {
      switch (response.statusCode) {
        case 401:
        case 403:
          throw UnauthorisedException(
              '${response.statusCode} - Unauthorized\n${response.statusMessage}');
        case 404:
          throw FetchDataException('${response.statusMessage}');
        case 422:
          throw BadRequestException(
              '${response.statusCode} - Unprocessable Entity\n${response.statusMessage}');
        case 500:
        default:
          throw FetchDataException(
              '${response.statusCode} - Internal Server Error\nTerjadi kesalahan pada server.\nSilahkan menghubungi Administrator melalui email:\nrhean.achmad@gmail.com');
      }
    }
  }
}

ExceptionModel exceptionModelFromJson(dynamic str) =>
    ExceptionModel.fromJson(str);

class ExceptionModel {
  ExceptionModel({
    this.messages,
  });

  String? messages;

  factory ExceptionModel.fromJson(Map<String, dynamic> json) => ExceptionModel(
        messages: json["message"] ?? json["statusMessage"],
      );
}

final DioHelper dio = DioHelper();
