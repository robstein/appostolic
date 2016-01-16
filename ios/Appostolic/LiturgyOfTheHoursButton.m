//
//  LiturgyOfTheHoursButton.m
//  Appostolic
//
//  Created by Robert Stein on 1/13/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "LiturgyOfTheHoursButton.h"

@implementation LiturgyOfTheHoursButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"LiturgyOfTheHoursButton" owner:self options:nil] firstObject]];
    }
    [[self layer] setBorderWidth:1.0f];
    [[self layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self layer] setCornerRadius:10.0f];
    return self;
}

@end
