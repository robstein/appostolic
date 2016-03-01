//
//  RASTransitioningDelegate.h
//  Appostolic
//
//  Created by Robert Stein on 2/28/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

@interface RASTransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) CGRect openingFrame;
@property (nonatomic, strong) UIView *openingView;

@end
