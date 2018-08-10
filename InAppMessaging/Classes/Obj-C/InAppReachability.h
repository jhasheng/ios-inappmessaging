/**
 * Class to handle network status changes by adding an observer on app boot up.
 */
@class InAppReachability;

@interface InAppReachability: NSObject

/**
 * Invoked whenever a class or category is added to the obj-c runtime. E.G During app boot up.
 */
+ (void)load;

/**
 * Invoked when network status changes.
 * Retry communicating with configuration server if unsuccessful on previous attempt.
 */
+ (void)reachabilityChanged;

@end
