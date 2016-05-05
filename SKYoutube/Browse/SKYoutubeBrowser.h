//
//  SKYoutubeBrowser.h
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKYoutubeBrowser : NSObject

typedef void (^SKExtendableListCallback)(NSArray  * _Nonnull list, BOOL finished);
typedef void (^SKErrorCallback)(NSError * _Nonnull error);

- (nonnull instancetype)initWithKey:(nonnull NSString *)key;

- (void)listMostPopular:(BOOL)refresh extend:(BOOL)extend success:(nonnull SKExtendableListCallback)success failure:(nonnull SKErrorCallback)failure;

@end
