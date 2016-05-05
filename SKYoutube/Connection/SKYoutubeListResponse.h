//
//  SKYoutubeListResponse.h
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubeResponse.h"

@interface SKYoutubeListResponse<__covariant ObjectType> : SKYoutubeResponse

@property(nonatomic, copy, readonly, nonnull) NSArray<ObjectType> *items;

@end
