//
//  TableVIewCell.h
//  PairWork
//
//  Created by Филипп Чернов on 18.02.16.
//  Copyright © 2016 Филипп Чернов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableVIewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageForCustomCell;
@property (weak, nonatomic) IBOutlet UILabel *textForCustomCell;
@property NSURLSessionDataTask *task;

@end
