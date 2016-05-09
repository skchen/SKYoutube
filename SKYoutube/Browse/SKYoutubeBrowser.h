//
//  SKYoutubeBrowser.h
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKYoutubeResource;

typedef void (^SKExtendableListCallback)(NSArray  * _Nonnull list, BOOL finished);
typedef void (^SKListCallback)(NSArray  * _Nonnull list);
typedef void (^SKErrorCallback)(NSError * _Nonnull error);

@interface SKYoutubeBrowser : NSObject

- (nonnull instancetype)initWithKey:(nonnull NSString *)key andLocale:(nullable NSLocale *)locale;

- (void)listChannels:(BOOL)refresh extend:(BOOL)extend category:(nullable NSString *)category success:(nonnull SKExtendableListCallback)success failure:(nonnull SKErrorCallback)failure;

- (void)listPlaylists:(BOOL)refresh extend:(BOOL)extend channel:(nonnull SKYoutubeResource *)channel success:(nonnull SKExtendableListCallback)success failure:(nonnull SKErrorCallback)failure;

- (void)listGuideCategories:(BOOL)refresh success:(nonnull SKListCallback)success failure:(nonnull SKErrorCallback)failure;
- (void)searchVideos:(BOOL)refresh extend:(BOOL)extend query:(nullable NSString *)query category:(nullable NSString *)category success:(nonnull SKExtendableListCallback)success failure:(nonnull SKErrorCallback)failure;
- (void)listVideoCategories:(BOOL)refresh success:(nonnull SKListCallback)success failure:(nonnull SKErrorCallback)failure;
- (void)listMostPopular:(BOOL)refresh extend:(BOOL)extend category:(nullable NSString *)category success:(nonnull SKExtendableListCallback)success failure:(nonnull SKErrorCallback)failure;

@end
