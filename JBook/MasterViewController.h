//
//  MasterViewController.h
//  JBook
//
//  Created by wangyue on 10/18/13.
//  Copyright (c) 2013 wangyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
