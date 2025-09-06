//implement base api logics such is re useble get, put , patch, post and delete
import 'package:http/http.dart' as http;

class Response {
  final int statusCode;
  final dynamic body;
}

Response({required this.statusCode, required this.body});

class Request {
  final String url;
  final dynamic body;

  Request({required this.url, required this.body});
}

class ApiError {
  final String message;
  final int statusCode;

  ApiError({required this.message, required this.statusCode});
}

class ApiResponse {
  final Response response;
  final Request request;
  final ApiError error;

  ApiResponse({required this.response, required this.request, required this.error});
}

class BaseApi {
  final String baseUrl;
  final String apiKey;
  final String apiSecret;
  final String apiToken;
  final String apiRefreshToken;
  final String apiExpiry;



  BaseApi({
    required this.baseUrl,
    required this.apiKey,
    required this.apiSecret,
    required this.apiToken,
    required this.apiRefreshToken,
    required this.apiExpiry,
  });


  Future<Response> get(String url) async {
    final response = await http.get(Uri.parse(baseUrl + url));
    return response;
  }

  Future<Response> post(String url, dynamic body) async {
    final response = await http.post(Uri.parse(baseUrl + url), body: body);
    return response;
  }

  Future<Response> put(String url, dynamic body) async {
    final response = await http.put(Uri.parse(baseUrl + url), body: body);
    return response;
  }
}