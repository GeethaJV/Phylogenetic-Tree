//
//  ViewController.h
//  Phylogenetic Tree
//
//  Created by Sid on 09/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHFilechooserViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *pasteButton;
@property (weak, nonatomic) IBOutlet UIButton *database;
@property (weak, nonatomic) IBOutlet UIButton *PC;

- (IBAction)pasteSequenceAction:(id)sender;
- (IBAction)fromDatabaseSequenceAction:(id)sender;
- (IBAction)pcSequenceAction:(id)sender;


@end

