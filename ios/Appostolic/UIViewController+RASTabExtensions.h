//
//  UIViewController+RASTabExtensions.h
//  Appostolic
//
//  Created by Robert Stein on 2/23/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

@interface UIViewController (RASTabExtensions)

// This method helps to use a RASCollectionViewController in a UITabViewController
//  It invokes -[self init]
- (instancetype)initWithTitle:(NSString *)title tabBarItemImage:(UIImage *)image;

@end
