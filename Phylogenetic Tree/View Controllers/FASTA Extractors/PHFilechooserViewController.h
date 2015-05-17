//
//  ViewController.h
//  Phylogenetic Tree
//
//  Created by Sid on 09/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHFileChoserProtocols.h"

@interface PHFilechooserViewController : UIViewController<PHFileChoserProtocols>

@property (weak, nonatomic) IBOutlet UIButton *pasteButton;
@property (weak, nonatomic) IBOutlet UIButton *database;
@property (weak, nonatomic) IBOutlet UIButton *PC;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (assign, nonatomic) BOOL isQuickTreeViewMode;

- (IBAction)pasteSequenceAction:(id)sender;
- (IBAction)fromDatabaseSequenceAction:(id)sender;
- (IBAction)pcSequenceAction:(id)sender;


@end

