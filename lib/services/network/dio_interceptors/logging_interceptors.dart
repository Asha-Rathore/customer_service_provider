import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class LoggingInterceptors extends Interceptor {
  LoggingInterceptors();
  var logger = Logger(
    filter: null,
    printer: PrettyPrinter(
      colors: true,
      printEmojis: true,
    ),
  );

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    logger.d('*** API Request - Start ***');
    printKV('URI', options.uri);
    printKV('METHOD', options.method);
    logPrint('HEADERS:');
    options.headers.forEach((key, v) => printKV(' - $key', v));
    logPrint('Body');
    logPrint(options.data.toString() ?? '');
    logPrint('*** API Request - End ***');

    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logPrint('*** Api Error - Start ***:');
    logPrint('URI: ${err.requestOptions.uri}');
    if (err.response != null) {
      logPrint('STATUS CODE: ${err.response?.statusCode?.toString()}');
    }
    logPrint('$err');
    if (err.response != null) {
      printKV('REDIRECT', err.response?.realUri ?? '');
      logPrint('BODY:');
      logger.e(err.response?.data.toString());
    }

    logPrint('*** Api Error - End ***:');
    return handler.next(err);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    logPrint('*** Api Response - Start ***');
    printKV('URI', response.requestOptions.uri);
    printKV('STATUS CODE', response.statusCode ?? '');
    printKV('REDIRECT', response.isRedirect ?? false);
    logPrint('BODY:');
    logger.i(response.data ?? '');
    logPrint('*** Api Response - End ***');
    return handler.next(response);
  }

  void printKV(String key, Object v) {
    logPrint('$key: $v');
  }

  void printAll(msg) {
    msg.toString().split('\n').forEach(logPrint);
  }

  void logPrint(String s) {
    debugPrint(s);
  }
}
