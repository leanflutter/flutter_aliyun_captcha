import 'package:flutter/services.dart';

import 'aliyun_captcha_config.dart';

const _kMethodChannelName = 'flutter_aliyun_captcha';
const _kEventChannelName = 'flutter_aliyun_captcha/event_channel';

class AliyunCaptcha {
  static const MethodChannel _methodChannel =
      const MethodChannel(_kMethodChannelName);
  static const EventChannel _eventChannel =
      const EventChannel(_kEventChannelName);

  static bool _eventChannelReadied = false;

  static Function(dynamic) _verifyOnLoaded;
  static Function(dynamic) _verifyOnSuccess;
  static Function(dynamic) _verifyOnFail;

  static Future<String> get sdkVersion async {
    final String sdkVersion =
        await _methodChannel.invokeMethod('getSDKVersion');
    return sdkVersion;
  }

  static Future<bool> init(String appId) async {
    if (_eventChannelReadied != true) {
      _eventChannel.receiveBroadcastStream().listen(_handleVerifyOnEvent);
      _eventChannelReadied = true;
    }

    return await _methodChannel.invokeMethod('init', {
      'appId': appId,
    });
  }

  static Future<bool> verify({
    AliyunCaptchaConfig config,
    Function(dynamic data) onLoaded,
    Function(dynamic data) onSuccess,
    Function(dynamic data) onFail,
  }) async {
    _verifyOnLoaded = onLoaded;
    _verifyOnSuccess = onSuccess;
    _verifyOnFail = onFail;

    return await _methodChannel.invokeMethod('verify', config?.toJson());
  }

  static _handleVerifyOnEvent(dynamic event) {
    String method = '${event['method']}';
    dynamic data = event['data'];

    switch (method) {
      case 'onLoaded':
        if (_verifyOnLoaded != null) _verifyOnLoaded(data);
        break;
      case 'onSuccess':
        if (_verifyOnSuccess != null) _verifyOnSuccess(data);
        break;
      case 'onFail':
        if (_verifyOnFail != null) _verifyOnFail(data);
        break;
    }
  }
}
