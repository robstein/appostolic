//
//  UIView+Autolayout.m
//  Appostolic
//
//  Created by Robert Stein on 1/13/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "UIView+Autolayout.h"

@implementation UIView (Autolayout)

+ (id)autolayoutView {
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

@end
