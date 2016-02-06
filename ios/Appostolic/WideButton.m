//
//  WideButton.m
//  Appostolic
//
//  Created by Robert Stein on 1/15/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "WideButton.h"
#import <GradientView/GradientView-Swift.h>
#import "Utils.h"

static const CGFloat WideButtonTitleFontSize = 20.f;
static const CGFloat WideButtonSubtitleFontSize = 12.f;
static const CGFloat WideButtonBodyFontSize = 9.f;
static const CGFloat WideButtonBodyHeight = 46.f;
static const CGFloat WideButtonCornerRadius = 10.f;
static const CGFloat WideButtonWidth = 175.f;
static const CGFloat WideButtonHeight = 86.f;
static const CGFloat WideButtonSpacing = 4.f;

@implementation WideButton

@synthesize background = _background;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize body = _body;

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:CGRectMake(30, 30, 0, 0)]) {
		_title = [[UILabel alloc] initWithFrame:CGRectZero];
		_subtitle = [[UILabel alloc] initWithFrame:CGRectZero];
		_body = [[UILabel alloc] initWithFrame:CGRectZero];
		_background = [[GradientView alloc] initWithFrame:CGRectZero];

		[_title setTranslatesAutoresizingMaskIntoConstraints:NO];
		[_subtitle setTranslatesAutoresizingMaskIntoConstraints:NO];
		[_body setTranslatesAutoresizingMaskIntoConstraints:NO];
		[_background setTranslatesAutoresizingMaskIntoConstraints:NO];
		
		[_title setFont:[UIFont systemFontOfSize:WideButtonTitleFontSize]];
		[_subtitle setFont:[UIFont systemFontOfSize:WideButtonSubtitleFontSize]];
		[_body setFont:[UIFont systemFontOfSize:WideButtonBodyFontSize]];
		
		[_body setLineBreakMode:NSLineBreakByWordWrapping];
		[_body setNumberOfLines:0];
		[_body setPreferredMaxLayoutWidth:(WideButtonWidth - (2 * WideButtonSpacing))];
//		[_body setClipsToBounds:NO];
//		[_body setContentMode:UIViewContentModeTopLeft];
//		[_body setTextAlignment:NSTextAlignmentLeft];
		
		[_background setColors:@[UIColorFromRGB(0xEFEFF4), UIColorFromRGB(0xCECED2)]];
		[[_background layer] setBorderColor:[UIColorFromRGB(0xCECED2) CGColor]];
		[[_background layer] setCornerRadius:WideButtonCornerRadius];
		[_background setClipsToBounds:YES];
		[_background addSubview:_title];
		[_background addSubview:_subtitle];
		[_background addSubview:_body];
		[self addSubview:_background];
	}
	return self;
}

- (instancetype) initWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body {
	if (self = [self initWithFrame:CGRectZero]) {
		[_title setText:title];
		[_subtitle setText:subtitle];
		[_body setText:body];
	}
	return self;
}

- (BOOL)requiresConstraintBasedLayout {
	return YES;
}

- (CGSize)sizeThatFits:(CGSize)size {
	return CGSizeMake(WideButtonWidth, WideButtonHeight);
}

- (void)layoutSubviews {
	if (_title != nil && _subtitle != nil && _body != nil && _background) {
		NSNumber *spacing = @(WideButtonSpacing);
		NSNumber *bodyHeight = @(WideButtonBodyHeight);
		NSDictionary *subviewMetrics = @{@"spacing":spacing, @"bodyHeight":bodyHeight, @"high":@(UILayoutPriorityDefaultHigh)};
		NSDictionary *subviews = NSDictionaryOfVariableBindings(_title, _subtitle, _body);
		NSArray<NSLayoutConstraint *> *subviewsHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(spacing)-[_title]-(spacing)-|"
																									options:0
																									metrics:subviewMetrics
																									  views:subviews];
		NSArray<NSLayoutConstraint *> *subviewsVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(spacing@high)-[_title]-(spacing)-[_subtitle]-(spacing)-[_body(bodyHeight)]-(0@high)-|"
																								  options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing
																								  metrics:subviewMetrics
																									views:subviews];
		[_background addConstraints:subviewsHorizontal];
		[_background addConstraints:subviewsVertical];
		
		NSNumber *width = @(WideButtonWidth);
		NSNumber *height = @(WideButtonHeight);
		NSDictionary *metrics = NSDictionaryOfVariableBindings(width, height);
		NSDictionary *views = NSDictionaryOfVariableBindings(_background);
		NSArray<NSLayoutConstraint *> *backgroundHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_background(width)]|"
																									  options:0
																									  metrics:metrics
																										views:views];
		NSArray<NSLayoutConstraint *> *backgroundVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_background(height)]|"
																									options:0
																									metrics:metrics
																									  views:views];
		[self addConstraints:backgroundHorizontal];
		[self addConstraints:backgroundVertical];
	}
}

@end
