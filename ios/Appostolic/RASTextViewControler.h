//
//  RASTextViewControler.h
//  Appostolic
//
//  Created by Robert Stein on 2/15/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RASReading;

@interface RASTextViewControler : UIViewController

- (instancetype)initWithReading:(RASReading *)reading;

@property (nonatomic, strong) RASReading *reading;

@end
