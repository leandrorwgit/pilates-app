import 'package:app_pilates/login/login_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDio {
  var _dio;
  var baseOptions = BaseOptions(
    baseUrl: 'https://pilates-api.herokuapp.com/api/',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  CustomDio() {
    _dio = Dio(baseOptions);
  }

  CustomDio.comAutenticacao() {
    _dio = Dio(baseOptions);
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      // Do something before request is sent
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.get('app-pilates-token');
      if (token != null)
        options.headers['Authorization'] = 'Bearer ' + token.toString();
      return handler.next(options); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: return `dio.resolve(response)`.
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: return `dio.reject(dioError)`
    }, onResponse: (response, handler) {
      // Do something with response data
      return handler.next(response); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: return `dio.reject(dioError)`
    }, onError: (DioError error, handler) async {
      // Do something with response error
      if (error.response?.statusCode == 403 ||
          error.response?.statusCode == 401) {
        var options = error.response?.requestOptions;
        _dio.lock();
        _dio.interceptors.responseLock.lock();
        _dio.interceptors.errorLock.lock();
        var repository = LoginRepository();
        repository.loginComPreferences().then((token) {
          options!.headers['Authorization'] = 'Bearer ' + token;
        }).whenComplete(() {
          _dio.unlock();
          _dio.interceptors.responseLock.unlock();
          _dio.interceptors.errorLock.unlock();
        }).then((e) {
          // repete a chamada
          //dio.request(options.path, options: options));
          _dio.fetch(options).then(
            (r) => handler.resolve(r),
            onError: (e) {
              handler.reject(e);
            },
          );
        });
        return;
      }
      return handler.next(error); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: return `dio.resolve(response)`.
    }));
  }

  Dio get instancia => _dio;
}
