//
//  ViewController.m
//  HW_CocoaPods
//
//  Created by Мария Тимофеева on 28.02.16.
//  Copyright © 2016 ___matim___. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.img.center = self.view.center;
    self.navigationItem.title = self.dic[@"title"];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    indicator.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin;
    
    indicator.center =self.view.center;
    
    [self.view addSubview:indicator];
    [indicator startAnimating];
    NSURL *urlImg = [NSURL URLWithString:self.dic[@"img"]];
    [self.img sd_setImageWithURL: urlImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [indicator stopAnimating];
        
    }];
   
}



@end
