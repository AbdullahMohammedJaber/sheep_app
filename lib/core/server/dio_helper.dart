import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/core/server/servise.dart';
import 'package:sheep/features/auth/login.dart';
import 'package:sheep/util/message_flash.dart';
import 'package:sheep/util/route.dart';

import 'header.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiService.domain,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: ApiHeaders.headers,
        responseType: ResponseType.json,
 
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseUrl: false,
        responseHeader: false,
        
        requestUrl: true,
        error: true,
        requestHeader: true,
      ),
    );
  }

  /// =======================
  /// Generic Request
  /// =======================
  Future<ApiResult<T>> request<T>({
    required String path,
    required String method,
    T Function(dynamic json)? converter,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headers,
    bool isMultipart = false,
    List<File>? files,
    String fileFieldName = 'files',

    CancelToken? cancelToken,
  }) async {
    try {
      final body = await _buildBody(
        data: data,
        isMultipart: isMultipart,
        files: files,
        fileFieldName: fileFieldName,
      );

      final response = await _dio.request(
        path,
        data: body,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: Options(method: method, headers: headers),
      );
      log(response.data.toString());

      if (response.statusCode != null && response.statusCode! == 200) {
        final result =
            converter != null ? converter(response.data) : response.data as T;

        return ApiResult.success(
          result,
          statusCode: response.data['statusCode'],
          message: response.statusMessage,
        );
      }
      if (response.data['statusCode'] == 405) {
        toRemoveAll(LoginScreen());
        showMessage(response.data['message'], value: false);
      }
      return ApiResult.failed(
        message: response.data?['message'],
        statusCode: response.statusCode,
        data: response.data,
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return ApiResult.failed(message: 'Request canceled');
      }

      return ApiResult.failed(
        message: e.response?.data?['message'],
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResult.failed(message: 'Unexpected error', statusCode: 501);
    }
  }

  /// =======================
  /// Multipart Helper
  /// =======================
  Future<dynamic> _buildBody({
    dynamic data,
    required bool isMultipart,
    List<File>? files,
    required String fileFieldName,
  }) async {
    if (!isMultipart) return data;

    final map = <String, dynamic>{};

    if (data is Map<String, dynamic>) {
      map.addAll(data);
    }

    if (files != null && files.isNotEmpty) {
      if (files.length == 1) {
        map[fileFieldName] = await MultipartFile.fromFile(
          files.first.path,
          filename: files.first.path.split('/').last,
        );
      } else {
        map[fileFieldName] = await Future.wait(
          files.map(
            (file) => MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }
    }

    return FormData.fromMap(map);
  }
}
