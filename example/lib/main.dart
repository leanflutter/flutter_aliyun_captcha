import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_aliyun_captcha/flutter_aliyun_captcha.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AliyunCaptcha.init('FFFF0N00000000006CAB');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _sdkVersion = 'Unknown';
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String sdkVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      sdkVersion = await AliyunCaptcha.sdkVersion;
    } on PlatformException {
      sdkVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _sdkVersion = sdkVersion;
    });
  }

  void _handleClickVerify() async {
    AliyunCaptchaConfig config = AliyunCaptchaConfig(
      bizState: 'aliyun-captcha',
      enableDarkMode: true,
      sdkOpts: {
        'width': 140,
        'height': 140,
      },
    );
    await AliyunCaptcha.verify(
      config: config,
      onLoaded: (dynamic data) {
        _addLog('onLoaded', data);
      },
      onSuccess: (dynamic data) {
        _addLog('onSuccess', data);
      },
      onFail: (dynamic data) {
        _addLog('onFail', data);
      },
    );
  }

  void _addLog(String method, dynamic data) {
    _logs.add('>>>$method');
    if (data != null) _logs.add(json.encode(data));
    _logs.add(' ');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Text('SDKVersion: $_sdkVersion'),
                    SizedBox(height: 10),
                    RaisedButton(
                      child: Text('验证'),
                      onPressed: () => _handleClickVerify(),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      for (var log in _logs)
                        Text(
                          log,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
