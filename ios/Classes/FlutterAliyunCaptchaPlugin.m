#import "FlutterAliyunCaptchaPlugin.h"

@implementation FlutterAliyunCaptchaPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_aliyun_captcha"
                                     binaryMessenger:[registrar messenger]];

    FlutterAliyunCaptchaPlugin* instance = [[FlutterAliyunCaptchaPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterAliyunCaptchaButtonFactory* platformViewFactory = [[FlutterAliyunCaptchaButtonFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:platformViewFactory withId:@"leanflutter.org/aliyun_captcha_button"];
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getSDKVersion" isEqualToString:call.method]) {
        [self handleMethodGetSDKVersion:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)handleMethodGetSDKVersion:(FlutterMethodCall*)call
                           result:(FlutterResult)result
{
    NSString *sdkVersion = @"1.0.3";
    
    result(sdkVersion);
}

@end
