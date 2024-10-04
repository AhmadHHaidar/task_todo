import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

enum StatusCode { operationSucceeded, operationFailed, serverError }

extension FetchCode on StatusCode {
  int get code {
    switch (this) {
      case StatusCode.operationSucceeded:
        return 200;
      case StatusCode.operationFailed:
        return 400;
      case StatusCode.serverError:
        return 500;
    }
  }
}

enum _StatusType { succeed, failed }

class DioLogInterceptor extends Interceptor {
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  final Logger logger = Logger();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    // if (kDebugMode) {
    //   logger.i(
    //     "***|| INFO Request ${options.method} ${options.path} ||***"
    //         "\n param : ${options.queryParameters}"
    //         "\n data : ${options.data}"
    //         "\n Header: ${encoder.convert(options.headers)}"
    //         "\n token: ${encoder.convert(options.headers[HttpHeaders.authorizationHeader])}"
    //         "\n timeout: ${options.connectTimeout ?? 0 ~/ 1000}s"
    //         // "\n curl command: ${HelperFunctions.getCurlCommandFromRequest(options)}s",
    //   );
    // }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _StatusType statusType;
      if (response.statusCode == StatusCode.operationSucceeded.code) {
        statusType = _StatusType.succeed;
      } else {
        statusType = _StatusType.failed;
      }

      if (statusType == _StatusType.failed) {
        logger.e(
            '***|| ${statusType.name.toUpperCase()} Response into -> ${response.requestOptions.uri.path} ||***');
      } else {
        logger.t(
            '***|| ${statusType.name.toUpperCase()} Response into -> ${response.requestOptions.uri.path} ||***');
      }

      logger.f(
        "***|| INFO Response Request ${response.requestOptions.uri.path} ${statusType == _StatusType.succeed ? '✊' : ''} ||***"
            "\n Status code: ${response.statusCode}"
            "\n Status message: ${response.statusMessage}"
            "\n Data: ${encoder.convert(response.data)}",
      );
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      logger.e(
        "***|| SOMETHING WENT WRONG 💔 ||***"
            "\n error: ${err.error}"
            "\n response: ${err.response}"
            "\n message: ${err.message}"
            "\n type: ${err.type}"
            "\n stackTrace: ${err.stackTrace}",
      );
    }
    handler.next(err);
  }
}
