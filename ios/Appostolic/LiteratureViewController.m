//
//  LiteratureViewController.m
//  Appostolic
//
//  Created by Robert Stein on 1/12/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "LiteratureViewController.h"
#import "SquareButton.h"

@interface LiteratureViewController ()

@end

@implementation LiteratureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SquareButton *button = [[SquareButton alloc] initWithTitle:@"9pm" caption:@"Compline"];
    [[self view] addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
