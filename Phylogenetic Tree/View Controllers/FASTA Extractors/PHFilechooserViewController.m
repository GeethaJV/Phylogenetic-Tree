//
//  ViewController.m
//  Phylogenetic Tree
//
//  Created by Sid on 09/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import "PHFilechooserViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PHFilechooserViewController ()

@end

@implementation PHFilechooserViewController

#pragma mark -
#pragma mark Designated initializers

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}


#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.pasteButton.layer.borderWidth = 1.0f;
    self.database.layer.borderWidth = 1.0f;
    self.PC.layer.borderWidth = 1.0f;
    self.pasteButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.database.layer.borderColor = [UIColor blueColor].CGColor;
    self.PC.layer.borderColor = [UIColor blueColor].CGColor;
    self.pasteButton.layer.cornerRadius = 4.0f;
    self.database.layer.cornerRadius = 4.0f;
    self.PC.layer.cornerRadius = 4.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}

#pragma mark -
#pragma Action Methods
- (IBAction)pasteSequenceAction:(id)sender {
    
    NSLog(@"Paste Action %@",sender);
}

- (IBAction)fromDatabaseSequenceAction:(id)sender {
    NSLog(@"Database Action %@",sender);
}

- (IBAction)pcSequenceAction:(id)sender {
    NSLog(@"PC Action %@",sender);
}
@end
