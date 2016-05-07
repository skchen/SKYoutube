//
//  SKYoutubeBrowser.h
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SKExtendableListCallback)(NSArray  * _Nonnull list, BOOL finished);
typedef void (^SKListCallback)(NSArray  * _Nonnull list);
typedef void (^SKErrorCallback)(NSError * _Nonnull error);

@interface SKYoutubeBrowser : NSObject

- (nonnull instancetype)initWithKey:(nonnull NSString *)key andLocale:(nullable NSLocale *)locale;

- (void)listVideoCategories:(BOOL)refresh success:(nonnull SKListCallback)success failure:(nonnull SKErrorCallback)failure;
- (void)listMostPopular:(BOOL)refresh extend:(BOOL)extend category:(nullable NSString *)category success:(nonnull SKExtendableListCallback)success failure:(nonnull SKErrorCallback)failure;

@end
