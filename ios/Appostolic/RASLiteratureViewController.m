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

NSString *const RASLiteratureTabName = @"Literature";
NSString *const RASLiteratureTabImageName = @"Literature";

@interface RASLiteratureViewController ()

@end

@implementation RASLiteratureViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self setTitle:RASLiteratureTabName];
		[[self tabBarItem] setImage:[UIImage imageNamed:RASLiteratureTabImageName]];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //RASSquareButton *button = [[RASSquareButton alloc] initWithTitle:@"9pm" caption:@"Compline"];
	RASWideButton *button = [[RASWideButton alloc] initWithTitle:@"Hello world" subtitle:@"Hi there" body:@"And here is a bunch of text. And here is a bunch of text. And here is a bunch of text. And here is a bunch of text. And here is a bunch of text."];
	[button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self view] addSubview:button];
}

@end
