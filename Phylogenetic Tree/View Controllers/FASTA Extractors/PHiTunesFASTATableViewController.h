//
//  PHiTunesFASTATableViewController.h
//  Phylogenetic Tree
//
//  Created by Sid on 15/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "PHFileChoserProtocols.h"

@interface PHiTunesFASTATableViewController : UITableViewController
@property (weak,nonatomic)NSObject<PHFileChoserProtocols> *fileChooserDelegate;
@end
