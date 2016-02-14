//
//  WideButton.h
//  Appostolic
//
//  An 86x175 view with a gradient background and title, subtitle, and body.
//
//  Created by Robert Stein on 1/15/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

@class GradientView;

@interface WideButton : UIView

- (instancetype) initWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body;

@property (nonatomic, strong) GradientView *background;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subtitle;
@property (nonatomic, strong) UILabel *body;

@end
