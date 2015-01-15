//
//  ViewController.m
//  Phylogenetic Tree
//
//  Created by Sid on 09/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import "PHFilechooserViewController.h"

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
    
    
    //[self.pasteButton setTitle:@"Geetha" forState:UIControlStateNormal];
    // Do any additional setup after loading the view, typically from a nib.
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
