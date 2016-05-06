//
//  SKYoutubeListResponse.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeListResponse.h"

#import "SKYoutubeObject.h"

static NSString * const kKeyList = @"items";

@implementation SKYoutubeListResponse

- (nonnull instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    _items = [[NSMutableArray alloc] init];
    
    NSArray *rawItems = [dictionary objectForKey:kKeyList];
    for(NSDictionary *rawItem in rawItems) {
        SKYoutubeObject *object = [SKYoutubeObject objectWithDictionary:rawItem];
        
        if(object) {
            [(NSMutableArray *)_items addObject:object];
        }
    }
    
    return self;
}

@end
