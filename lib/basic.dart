import 'package:flutter/material.dart';

abstract class StateWithFuture<T extends StatefulWidget> extends State<T> {
  Object _lock;

  @override
  void initState() {
    super.initState();
    _lock = Object();
  }

  @override
  void setState(fn) {
    if (_lock != null) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _lock = null;
  }
}

enum ApiResponseStatus {
  loading,
  success,
  fail,
}

///api请求的包装类
class ApiResponse<T> {
  ApiResponseStatus status;
  T response;
  Exception error;

  ApiResponse.ofSuccess(T response) {
    this.response = response;
    status = ApiResponseStatus.success;
  }

  ApiResponse.ofLoading() {
    this.status = ApiResponseStatus.loading;
  }

  ApiResponse.ofError(Exception e) {
    this.status = ApiResponseStatus.fail;
    error = e;
  }

  bool success() {
    return status == ApiResponseStatus.success;
  }

  bool loading() {
    return status == ApiResponseStatus.loading;
  }

  bool fail() {
    return status == ApiResponseStatus.fail;
  }
}
