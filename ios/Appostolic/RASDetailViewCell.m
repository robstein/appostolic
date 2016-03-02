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

static const CGFloat RASDetailViewCellVerticalMargin = 18.f;
static const CGFloat RASDetailViewCellHorizontalMargin = 25.f;

@interface RASDetailViewCell ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic) BOOL didSetupConstraints;
@property (nonatomic) BOOL didCalculateHeight;

@end

@implementation RASDetailViewCell

@synthesize text = _text;
@synthesize textLabel = _textLabel;
@synthesize didSetupConstraints = _didSetupConstraints;
@synthesize didCalculateHeight = _didCalculateHeight;

- (void)setText:(NSString *)text isPoetry:(BOOL)isPoetry {
	_text = text;
	
	NSData *bodyData = [text dataUsingEncoding:NSUTF8StringEncoding];
	NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:bodyData documentAttributes:NULL];
	NSString *string = [attrString string];
	if (!isPoetry) {
		string = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
	}
	NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	trimmedString = [trimmedString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	[_textLabel setText:trimmedString];
	
	[self setNeedsUpdateConstraints];
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initializeLabels];
		[self configureLabels];
		[self addLabelsToContentView];
		[self setBackgroundColor:[UIColor whiteColor]];
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
	
	CGFloat width = [[self contentView] frame].size.width - (2 * RASDetailViewCellHorizontalMargin);
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

		if (_textLabel != nil) {
			NSDictionary *subviews;
			NSNumber *verticalMargin = @(RASDetailViewCellVerticalMargin);
			NSNumber *horizontalMargin = @(RASDetailViewCellHorizontalMargin);
			NSNumber *labelWidth = @([[self contentView] frame].size.width - (2 * RASDetailViewCellHorizontalMargin));
			NSArray<NSLayoutConstraint *> *constraints = [[NSArray alloc] init];
			NSDictionary *metrics = NSDictionaryOfVariableBindings(verticalMargin, horizontalMargin, labelWidth);
			subviews = NSDictionaryOfVariableBindings(_textLabel);
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalMargin-[_textLabel]-verticalMargin-|" options:0 metrics:metrics views:subviews]];
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-horizontalMargin-[_textLabel(<=labelWidth)]-horizontalMargin-|" options:0 metrics:metrics views:subviews]];
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

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
	if (!_didCalculateHeight) {
		[self setNeedsLayout];
		[self layoutIfNeeded];
		CGSize size = [[self contentView] systemLayoutSizeFittingSize:[layoutAttributes size]];
		CGRect newFrame = [layoutAttributes frame];
		newFrame.size.height = (CGFloat)(ceilf(size.height));
		[layoutAttributes setFrame:newFrame];
		[self setDidCalculateHeight:YES];
	}
	return layoutAttributes;
}

@end
