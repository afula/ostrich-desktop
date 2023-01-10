import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';

class HttpNetwork {
  HttpNetwork._internal();
  // final path = ":9443/ostrich/api/mobile/server/list";

  ///网络请求配置
  static final Dio dio = Dio(BaseOptions(
    connectTimeout: 60000,
    receiveTimeout: 3000,
  ));

  ///初始化dio
  static init() {
    ///初始化cookie

    //添加拦截器
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      return handler.next(options); //continue
    }, onResponse: (response, handler) {
      // Do something with response data
      return handler.next(response); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onError: (DioError e, handler) {
      // Do something with response error
      return handleError(e); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
    }));
  }

  ///error统一处理
  static void handleError(DioError e) {
    switch (e.type) {
      case DioErrorType.connectTimeout:
        EasyLoading.dismiss();
        EasyLoading.showToast('连接超时');
         Logger().d("连接超时");
        break;
      case DioErrorType.sendTimeout:
        EasyLoading.dismiss();
        EasyLoading.showToast('请求超时');
         Logger().d("请求超时");
        break;
      case DioErrorType.receiveTimeout:
        EasyLoading.dismiss();
        EasyLoading.showToast('响应超时');
         Logger().d("响应超时");
        break;
      case DioErrorType.response:
        EasyLoading.dismiss();
        EasyLoading.showToast('出现异常');
         Logger().d("出现异常");
        break;
      case DioErrorType.cancel:
        EasyLoading.dismiss();
        EasyLoading.showToast('请求取消');
         Logger().d("请求取消");
        break;
      default:
         Logger().d("未知错误");
        EasyLoading.dismiss();
        EasyLoading.showToast(e.toString());
        break;
    }
  }

  ///get请求
  static Future get(String url, Map<String, dynamic> params) async {
    Response response = await dio.get(url);
    return response.data;
  }

  ///post 表单请求
  static Future post(String url, Map<String, dynamic> params) async {
    Response response = await dio.post(url, queryParameters: params);
    return response.data;
  }

  ///post body请求
  static Future postJson(String url, Map<String, dynamic> data) async {
    Response response = await dio.post(url, data: data);
    return response.data;
  }
}
