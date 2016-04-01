//
//  AnotherVC.m
//  PairWork
//
//  Created by Филипп Чернов on 18.02.16.
//  Copyright © 2016 Филипп Чернов. All rights reserved.
//

#import "AnotherVC.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>

@interface AnotherVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageForBigFruits;

@end

@implementation AnotherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.dictionaryForFruits[@"title"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *urlImage = [NSURL URLWithString:self.dictionaryForFruits[@"img"]];
    [self.imageForBigFruits sd_setImageWithURL:urlImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [hud hide:YES];
    }];


    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
