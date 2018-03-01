//
//  ParseAdapter.m
//  iOS64TitaniumParse
//
//  Created by Eileen Zhang on 2015-05-07.
//
//

#import "ParseAdapter.h"

@implementation ParseAdapter

static ParseAdapter *sharedAdapter;

+(ParseAdapter *)sharedParseAdapter {
    if(!sharedAdapter) {
        sharedAdapter = [[ParseAdapter alloc]init];
    }
    return sharedAdapter;
}

-(void)setApplicationId:(NSString *)appId clientKey:(NSString *)clientKey{
    [Parse setApplicationId:appId clientKey:clientKey];
    
    // Test id
    //[Parse setApplicationId:@"HvTJw1DHRZ3X4OFWG802vk08W5c0lFU7b6Y3IN8f"
    //              clientKey:@"L4EZXj2nE1lm4CQzzVo9w7p3bLPbtOz423HFqaFi"];
}

- (void)setUserEmail:(NSString *)email{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"userEmail"] = email;
    [currentInstallation saveInBackground];
}

- (void)initializeWithConfiguration:(NSString *)appId clientKey:(NSString *)clientKey serverUrl:(NSString *)serverUrl{
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = appId;
        configuration.clientKey = clientKey;
        configuration.server = serverUrl;
    }]];
}

- (void)clearBadge {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (void)registerForPushWithDeviceToken:(NSString *)deviceToken andSubscribeToChannel:(NSString *)channel withCallback:(void(^)(BOOL, NSError *))callbackBlock {
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation addUniqueObject:channel forKey:@"channels"];
    
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        callbackBlock(succeeded, error);
    }];
}

- (void)registerForSinglePushChannel:(NSString *)deviceToken andSubscribeToChannel:(NSString *)channel withCallback:(void(^)(BOOL, NSError *))callbackBlock {
    
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    NSArray *array = [NSArray arrayWithObjects:channel,nil];
    currentInstallation.channels = array;
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        callbackBlock(succeeded, error);
    }];
}

- (void)registerForMultiplePushChannel:(NSString *)deviceToken andSubscribeToChannel:(NSArray *)channels withCallback:(void(^)(BOOL, NSError *))callbackBlock {
    
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = channels;
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        callbackBlock(succeeded, error);
    }];
}

- (void)unsubscribeFromPushChannel:(NSString *)channel withCallback:(void(^)(BOOL, NSError *))callbackBlock {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation removeObject:channel forKey:@"channels"];
    
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        callbackBlock(succeeded, error);
    }];
}

- (void)unsubscribeFromAllChannels:(void(^)(BOOL, NSError *))callbackBlock {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation.channels = [NSArray array];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        callbackBlock(succeeded, error);
    }];
}


-(void)findObjectsOfClassName:(NSString *)className withCriteria:(NSArray *)criteria andCallback:(void(^)(NSArray *, NSError *))callbackBlock {
    
    PFQuery *query = [PFQuery queryWithClassName:className];
    
    for(NSInteger i = 0; i < [criteria count]; i++) {
        NSDictionary *dic = [criteria objectAtIndex:i];
        
        NSString *key = [dic objectForKey:@"key"];
        NSString *condition = [dic objectForKey:@"condition"];
        
        // if it should be a PFObject, let it be so in query
        id value = [self convertToPFObjectIfNeededWithObject:[dic objectForKey:@"value"]];
        
        if([condition isEqualToString:@"=="]) {
            [query whereKey:key equalTo:value];
        } else if([condition isEqualToString:@">"]) {
            [query whereKey:key greaterThan:value];
        } else if([condition isEqualToString:@">="]) {
            [query whereKey:key greaterThanOrEqualTo:value];
        } else if([condition isEqualToString:@"<"]) {
            [query whereKey:key lessThan:value];
        } else if([condition isEqualToString:@"<="]) {
            [query whereKey:key lessThanOrEqualTo:value];
        } else if([condition isEqualToString:@"!="]) {
            [query whereKey:key notEqualTo:value];
        } else if([condition isEqualToString:@"in"]) {
            [query whereKey:key containedIn:value];
        } else if([condition isEqualToString:@"not in"]) {
            [query whereKey:key notContainedIn:value];
        } else if([condition isEqualToString:@"orderby"] && [value isEqualToString:@"asc"]) {
            [query orderByAscending:key];
        } else if([condition isEqualToString:@"orderby"] && [value isEqualToString:@"desc"]) {
            [query orderByDescending:key];
        }
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // convert PFObjects to NSDictionaries
        NSMutableArray *responseArray = [NSMutableArray arrayWithCapacity:[objects count]];
        
        for(NSInteger i = 0; i < [objects count]; i++) {
            
            PFObject *curObj = [objects objectAtIndex:i];
            NSDictionary *dic = [self convertPFObjectToNSDictionary:curObj];
            
            [responseArray setObject:dic atIndexedSubscript:i];
        }
        
        callbackBlock(responseArray, error);
    }];
}

-(id)convertToPFObjectIfNeededWithObject:(id)obj {
    if([obj isKindOfClass:[NSDictionary class]]) {
        // check if it needs to be a PFObject
        NSString *className = [obj objectForKey:@"_className"];
        NSString *objectId = [obj objectForKey:@"_objectId"];
        
        if(className && objectId) { // let's make it a PFObject
            PFObject *pfObj = [PFObject objectWithoutDataWithClassName:className objectId:objectId];
            
            // go through and assign keys
            NSArray *keys = [obj allKeys];
            NSEnumerator *e = [keys objectEnumerator];
            id key;
            
            while (key = [e nextObject]) {
                id curValue = [obj objectForKey:key];
                
                if([key isEqualToString:@"_className"] ||
                   [key isEqualToString:@"_objectId"] ||
                   [key isEqualToString:@"_createdAt"] ||
                   [key isEqualToString:@"_updatedAt"]) {
                    continue;
                }
                
                // ignore ACL as we don't have a format set up to conver to JS yet
                if([curValue isKindOfClass:[NSString class]] ||
                   [curValue isKindOfClass:[NSNumber class]] ||
                   [curValue isKindOfClass:[NSArray class]]) {
                    
                    [pfObj setObject:curValue forKey:key];
                } else if([curValue isKindOfClass:[NSDictionary class]]) {
                    NSString *className = [curValue objectForKey:@"_className"];
                    
                    if(className) { // it's a type of PFObject
                        if([className isEqualToString:@"_File"]) { // ignore PFFiles, as we can't recreate them
                            continue;
                        }
                        [pfObj setObject:[self convertToPFObjectIfNeededWithObject:curValue] forKey:key];
                    } else { // just an NSDictionary
                        [pfObj setObject:curValue forKey:key];
                    }
                }
            }
            return pfObj;
        }
    }
    
    return obj;
}

-(NSDictionary *)convertPFObjectToNSDictionary:(PFObject *)curObj {
    NSArray *keys = [curObj allKeys];
    NSEnumerator *e = [keys objectEnumerator];
    id object;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    while (object = [e nextObject]) {
        id curValue = [curObj objectForKey:object];
        
        // ignore ACL as we don't have a format set up to conver to JS yet
        if([curValue isKindOfClass:[PFACL class]]) {
            continue;
        }
        
        if([curValue isKindOfClass:[PFFile class]]) {
            PFFile *curFile = curValue;
            
            curValue = [NSDictionary dictionaryWithObjectsAndKeys:curFile.name, @"name", curFile.url, @"url", @"_File", @"_className", nil];
        } else if([curValue isKindOfClass:[PFObject class]]) {
            PFObject *curPFObj = curValue;
            
            NSString *className = [curPFObj className];
            NSString *objectId = [curPFObj objectId];
            
            curValue = [NSDictionary dictionaryWithObjectsAndKeys:className, @"_className", objectId, @"_objectId", nil];
        }
        
        [dict setValue:curValue forKey:object];
    }
    // assign id
    [dict setValue:curObj.objectId forKey:@"_objectId"];
    
    // remember className
    //[dict setValue:curObj.className forKey:@"_className"];
    
    // assign createdAt, updatedAt
    [dict setValue:curObj.createdAt forKey:@"_createdAt"];
    [dict setValue:curObj.updatedAt forKey:@"_updatedAt"];
    
    return [dict autorelease];
}


@end
