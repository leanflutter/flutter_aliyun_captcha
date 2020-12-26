# flutter_aliyun_captcha

适用于 Flutter 的阿里云人机验证插件

> 支持滑动验证及智能验证（未适配刮刮卡及滑动验证）。

[![pub version][pub-image]][pub-url]

[pub-image]: https://img.shields.io/pub/v/flutter_aliyun_captcha.svg
[pub-url]: https://pub.dev/packages/flutter_aliyun_captcha

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [屏幕截图](#%E5%B1%8F%E5%B9%95%E6%88%AA%E5%9B%BE)
- [快速开始](#%E5%BF%AB%E9%80%9F%E5%BC%80%E5%A7%8B)
  - [安装](#%E5%AE%89%E8%A3%85)
  - [用法](#%E7%94%A8%E6%B3%95)
    - [滑动验证](#%E6%BB%91%E5%8A%A8%E9%AA%8C%E8%AF%81)
    - [智能验证](#%E6%99%BA%E8%83%BD%E9%AA%8C%E8%AF%81)
    - [获取 SDK 版本](#%E8%8E%B7%E5%8F%96-sdk-%E7%89%88%E6%9C%AC)
- [许可证](#%E8%AE%B8%E5%8F%AF%E8%AF%81)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## 屏幕截图

<div>
  <img src='./screenshots/flutter_aliyun_captcha-ios-slide.png' width=280>
  <img src='./screenshots/flutter_aliyun_captcha-ios-smart.png' width=280>
</div>

## 快速开始

### 安装

将此添加到包的 pubspec.yaml 文件中：

```yaml
dependencies:
  flutter_aliyun_captcha: ^1.0.0
```

您可以从命令行安装软件包：

```bash
$ flutter packages get
```

### 用法

导入 `flutter_aliyun_captcha`

```dart
import 'package:flutter_aliyun_captcha/flutter_aliyun_captcha.dart';
```

#### 滑动验证

> `AliyunCaptchaButton` 会根据其上层小部件的尺寸自适应，务必在上层小部件设置宽度和高度。

```dart
Container(
  width: double.infinity,
  height: 48,
  margin: EdgeInsets.only(
    top: 10,
    bottom: 10,
    left: 16,
    right: 16,
  ),
  child: AliyunCaptchaButton(
    controller: _captchaController,
    type: AliyunCaptchaType.slide, // 重要：请设置正确的类型
    option: AliyunCaptchaOption(
      appKey: '<appKey>',
      scene: 'scene',
      language: 'cn',
      // 更多参数请参见：https://help.aliyun.com/document_detail/193141.html
    ),
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
)
```

#### 智能验证

```dart
AliyunCaptchaButton(
    controller: _captchaController,
    type: AliyunCaptchaType.smart, // 重要：请设置正确的类型
    option: AliyunCaptchaOption(
      appKey: '<appKey>',
      scene: 'scene',
      language: 'cn',
      // 更多参数请参见：https://help.aliyun.com/document_detail/193144.html
    ),
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
)
```

#### 获取 SDK 版本

```dart
String sdkVersion = await AliyunCaptcha.sdkVersion;
```

## 许可证

```
MIT License

Copyright (c) 2019-2020 LiJianying <lijy91@foxmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
