#import <Foundation/Foundation.h>
#import <InAppMessaging/InAppMessaging-Swift.h>

#import "ReachabilityManager.h"
#import "InAppReachability.h"

// Initialize instance for Reachability API.
ReachabilityManager* reach;

@implementation InAppReachability

+ (void)load {
    // Listener for network changes.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged)
                                                 name:kReachabilityChangedNotification object:nil];
    
    reach = [ReachabilityManager reachabilityForInternetConnection];
    [reach startNotifier];
}

+ (void)reachabilityChanged {
    NetworkStatus remoteHostStatus = [reach currentReachabilityStatus];
    
    if (remoteHostStatus != NotReachable)
    {
        [InAppMessaging configure];
    }
}

@end
