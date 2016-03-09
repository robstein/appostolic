//
//  RASAnimatingFlowLayout.m
//  Appostolic
//
//  Created by Robert Stein on 3/6/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASAnimatingFlowLayout.h"

@implementation RASAnimatingFlowLayout

- (void)commonInit {
}

- (instancetype)init {
	if (self = [super init]) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self commonInit];
	}
	return self;
}

@end
