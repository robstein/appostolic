//
//  RASMainViewController.m
//  Appostolic
//
//  Created by Robert Stein on 2/14/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASMainViewController.h"
#import "RASDayViewController.h"
#import "RASLiteratureViewController.h"
#import "RASProgressViewController.h"
#import "RASMoreViewController.h"

@interface RASMainViewController () <UITabBarControllerDelegate>

@end

@implementation RASMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
		[layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
		[layout setItemSize:CGSizeMake(175, 86)];
		
		RASDayViewController *dayVC = [[RASDayViewController alloc] initWithCollectionViewLayout:layout];
		RASLiteratureViewController *litVC = [[RASLiteratureViewController alloc] initWithNibName:nil bundle:nibBundleOrNil];
		RASProgressViewController *progressVC = [[RASProgressViewController alloc] initWithNibName:nil bundle:nibBundleOrNil];
		RASMoreViewController *moreVC = [[RASMoreViewController alloc] initWithNibName:nil bundle:nibBundleOrNil];
		NSArray<UIViewController *> *viewControllers = @[dayVC, litVC, progressVC, moreVC];
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

@end
