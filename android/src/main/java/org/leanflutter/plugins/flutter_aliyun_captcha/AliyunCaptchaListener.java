package org.leanflutter.plugins.flutter_aliyun_captcha;

public interface AliyunCaptchaListener {
    void onSuccess(String data);

    void onFailure(String data);

    void onError(String data);
}
