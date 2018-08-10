/**
 * This class is taken and renamed from 'Reachability' to 'ReachabilityManager'
 * to resolve posssible app rejection by the app store.
 * Original repo of the class can be found here: https://github.com/tonymillion/Reachability
 */

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>


/**
 * Create NS_ENUM macro if it does not exist on the targeted version of iOS or OS X.
 *
 * @see http://nshipster.com/ns_enum-ns_options/
 **/
#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

extern NSString *const kReachabilityChangedNotification;

typedef NS_ENUM(NSInteger, NetworkStatus) {
    // Apple NetworkStatus Compatible Names.
    NotReachable = 0,
    ReachableViaWiFi = 2,
    ReachableViaWWAN = 1
};

@class ReachabilityManager;

typedef void (^NetworkReachable)(ReachabilityManager * reachability);
typedef void (^NetworkUnreachable)(ReachabilityManager * reachability);


@interface ReachabilityManager : NSObject

@property (nonatomic, copy) NetworkReachable    reachableBlock;
@property (nonatomic, copy) NetworkUnreachable  unreachableBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;


+(ReachabilityManager*)reachabilityWithHostname:(NSString*)hostname;
// This is identical to the function above, but is here to maintain
//compatibility with Apples original code. (see .m)
+(ReachabilityManager*)reachabilityWithHostName:(NSString*)hostname;
+(ReachabilityManager*)reachabilityForInternetConnection;
+(ReachabilityManager*)reachabilityWithAddress:(void *)hostAddress;
+(ReachabilityManager*)reachabilityForLocalWiFi;

-(ReachabilityManager *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

-(BOOL)startNotifier;
-(void)stopNotifier;

-(BOOL)isReachable;
-(BOOL)isReachableViaWWAN;
-(BOOL)isReachableViaWiFi;

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
-(BOOL)isConnectionRequired; // Identical DDG variant.
-(BOOL)connectionRequired; // Apple's routine.
// Dynamic, on demand connection?
-(BOOL)isConnectionOnDemand;
// Is user intervention required?
-(BOOL)isInterventionRequired;

-(NetworkStatus)currentReachabilityStatus;
-(SCNetworkReachabilityFlags)reachabilityFlags;
-(NSString*)currentReachabilityString;
-(NSString*)currentReachabilityFlags;

@end
