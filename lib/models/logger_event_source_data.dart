class LoggerEventSourceData {
  LoggerEventSourceData(
      {required this.companyID,
      required this.licenseID,
      required this.hostName,
      required this.entity,
      required this.appVersion,
      required this.ip,
      required this.os,
      required this.ram,
      required this.companyName})
      : date = DateTime.now();

  int? companyID;
  String? companyName;
  String? licenseID;
  String? hostName;
  String? entity;
  String? appVersion;
  String? ip;
  String? os;
  String? ram;
  String source = '';
  String hdd = '';
  DateTime date;
}
