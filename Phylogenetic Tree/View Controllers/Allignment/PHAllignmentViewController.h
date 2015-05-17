//
//  PHAllignmentViewController.h
//  Phylogenetic Tree
//
//  Created by Sid on 29/03/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHFileChoserProtocols.h"

@interface PHAllignmentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *viewAllignmentButton;
@property (weak, nonatomic) IBOutlet UIButton *treeConstructionButton;
@property (copy, nonatomic) NSString *allignmentFile;
@property (weak,nonatomic)NSObject<PHFileChoserProtocols> *fileChooserDelegate;
@property (nonatomic,copy) NSString *quickTreeFileName;

- (IBAction)viewAllignment:(id)sender;
- (IBAction)constructTree:(id)sender;

// The Objective-C member function you want to call from C++
- (int) doSomethingWith:(int)aParameter andString:(NSString *)strng;
@end
