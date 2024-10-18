library cloud_logger;

import 'package:api_request_manager/interfaces/logger.dart';
import 'package:cloud_logger/models/log_type.dart';
import 'package:cloud_logger/models/logger_event.dart';
import 'package:cloud_logger/models/logger_event_source_data.dart';
import 'package:cloud_logger/logger_repository.dart';
import 'package:cloud_logger/models/request_data.dart';
import 'package:flutter/foundation.dart';

export 'export_models.dart';

class CloudLogger implements Logger {
  final LoggerEventSourceData loggerEventSourceData;
  final LoggerRepository loggerRepository;

  CloudLogger({required RequestData requestData, required this.loggerEventSourceData})
      : loggerRepository = LoggerRepository(requestData: requestData);

  @override
  String getMethodAndClassName({int callDepth = 0}) {
    final List<StackFrame> currentFrames = StackFrame.fromStackTrace(StackTrace.current);
    StackFrame stackFrame;
    if (currentFrames.length < callDepth + 1) {
      stackFrame = currentFrames[currentFrames.length - 1];
    } else {
      stackFrame = currentFrames[callDepth + 1];
    }
    String? className = '${stackFrame.className}.';
    String? parentName = className.isEmpty ? '${stackFrame.package}:' : className;
    return '$parentName${stackFrame.method}';
  }

  @override
  Future<void> logExceptionWithStack(
      Object exception, StackTrace? stackTrace, String action) async {
    logToCloud(
        action: action,
        message: 'Exception occurred: $exception',
        details: 'Stack trace: $stackTrace',
        isError: true);
  }

  @override
  Future<void> logRequestResult(
      {required String endpoint,
      required String action,
      required dynamic dto,
      required String? body,
      required Map<String, dynamic> jsonResult,
      bool? isSuccess}) async {
    try {
      String dtoInformation = dto != null ? 'DTO: $dto' : '';
      if (isSuccess == null) {
        int errorCode = getErrorCode(jsonResult);
        isSuccess = errorCode == 0;
      }
      logToCloud(
          action: action,
          message: 'Called $endpoint with ${isSuccess ? 'success' : 'failure'}',
          details:
              'The request result: $jsonResult. \nWhat I sent as the request body: $body. ${dtoInformation.isEmpty ? '' : '\nWhat i deserialized: $dtoInformation'}',
          isError: !isSuccess);
    } catch (_) {}
  }

  @override
  Future<void> logToCloud(
      {required String action,
      required String details,
      required bool isError,
      required String message}) async {
    try {
      LoggerEvent? loggerEvent = await _getLoggerEvent(
          action: action,
          message: message,
          details: details,
          logType: isError ? LogType.error : LogType.information);
      if (loggerEvent == null) {
        return;
      }
      await loggerRepository.logToCloud(loggerEvent);
    } catch (_) {}
  }

  int getErrorCode(Map<String, dynamic> json) {
    return json['errorCode'] ?? json['ErrorCode'];
  }

  Future<LoggerEvent?> _getLoggerEvent(
      {required String action,
      required String message,
      required String details,
      required LogType logType}) async {
    return LoggerEvent.fromSourceData(loggerEventSourceData,
        action: action, message: message, details: details, logType: logType);
  }
}
