//
//  RASLiteratureViewController.m
//  Appostolic
//
//  Created by Robert Stein on 1/12/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASLiteratureViewController.h"
#import "RASSquareButton.h"
#import "RASWideButton.h"

@interface RASLiteratureViewController ()

@end

@implementation RASLiteratureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //RASSquareButton *button = [[RASSquareButton alloc] initWithTitle:@"9pm" caption:@"Compline"];
	RASWideButton *button = [[RASWideButton alloc] initWithTitle:@"Hello world" subtitle:@"Hi there" body:@"And here is a bunch of text. And here is a bunch of text. And here is a bunch of text. And here is a bunch of text. And here is a bunch of text."];
	[button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self view] addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
