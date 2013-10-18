//
//  DetailViewController.m
//  JBook
//
//  Created by wangyue on 10/18/13.
//  Copyright (c) 2013 wangyue. All rights reserved.
//

#import "Book.h"
#import "Chapter.h"
#import "Section.h"
#import "DetailViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface DetailViewController (){
  UITextView *textView;
  UIBarButtonItem *button;
  UISlider *slider;
  AVAudioPlayer* audioPlayer;
  NSTimer * timer;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

  if (self.detailItem) {
    [self setText:[_detailItem text]];
    [self setMp3:[_detailItem mp3]];
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  textView = [[UITextView alloc]initWithFrame:self.view.bounds];
  [textView setEditable:NO];
  [self.view addSubview:textView];
  slider = [[UISlider alloc] init];
  [slider addTarget:self action:@selector(slide) forControlEvents:UIControlEventValueChanged];
  [self.navigationItem setTitleView:slider];
  button = [[UIBarButtonItem alloc] initWithTitle:@"播放"
                                            style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(play)];
	// Do any additional setup after loading the view, typically from a nib.
  [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setText:(NSString *)text{
  [textView setText:text];
}

- (void) setMp3:(NSString *)mp3{
  [button setTitle:@"播放"];
  NSURL* file = [NSURL fileURLWithPath:mp3];
  audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
  BOOL hasAudio = audioPlayer != nil;
  [self.navigationItem setRightBarButtonItem: hasAudio ? button : nil];
  [slider setHidden:!hasAudio];
  [slider setValue:0.0f];
  if (hasAudio){
    [audioPlayer prepareToPlay];
    [slider setMaximumValue:[audioPlayer duration]];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(updateTime:)
                                           userInfo:nil
                                            repeats:YES];

  }else{
    [timer invalidate];
    timer = nil;
  }
}

- (void) play{
  if ([audioPlayer isPlaying]) {
    [audioPlayer pause];
    [button setTitle:@"播放"];
  } else {
    [audioPlayer play];
    [button setTitle:@"暫停"];
  }

}

- (void)slide{
  [audioPlayer setCurrentTime:[slider value]];
}

- (void)updateTime:(NSTimer *)timer {
  [slider setValue:[audioPlayer currentTime]];
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController
{
  barButtonItem.title = @"選課";
  [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
  self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
