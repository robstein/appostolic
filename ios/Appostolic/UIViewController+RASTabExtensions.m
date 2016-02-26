//
//  UIViewController+RASTabExtensions.m
//  Appostolic
//
//  Created by Robert Stein on 2/23/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "UIViewController+RASTabExtensions.h"

@implementation UIViewController (RASTabExtensions)

- (instancetype)initWithTitle:(NSString *)title tabBarItemImage:(UIImage *)image {
	if (self = [self init]) {
		[self setTitle:title];
		[[self tabBarItem] setImage:image];
	}
	return self;
}

@end
