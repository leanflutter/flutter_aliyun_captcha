package dev.learn_flutter.plugins.flutter_aliyun_captcha;

public interface AliyunCaptchaListener {
    void onLoaded(String data);

    void onSuccess(String data);

    void onFail(String data);
}
