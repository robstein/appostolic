//
//  RASCollectionViewCell.m
//  Appostolic
//
//  Created by Robert Stein on 2/23/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASCollectionViewCell.h"

NSString *const RASCollectionViewCellReuseIdentifierSmall = @"RASCollectionViewCellReuseIdentifierSmall";
NSString *const RASCollectionViewCellReuseIdentifierLarge = @"RASCollectionViewCellReuseIdentifierLarge";

static CGFloat const RASCollectionViewCellMargin = 18.f;
static CGFloat const RASCollectionViewCellInnerMargin = 10.f;
static CGFloat const RASCollectionViewCellTitleHeightMin = 18.f;
static CGFloat const RASCollectionViewCellSubtitleHeightMin = 0.f;//14.f;

static CGFloat const RASCollectionViewCellSmallImageSideLength = 102.f;
static CGFloat const RASCollectionViewCellLargeImageHeight = 300.f;

@interface RASCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *leftFooterLabel;
@property (nonatomic, strong) UILabel *rightFooterLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic) BOOL didSetupConstraints;

@end

@implementation RASCollectionViewCell

@synthesize titleLabel = _titleLabel;
@synthesize subtitleLabel = _subtitleLabel;
@synthesize leftFooterLabel = _leftFooterLabel;
@synthesize rightFooterLabel = _rightFooterLabel;
@synthesize imageView = _imageView;

@synthesize didSetupConstraints = _didSetupConstraints;

- (CGRect)animateFrom {
	if (_imageView != nil) {
		return [_imageView frame];
	} else {
		return [[self contentView] frame];
	}
}

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle leftFooter:(NSString *)leftText rightFooter:(NSString *)rightText {
	[self setTitle:title];
	[self setSubtitle:subtitle];
	[self setLeftFooter:leftText];
	[self setRightFooter:rightText];
	[self setNeedsUpdateConstraints];
}

- (void)setImage:(UIImage *)image {
	CGRect contentViewFrame = [[self contentView] frame];
	if ([[self reuseIdentifier] isEqualToString:RASCollectionViewCellReuseIdentifierSmall]) {
		_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentViewFrame.size.width - RASCollectionViewCellMargin - RASCollectionViewCellSmallImageSideLength, RASCollectionViewCellMargin, RASCollectionViewCellSmallImageSideLength, RASCollectionViewCellSmallImageSideLength)];
	} else if ([[self reuseIdentifier] isEqualToString:RASCollectionViewCellReuseIdentifierLarge]) {
		_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(RASCollectionViewCellMargin, RASCollectionViewCellMargin, contentViewFrame.size.width - (2 * RASCollectionViewCellMargin), RASCollectionViewCellLargeImageHeight)];
	}
	[_imageView setImage:image];
	[[self contentView] addSubview:_imageView];
	[self setNeedsUpdateConstraints];
}

- (void)setTitle:(NSString *)title {
	[_titleLabel setText:title];
}

- (void)setSubtitle:(NSString *)subtitle {
	[_subtitleLabel setText:subtitle];
}

- (void)setLeftFooter:(NSString *)text {
	[_leftFooterLabel setText:text];
}

- (void)setRightFooter:(NSString *)text {
	[_rightFooterLabel setText:text];
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initializeLabels];
		[self configureLabels];
		[self addLabelsToContentView];
		
		// Add a bottom border to content view
		CALayer *bottomBorder = [CALayer layer];
		[bottomBorder setFrame:CGRectMake(RASCollectionViewCellMargin, frame.size.height-0.5f, frame.size.width - 1 * RASCollectionViewCellMargin, 0.5f)];
		[bottomBorder setBackgroundColor:[[UIColor colorWithWhite:0.8f alpha:1.0f] CGColor]];
		[[[self contentView] layer] addSublayer:bottomBorder];
	}
	return self;
}

- (void)initializeLabels {
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_leftFooterLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_rightFooterLabel = [[UILabel alloc] initWithFrame:CGRectZero];
}

- (void)configureLabels {
	[_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_subtitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_leftFooterLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_rightFooterLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	[_titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
	[_subtitleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]];
	[_leftFooterLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]];
	[_rightFooterLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]];
	
	[_titleLabel setTextColor:[UIColor blackColor]];
	[_subtitleLabel setTextColor:[UIColor grayColor]];
	[_leftFooterLabel setTextColor:[UIColor grayColor]];
	[_rightFooterLabel setTextColor:[UIColor grayColor]];

	[_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
	[_subtitleLabel setLineBreakMode:NSLineBreakByWordWrapping];

	[_titleLabel setNumberOfLines:0];
	[_subtitleLabel setNumberOfLines:0];
	
	CGFloat width = [[self contentView] frame].size.width - (2 * RASCollectionViewCellMargin);
	[_titleLabel setPreferredMaxLayoutWidth:width];
	[_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//	[_titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
	[_subtitleLabel setPreferredMaxLayoutWidth:width];
//	[_subtitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
//	[_subtitleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
}

- (void)addLabelsToContentView {
	UIView *contentView = [self contentView];
	[contentView addSubview:_titleLabel];
	[contentView addSubview:_subtitleLabel];
	[contentView addSubview:_leftFooterLabel];
	[contentView addSubview:_rightFooterLabel];
}

- (BOOL)requiresConstraintBasedLayout {
	return YES;
}

- (void)updateConstraints {
	[super updateConstraints];
	if (![self didSetupConstraints]) {
		if ([[self reuseIdentifier] isEqualToString:RASCollectionViewCellReuseIdentifierSmall]) {
			[self updateConstraintsForSmall];
		} else if ([[self reuseIdentifier] isEqualToString:RASCollectionViewCellReuseIdentifierLarge]) {
			[self updateConstraintsForLarge];
		}
		_didSetupConstraints = YES;
	}
}

- (void)updateConstraintsForSmall {
	if (_titleLabel != nil && _subtitleLabel != nil && _leftFooterLabel != nil && _rightFooterLabel != nil) {
		NSDictionary *subviews;
		NSNumber *margin = @(RASCollectionViewCellMargin);
		NSNumber *innerMargin = @(RASCollectionViewCellInnerMargin);
		NSNumber *subtitleMinHeight = @(RASCollectionViewCellSubtitleHeightMin);
		NSNumber *titleMinHeight = @(RASCollectionViewCellTitleHeightMin);
		NSNumber *imageSideLength = @(RASCollectionViewCellSmallImageSideLength);
		
		NSArray<NSLayoutConstraint *> *constraints = [[NSArray alloc] init];
		if (_imageView != nil) {
			NSNumber *labelWidth = @([[self contentView] frame].size.width - (2 * RASCollectionViewCellMargin) - RASCollectionViewCellTitleHeightMin);
			NSDictionary *metrics = NSDictionaryOfVariableBindings(margin, innerMargin, labelWidth, subtitleMinHeight, titleMinHeight, imageSideLength);
			// Constraints if there is an image:
			subviews = NSDictionaryOfVariableBindings(_titleLabel, _subtitleLabel, _leftFooterLabel, _rightFooterLabel, _imageView);
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[_imageView(>=imageSideLength)]-margin-|" options:0 metrics:metrics views:subviews]];
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_imageView(>=imageSideLength)]-margin-|" options:0 metrics:metrics views:subviews]];
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_titleLabel(>=titleMinHeight)]-innerMargin-[_subtitleLabel(>=subtitleMinHeight)]-innerMargin-[_leftFooterLabel]-margin-|" options:0 metrics:metrics views:subviews]];
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-margin-[_titleLabel(<=labelWidth)]-[_imageView(>=imageSideLength)]-margin-|" options:0 metrics:metrics views:subviews]];
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-margin-[_subtitleLabel(<=labelWidth)]-[_imageView(>=imageSideLength)]-margin-|" options:0 metrics:metrics views:subviews]];
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-margin-[_leftFooterLabel]->=0-[_rightFooterLabel]-[_imageView(>=imageSideLength)]-margin-|" options:0 metrics:metrics views:subviews]];
		} else {
			NSNumber *labelWidth = @([[self contentView] frame].size.width - (2 * RASCollectionViewCellMargin));
			NSDictionary *metrics = NSDictionaryOfVariableBindings(margin, innerMargin, labelWidth, subtitleMinHeight, titleMinHeight, imageSideLength);
			subviews = NSDictionaryOfVariableBindings(_titleLabel, _subtitleLabel, _leftFooterLabel, _rightFooterLabel);
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_titleLabel(>=titleMinHeight)]-innerMargin-[_subtitleLabel(>=subtitleMinHeight)]-innerMargin-[_leftFooterLabel]-margin-|" options:0 metrics:metrics views:subviews]];
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-margin-[_titleLabel(<=labelWidth)]-margin-|" options:0 metrics:metrics views:subviews]];
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-margin-[_subtitleLabel(<=labelWidth)]-margin-|" options:0 metrics:metrics views:subviews]];
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-margin-[_leftFooterLabel]->=0-[_rightFooterLabel]-margin-|" options:0 metrics:metrics views:subviews]];
		}
		constraints = [constraints arrayByAddingObject:[NSLayoutConstraint constraintWithItem:_leftFooterLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_rightFooterLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];

		
		[[self contentView] addConstraints:constraints];
	}
}

- (void)updateConstraintsForLarge {
	if (_titleLabel != nil && _subtitleLabel != nil && _leftFooterLabel != nil && _rightFooterLabel != nil && _imageView != nil) {
		NSDictionary *subviews = NSDictionaryOfVariableBindings(_titleLabel, _subtitleLabel, _leftFooterLabel, _rightFooterLabel, _imageView);
		NSNumber *margin = @(RASCollectionViewCellMargin);
		NSNumber *innerMargin = @(RASCollectionViewCellInnerMargin);
		NSNumber *labelWidth = @([[self contentView] frame].size.width - (2 * RASCollectionViewCellMargin));
		NSNumber *subtitleMinHeight = @(RASCollectionViewCellSubtitleHeightMin);
		NSNumber *titleMinHeight = @(RASCollectionViewCellTitleHeightMin);
		NSNumber *imageHeight = @(RASCollectionViewCellLargeImageHeight);
		NSDictionary *metrics = NSDictionaryOfVariableBindings(margin, innerMargin, labelWidth, subtitleMinHeight, titleMinHeight, imageHeight);
		NSArray<NSLayoutConstraint *> *constraints = [[NSArray alloc] init];
		constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_imageView(>=imageHeight)]-[_titleLabel(>=titleMinHeight)]-innerMargin-[_subtitleLabel(>=subtitleMinHeight)]-innerMargin-[_leftFooterLabel]-margin-|" options:0 metrics:metrics views:subviews]];
		constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-margin-[_titleLabel(<=labelWidth)]-margin-|" options:0 metrics:metrics views:subviews]];
		constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-margin-[_subtitleLabel(<=labelWidth)]-margin-|" options:0 metrics:metrics views:subviews]];
		constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-margin-[_leftFooterLabel]->=0-[_rightFooterLabel]-margin-|" options:0 metrics:metrics views:subviews]];
		constraints = [constraints arrayByAddingObject:[NSLayoutConstraint constraintWithItem:_leftFooterLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_rightFooterLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
		[[self contentView] addConstraints:constraints];
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
