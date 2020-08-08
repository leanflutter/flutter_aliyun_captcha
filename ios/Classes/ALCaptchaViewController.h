//
//  ALCaptchaViewController.h
//  flutter_aliyun_captcha
//
//  Created by Lijy91 on 2020/8/6.
//

#import <UIKit/UIKit.h>
#import "ALCaptchaWebView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ALCaptchaCallback)(NSDictionary *data);

@interface ALCaptchaViewController : UIViewController
- (instancetype)initWithConfig:(NSString*)config captchaHtmlPath:(NSString*) path;

@property (nonatomic, copy) ALCaptchaCallback onLoaded;
@property (nonatomic, copy) ALCaptchaCallback onSuccess;
@property (nonatomic, copy) ALCaptchaCallback onCancel;

@end

NS_ASSUME_NONNULL_END
