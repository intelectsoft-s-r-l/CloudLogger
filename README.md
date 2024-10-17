# Cloud Logger
The Cloud Logger package provides a robust logging solution for Flutter applications, enabling you to log events, exceptions, and request results to the cloud. It is built to work seamlessly with your API request manager and offers easy-to-use methods for capturing and sending log data.

## Features
1. Log exceptions with stack traces.
2. Log request results with customizable details.
3. Handle information or error log types.
4. Integration with an API request manager for sending logs to the cloud.
5. Log message and details to cloud.

## Installation
Add the package to your pubspec.yaml file:

```yaml
dependencies:
  cloud_logger:
    git:
      url: https://github.com/intelectsoft-s-r-l/CloudLogger
      ref: main
```
Then run:
```bash
flutter pub get
```

## Usage

### Step 1: Initialize CloudLogger

Before using the CloudLogger, you need to create an instance by providing a RequestData object and a LoggerEventSourceData object.

``` dart
import 'package:cloud_logger/cloud_logger.dart';

// Create an instance of RequestData
RequestData requestData = RequestData(
    baseUrl: 'https://api.example.com',
    username: 'your_username',
    password: 'your_password',
);

// Create an instance of LoggerEventSourceData
LoggerEventSourceData loggerEventSourceData = LoggerEventSourceData(
    companyID: 123,
    licenseID: '6d3fd3f6-ee7f-4b8b-aed1-799e025c209c',
    hostName: 'md.edi.myapp',
    entity: 'YourEntity',
    appVersion: '1.0.0',
    ip: '192.168.1.1',
    os: 'Android',
    ram: '2048MB',
    hdd: '2048MB'
    companyName: 'Your Company',
);

// Initialize CloudLogger
CloudLogger cloudLogger = CloudLogger(
    requestData: requestData,
    loggerEventSourceData: loggerEventSourceData,
);
```

### Step 2: Log Events

You can log exceptions and request results using the following methods.

#### Logging Exceptions
``` dart
try {
// Your code that might throw an exception
} catch (e, stackTrace) {
    await cloudLogger.logExceptionWithStack(e, stackTrace, cloudLogger.getMethodAndClassName());
}
```

#### Logging Request Results

``` dart
await cloudLogger.logRequestResult(
    endpoint: '/api/endpoint',
    action: 'Fetching data',
    dto: yourDtoObject, // Your data transfer object
    body: 'Request body',
    jsonResult: responseJson, // Response from the API
    isSuccess: true, // or false based on the result
);
```

#### Logging messages and details

``` dart
await cloudLogger.logToCloud(
    action: cloudLogger.getMethodAndClassName(),
    message: 'Executed retry',
    details: 'Your details',
    isError: false,
);
```

### Step 3: Customization

You can customize the log messages by modifying the action, message, and details fields as needed in the logging methods.

## Error Handling

The logger also allows you to handle API request errors gracefully by logging them with the appropriate error codes and messages. You can retrieve the error code from the JSON response as shown in the implementation.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any bugs or feature requests.