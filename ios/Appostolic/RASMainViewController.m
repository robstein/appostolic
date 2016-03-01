//
//  RASMainViewController.m
//  Appostolic
//
//  Created by Robert Stein on 2/14/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASMainViewController.h"
#import "RASCollectionViewController.h"
#import "RASProgressViewController.h"
#import "UIViewController+RASTabExtensions.h"

static NSString *const RASTabNameToday = @"Today";
static NSString *const RASTabNameProgress = @"Progress";

static NSString *const RASTabImageNameToday = @"Home";
static NSString *const RASTabImageNameProgress = @"HeartMonitor";

@interface RASMainViewController () <UITabBarControllerDelegate>

@end

@implementation RASMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		RASCollectionViewController *dayViewController = [[RASCollectionViewController alloc] initWithTitle:RASTabNameToday tabBarItemImage:[UIImage imageNamed:RASTabImageNameToday]];
		UINavigationController *dayNavigationController = [[UINavigationController alloc] initWithRootViewController:dayViewController];
		RASProgressViewController *progressViewController = [[RASProgressViewController alloc] initWithTitle:RASTabNameProgress tabBarItemImage:[UIImage imageNamed:RASTabImageNameProgress]];
		NSArray<UIViewController *> *viewControllers = @[dayNavigationController, progressViewController];
		[self setViewControllers:viewControllers];
		[self setDelegate:self];
	}
	return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	return YES;
}

@end
