#import <Flutter/Flutter.h>

@interface FlutterFlavorConfigPlugin : NSObject<FlutterPlugin>
+ (NSDictionary *)env;
+ (NSString *)envFor: (NSString *)key;
@end
