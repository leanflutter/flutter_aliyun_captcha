import 'package:flutter/services.dart';

const _kMethodChannelName = 'flutter_aliyun_captcha';

class AliyunCaptcha {
  static const MethodChannel _methodChannel =
      const MethodChannel(_kMethodChannelName);

  static Future<String> get sdkVersion async {
    final String sdkVersion =
        await _methodChannel.invokeMethod('getSDKVersion');
    return sdkVersion;
  }
}
