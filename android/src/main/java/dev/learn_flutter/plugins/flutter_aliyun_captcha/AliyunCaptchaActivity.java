package dev.learn_flutter.plugins.flutter_aliyun_captcha;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.JavascriptInterface;
import android.webkit.ValueCallback;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

class AliyunCaptchaJsInterface {
    private Handler handler = new Handler(Looper.getMainLooper());
    private DialogInterface.OnDismissListener listener;

    public AliyunCaptchaJsInterface(DialogInterface.OnDismissListener listener) {
        this.listener = listener;
    }

    @JavascriptInterface
    public void onLoaded(final String data) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                AliyunCaptchaSender.getInstance().onLoaded(data);
            }
        };
        handler.post(runnable);
    }

    @JavascriptInterface
    public void onSuccess(final String data) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                AliyunCaptchaSender.getInstance().onSuccess(data);

                listener.onDismiss(null);
            }
        };
        handler.post(runnable);
    }

    @JavascriptInterface
    public void onFail(final String data) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                AliyunCaptchaSender.getInstance().onFail(data);
                listener.onDismiss(null);
            }
        };
        handler.post(runnable);
    }
}

public class AliyunCaptchaActivity extends Activity implements DialogInterface.OnDismissListener {
    private AliyunCaptchaConfig config;

    private WebView webView;
    private WebSettings webSettings;
    private WebViewClient webViewClient = new WebViewClient() {
        @RequiresApi(api = Build.VERSION_CODES.KITKAT)
        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);

            String jsCode = String.format("window._verify(\"%s\");", config.appId);
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

    @SuppressLint({"ResourceAsColor", "AddJavascriptInterface", "SetJavaScriptEnabled"})
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);

            window.setStatusBarColor(Color.parseColor("#99000000"));
        }

        this.webView = new WebView(this);

        this.webView.setBackgroundColor(android.R.color.transparent);
        this.webView.setWebViewClient(this.webViewClient);
        this.webView.addJavascriptInterface(new AliyunCaptchaJsInterface(this), "messageHandlers");

        this.webSettings = this.webView.getSettings();
        this.webSettings.setJavaScriptEnabled(true);
        this.webSettings.setAllowFileAccessFromFileURLs(true);
        this.webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
        this.webView.requestFocus();

        Intent intent = getIntent();
        if (intent.hasExtra("config")) {
            this.config = (AliyunCaptchaConfig) intent.getSerializableExtra("config");
        }
        if (intent.hasExtra("captchaHtmlPath")) {
            String captchaHtmlPath = intent.getStringExtra("captchaHtmlPath");
            this.webView.loadUrl("file:///android_asset/" + captchaHtmlPath);
        }

        this.setContentView(this.webView);
    }

    @Override
    protected void onPause() {
        overridePendingTransition(0, 0);
        super.onPause();
    }

    @Override
    public void onDismiss(DialogInterface dialog) {
        this.finish();
    }
}
