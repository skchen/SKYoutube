//
//  SKYoutubePagedListResponse.h
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeListResponse.h"

@interface SKYoutubePagedListResponse<__covariant ObjectType> : SKYoutubeListResponse<ObjectType>

@property(nonatomic, copy, readonly, nonnull) NSString *nextPageToken;
@property(nonatomic, readonly) NSUInteger itemsPerPage;
@property(nonatomic, readonly) NSUInteger totalItems;

@end
