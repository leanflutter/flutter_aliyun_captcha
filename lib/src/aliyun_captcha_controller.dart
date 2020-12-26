import 'package:flutter/services.dart';

import './constants.dart';

class AliyunCaptchaController {
  MethodChannel _channel;

  void initWithViewId(int viewId) {
    _channel = MethodChannel('${kAliyunCaptchaButtonChannelName}_$viewId');
  }

  void refresh(Map<String, dynamic> refreshParams) {
    if (_channel == null) return;
    _channel.invokeMethod('refresh', refreshParams);
  }

  void reset() {
    if (_channel == null) return;
    _channel.invokeMethod('reset');
  }
}
