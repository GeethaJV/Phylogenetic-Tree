//
//  PHFASTAFileViewerController.h
//  Phylogenetic Tree
//
//  Created by Sid on 18/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHFASTAFileViewerController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *fileTextwebViewer;
@property (copy, nonatomic) NSURL *fileURL;
@end
