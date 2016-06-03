//
//  SKYoutubePagedList.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/6/3.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubePagedList.h"

#import "SKYoutubePagedListResponse.h"

@interface SKYoutubePagedList ()

@property(nonatomic, strong, readonly, nonnull) NSMutableArray *mutableList;

@end

@implementation SKYoutubePagedList

@synthesize finished;

- (nonnull instancetype)initWithResponse:(nonnull SKYoutubePagedListResponse *)response {
    self = [super init];
    
    _mutableList = [[NSMutableArray alloc] init];
    
    [self append:response];
    
    finished = NO;
    
    return self;
}

- (NSArray *)list {
    return _mutableList;
}

- (void)append:(nonnull id)newPage {
    if([newPage isKindOfClass:[SKYoutubePagedList class]]) {
        SKYoutubePagedList *pagedList = (SKYoutubePagedList *)newPage;
        
        [_mutableList addObjectsFromArray:pagedList.list];
        _next = pagedList.next;
        finished = pagedList.finished;
    } else if([newPage isKindOfClass:[SKYoutubePagedListResponse class]]) {
        SKYoutubePagedListResponse *response = (SKYoutubePagedListResponse *)newPage;
        
        [_mutableList addObjectsFromArray:response.items];
        _next = response.nextPageToken;
        finished = (!_next);
    } else {
        NSLog(@"Unable to append %@", newPage);
    }
}

@end
