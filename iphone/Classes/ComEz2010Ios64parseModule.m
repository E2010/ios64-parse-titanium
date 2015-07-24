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


@implementation ComEz2010Ios64parseModule

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
