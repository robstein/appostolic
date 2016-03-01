//
//  RASDismissalAnimator.m
//  Appostolic
//
//  Created by Robert Stein on 2/28/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASDismissalAnimator.h"

static NSTimeInterval const RASDismissalAnimatorTransitionDuration = 0.5f;

@implementation RASDismissalAnimator

@synthesize openingFrame = _openingFrame;

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
	return RASDismissalAnimatorTransitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIView *containerView = [transitionContext containerView];
	NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
	
	UIView *snapshotView = [[fromViewController view] resizableSnapshotViewFromRect:[[fromViewController view] bounds] afterScreenUpdates:true withCapInsets:UIEdgeInsetsZero];
	[containerView addSubview:snapshotView];
	
	[[fromViewController view] setAlpha:0.f];
	
	[UIView animateWithDuration:animationDuration animations:^{
		[snapshotView setFrame:_openingFrame];
		[snapshotView setAlpha:1.f];
	} completion:^(BOOL finished) {
		[snapshotView removeFromSuperview];
		[[fromViewController view] removeFromSuperview];
		[transitionContext completeTransition:[transitionContext transitionWasCancelled]];
	}];
}

@end
