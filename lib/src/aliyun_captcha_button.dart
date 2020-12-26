import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'aliyun_captcha_controller.dart';
import 'aliyun_captcha_option.dart';
import 'aliyun_captcha_type.dart';
import 'constants.dart';

class AliyunCaptchaButton extends StatefulWidget {
  final AliyunCaptchaController controller;
  final AliyunCaptchaType type;
  final AliyunCaptchaOption option;
  final Function(dynamic data) onSuccess;
  final Function(String failCode) onFailure;
  final Function(String errorCode) onError;

  AliyunCaptchaButton({
    Key key,
    this.controller,
    this.type,
    this.option,
    this.onSuccess,
    this.onFailure,
    this.onError,
  }) : super(key: key);

  @override
  _AliyunCaptchaButtonState createState() => _AliyunCaptchaButtonState();
}

class _AliyunCaptchaButtonState extends State<AliyunCaptchaButton> {
  GlobalKey _captchaButtonKey = GlobalKey();

  EventChannel _eventChannel;

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.type != widget.type ||
        json.encode(oldWidget.option) != json.encode(widget.option)) {
      if (widget.controller != null) {
        widget.controller.refresh(creationParams);
      }
    }
  }

  Map<String, dynamic> get creationParams {
    AliyunCaptchaOption option = widget.option;
    Map<String, dynamic> creationParams = {
      'type': widget.type.toValue(),
      'optionJsonString': json.encode(option),
    };
    return creationParams;
  }

  void _handleOnEvent(dynamic event) {
    String method = '${event['method']}';
    dynamic data = event['data'];

    switch (method) {
      case 'onSuccess':
        if (widget.onSuccess != null) widget.onSuccess(data);
        break;
      case 'onFailure':
        if (widget.onFailure != null) {
          String failCode = data['failCode'];
          widget.onFailure(failCode);
        }
        break;
      case 'onError':
        if (widget.onError != null) {
          String errorCode = data['errorCode'];
          widget.onError(errorCode);
        }
        break;
    }
  }

  void _onPlatformViewCreated(int viewId) {
    if (widget.controller != null) {
      widget.controller.initWithViewId(viewId);
    }
    _eventChannel = EventChannel(
      '${kAliyunCaptchaButtonEventChannelName}_$viewId',
    );
    _eventChannel.receiveBroadcastStream().listen(_handleOnEvent);
  }

  Widget _buildNativeView(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: kAliyunCaptchaButtonViewType,
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: kAliyunCaptchaButtonViewType,
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _captchaButtonKey,
      width: double.infinity,
      height: double.infinity,
      child: _buildNativeView(context),
    );
  }
}
