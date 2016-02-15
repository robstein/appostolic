//
//  RASProgressViewController.m
//  Appostolic
//
//  Created by Robert Stein on 1/12/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASProgressViewController.h"

NSString *const RASProgressTabName = @"Progress";
NSString *const RASProgressTabImageName = @"HeartMonitor";

@implementation RASProgressViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self setTitle:RASProgressTabName];
		[[self tabBarItem] setImage:[UIImage imageNamed:RASProgressTabImageName]];
	}
	return self;
}

@end
