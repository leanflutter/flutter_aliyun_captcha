package org.leanflutter.plugins.flutter_aliyun_captcha;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public final class AliyunCaptchaButtonFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;
    private final String captchaHtmlPath;


    public AliyunCaptchaButtonFactory(BinaryMessenger messenger, String captchaHtmlPath) {
        super(StandardMessageCodec.INSTANCE);

        this.messenger = messenger;
        this.captchaHtmlPath = captchaHtmlPath;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        return new FlutterAliyunCaptchaButton(context, messenger, viewId, params, captchaHtmlPath);
    }
}
