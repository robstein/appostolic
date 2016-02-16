//
//  RASTextViewControler.m
//  Appostolic
//
//  Created by Robert Stein on 2/15/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASTextViewControler.h"

#import "RASReading.h"
#import <DTCoreText/DTCoreText.h>

static const CGFloat RASTextViewControllerTitleFontSize = 20.f;
static const CGFloat RASTextViewControllerSubtitleFontSize = 9.f;
static const CGFloat RASTextViewControllerBodyFontSize = 12.f;

@interface RASTextViewControler ()

@end

@implementation RASTextViewControler

@synthesize reading = _reading;

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
	
	UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeOut:)];
	UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeOut:)];
	[swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
	[swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
	[view addGestureRecognizer:swipeUp];
	[view addGestureRecognizer:swipeDown];
}

- (void)closeOut:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
