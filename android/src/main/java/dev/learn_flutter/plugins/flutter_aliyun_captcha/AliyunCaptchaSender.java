package dev.learn_flutter.plugins.flutter_aliyun_captcha;

public class AliyunCaptchaSender {
    private static AliyunCaptchaSender instance = new AliyunCaptchaSender();

    public static AliyunCaptchaSender getInstance() {
        return instance;
    }

    AliyunCaptchaListener listener;

    void listene(AliyunCaptchaListener listener) {
        this.listener = listener;
    }

    void onLoaded(String data) {
        this.listener.onLoaded(data);
    }

    void onSuccess(String data) {
        this.listener.onSuccess(data);
    }

    void onFail(String data) {
        this.listener.onFail(data);
    }
}
