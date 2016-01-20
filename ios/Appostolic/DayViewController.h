//
//  DayViewController.h
//  Appostolic
//
//  Created by Robert Stein on 1/12/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

@class WideButton;
@class SquareButton;

@interface DayViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UIScrollView *readings;
@property (weak, nonatomic) IBOutlet WideButton *reading1;
@property (weak, nonatomic) IBOutlet WideButton *reading2;
@property (weak, nonatomic) IBOutlet WideButton *reading3;

@property (weak, nonatomic) IBOutlet UIScrollView *liturgyOfTheHours;
@property (weak, nonatomic) IBOutlet SquareButton *invitatory;
@property (weak, nonatomic) IBOutlet SquareButton *officeOfReadings;
@property (weak, nonatomic) IBOutlet SquareButton *lauds;
@property (weak, nonatomic) IBOutlet SquareButton *terce;
@property (weak, nonatomic) IBOutlet SquareButton *sext;
@property (weak, nonatomic) IBOutlet SquareButton *none;
@property (weak, nonatomic) IBOutlet SquareButton *vespers;
@property (weak, nonatomic) IBOutlet SquareButton *compline;

@end
