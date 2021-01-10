package org.leanflutter.plugins.flutter_aliyun_captcha;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.view.Gravity;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.ValueCallback;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import static org.leanflutter.plugins.flutter_aliyun_captcha.Constants.ALIYUN_CAPTCHA_BUTTON_CHANNEL_NAME;
import static org.leanflutter.plugins.flutter_aliyun_captcha.Constants.ALIYUN_CAPTCHA_BUTTON_EVENT_CHANNEL_NAME;

class FlutterAliyunCaptchaButtonJsInterface {
    private Handler handler = new Handler(Looper.getMainLooper());

    @JavascriptInterface
    public void onSuccess(final String data) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                AliyunCaptchaSender.getInstance().onSuccess(data);
            }
        };
        handler.post(runnable);
    }

    @JavascriptInterface
    public void onFailure(final String data) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                AliyunCaptchaSender.getInstance().onFailure(data);
            }
        };
        handler.post(runnable);
    }

    @JavascriptInterface
    public void onError(final String data) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                AliyunCaptchaSender.getInstance().onError(data);
            }
        };
        handler.post(runnable);
    }
}

public class FlutterAliyunCaptchaButton implements PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private final MethodChannel methodChannel;
    private final EventChannel eventChannel;

    private EventChannel.EventSink eventSink;

    private String captchaHtmlPath;
    private String captchaType;
    private String captchaOptionJsonString;

    private FrameLayout containerView;
    private WebView webView;

    private WebSettings webSettings;
    private WebViewClient webViewClient = new WebViewClient() {
        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);

            final float scale = webView.getContext().getResources().getDisplayMetrics().density;

            int widgetHeight = (int) (containerView.getMeasuredHeight() / scale);

            String jsCode = String.format("window._init('%s', {\"height\":%d}, '%s');",
                    captchaType,
                    widgetHeight,
                    captchaOptionJsonString
            );
            webView.evaluateJavascript(jsCode, new ValueCallback<String>() {
                @Override
                public void onReceiveValue(String value) {
                }
            });
        }

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            if (url != null && (url.startsWith("http://") || url.startsWith("https://"))) {
                view.getContext().startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
                return true;
            }
            return false;
        }
    };

    @SuppressLint("ResourceAsColor")
    FlutterAliyunCaptchaButton(
            final Context context,
            BinaryMessenger messenger,
            int viewId,
            Map<String, Object> params,
            String captchaHtmlPath) {
        methodChannel = new MethodChannel(messenger, ALIYUN_CAPTCHA_BUTTON_CHANNEL_NAME + "_" + viewId);
        methodChannel.setMethodCallHandler(this);


        eventChannel = new EventChannel(messenger, ALIYUN_CAPTCHA_BUTTON_EVENT_CHANNEL_NAME + "_" + viewId);
        eventChannel.setStreamHandler(this);

        FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT,
                Gravity.CENTER_HORIZONTAL | Gravity.CENTER_VERTICAL
        );
        this.containerView = new FrameLayout(context);
        this.containerView.setLayoutParams(layoutParams);

        this.webView = new WebView(context);

        this.webView.setBackgroundColor(android.R.color.transparent);
        this.webView.setWebViewClient(this.webViewClient);
        this.webView.addJavascriptInterface(new FlutterAliyunCaptchaButtonJsInterface(), "messageHandlers");

        this.webSettings = this.webView.getSettings();
        this.webSettings.setJavaScriptEnabled(true);
        this.webSettings.setAllowFileAccessFromFileURLs(true);
        this.webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
        this.webView.requestFocus();
        this.containerView.addView(webView);

        this.captchaHtmlPath = captchaHtmlPath;

        if (params.containsKey("type"))
            this.captchaType = (String) params.get("type");
        if (params.containsKey("optionJsonString"))
            this.captchaOptionJsonString = (String) params.get("optionJsonString");

        AliyunCaptchaSender.getInstance().listene(new AliyunCaptchaListener() {
            @Override
            public void onSuccess(String data) {
                final Map<String, Object> result = new HashMap<>();
                result.put("method", "onSuccess");
                result.put("data", convertMsgToMap(data));

                eventSink.success(result);
            }

            @Override
            public void onFailure(String data) {
                final Map<String, Object> result = new HashMap<>();
                result.put("method", "onFailure");
                result.put("data", convertMsgToMap(data));

                eventSink.success(result);
            }

            @Override
            public void onError(String data) {
                final Map<String, Object> result = new HashMap<>();
                result.put("method", "onError");
                result.put("data", convertMsgToMap(data));

                eventSink.success(result);
            }
        });
    }

    @Override
    public View getView() {
        return containerView;
    }

    @Override
    public void dispose() {

    }

    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object args) {
        this.eventSink = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("refresh")) {
            refresh(call, result);
        } else if (call.method.equals("reset")) {
            reset(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void refresh(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.arguments != null) {
            Map<String, Object> params = (Map<String, Object>) call.arguments;
            if (params.containsKey("type"))
                this.captchaType = (String) params.get("type");
            if (params.containsKey("optionJsonString"))
                this.captchaOptionJsonString = (String) params.get("optionJsonString");
        }
        this.webView.loadUrl("file:///android_asset/" + this.captchaHtmlPath);
        result.success(true);
    }

    private void reset(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String jsCode = "window.captcha_button.reset();";

        webView.evaluateJavascript(jsCode, new ValueCallback<String>() {
            @Override
            public void onReceiveValue(String value) {
            }
        });
        result.success(true);
    }

    private static Map<String, Object> convertMsgToMap(String jsonString) {
        Map<String, Object> map = new HashMap<String, Object>();
        JSONObject jsonObject = null;
        try {
            jsonObject = new JSONObject(jsonString);
            map = toMap(jsonObject);
        } catch (JSONException ex) {
            // skip;
        }
        return map;
    }

    private static Map<String, Object> toMap(JSONObject jsonObject) throws JSONException {
        Map<String, Object> map = new HashMap<String, Object>();
        Iterator<String> keys = jsonObject.keys();
        while (keys.hasNext()) {
            String key = keys.next();
            Object value = jsonObject.get(key);
            if (value instanceof JSONObject) {
                value = toMap((JSONObject) value);
            }
            map.put(key, value);
        }
        return map;
    }
}
