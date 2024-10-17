import 'dart:convert';

import 'package:api_request_manager/api_request_manager.dart';
import 'package:api_request_manager/models/base_dto.dart';
import 'package:api_request_manager/services/network_and_api_error_handler.dart';
import 'package:cloud_logger/models/logger_event.dart';
import 'package:cloud_logger/models/request_data.dart';

class LoggerRepository {
  static const String _endpointName = 'App/Event';
  final ApiRequestManager _apiRequestManager;
  final RequestData requestData;

  LoggerRepository({required this.requestData})
      : _apiRequestManager =
            ApiRequestManager(logger: null, errorHandler: NetworkAndApiErrorHandler(logger: null));

  Future<void> logToCloud(LoggerEvent loggerEvent) async {
    try {
      if (requestData.baseUrl.isEmpty) {
        return;
      }
      final BaseDto response = await _getLogResponse(loggerEvent);
      if (response.isError) {
        await _getLogResponse(loggerEvent);
      }
    } catch (_) {}
  }

  Future<BaseDto> _getLogResponse(LoggerEvent loggerEvent) async {
    final Uri uri = Uri.parse('${requestData.baseUrl}/$_endpointName');
    final String body = json.encode(loggerEvent.toJson());
    final Map<String, String> headers = _apiRequestManager.getHeadersForUsernameAndPassword(
        username: requestData.username, password: requestData.password);
    return await _apiRequestManager.post(
        uri: uri, body: body, headers: headers, fromJson: BaseDto.fromJson);
  }
}
