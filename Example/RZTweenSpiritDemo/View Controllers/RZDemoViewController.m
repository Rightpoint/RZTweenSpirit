//
//  RZDemoViewController.m
//  RZTweenSpiritDemo
//
//  Created by Nick Donaldson on 6/16/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZDemoViewController.h"
#import "RZTweeningDemoView.h"

@interface RZDemoViewController ()

@end

@implementation RZDemoViewController

- (void)loadView
{
    self.view = [[RZTweeningDemoView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

@end
