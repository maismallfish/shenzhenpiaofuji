//
//  LeftTableViewController.h
//  MutipleTableView
//
//  Created by wuyine on 2017/9/30.
//  Copyright © 2017年 wuyine. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^cellClickBlock)(NSInteger selectIndex,NSString *categoryName);
@interface LeftTableViewController : UITableViewController
@property (nonatomic,copy) cellClickBlock leftCellClickBlock;
@end
