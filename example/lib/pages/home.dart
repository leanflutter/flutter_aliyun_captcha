import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_aliyun_captcha/flutter_aliyun_captcha.dart';

const kLanguages = ['cn', 'en', 'ja_JP', 'ko_KR', 'ru_RU'];
const kTests = ['pass', 'block'];

class _ListSection extends StatelessWidget {
  final Widget title;

  const _ListSection({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.1),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: 10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              DefaultTextStyle(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                child: title,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const _ListItem({
    Key key,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: BoxConstraints(minHeight: 48),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: 8,
        ),
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Row(
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  child: title,
                ),
                Expanded(child: Container()),
                if (trailing != null) SizedBox(height: 34, child: trailing),
              ],
            ),
            if (subtitle != null) Container(child: subtitle),
          ],
        ),
      ),
      onTap: this.onTap,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AliyunCaptchaController _captchaController = AliyunCaptchaController();

  String _sdkVersion = 'Unknown';
  List<String> _logs = [];

  AliyunCaptchaType _captchaType = AliyunCaptchaType.slide;
  String _language = 'cn';
  String _test = '';

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

  void _addLog(String method, dynamic data) {
    _logs.add('>>>$method');
    if (data != null) {
      _logs.add(data is Map ? json.encode(data) : data);
    }
    _logs.add(' ');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  _ListItem(
                    title: Text('SDKVersion: $_sdkVersion'),
                    trailing: GestureDetector(
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () {
                        _captchaController.reset();
                        _logs = [];
                        setState(() {});
                      },
                    ),
                  ),
                  Divider(height: 0, indent: 16, endIndent: 16),
                  _ListItem(
                    title: Text('captchaType'),
                    trailing: ToggleButtons(
                      children: <Widget>[
                        for (var captchaType in AliyunCaptchaType.values)
                          Text(captchaType.name),
                      ],
                      onPressed: (int index) {
                        _captchaType = AliyunCaptchaType.values[index];

                        setState(() {});
                      },
                      isSelected: AliyunCaptchaType.values
                          .map((e) => e == _captchaType)
                          .toList(),
                    ),
                  ),
                  _ListSection(
                    title: Text('Option'),
                  ),
                  _ListItem(
                    title: Text('language'),
                    trailing: ToggleButtons(
                      children: <Widget>[
                        for (var language in kLanguages) Text(language),
                      ],
                      onPressed: (int index) {
                        _language = kLanguages[index];

                        setState(() {});
                      },
                      isSelected:
                          kLanguages.map((e) => e == _language).toList(),
                    ),
                  ),
                  Divider(height: 0, indent: 16, endIndent: 16),
                  _ListItem(
                    title: Text('test'),
                    trailing: ToggleButtons(
                      children: <Widget>[
                        for (var test in kTests) Text(test),
                      ],
                      onPressed: (int index) {
                        _test = kTests[index];

                        setState(() {});
                      },
                      isSelected: kTests.map((e) => e == _test).toList(),
                    ),
                  ),
                  Divider(height: 0, indent: 16, endIndent: 16),
                  SizedBox(height: 10),
                  Container(
                    // width: double.infinity,
                    width: 280,
                    height: 44,
                    margin: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 16,
                      right: 16,
                    ),
                    child: AliyunCaptchaButton(
                      controller: _captchaController,
                      type: _captchaType,
                      option: AliyunCaptchaOption(
                        appKey: 'FFFF0N00000000006CAB',
                        scene: _captchaType == AliyunCaptchaType.slide
                            ? 'nc_login'
                            : 'ic_login',
                        language: _language,
                        // hideErrorCode: true,
                        test: _test != 'block'
                            ? null
                            : _captchaType == AliyunCaptchaType.slide
                                ? 'code300'
                                : 800,
                      ),
                      customStyle: '''
                        .nc_scale {
                          background: #eeeeee !important;
                          /* 默认背景色 */
                        }

                        .nc_scale div.nc_bg {
                          background: #4696ec !important;
                          /* 滑过时的背景色 */
                        }

                        .nc_scale .scale_text2 {
                          color: #fff !important;
                          /* 滑过时的字体颜色 */
                        }

                        .errloading {
                          border: #ff0000 1px solid !important;
                          color: #ef9f06 !important;
                        }
                      ''',
                      onSuccess: (dynamic data) {
                        // {"sig": "...", "token": "..."}
                        _addLog('onSuccess', data);
                      },
                      onFailure: (String failCode) {
                        _addLog('onFailure', 'failCode: $failCode');
                      },
                      onError: (String errorCode) {
                        _addLog('onError', 'errorCode: $errorCode');
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var log in _logs) Text(log),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
