//
//  FlutterAliyunCaptchaButton.h
//
//  Created by Lijy91 on 2020/12/24.
//

#import <WebKit/WebKit.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FlutterAliyunCaptchaButtonCallback)(NSDictionary *data);

// FlutterAliyunCaptchaButtonController
@interface FlutterAliyunCaptchaButtonController : NSObject <FlutterPlatformView, FlutterStreamHandler>

- (instancetype)initWithFrame:(CGRect)frame
viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;

@end

// FlutterAliyunCaptchaButtonFactory
@interface FlutterAliyunCaptchaButtonFactory : NSObject
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

// FlutterAliyunCaptchaButton
@interface FlutterAliyunCaptchaButton : UIView <WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) NSString* captchaHtmlPath;
@property (nonatomic, strong) NSString* captchaType;
@property (nonatomic, strong) NSString* captchaOptionJsonString;
@property (nonatomic, strong) NSString* captchaCustomStyle;
@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, strong) WKWebViewConfiguration * webViewConfiguration;

@property (nonatomic, copy) FlutterAliyunCaptchaButtonCallback onSuccess;
@property (nonatomic, copy) FlutterAliyunCaptchaButtonCallback onFailure;
@property (nonatomic, copy) FlutterAliyunCaptchaButtonCallback onError;

- (instancetype)initWithArguments:(id _Nullable)args;
- (void)refresh:(id _Nullable)args;
@end

NS_ASSUME_NONNULL_END
