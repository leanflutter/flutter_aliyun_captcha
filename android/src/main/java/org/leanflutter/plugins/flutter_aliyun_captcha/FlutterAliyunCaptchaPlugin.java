package org.leanflutter.plugins.flutter_aliyun_captcha;

import android.content.Context;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.platform.PlatformViewFactory;
import io.flutter.plugin.platform.PlatformViewRegistry;

import static org.leanflutter.plugins.flutter_aliyun_captcha.Constants.ALIYUN_CAPTCHA_BUTTON_VIEWTYPE;
import static org.leanflutter.plugins.flutter_aliyun_captcha.Constants.CHANNEL_NAME;

/**
 * FlutterAliyunCaptchaPlugin
 */
public class FlutterAliyunCaptchaPlugin implements FlutterPlugin, MethodCallHandler {
    private FlutterPluginBinding pluginBinding;

    private MethodChannel channel;

    private String captchaHtmlPath;

    private void setupChannel(Context context, BinaryMessenger messenger) {
        this.channel = new MethodChannel(messenger, CHANNEL_NAME);
        this.channel.setMethodCallHandler(this);

        PlatformViewFactory captchaButtonViewFactory = new AliyunCaptchaButtonFactory(messenger, this.captchaHtmlPath);
        PlatformViewRegistry platformViewRegistry = pluginBinding.getFlutterEngine().getPlatformViewsController().getRegistry();
        platformViewRegistry.registerViewFactory(ALIYUN_CAPTCHA_BUTTON_VIEWTYPE, captchaButtonViewFactory);
    }

    private void teardownChannel() {
        this.channel.setMethodCallHandler(null);
        this.channel = null;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.pluginBinding = flutterPluginBinding;
        this.captchaHtmlPath = flutterPluginBinding.getFlutterAssets().getAssetFilePathBySubpath("assets/captcha.html", "flutter_aliyun_captcha");

        this.setupChannel(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        this.teardownChannel();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getSDKVersion")) {
            getSDKVersion(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void getSDKVersion(@NonNull MethodCall call, @NonNull Result result) {
        result.success("1.0.3");
    }
}
