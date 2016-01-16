//
//  PreviewButton.m
//  Appostolic
//
//  Created by Robert Stein on 1/13/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "PreviewButton.h"

@interface PreviewButton ()

@end

@implementation PreviewButton

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize bodyText = _bodyText;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"PreviewButton" owner:self options:nil] firstObject]];
    }
    [[self layer] setBorderWidth:1.0f];
    [[self layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self layer] setCornerRadius:10.0f];
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [super sizeThatFits:size];
}




@end
