//
//  SquareButton.m
//  Appostolic
//
//  An 80x80 square view with a gradient background and a title and caption.
//
//  Created by Robert Stein on 1/15/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "SquareButton.h"
#import <GradientView/GradientView-Swift.h>
#import "Utils.h"

static const CGFloat SquareButtonTitleFontSize = 20.f;
static const CGFloat SquareButtonCaptionFontSize = 12.f;
static const CGFloat SquareButtonCornerRadius = 15.f;
static const CGFloat SquareButtonCornerSideLength = 80.f;

@implementation SquareButton

@synthesize background = _background;
@synthesize title = _title;
@synthesize caption = _caption;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        [_title setFont:[UIFont systemFontOfSize:SquareButtonTitleFontSize]];
        [_title setTranslatesAutoresizingMaskIntoConstraints:NO];

        _caption = [[UILabel alloc] initWithFrame:CGRectZero];
        [_caption setFont:[UIFont systemFontOfSize:SquareButtonCaptionFontSize]];
        [_caption setTranslatesAutoresizingMaskIntoConstraints:NO];

        _background = [[GradientView alloc] initWithFrame:CGRectZero];
        [_background setColors:@[UIColorFromRGB(0x5AC8FA), UIColorFromRGB(0x007AFF)]];
        [[_background layer] setBorderColor:[UIColorFromRGB(0xCECED2) CGColor]];
        [[_background layer] setCornerRadius:SquareButtonCornerRadius];
        [_background setClipsToBounds:YES];
        [_background setTranslatesAutoresizingMaskIntoConstraints:NO];

        [_background addSubview:_title];
        [_background addSubview:_caption];
        
        [self addSubview:_background];
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title caption:(NSString *)caption {
    if ((self = [self initWithFrame:CGRectZero])) {
        
        [_title setText:title];
        [_caption setText:caption];
        
    }
    return self;
}

- (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(SquareButtonCornerSideLength, SquareButtonCornerSideLength);
}

- (void)layoutSubviews {
    
    if (_title != nil && _caption != nil && _background != nil) {
        NSDictionary *subviews = NSDictionaryOfVariableBindings(_title, _caption);
        NSArray<NSLayoutConstraint *> *subviewsVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_title]-[_caption]-|"
                                                                                                  options:0
                                                                                                  metrics:nil
                                                                                                    views:subviews];
        NSLayoutConstraint *centerTitleX = [NSLayoutConstraint constraintWithItem:_title
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_background
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0
                                                                    constant:0.0];
        NSLayoutConstraint *centerCaptionX = [NSLayoutConstraint constraintWithItem:_caption
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_background
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1.0
                                                                         constant:0.0];
        [_background addConstraints:subviewsVertical];
        [_background addConstraint:centerTitleX];
        [_background addConstraint:centerCaptionX];
        
        NSNumber *sideLength = @(SquareButtonCornerSideLength);
        NSDictionary *metrics = NSDictionaryOfVariableBindings(sideLength);
        NSDictionary *views = NSDictionaryOfVariableBindings(_background);
        NSArray<NSLayoutConstraint *> *backgroundHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_background(sideLength)]|"
                                                                                                      options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                                                                                      metrics:metrics
                                                                                                        views:views];
        NSArray<NSLayoutConstraint *> *backgroundVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_background(sideLength)]|"
                                                                                                    options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                                                    metrics:metrics
                                                                                                      views:views];
        [self addConstraints:backgroundHorizontal];
        [self addConstraints:backgroundVertical];
    }
}

@end
