import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'aliyun_captcha_controller.dart';
import 'aliyun_captcha_option.dart';
import 'aliyun_captcha_type.dart';
import 'constants.dart';

class AliyunCaptchaButton extends StatefulWidget {
  final AliyunCaptchaController controller;
  final AliyunCaptchaType type;
  final AliyunCaptchaOption option;
  final String customStyle;
  final Function(dynamic data) onSuccess;
  final Function(String failCode) onFailure;
  final Function(String errorCode) onError;

  AliyunCaptchaButton({
    Key key,
    this.controller,
    this.type,
    this.option,
    this.customStyle,
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
  AliyunCaptchaController _captchaController;

  AliyunCaptchaController get captchaController {
    if (widget.controller != null) {
      return widget.controller;
    }
    if (_captchaController == null) {
      _captchaController = AliyunCaptchaController();
    }
    return _captchaController;
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.type != widget.type ||
        json.encode(oldWidget.option) != json.encode(widget.option) ||
        oldWidget.customStyle != widget.customStyle) {
      captchaController.refresh(creationParams);
    }
  }

  Map<String, dynamic> get creationParams {
    AliyunCaptchaOption option = widget.option;
    Map<String, dynamic> creationParams = {
      'type': widget.type.toValue(),
      'optionJsonString': json.encode(option),
      'customStyle': widget.customStyle,
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
    if (captchaController != null) {
      captchaController.initWithViewId(viewId);
    }
    _eventChannel = EventChannel(
      '${kAliyunCaptchaButtonEventChannelName}_$viewId',
    );
    _eventChannel.receiveBroadcastStream().listen(_handleOnEvent);

    Future.delayed(Duration(milliseconds: 20))
        .then((value) => captchaController.refresh(null));
  }

  Widget _buildNativeView(BuildContext context) {
    if (Platform.isAndroid) {
      return PlatformViewLink(
        viewType: kAliyunCaptchaButtonViewType,
        surfaceFactory: (
          BuildContext context,
          PlatformViewController controller,
        ) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: kAliyunCaptchaButtonViewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..addOnPlatformViewCreatedListener((int id) {
              if (_onPlatformViewCreated == null) {
                return;
              }
              _onPlatformViewCreated(params.id);
            })
            ..create();
        },
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
