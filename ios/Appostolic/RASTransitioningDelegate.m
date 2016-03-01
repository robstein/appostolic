//
//  RASTransitioningDelegate.m
//  Appostolic
//
//  Created by Robert Stein on 2/28/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASTransitioningDelegate.h"
#import "RASPresentationAnimator.h"
#import "RASDismissalAnimator.h"

@implementation RASTransitioningDelegate

@synthesize openingFrame = _openingFrame;
@synthesize openingView = _openingView;

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
	RASPresentationAnimator *presentationAnimator = [[RASPresentationAnimator alloc] init];
	[presentationAnimator setOpeningFrame:_openingFrame];
	[presentationAnimator setOpeningView:_openingView];
	return presentationAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	RASDismissalAnimator *dismissAnimator = [[RASDismissalAnimator alloc] init];
	[dismissAnimator setOpeningFrame:_openingFrame];
	return dismissAnimator;
}

@end
