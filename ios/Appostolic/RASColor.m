//
//  RASColor.m
//  Appostolic
//
//  Created by Robert Stein on 3/2/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASColor.h"
#import "RASUtils.h"

@implementation RASColor

+ (NSArray *)whiteColors {
	return [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xF7F7F7) CGColor], (id)[UIColorFromRGB(0xF7F7F7) CGColor], nil];
}

+ (NSArray *)silverColors {
	return [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xF7F7F7) CGColor], (id)[UIColorFromRGB(0xD7D7D7) CGColor], nil];
}

+ (NSArray *)goldColors {
	return [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xD6CEC3) CGColor], (id)[UIColorFromRGB(0xE4DDCA) CGColor], nil];
}

+ (NSArray *)yellowColors {
	return [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xFFDB4C) CGColor], (id)[UIColorFromRGB(0xFFCD02) CGColor], nil];
}

+ (NSArray *)redColors {
	return [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xFF3B30) CGColor], (id)[UIColorFromRGB(0xFF3B30) CGColor], nil];
}

+ (NSArray *)violetColors {
	return [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xC644FC) CGColor], (id)[UIColorFromRGB(0xC644FC) CGColor], nil];
}

+ (NSArray *)blackColors {
	return [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x4A4A4A) CGColor], (id)[UIColorFromRGB(0x2B2B2B) CGColor], nil];
}

+ (NSArray *)roseColors {
	return [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xFFD3E0) CGColor], (id)[UIColorFromRGB(0xFFD3E0) CGColor], nil];
}

@end
