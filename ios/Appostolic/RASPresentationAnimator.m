//
//  RASPresentationAnimator.m
//  Appostolic
//
//  Created by Robert Stein on 2/28/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASPresentationAnimator.h"

static NSTimeInterval const RASPresentationAnimatorTransitionDuration = 0.5f;

@implementation RASPresentationAnimator

@synthesize openingFrame = _openingFrame;
@synthesize openingView = _openingView;

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
	return RASPresentationAnimatorTransitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
	UIView *fromView = _openingView;
	CGRect frameToOpenFrom = _openingFrame;

	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIView *containerView = [transitionContext containerView];
	NSTimeInterval animationDuration = [self transitionDuration:transitionContext];

	CGRect fromViewFrame = [fromView convertRect:frameToOpenFrom toView:[fromViewController view]];
	
	// add blurred background to the view
	UIGraphicsBeginImageContext(fromViewFrame.size);
	[fromView drawViewHierarchyInRect:fromViewFrame afterScreenUpdates:true];
	UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIView *toView = [toViewController view];
	UIView *snapshotView = [toView resizableSnapshotViewFromRect:[toView frame] afterScreenUpdates:true withCapInsets:UIEdgeInsetsZero];
	[snapshotView setFrame:_openingFrame];
	[containerView addSubview:snapshotView];

	[toView setAlpha:0.f];
	[containerView addSubview:toView];
	
	[UIView animateWithDuration:animationDuration delay:0.f usingSpringWithDamping:1.f initialSpringVelocity:20.f options:0 animations:^{
		[snapshotView setFrame:fromViewFrame];
	} completion:^(BOOL finished) {
		[snapshotView removeFromSuperview];
		[toView setAlpha:1.f];
		[transitionContext completeTransition:finished];
	}];
}

@end
