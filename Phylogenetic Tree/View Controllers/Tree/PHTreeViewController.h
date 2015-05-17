//
//  PHTreeViewController.h
//  Phylogenetic Tree
//
//  Created by Siddalingamurthy Gangadharappa on 29/04/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHFileChoserProtocols.h"

@interface PHTreeViewController : UIViewController
@property (nonatomic,strong) NSString *xmlFileName;
@property (weak,nonatomic)NSObject<PHFileChoserProtocols> *fileChooserDelegate;
@end
