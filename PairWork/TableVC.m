//
//  TableVC.m
//  PairWork
//
//  Created by Филипп Чернов on 18.02.16.
//  Copyright © 2016 Филипп Чернов. All rights reserved.
//

#import "TableVC.h"
#import "TableVIewCell.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import "AnotherVC.h"
@interface TableVC ()
@property NSArray *fruits;
@property NSURLSession *session;

@end
@implementation TableVC

- (void)viewDidLoad {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setHTTPAdditionalHeaders:@{@"device" : @"iOS"}];
    self.session = [NSURLSession sessionWithConfiguration:config];
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)refreshDidClick:(id)sender {
    [self reloadData];
}

- (void)reloadData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *jsonURL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/55523423/Fructs.json"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:jsonURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        self.fruits = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.tableView reloadData];
            [hud hide:YES];
        });
        
    }];
    [task resume];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    AnotherVC *vc = segue.destinationViewController;
    NSDictionary *fruitsDict = self.fruits[indexPath.row];
    vc.dictionaryForFruits = fruitsDict;
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fruits.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    NSDictionary *fruitDictionary = self.fruits[indexPath.row];
    NSURL *urlImage = [NSURL URLWithString:fruitDictionary[@"thumb"]];
    cell.textForCustomCell.text = fruitDictionary[@"title"];
    if (!cell.task) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSURLSessionDataTask  *task = [self.session dataTaskWithURL:urlImage completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageForCustomCell.image = [UIImage imageWithData:data];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        }];
        cell.task = task;
        [task resume];
    }else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [cell.task cancel];
        cell.imageForCustomCell.image = nil;
        cell.task = [self.session dataTaskWithURL:urlImage completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageForCustomCell.image = [UIImage imageWithData:data];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
            });
        }];
        [cell.task resume];
    }
    
    return cell;
}

@end