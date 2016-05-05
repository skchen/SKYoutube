//
//  SKYoutubeExtendableList.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeExtendableList.h"

@interface SKYoutubeExtendableList ()

@property(nonatomic, strong, readonly, nonnull) NSMutableArray *mutableObjects;

@end

@implementation SKYoutubeExtendableList

- (nonnull instancetype)init {
    self = [super init];
    
    _mutableObjects = [[NSMutableArray alloc] init];
    _finished = NO;
    
    return self;
}

- (NSArray *)objects {
    return _mutableObjects;
}

- (void)addObjectsByResponse:(nonnull SKYoutubePagedListResponse *)response {
    [_mutableObjects addObjectsFromArray:response.items];
    _nextPageToken = response.nextPageToken;
    
    _finished = (!_nextPageToken);
}

@end
