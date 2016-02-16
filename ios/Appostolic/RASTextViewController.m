//
//  RASTextViewController.m
//  Appostolic
//
//  Created by Robert Stein on 2/15/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASTextViewController.h"

#import "RASReading.h"
#import <DTCoreText/DTCoreText.h>

static const CGFloat RASTextViewControllerTitleFontSize = 20.f;
static const CGFloat RASTextViewControllerSubtitleFontSize = 9.f;
static const CGFloat RASTextViewControllerBodyFontSize = 12.f;
static const CGFloat RASTextViewPanThreshold = 160.f;

@interface RASTextViewController ()

@property (nonatomic, assign) CGFloat totalTranslationY;

@end

@implementation RASTextViewController

@synthesize reading = _reading;
@synthesize totalTranslationY = _totalTranslationY;

- (instancetype)initWithReading:(RASReading *)reading {
	if (self = [self init]) {
		_reading = reading;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIView *view = [self view];
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
	UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
	UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectZero];
	UILabel *body = [[UILabel alloc] initWithFrame:CGRectZero];
	
	[scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[title setTranslatesAutoresizingMaskIntoConstraints:NO];
	[subtitle setTranslatesAutoresizingMaskIntoConstraints:NO];
	[body setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	NSData *bodyData = [[_reading body] dataUsingEncoding:NSUTF8StringEncoding];
	NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:bodyData documentAttributes:NULL];
	
	[title setText:[_reading name]];
	[subtitle setText:[_reading passage]];
	[body setText:[attrString string]];
	
	[title setFont:[UIFont systemFontOfSize:RASTextViewControllerTitleFontSize]];
	[subtitle setFont:[UIFont systemFontOfSize:RASTextViewControllerSubtitleFontSize]];
	[body setFont:[UIFont systemFontOfSize:RASTextViewControllerBodyFontSize]];
	[body setLineBreakMode:NSLineBreakByWordWrapping];
	[body setNumberOfLines:0];
	
	[scrollView addSubview:title];
	[scrollView addSubview:subtitle];
	[scrollView	addSubview:body];
	
	NSDictionary *views = NSDictionaryOfVariableBindings(title, subtitle, body);
	NSArray<NSLayoutConstraint *> *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[title]-[subtitle]-[body]" options:NSLayoutFormatAlignAllLeading metrics:nil views:views];
	NSArray<NSLayoutConstraint *> *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[title]" options:0 metrics:nil views:views];
	[scrollView addConstraints:constraintsV];
	[scrollView addConstraints:constraintsH];
	
	[view addSubview:scrollView];
	
	id top = [self topLayoutGuide];
	views = NSDictionaryOfVariableBindings(top, scrollView);
	constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[top]-(0)-[scrollView]|" options:0 metrics:nil views:views];
	constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"|[scrollView]|" options:0 metrics:nil views:views];
	[view addConstraints:constraintsH];
	[view addConstraints:constraintsV];
	
	[view setBackgroundColor:[UIColor whiteColor]];
	
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveView:)];
	[scrollView addGestureRecognizer:pan];
}

- (void)removeFromParent:(UIViewController *)childController {
	[childController willMoveToParentViewController:nil];
	[[childController view] removeFromSuperview];
	[childController removeFromParentViewController];
}

- (void)moveView:(UIPanGestureRecognizer *)gestureRecognizer
{
	UIView *view = [gestureRecognizer view];
	UIView *superview = [view superview];
	CGRect bounds = [view bounds];

	UIGestureRecognizerState state = [gestureRecognizer state];
	if (state == UIGestureRecognizerStateBegan) {
		CGPoint locationInView = [gestureRecognizer locationInView:view];
		CGPoint locationInSuperview = [gestureRecognizer locationInView:superview];
		CGFloat newAnchorX = locationInView.x / bounds.size.width;
		CGFloat newAnchorY = locationInView.y / bounds.size.height;
		[[view layer] setAnchorPoint:CGPointMake(newAnchorX, newAnchorY)]; //
		[view setCenter:locationInSuperview]; //
	}
	
	CGPoint center = [view center];
	if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
		CGPoint translation = [gestureRecognizer translationInView:superview];
		_totalTranslationY += translation.y;

		[view setCenter:CGPointMake(center.x, center.y + translation.y)]; //
		[gestureRecognizer setTranslation:CGPointZero inView:superview];
	}
	
	if (state == UIGestureRecognizerStateEnded) {
		if (fabs(_totalTranslationY) > RASTextViewPanThreshold) {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.2];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
			if (_totalTranslationY > 0) {
				// positive translation. animate down
				[view setCenter:CGPointMake(center.x, center.y - _totalTranslationY + bounds.size.height)];
			} else {
				// negative translation. animate up
				[view setCenter:CGPointMake(center.x, center.y - _totalTranslationY - bounds.size.height)];
			}
			[UIView commitAnimations];
			[self removeFromParent:self];
		} else {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.2];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
			[view setCenter:CGPointMake(center.x, center.y - _totalTranslationY)];
			[UIView commitAnimations];
			_totalTranslationY = 0;
		}
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
