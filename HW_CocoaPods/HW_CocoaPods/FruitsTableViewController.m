//
//  FruitsTableViewController.m
//  HW_CocoaPods
//
//  Created by Мария Тимофеева on 02.03.16.
//  Copyright © 2016 ___matim___. All rights reserved.
//

#import "FruitsTableViewController.h"
#import "FruitTableViewCell.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ViewController.h"


@interface FruitsTableViewController ()
{
    NSURLSession *session;
    NSArray *fruitArr;
    NSDictionary *currentDic;
}

@end

@implementation FruitsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
}


-(void)reloadDataFromNet{
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     NSURL *url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/55523423/Fructs.json"];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            NSLog(@"Error : %@", error);
        }
        else {
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error: nil];
            NSMutableArray *array = [NSMutableArray new];
            for (NSDictionary *dic in arr){
                [array addObject:dic];
            }
            fruitArr = array;
            dispatch_async(dispatch_get_main_queue() , ^{
                [hud hide:YES];
                [self.tableView reloadData];
            });
            
        }
    }] resume];
}


#pragma mark - Table view data source

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ViewController *vc = (ViewController *)segue.destinationViewController;
    vc.dic =[fruitArr objectAtIndex: [self.tableView indexPathForSelectedRow].row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (IBAction)refresh:(id)sender {
    [self reloadDataFromNet];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return fruitArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FruitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dic = [fruitArr objectAtIndex:indexPath.row];
    cell.label.text = dic[@"title"];
    NSURL *urlImg = [NSURL URLWithString:dic[@"thumb"]];
    [cell.image sd_setImageWithURL:urlImg];
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
