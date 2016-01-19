//
//  DayViewController.m
//  Appostolic
//
//  Created by Robert Stein on 1/12/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "DayViewController.h"
#import "DayModel.h"

@interface DayViewController ()

@end

@implementation DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *today = [NSDate date];
    DayModel *model = [[DayModel alloc] initForDate:today];
     (void)model;
    
    [[[self reading1] title] setText:@"1st Reading"];
    //[[[self reading1] subtitle] setText:@"1 Sm 3:1-10, 19-20"];
    [[[self reading1] bodyText] setText:@"During the time young Samuel was minister to the LORD under Eli, a revelation of the LORD was uncommon and vision infrequent. One day Eli was asleep in his usual place. His eyes had lately grown so weak that he could not see. The lamp of God was not yet extinguished, and Samuel was sleeping in the temple of the LORD where the ark of God was. The LORD called to Samuel, who answered, “Here I am.”"];

    [[[self reading2] title] setText:@"Responsorial Psalm"];
    //[[[self reading2] subtitle] setText:@"Ps 40:2, 5, 7-8A, 8B-9, 10"];
    [[[self reading2] bodyText] setText:@"R. (8a and 9a) Here am I, Lord; I come to do your will.\
     I have waited, waited for the LORD,\
     and he stooped toward me and heard my cry.\
     Blessed the man who makes the LORD his trust;\
     who turns not to idolatry\
     or to those who stray after falsehood."];
    
    [[[self reading3] title] setText:@"Gospel"];
    //[[[self reading3] subtitle] setText:@"Mk 1:29-39"];
    [[[self reading3] bodyText] setText:@"On leaving the synagogue Jesus entered the house of Simon and Andrew with James and John. Simon’s mother-in-law lay sick with a fever. They immediately told him about her. He approached, grasped her hand, and helped her up. Then the fever left her and she waited on them."];
    
    [[[self invitatory] title] setText:@"3am"];
    [[[self invitatory] caption] setText:@"Invitatory"];
    [[[self officeOfReadings] title] setText:@"Office"];
    [[[self officeOfReadings] caption] setText:@"of Readings"];
    [[[self lauds] title] setText:@"6am"];
    [[[self lauds] caption] setText:@"Lauds"];
    [[[self terce] title] setText:@"9am"];
    [[[self terce] caption] setText:@"Terce"];
    [[[self sext] title] setText:@"12pm"];
    [[[self sext] caption] setText:@"Sext"];
    [[[self none] title] setText:@"3pm"];
    [[[self none] caption] setText:@"None"];
    [[[self vespers] title] setText:@"6pm"];
    [[[self vespers] caption] setText:@"Vespers"];
    [[[self compline] title] setText:@"9pm"];
    [[[self compline] caption] setText:@"Compline"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [[self readings] setContentSize:CGSizeMake(4*175+(4-1)*15+27.5, 86)];
    [[self liturgyOfTheHours] setContentSize:CGSizeMake(10*80+(10-1)*15+27.5, 80)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
