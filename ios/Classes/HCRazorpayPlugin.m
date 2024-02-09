#import "HCRazorpayPlugin.h"
#if __has_include(<htkc_razorpay/htkc_razorpay-Swift.h>)
#import <htkc_razorpay/htkc_razorpay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "htkc_razorpay-Swift.h"
#endif

@implementation HCRazorpayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHCRazorpayPlugin registerWithRegistrar:registrar];
}
@end
