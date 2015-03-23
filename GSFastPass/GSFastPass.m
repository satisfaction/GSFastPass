//
//  GSFastPass.m
//  FastPass iOS Test App
//
//  Created by Andy Hite on 3/22/15.
//  Copyright (c) 2015 Andrew Hite. All rights reserved.
//

#import "GSFastPass.h"
#import "NSDictionary+QueryString.h"

#import <BDBOAuth1Manager/BDBOAuth1RequestOperationManager.h>
#import <BDBOAuth1Manager/NSString+BDBOAuth1Manager.h>

@interface BDBOAuth1RequestSerializer ()

- (NSString *)OAuthAuthorizationHeaderForMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error;

@end

@implementation GSFastPass {
    NSURL *baseURL;
    NSURL *baseCallbackURL;
    BDBOAuth1RequestSerializer *requestSerializer;
}

- (instancetype)initWithHost:(NSString *)host protocol:(NSString *)protocol consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret {
   
    self = [super init];
    
    if (self) {
        baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", protocol, host]];
        baseCallbackURL = [NSURL URLWithString:@"/fastpass" relativeToURL:baseURL];
        requestSerializer = [[BDBOAuth1RequestOperationManager alloc] initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret].requestSerializer;
        
        return self;
    }
    
    return nil;
}

- (NSURL *)loginUrlForCommunity:(NSString *)community email:(NSString *)email name:(NSString *)name uid:(NSString *)uid {
    NSString *encodedCallbackURL = [[[self callbackURLForEmail:email name:name uid:uid] absoluteString] bdb_URLEncode];
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?fastpass=%@", [baseURL absoluteString], community, encodedCallbackURL]];
}

- (NSURL *)callbackURLForEmail:(NSString *)email name:(NSString *)name uid:(NSString *)uid {
    NSString *query = [self authorizationQueryForURL:baseCallbackURL parameters:@{ @"email": email, @"name": name, @"uid": uid }];
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [baseCallbackURL absoluteString], query]];
}

- (NSString *)authorizationHeaderForUrl:(NSURL *)url parameters:(NSDictionary *)parameters {
    return [requestSerializer OAuthAuthorizationHeaderForMethod:@"GET" URLString:[url absoluteString] parameters:parameters error:nil];
}

- (NSString *)authorizationQueryForURL:(NSURL *)url parameters:(NSDictionary *)parameters {
    NSString *header = [self authorizationHeaderForUrl:url parameters:parameters];
    
    NSMutableDictionary *headerDictionary = [[GSFastPass convertHeaderToDictionary:header] mutableCopy];
    
    [headerDictionary addEntriesFromDictionary:parameters];
    
    return [headerDictionary queryStringRepresentation];
}

+ (NSDictionary *)convertHeaderToDictionary:(NSString *)header {
    NSMutableString *mutableHeaders = [header mutableCopy];
   
    for (NSString *stringToRemove in [NSArray arrayWithObjects:@"\"", @"Oauth ", nil]) {
        [mutableHeaders replaceOccurrencesOfString:stringToRemove withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mutableHeaders length])];
    }
    
    NSMutableDictionary *headerDictionary = [[NSMutableDictionary alloc] init];
   
    [[mutableHeaders componentsSeparatedByString:@", "] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *headerPair = [obj componentsSeparatedByString:@"="];
        [headerDictionary setObject:[headerPair objectAtIndex:1] forKey:[headerPair objectAtIndex:0]];
    }];
    
    return headerDictionary;
}

@end
