//
//  RASDetailViewCell.m
//  Appostolic
//
//  Created by Robert Stein on 3/1/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASDetailViewCell.h"
#import <DTCoreText/DTCoreText.h>

NSString *const RASDetailViewCellReuseIdentifier = @"RASDetailViewCellReuseIdentifier";

static CGFloat const RASDetailViewCellMargin = 18.f;

@interface RASDetailViewCell ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic) BOOL didSetupConstraints;

@end

@implementation RASDetailViewCell

@synthesize text = _text;
@synthesize textLabel = _textLabel;
@synthesize didSetupConstraints = _didSetupConstraints;

- (void)setText:(NSString *)text {
	_text = text;
	
	NSData *bodyData = [text dataUsingEncoding:NSUTF8StringEncoding];
	NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:bodyData documentAttributes:NULL];
	[_textLabel setText:[attrString string]];
	
	[self setNeedsUpdateConstraints];
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initializeLabels];
		[self configureLabels];
		[self addLabelsToContentView];
	}
	return self;
}

- (void)initializeLabels {
	_textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
}

- (void)configureLabels {
	[_textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_textLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
	[_textLabel setTextColor:[UIColor blackColor]];
	[_textLabel setLineBreakMode:NSLineBreakByWordWrapping];
	[_textLabel setNumberOfLines:0];
	
	CGFloat width = [[self contentView] frame].size.width - (2 * RASDetailViewCellMargin);
	[_textLabel setPreferredMaxLayoutWidth:width];
	[_textLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)addLabelsToContentView {
	UIView *contentView = [self contentView];
	[contentView addSubview:_textLabel];
}

- (BOOL)requiresConstraintBasedLayout {
	return YES;
}

- (void)updateConstraints {
	[super updateConstraints];
	if (![self didSetupConstraints]) {

		if (_textLabel != nil) {
			NSDictionary *subviews;
			NSNumber *margin = @(RASDetailViewCellMargin);
			NSNumber *labelWidth = @([[self contentView] frame].size.width - (2 * RASDetailViewCellMargin));
			NSArray<NSLayoutConstraint *> *constraints = [[NSArray alloc] init];
			NSDictionary *metrics = NSDictionaryOfVariableBindings(margin, labelWidth);
			subviews = NSDictionaryOfVariableBindings(_textLabel);
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_textLabel]-margin-|" options:0 metrics:metrics views:subviews]];
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-margin-[_textLabel(<=labelWidth)]-margin-|" options:0 metrics:metrics views:subviews]];
			[[self contentView] addConstraints:constraints];
		}
		
		_didSetupConstraints = YES;
	}
}

- (void)layoutSubviews {
	UIView *contentView = [self contentView];
	BOOL contentViewIsAutoresized = CGSizeEqualToSize([self frame].size, [contentView frame].size);
	if(!contentViewIsAutoresized) {
		CGRect contentViewFrame = contentView.frame;
		contentViewFrame.size = [self frame].size;
		[contentView setFrame:contentViewFrame];
	}
}

@end
