import 'package:dio/dio.dart';

class Apihelper {
  static Dio? _dio;
  Apihelper._();
  static void init (){
    _dio = Dio(
      BaseOptions(
        baseUrl: "",
        receiveTimeout: const Duration(
          seconds: 60,
        ),
        headers: {
          "lang": "en",
          "Content-Type": "application/json",
        },
      ),
    );
  }
  static Future<Response> getData ({required String path ,Map<String, dynamic>? queryParameters,})async{
    final response =await  _dio!.get(path, queryParameters: queryParameters);
    return response;
  }

  static Future<Response?> PostData({required String path ,Map<String, dynamic>? queryParameters, Map<String,dynamic>?Body  ,})async{

   final response = await _dio?.post(path,data: Body,queryParameters:queryParameters );

   return response;
  }


  //Put
  static Future<Response> putData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    final response = _dio!.put(
      path,
      queryParameters: queryParameters,
      data: body,
    );
    return response;
  }

  //Delete
  static Future<Response> deleteData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    final response = _dio!.delete(
      path,
      queryParameters: queryParameters,
      data: body,
    );
    return response;
  }




}
