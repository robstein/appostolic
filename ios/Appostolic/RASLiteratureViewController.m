//
//  LiteratureViewController.m
//  Appostolic
//
//  Created by Robert Stein on 1/12/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "LiteratureViewController.h"
#import "SquareButton.h"
#import "WideButton.h"

@interface LiteratureViewController ()

@end

@implementation LiteratureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //SquareButton *button = [[SquareButton alloc] initWithTitle:@"9pm" caption:@"Compline"];
	WideButton *button = [[WideButton alloc] initWithTitle:@"Hello world" subtitle:@"Hi there" body:@"And here is a bunch of text. And here is a bunch of text. And here is a bunch of text. And here is a bunch of text. And here is a bunch of text."];
	[button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self view] addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
