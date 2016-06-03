//
//  SKYoutubeBrowser.h
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SKUtils/SKUtils.h>

@class SKYoutubeResource;

@interface SKYoutubeBrowser : SKPagedAsync

- (nonnull instancetype)initWithKey:(nonnull NSString *)key andLocale:(nullable NSLocale *)locale;

- (void)listChannels:(BOOL)refresh extend:(BOOL)extend category:(nullable NSString *)category success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure;
- (void)listPlaylists:(BOOL)refresh extend:(BOOL)extend channel:(nonnull SKYoutubeResource *)channel success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure;
- (void)listGuideCategories:(BOOL)refresh success:(nonnull SKListCallback)success failure:(nonnull SKErrorCallback)failure;
- (void)searchVideos:(BOOL)refresh extend:(BOOL)extend query:(nullable NSString *)query channel:(nullable NSString *)channel category:(nullable NSString *)category success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure;
- (void)listVideoCategories:(BOOL)refresh success:(nonnull SKListCallback)success failure:(nonnull SKErrorCallback)failure;

- (void)listMostPopular:(BOOL)refresh extend:(BOOL)extend category:(nullable NSString *)category success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure;
- (void)listVideos:(BOOL)refresh extend:(BOOL)extend playlist:(nonnull SKYoutubeResource *)playlist success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure;

@end
