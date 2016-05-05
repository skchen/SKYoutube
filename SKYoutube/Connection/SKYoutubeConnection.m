//
//  SKYoutubeConnection.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeConnection.h"

@implementation SKYoutubeConnection

+ (nonnull SKYoutubePagedListResponse *)pagedListForApi:(nonnull NSString *)api andParameter:(NSDictionary *)parameter {
    
    NSString *urlString = [SKYoutubeConnection urlForScheme:@"https" Host:@"www.googleapis.com" andPort:443 andApi:api andParameter:parameter];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    return [[SKYoutubePagedListResponse alloc] initWithData:data];
}

+ (nonnull NSString *)urlForScheme:(nonnull NSString *)scheme Host:(nonnull NSString *)host andPort:(NSUInteger)port andApi:(nonnull NSString *)api andParameter:(nonnull NSDictionary *)parameter {
    
    return [NSString stringWithFormat:@"%@://%@:%@/%@%@", scheme, host, @(port), api, [SKYoutubeConnection queryForParameter:parameter]];
}

+ (nonnull NSString *)queryForParameter:(nonnull NSDictionary *)parameter {
    
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    for(NSString *key in [parameter allKeys]) {
        NSString *value = [parameter objectForKey:key];
        
        NSString *operator = ([mutableString length]==0)?(@"?"):(@"&");
        [mutableString appendFormat:@"%@%@=%@", operator, key, value];
    }
    
    return mutableString;
}

@end
