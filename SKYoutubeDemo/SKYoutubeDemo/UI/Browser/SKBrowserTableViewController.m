//
//  SKBrowserTableViewController.m
//  SKYoutubeDemo
//
//  Created by Shin-Kai Chen on 2016/5/7.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKBrowserTableViewController.h"

#import <SKYoutube/SKYoutube.h>

#import "SKYoutubePlayerViewController.h"

static NSString * const kYoutubeKey = @"please enter your own youtube key";

@interface SKBrowserTableViewController ()

@property(nonatomic, strong, nonnull) SKYoutubeBrowser *browser;
@property(nonatomic, strong, nullable) NSArray *list;

@end

@implementation SKBrowserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _browser = [[SKYoutubeBrowser alloc] initWithKey:kYoutubeKey andLocale:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_browser searchVideos:YES extend:NO query:@"X-Japan" channel:nil category:nil success:^(NSArray * _Nonnull list, BOOL finished) {
        _list = list;
        [self.tableView reloadData];
    } failure:^(NSError * _Nullable error) {
        NSLog(@"Unable to search video: %@", error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SKBrowserTableViewCell"];
    
    SKYoutubeResource *resource = [_list objectAtIndex:indexPath.row];
    [cell.textLabel setText:resource.title];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    SKYoutubePlayerViewController *destinationViewController = [segue destinationViewController];
    destinationViewController.list = _list;
    destinationViewController.index = indexPath.row;
}

@end
