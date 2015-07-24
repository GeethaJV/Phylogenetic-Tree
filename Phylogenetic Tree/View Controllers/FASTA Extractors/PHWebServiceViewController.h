//
//  PHWebServiceViewController.h
//  Phylogenetic Tree
//
//  Created by Siddalingamurthy Gangadharappa on 30/05/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHFileChoserProtocols.h"

@interface PHWebServiceViewController : UIViewController
@property (weak,nonatomic)NSObject<PHFileChoserProtocols> *fileChooserDelegate;
@end
