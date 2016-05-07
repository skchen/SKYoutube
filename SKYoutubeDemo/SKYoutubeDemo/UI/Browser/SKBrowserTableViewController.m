//
//  SKBrowserTableViewController.m
//  SKYoutubeDemo
//
//  Created by Shin-Kai Chen on 2016/5/7.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKBrowserTableViewController.h"

@implementation SKBrowserTableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SKBrowserTableViewCell"];
    
    NSString *title = nil;
    
    switch (indexPath.row) {
        case 0: title = @"Audio"; break;
        default: break;
    }
    
    if(title) {
        [cell.textLabel setText:title];
    }
    
    return cell;
}

@end
