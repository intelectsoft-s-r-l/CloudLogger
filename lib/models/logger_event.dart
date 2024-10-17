import 'package:cloud_logger/models/log_type.dart';
import 'package:cloud_logger/models/logger_event_source_data.dart';

class LoggerEvent extends LoggerEventSourceData {
  String? action;
  String? message;
  String? details;
  LogType logType;
  DateTime date;

  LoggerEvent({
    required this.action,
    required this.message,
    required this.details,
    required this.logType,
    required super.companyID,
    required super.licenseID,
    required super.hostName,
    required super.entity,
    required super.appVersion,
    required super.ip,
    required super.os,
    required super.ram,
    required super.companyName,
    required super.source,
  }) : date = DateTime.now();

  LoggerEvent.fromSourceData(
    LoggerEventSourceData sourceData, {
    required this.action,
    required this.message,
    required this.details,
    required this.logType,
  })  : date = DateTime.now(),
        super(
            companyID: sourceData.companyID,
            licenseID: sourceData.licenseID,
            hostName: sourceData.hostName,
            entity: sourceData.entity,
            appVersion: sourceData.appVersion,
            ip: sourceData.ip,
            os: sourceData.os,
            ram: sourceData.ram,
            companyName: sourceData.companyName,
            hdd: sourceData.hdd,
            source: sourceData.source);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (companyID != null) 'companyID': companyID,
      if (licenseID != null && licenseID!.isNotEmpty) 'licenseID': licenseID,
      'source': source,
      'action': action,
      'hostName': hostName,
      'entity': entity,
      'appVersion': appVersion,
      'ip': ip,
      'type': logType.code, // Assuming LogType has a code property
      'os': os,
      'ram': ram,
      'hdd': hdd,
      'company': companyName,
      'date': date.toIso8601String(),
      'message': message,
      'details': details,
    };
  }
}
