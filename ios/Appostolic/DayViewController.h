//
//  DayViewController.h
//  Appostolic
//
//  Created by Robert Stein on 1/12/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreviewButton.h"
#import "LiturgyOfTheHoursButton.h"

@interface DayViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet PreviewButton *firstReading;
@property (weak, nonatomic) IBOutlet PreviewButton *secondReading;
@property (weak, nonatomic) IBOutlet PreviewButton *gospelReading;

@property (weak, nonatomic) IBOutlet LiturgyOfTheHoursButton *invitatory;
@property (weak, nonatomic) IBOutlet LiturgyOfTheHoursButton *officeOfReadings;
@property (weak, nonatomic) IBOutlet LiturgyOfTheHoursButton *lauds;
@property (weak, nonatomic) IBOutlet LiturgyOfTheHoursButton *terce;
@property (weak, nonatomic) IBOutlet LiturgyOfTheHoursButton *sext;
@property (weak, nonatomic) IBOutlet LiturgyOfTheHoursButton *none;
@property (weak, nonatomic) IBOutlet LiturgyOfTheHoursButton *vespers;
@property (weak, nonatomic) IBOutlet LiturgyOfTheHoursButton *compline;



@end

