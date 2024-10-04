import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_app/common/utils.dart';
import 'package:task_app/core/usecase.dart';

import 'app_exception.dart';

Future<T> throwAppException<T>(FutureOr<T> Function() call) async {
  try {
    return (await call());
  } on AppException {
    rethrow;
  } on SocketException catch (e) {
    throw AppNetworkException(message: e.message, reason: AppNetworkExceptionReason.noInternet, exception: e);
  } on Exception catch (e) {
    throw AppException.unknown(exception: e, message: e.toString());
  } catch (e, s) {
    log(e.toString(), stackTrace: s);
    throw AppException.unknown(exception: e, message: e.toString());
  }
}

FutureResult<T> toApiResult<T>(FutureOr<T> Function() call) async {
  try {
    return Right(await call());
  } on AppNetworkResponseException catch (e) {
    if (e.data is! String) {
      return Left(e);
    }
    return Left(e);
  } on AppNetworkException catch (e) {
    final message = e.message;
    final appNetworkException = e.copyWith(message: message);
    return Left(appNetworkException);
  } on AppException catch (e) {
    return Left(e);
  } catch (e, s) {
    log(e.toString(), stackTrace: s);
    final exception = AppException.unknown(exception: e, message: e.toString());
    return Left(exception);
  }
}
