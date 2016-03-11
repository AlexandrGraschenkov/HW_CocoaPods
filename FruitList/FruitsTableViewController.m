//
//  FruitsTableViewController.m
//  FruitList
//
//  Created by Эдуард Рязапов on 27.02.16.
//  Copyright © 2016 Эдуард Рязапов. All rights reserved.
//

#import "FruitsTableViewController.h"
#import "FruitViewController.h"
#import "FriutTableViewCell.h"
#import "Fruit.h"
#import "MBProgressHUD.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface FruitsTableViewController ()

@property NSMutableArray<Fruit *> *fruits;
@property NSInteger selectFruitNumber;
@property NSURL *url;
@property NSURLSession *session;
@property NSMutableArray<NSURLSessionDataTask *> *tasks;

@end

@implementation FruitsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/55523423/Fructs.json"];
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    self.tasks = [NSMutableArray new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fruits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fruitCellIdentify" forIndexPath:indexPath];
    cell.fruitNameLabel.text = self.fruits[indexPath.row].fruitName;
    cell.fruitImage.image = nil;
    
    if (cell.task.state == NSURLSessionTaskStateRunning) {
        [cell.task cancel];
        [self.tasks removeObject:cell.task];
    }
    
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:self.fruits[indexPath.row].thumb completionHandler:^     (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *img = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.fruitImage.image = img;
            [self.tasks removeObject:task];
            
            if(cell.task.state == NSURLSessionTaskStateCompleted) {
            }
            if (self.allTasksComplete) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
            }
        });
    }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    cell.task = task;
    [self.tasks addObject:task];
    [cell.task resume];
    return cell;
}

- (IBAction)loadFruits:(id)sender {
    self.fruits = [NSMutableArray new];
    __block NSArray *jsonObjects;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.minShowTime = .5;
    hud.labelText = @"Loading";
    
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:self.url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @try {
            jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        }
        @catch (NSException *exception) {
            hud.labelText = @"Error";
        }
        if (!error) {
            for (NSDictionary *d in jsonObjects) {
                Fruit *fruit = [Fruit fruitWithDictionary:d];
                [self.fruits addObject:fruit];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [hud hide:YES];
        });
        
    }];
    
    [task resume];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FruitViewController *fruitController = (FruitViewController *)segue.destinationViewController;
    fruitController.fruit = self.fruits[self.selectFruitNumber];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectFruitNumber = indexPath.row;
    return indexPath;
}

- (BOOL)allTasksComplete {
    for (NSURLSessionDataTask *task in self.tasks) {
        if (!(task.state == NSURLSessionTaskStateCompleted)) {
            return false;
        }
    }
    return true;
}

@end
