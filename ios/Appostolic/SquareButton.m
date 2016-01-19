//
//  SquareButton.m
//  Appostolic
//
//  Created by Robert Stein on 1/15/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "SquareButton.h"
#import "Utils.h"

@implementation SquareButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"SquareButton" owner:self options:nil] firstObject]];
        
        [[self layer] setBorderWidth:1.0f];
        [[self layer] setCornerRadius:15.0f];
        [self setBackgroundColor:UIColorFromRGB(0x007AFF)];

    }
    return self;
}

@end
