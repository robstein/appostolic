//
//  RASMoreViewController.m
//  Appostolic
//
//  Created by Robert Stein on 1/12/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASMoreViewController.h"

NSString *const RASMoreTabName = @"More";
const NSInteger RASMoreTabTag = 3;

@implementation RASMoreViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self setTitle:RASMoreTabName];
		[self setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:RASMoreTabTag]];
	}
	return self;
}

@end
