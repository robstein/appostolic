//
//  RASTextViewController.h
//  Appostolic
//
//  Created by Robert Stein on 2/15/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

@class RASReading;

@interface RASTextViewController : UIViewController

- (instancetype)initWithReading:(RASReading *)reading;

@property (nonatomic, strong) RASReading *reading;

@end
