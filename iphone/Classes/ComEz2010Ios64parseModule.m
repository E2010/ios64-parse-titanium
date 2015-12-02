/**
 * iOS64TitaniumParse
 *
 * Created by Eileen
 * Copyright (c) 2015 Your Company. All rights reserved.
 */

#import "ComEz2010Ios64parseModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"
#import "JRSwizzle.h"

//added - Create a category which adds new methods to TiApp
@implementation TiApp (ParseTi)

- (void)parsetiApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions_ {
    // If you're successful, you should see the following output from titanium
    NSLog(@"[INFO] -- ParseTi#didFinishLaunchingWithOptions: --");
    
    [self parsetiApplication:application didFinishLaunchingWithOptions:launchOptions_];
    
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
}

- (void)parsetiApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you're successful, you should see the following output from titanium
    NSLog(@"[INFO] -- ParseTi#didReceiveRemoteNotification: --");
    
    [self parsetiApplication:application didReceiveRemoteNotification:userInfo];
    
    if (application.applicationState == UIApplicationStateInactive) {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

- (void)parsetiApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you're successful, you should see the following output from titanium
    NSLog(@"[INFO] -- ParseTi#didReceiveRemoteNotification:fetchCompletionHandler --");

    [self parsetiApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

@end

@implementation ComEz2010Ios64parseModule

+ (void)load {
    NSError *error = nil;
    [TiApp jr_swizzleMethod:@selector(application:didFinishLaunchingWithOptions:)
                 withMethod:@selector(parsetiApplication:didFinishLaunchingWithOptions:)
                      error:&error];
    
    if(error)
        NSLog(@"[WARN] Cannot swizzle parsetiApplication:didFinishLaunchingWithOptions: %@", error);
    
    [TiApp jr_swizzleMethod:@selector(application:didReceiveRemoteNotification:)
                 withMethod:@selector(parsetiApplication:didReceiveRemoteNotification:)
                      error:&error];
    
    if(error)
        NSLog(@"[WARN] Cannot swizzle parsetiApplication:didReceiveRemoteNotification: %@", error);

    [TiApp jr_swizzleMethod:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)
                 withMethod:@selector(parsetiApplication:didReceiveRemoteNotification:fetchCompletionHandler:)
                      error:&error];
    
    if(error)
        NSLog(@"[WARN] Cannot swizzle parsetiApplication:didReceiveRemoteNotification:fetchCompletionHandler: %@", error);
}


#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"fac13f8a-1d68-45d2-82ff-4cac163d9b5e";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.ez2010.ios64parse";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(void)initParse:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    NSDictionary *argsDic = [args objectAtIndex:0];
    
    NSString *appId = [argsDic objectForKey:@"appId"];
    NSString *clientKey = [argsDic objectForKey:@"clientKey"];
    
    ParseAdapter *pa = [ParseAdapter sharedParseAdapter];
    [pa setApplicationId:appId clientKey:clientKey];    
}

-(void)clearBadge:(id)args{
    ENSURE_ARG_COUNT(args, 0);
    ParseAdapter *pa = [ParseAdapter sharedParseAdapter];
    
    [pa clearBadge];
}

-(void)registerForPush:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    __block ComEz2010Ios64parseModule *selfRef = self;
    
    NSString *deviceToken = [args objectAtIndex:0];
    NSString *channel = [args objectAtIndex:1];
    KrollCallback *callback = [args objectAtIndex:2];
    
    ParseAdapter *pa = [ParseAdapter sharedParseAdapter];
    [pa registerForPushWithDeviceToken:deviceToken andSubscribeToChannel:channel withCallback:^(BOOL success, NSError *error){
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:success], @"success", [error userInfo], @"error", nil];
        [selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
    }];
}

-(void)registerForSinglePushChannel:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    __block ComEz2010Ios64parseModule *selfRef = self;
    
    NSString *deviceToken = [args objectAtIndex:0];
    NSString *channel = [args objectAtIndex:1];
    KrollCallback *callback = [args objectAtIndex:2];
    
    ParseAdapter *pa = [ParseAdapter sharedParseAdapter];
    [pa registerForSinglePushChannel:deviceToken andSubscribeToChannel:channel withCallback:^(BOOL success, NSError *error){
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:success], @"success", [error userInfo], @"error", nil];
        [selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
    }];
}

-(void)registerForMultiplePushChannel:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    __block ComEz2010Ios64parseModule *selfRef = self;
    
    NSString *deviceToken = [args objectAtIndex:0];
    NSArray *channels = [args objectAtIndex:1];
    KrollCallback *callback = [args objectAtIndex:2];
    NSLog(@"DEBUG: %@", channels);
    
    ParseAdapter *pa = [ParseAdapter sharedParseAdapter];
    [pa registerForMultiplePushChannel:deviceToken andSubscribeToChannel:channels withCallback:^(BOOL success, NSError *error){
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:success], @"success", [error userInfo], @"error", nil];
        [selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
    }];
    /*
    ParseAdapter *pa = [ParseAdapter sharedParseAdapter];
    [pa registerForMultiplePushChannel:deviceToken andSubscribeToChannel:channels withCallback:^(BOOL success, NSError *error){
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:success], @"success", [error userInfo], @"error", nil];
        [selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
    }];*/
}

-(void)unsubscribeFromAllChannels:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    __block ComEz2010Ios64parseModule *selfRef = self;
    
    KrollCallback *callback = [args objectAtIndex:0];
    
    ParseAdapter *pa = [ParseAdapter sharedParseAdapter];
    [pa unsubscribeFromAllChannels:^(BOOL success, NSError *error){
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:success], @"success", [error userInfo], @"error", nil];
        [selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
    }];
}

-(void)findObjects:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    __block ComEz2010Ios64parseModule *selfRef = self;
    
    NSString *className = [args objectAtIndex:0];
    NSArray *criteria = [args objectAtIndex:1];
    KrollCallback *callback = [args objectAtIndex:2];
    
    ParseAdapter *pa = [ParseAdapter sharedParseAdapter];
    [pa findObjectsOfClassName:className withCriteria:criteria andCallback:^(NSArray *results, NSError *error) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:results, @"results", [error userInfo], @"error", nil];
        [selfRef _fireEventToListener:@"completed" withObject:result listener:callback thisObject:nil];
    }];
}

-(id)example:(id)args
{
	// example method
	return @"hello world";
}

-(id)exampleProp
{
	// example property getter
	return @"hello world";
}

-(void)setExampleProp:(id)value
{
	// example property setter
}

@end
