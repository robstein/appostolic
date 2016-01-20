//
//  SquareButton.h
//  Appostolic
//
//  Created by Robert Stein on 1/15/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GradientView;

@interface SquareButton : UIView

- (instancetype) initWithTitle:(NSString *)title caption:(NSString *)caption;

@property (nonatomic, strong) GradientView *background;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *caption;

@end
