package org.leanflutter.plugins.flutter_aliyun_captcha;

public class AliyunCaptchaSender {
    private static AliyunCaptchaSender instance = new AliyunCaptchaSender();

    public static AliyunCaptchaSender getInstance() {
        return instance;
    }

    AliyunCaptchaListener listener;

    void listene(AliyunCaptchaListener listener) {
        this.listener = listener;
    }

    void onSuccess(String data) {
        this.listener.onSuccess(data);
    }

    void onFailure(String data) {
        this.listener.onFailure(data);
    }

    void onError(String data) {
        this.listener.onError(data);
    }
}
