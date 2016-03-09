//
//  RASDetailHeaderView.m
//  Appostolic
//
//  Created by Robert Stein on 3/8/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASDetailHeaderView.h"

NSString *const RASDetailHeaderViewReuseIdentifier = @"RASDetailHeaderViewReuseIdentifier";

static const CGFloat RASDetailHeaderViewVerticalMargin = 8.f;
static const CGFloat RASDetailHeaderViewHorizontalMargin = 27.f;

@interface RASDetailHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic) BOOL didCalculateHeight;

@end

@implementation RASDetailHeaderView

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize titleLabel = _titleLabel;
@synthesize subtitleLabel = _subtitleLabel;
@synthesize didCalculateHeight = _didCalculateHeight;

- (void)setTitle:(NSString *)title {
	_title = [title copy];
	[_titleLabel setText:_title];
	[self setNeedsUpdateConstraints];
}

- (void)setSubtitle:(NSString *)subtitle {
	_subtitle = [subtitle copy];
	[_subtitleLabel setText:_subtitle];
	[self setNeedsUpdateConstraints];
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initializeLabels];
		[self configureLabels];
		[self addLabelsToView];
		[self setBackgroundColor:[UIColor clearColor]];
	}
	return self;
}

- (void)initializeLabels {
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
}

- (void)configureLabels {
	[_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
	[_titleLabel setTextColor:[UIColor blackColor]];
	[_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
	[_titleLabel setNumberOfLines:0];
	CGFloat width = [self frame].size.width - (2 * RASDetailHeaderViewHorizontalMargin);
	[_titleLabel setPreferredMaxLayoutWidth:width];
	[_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	
	[_subtitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_subtitleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
	[_subtitleLabel setTextColor:[UIColor blackColor]];
	[_subtitleLabel setNumberOfLines:1];
}

- (void)addLabelsToView {
	UIView *view = self;
	[view addSubview:_titleLabel];
	[view addSubview:_subtitleLabel];
}


- (BOOL)requiresConstraintBasedLayout {
	return YES;
}

- (void)updateConstraints {
	[super updateConstraints];
	if (_titleLabel != nil && _subtitleLabel != nil) {
		NSDictionary *subviews;
		NSNumber *verticalMargin = @(RASDetailHeaderViewVerticalMargin);
		NSNumber *horizontalMargin = @(RASDetailHeaderViewHorizontalMargin);
		NSNumber *labelWidth = @([self frame].size.width - (2 * RASDetailHeaderViewHorizontalMargin));
		NSArray<NSLayoutConstraint *> *constraints = [[NSArray alloc] init];
		NSDictionary *metrics = NSDictionaryOfVariableBindings(verticalMargin, horizontalMargin, labelWidth);
		subviews = NSDictionaryOfVariableBindings(_titleLabel, _subtitleLabel);
		constraints = [constraints arrayByAddingObject:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_subtitleLabel attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f]];
		constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-horizontalMargin-[_titleLabel(<=labelWidth)]-horizontalMargin-|" options:0 metrics:metrics views:subviews]];
		constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[_subtitleLabel]-horizontalMargin-|" options:0 metrics:metrics views:subviews]];
		constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalMargin-[_titleLabel]-verticalMargin-|" options:0 metrics:metrics views:subviews]];
		[self addConstraints:constraints];
	}
}

@end