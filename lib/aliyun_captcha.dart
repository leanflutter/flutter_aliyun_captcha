import 'dart:convert';

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

  static String sdkAppKey;
  static Function(dynamic) _verifyOnLoaded;
  static Function(dynamic) _verifyOnSuccess;
  static Function(dynamic) _verifyOnCancel;

  static Future<String> get sdkVersion async {
    final String sdkVersion =
        await _methodChannel.invokeMethod('getSDKVersion');
    return sdkVersion;
  }

  static Future<bool> init(String appKey) async {
    if (_eventChannelReadied != true) {
      _eventChannel.receiveBroadcastStream().listen(_handleVerifyOnEvent);
      _eventChannelReadied = true;
    }

    sdkAppKey = appKey;

    return true;
  }

  static Future<bool> verify({
    AliyunCaptchaConfig config,
    Function(dynamic data) onLoaded,
    Function(dynamic data) onSuccess,
    Function(dynamic data) onCancel,
  }) async {
    _verifyOnLoaded = onLoaded;
    _verifyOnSuccess = onSuccess;
    _verifyOnCancel = onCancel;

    if (config == null) {
      config = new AliyunCaptchaConfig();
    }

    if (config?.appKey == null) {
      config.appKey = sdkAppKey;
    }

    return await _methodChannel.invokeMethod('verify', {
      'config': json.encode(config?.toJson()),
    });
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
      case 'onCancel':
        if (_verifyOnCancel != null) _verifyOnCancel(data);
        break;
    }
  }
}
