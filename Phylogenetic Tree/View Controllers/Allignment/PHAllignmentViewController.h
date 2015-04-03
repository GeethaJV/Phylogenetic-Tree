//
//  PHAllignmentViewController.h
//  Phylogenetic Tree
//
//  Created by Sid on 29/03/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHAllignmentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *viewAllignmentButton;
@property (weak, nonatomic) IBOutlet UIButton *treeConstructionButton;
@property (copy, nonatomic) NSString *allignmentFile;
- (IBAction)viewAllignment:(id)sender;
- (IBAction)constructTree:(id)sender;
@end
