//
//  WideButton.m
//  Appostolic
//
//  Created by Robert Stein on 1/15/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "WideButton.h"
#import "Utils.h"

@implementation WideButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"WideButton" owner:self options:nil] firstObject]];
        
        [[self layer] setBorderWidth:1.0f];
        [[self layer] setBorderColor:[UIColorFromRGB(0xCECED2) CGColor]];
        [[self layer] setCornerRadius:10.0f];
        [self setBackgroundColor:UIColorFromRGB(0xFFCC00)];
    }

    return self;
}

@end
