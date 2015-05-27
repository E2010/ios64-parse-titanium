//
//  ParseAdapter.h
//  iOS64TitaniumParse
//
//  Created by Eileen Zhang on 2015-05-07.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ParseAdapter : NSObject

+(ParseAdapter *)sharedParseAdapter;
-(void)setApplicationId:(NSString *)appId clientKey:(NSString *)clientKey;

// PFPush
- (void)registerForPushWithDeviceToken:(NSString *)deviceToken andSubscribeToChannel:(NSString *)channel withCallback:(void(^)(BOOL, NSError *))callbackBlock;
- (void)registerForSinglePushChannel:(NSString *)deviceToken andSubscribeToChannel:(NSString *)channel withCallback:(void(^)(BOOL, NSError *))callbackBlock;
- (void)unsubscribeFromPushChannel:(NSString *)channel withCallback:(void(^)(BOOL, NSError *))callbackBlock;
- (void)clearBadge;
- (void)unsubscribeFromAllChannels:(void(^)(BOOL, NSError *))callbackBlock;

// PFObject
-(void)findObjectsOfClassName:(NSString *)className withCriteria:(NSArray *)criteria andCallback:(void(^)(NSArray *, NSError *))callbackBlock;

@end
