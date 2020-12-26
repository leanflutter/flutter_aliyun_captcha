//
//  FlutterAliyunCaptchaButton.m
//
//  Created by Lijy91 on 2020/12/24.
//

#import "FlutterAliyunCaptchaButton.h"

// FlutterAliyunCaptchaButtonController
@implementation FlutterAliyunCaptchaButtonController {
    UIView* _containerView;
    FlutterAliyunCaptchaButton* _aliyunCaptchaButton;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    FlutterEventChannel* _eventChannel;
    FlutterEventSink _eventSink;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if (self = [super init]) {
        _viewId = viewId;
        
        NSString* channelName = [NSString stringWithFormat:@"leanflutter.org/aliyun_captcha_button/channel_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        
        NSString* eventChannelName = [NSString stringWithFormat:@"leanflutter.org/aliyun_captcha_button/event_channel_%lld", viewId];
        _eventChannel = [FlutterEventChannel eventChannelWithName:eventChannelName
                                                  binaryMessenger:messenger];
        [_eventChannel setStreamHandler:self];
        
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
        
        _aliyunCaptchaButton = [[FlutterAliyunCaptchaButton alloc] initWithArguments:args];
        _aliyunCaptchaButton.onSuccess = ^(NSDictionary * _Nonnull data) {
            NSDictionary<NSString *, id> *eventData = @{
                @"method": @"onSuccess",
                @"data": data ?: @"",
            };
            self->_eventSink(eventData);
        };
        _aliyunCaptchaButton.onFailure = ^(NSDictionary * _Nonnull data) {
            NSDictionary<NSString *, id> *eventData = @{
                @"method": @"onFailure",
                @"data": data ?: @"",
            };
            self->_eventSink(eventData);
        };
        _aliyunCaptchaButton.onError = ^(NSDictionary * _Nonnull data) {
            NSDictionary<NSString *, id> *eventData = @{
                @"method": @"onError",
                @"data": data ?: @"",
            };
            self->_eventSink(eventData);
        };
    }
    return self;
}

- (UIView*)view {
    return _aliyunCaptchaButton;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    _eventSink = nil;
    
    return nil;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([[call method] isEqualToString:@"refresh"]) {
        [self refresh:call result: result];
    } else if ([[call method] isEqualToString:@"reset"]) {
        [self reset:call result: result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)refresh:(FlutterMethodCall*)call
         result:(FlutterResult)result {
    [_aliyunCaptchaButton refresh: call.arguments];
    result([NSNumber numberWithBool:YES]);
}

- (void)reset:(FlutterMethodCall*)call
       result:(FlutterResult)result {
    NSString *jsCode = @"window.captcha_button.reset();";
    [_aliyunCaptchaButton.webView evaluateJavaScript:jsCode completionHandler:^(id response, NSError * _Nullable error) {
        result([NSNumber numberWithBool:YES]);
    }];
}

@end

// FlutterAliyunCaptchaButtonFactory
@implementation FlutterAliyunCaptchaButtonFactory{
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger{
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    FlutterAliyunCaptchaButtonController* aliyunCaptchaButtonController = [[FlutterAliyunCaptchaButtonController alloc] initWithFrame:frame
                                                                                                                       viewIdentifier:viewId
                                                                                                                            arguments:args
                                                                                                                      binaryMessenger:_messenger];
    return aliyunCaptchaButtonController;
}
@end

@implementation FlutterAliyunCaptchaButton

- (instancetype)initWithArguments:(id _Nullable)args
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.webView = [[WKWebView alloc] initWithFrame:self.frame configuration:self.webViewConfiguration];
        self.webView.navigationDelegate = self;
        self.webView.UIDelegate = self;
        
        self.webView.backgroundColor = [UIColor clearColor];
        self.webView.scrollView.backgroundColor = [UIColor clearColor];
        self.webView.opaque = false;
        self.webView.scrollView.alwaysBounceVertical = false;
        self.webView.scrollView.bounces = false;
        
        [self addSubview:self.webView];
        
        NSString* captchaHtmlKey = [FlutterDartProject lookupKeyForAsset:@"assets/captcha.html" fromPackage:@"flutter_aliyun_captcha"];
        NSString* captchaHtmlPath = [[NSBundle mainBundle] pathForResource:captchaHtmlKey ofType:nil];
        self.captchaHtmlPath = captchaHtmlPath;
        self.captchaType = args[@"type"];
        self.captchaOptionJsonString = args[@"optionJsonString"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.webView != nil) {
        self.webView.frame = self.frame;
        
        [self refresh:nil];
    }
}

- (void)refresh:(id _Nullable)args {
    if (args != nil) {
        self.captchaType = args[@"type"];
        self.captchaOptionJsonString = args[@"optionJsonString"];
    }
    
    NSURL* url = [NSURL fileURLWithPath:self.captchaHtmlPath];
    if (@available(iOS 9.0, *)) {
        [self.webView loadFileURL:url allowingReadAccessToURL:url];
    }
}

-(WKWebViewConfiguration*) webViewConfiguration {
    if (!_webViewConfiguration) {
        // Create WKWebViewConfiguration instance
        _webViewConfiguration = [[WKWebViewConfiguration alloc]init];
        
        WKUserContentController* userContentController = [[WKUserContentController alloc] init];
        [userContentController addScriptMessageHandler:self name:@"onSuccess"];
        [userContentController addScriptMessageHandler:self name:@"onFailure"];
        [userContentController addScriptMessageHandler:self name:@"onError"];
        
        _webViewConfiguration.userContentController = userContentController;
        
        _webViewConfiguration.preferences.javaScriptEnabled = YES;
        _webViewConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    }
    return _webViewConfiguration;
}

#pragma mark -WKScriptMessageHandler
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    NSDictionary *messageBody = message.body;
    
    if ([message.name isEqualToString:@"onSuccess"]) {
        self.onSuccess(messageBody);
    } else if ([message.name isEqualToString:@"onFailure"]) {
        self.onFailure(messageBody);
    } else if ([message.name isEqualToString:@"onError"]) {
        self.onError(messageBody);
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *jsCode = [NSString stringWithFormat:@"window._init('%@', {\"width\":%f,\"height\":%f}, '%@');",
                        self.captchaType,
                        self.frame.size.width,
                        self.frame.size.height ,
                        self.captchaOptionJsonString];
    [self.webView evaluateJavaScript:jsCode completionHandler:^(id response, NSError * _Nullable error) {
        // skip
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@", error);
}

#pragma mark - WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    if (navigationAction.request.URL) {
        
        NSURL *url = navigationAction.request.URL;
        NSString *urlPath = url.absoluteString;
        if ([urlPath rangeOfString:@"https://"].location != NSNotFound || [urlPath rangeOfString:@"http://"].location != NSNotFound) {
            
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    return nil;
}

@end
