//
//  DayViewController.m
//  Appostolic
//
//  Created by Robert Stein on 1/12/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "DayViewController.h"
#import "UIView+Autolayout.h"

@interface DayViewController ()

@end

@implementation DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *viewSet_dailyReadings = [UIView autolayoutView];
    UIView *viewSet_liturgyOfTheHours = [UIView autolayoutView];
    UIView *viewSet_saintOfTheDay = [UIView autolayoutView];
    
    UILabel *dailyReadingsTitle = [UILabel autolayoutView];
    [dailyReadingsTitle setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
    [dailyReadingsTitle setText:@"Today's Readings"];
    UILabel *reading1 = [UILabel autolayoutView];
    [reading1 setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [reading1 setText:@"Mk 10 etc etc blah blah blah"];
    UILabel *reading2 = [UILabel autolayoutView];
    [reading2 setText:@"Psalm blah"];
    [reading2 setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    UILabel *reading3 = [UILabel autolayoutView];
    [reading3 setText:@"This is the Gospel and shall be bigger"];
    [reading3 setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]];
    
    [viewSet_dailyReadings addSubview:dailyReadingsTitle];
    [viewSet_dailyReadings addSubview:reading1];
    [viewSet_dailyReadings addSubview:reading2];
    [viewSet_dailyReadings addSubview:reading3];
    NSDictionary *viewSet_dailyReadingsViews = NSDictionaryOfVariableBindings(dailyReadingsTitle,reading1,reading2,reading3);
    [viewSet_dailyReadings addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[dailyReadingsTitle]-[reading1]-[reading3]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewSet_dailyReadingsViews]];
    [viewSet_dailyReadings addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[dailyReadingsTitle]-[reading2]-[reading3]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:viewSet_dailyReadingsViews]];
    [viewSet_dailyReadings addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[dailyReadingsTitle]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewSet_dailyReadingsViews]];
    [viewSet_dailyReadings addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[reading1]-[reading2]-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:viewSet_dailyReadingsViews]];
    [viewSet_dailyReadings addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[reading3]-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:viewSet_dailyReadingsViews]];

    
    UILabel *liturgyOfTheHoursTitle = [UILabel autolayoutView];
    [liturgyOfTheHoursTitle setText:@"Liturgy of the Hours"];
    [viewSet_liturgyOfTheHours addSubview:liturgyOfTheHoursTitle];
    
    UILabel *saintOfTheDayTitle = [UILabel autolayoutView];
    [saintOfTheDayTitle setText:@"Saint of the Day"];
    [viewSet_saintOfTheDay addSubview:saintOfTheDayTitle];
    
    UIStackView *stackView = [UIStackView autolayoutView];
    [stackView addArrangedSubview:viewSet_dailyReadings];
    [stackView addArrangedSubview:liturgyOfTheHoursTitle];
    [stackView addArrangedSubview:saintOfTheDayTitle];
    [stackView setAxis:UILayoutConstraintAxisVertical];
    [stackView setDistribution:UIStackViewDistributionFillProportionally];
    [stackView setAlignment:UIStackViewAlignmentLeading];
    [stackView setSpacing:10.0];

    UIView *view = [self view];
    [view addSubview:stackView];
    
    id bottomGuide = [self bottomLayoutGuide];
    NSDictionary *views = NSDictionaryOfVariableBindings(stackView,bottomGuide);
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[stackView]-[bottomGuide]|"
                                                                options:0
                                                                metrics:nil
                                                                  views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[stackView]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
