//
//  MasterViewController.m
//  JBook
//
//  Created by wangyue on 10/18/13.
//  Copyright (c) 2013 wangyue. All rights reserved.
//

#import "MasterViewController.h"
#import "Book.h"
#import "Chapter.h"
#import "Section.h"
#import "DetailViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MasterViewController () {
  Book * book;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
      self.clearsSelectionOnViewWillAppear = NO;
      self.preferredContentSize = CGSizeMake(320.0, 600.0);
  }
  self.navigationItem.title = @"新編日語（第一冊）";
  book = [Book sharedStore];
  [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//  self.navigationItem.leftBarButtonItem = self.editButtonItem;

//  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//  self.navigationItem.rightBarButtonItem = addButton;
  self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
 */

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[book chapters] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[[[book chapters] objectAtIndex:section] sections] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  Chapter * chapter = [[book chapters] objectAtIndex:indexPath.section];
  Section *section = [[chapter sections] objectAtIndex:indexPath.row];
  cell.textLabel.text = [section title];
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  Chapter * chapter = [[book chapters] objectAtIndex:section];
  return [chapter title];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
      NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
      Chapter * chapter = [[book chapters] objectAtIndex:indexPath.section];
      Section *section = [[chapter sections] objectAtIndex:indexPath.row];
      self.detailViewController.detailItem = section;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
      NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
      Chapter * chapter = [[book chapters] objectAtIndex:indexPath.section];
      Section *section = [[chapter sections] objectAtIndex:indexPath.row];
      [[segue destinationViewController] setDetailItem:section];
    }
}

@end
