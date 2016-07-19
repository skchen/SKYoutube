//
//  ViewController.m
//  SKYoutubePlayer
//
//  Created by Shin-Kai Chen on 2016/4/19.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKYoutubePlayerViewController.h"

#import <SKYoutube/SKYoutube.h>

@interface SKYoutubePlayerViewController ()

@property (weak, nonatomic) IBOutlet UIView *screenView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SKYoutubePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.player = [[SKYoutubeListPlayer alloc] initWithView:_screenView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __weak __typeof(self.player) weakPlayer = self.player;
    
    [self.listPlayer setSource:_list atIndex:_index callback:^(NSError * _Nullable error) {
        if(error) {
            NSLog(@"Unable to set source: %@", error);
        } else {
            [weakPlayer start:^(NSError * _Nullable error) {
                if(error) {
                    NSLog(@"Unable to start: %@", error);
                }
            }];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.player stop:^(NSError * _Nullable error) {
        if(error) {
            NSLog(@"Unable to stop: %@", error);
        }
    }];
}

- (void)playerDidChangeSource:(SKPlayer *)player {
    [super playerDidChangeSource:player];
    
    id singleSource = [self.listPlayer.source objectAtIndex:self.listPlayer.index];
    
    SKYoutubeResource *resource = (SKYoutubeResource *)singleSource;
    [_nameLabel setText:resource.title];
}

@end
