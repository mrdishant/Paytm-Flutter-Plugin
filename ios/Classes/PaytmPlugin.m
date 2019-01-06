#import "PaytmPlugin.h"
#import <paytm/paytm-Swift.h>

@implementation PaytmPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPaytmPlugin registerWithRegistrar:registrar];
}
@end
