//
//  PHAllignmentViewController.m
//  Phylogenetic Tree
//
//  Created by Sid on 29/03/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import "PHAllignmentViewController.h"
#import "PHFASTAFileViewerController.h"
#import "PHUtility.h"
#include "progressivealignment.h"
#import "MBProgressHUD.h"


@interface PHAllignmentViewController ()<MBProgressHUDDelegate>{
    ProgressiveAlignment *allignmentObj;
}
@property (copy,nonatomic) NSString *outPutAllignedFilePath;
@property (strong,nonatomic) MBProgressHUD *progressbar;
@end

@implementation PHAllignmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewAllignmentButton.layer.borderWidth = 1.0f;
    self.viewAllignmentButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.viewAllignmentButton.layer.cornerRadius = 4.0f;
    
    self.treeConstructionButton.layer.borderWidth = 1.0f;
    self.treeConstructionButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.treeConstructionButton.layer.cornerRadius = 4.0f;
    
    //[self.viewAllignmentButton setEnabled:NO];
    //[self.treeConstructionButton setEnabled:NO];
    
    [self processAllignmentforFile:self.allignmentFile];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"TreeViewController"]){

    }
}


- (IBAction)viewAllignment:(id)sender {
    
    self.outPutAllignedFilePath = [NSString stringWithFormat:@"%@.%@",[NSString stringWithFormat:@"%s",outfile.c_str()],@"best.fas"];
    
    
    if([[NSFileManager defaultManager]fileExistsAtPath:self.outPutAllignedFilePath]){
        
        PHFASTAFileViewerController * fastafileviewerController = (PHFASTAFileViewerController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PHFASTAFileViewerController"];
        fastafileviewerController.fileURL = [[NSURL alloc]initFileURLWithPath:self.outPutAllignedFilePath];
        [fastafileviewerController view];
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fastafileviewerController];
        [self.navigationController presentViewController:navigationController
                                                animated:YES
                                              completion:^{
                                              }];
    }
    
}

- (IBAction)constructTree:(id)sender {
}

#pragma mark -
- (void)processAllignmentforFile:(NSString *)inputFASTAFile{
    
    [self deleteOutputFileIfExists];
     std::string seq = *new std::string([inputFASTAFile UTF8String]);
     seqfile = seq;
    self.outPutAllignedFilePath = [NSString stringWithFormat:@"%@/%@",[PHUtility applicationTempDirectory],@"output.best.fas"];
    
   std::string outputfilepath = *new std::string([self.outPutAllignedFilePath UTF8String]);
   outfile = outputfilepath;

    
    self.progressbar = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.progressbar];
    [self.progressbar removeFromSuperViewOnHide];
    self.progressbar.delegate = self;
    self.progressbar.labelText = @"Generating Multiple Allignment…";
    self.progressbar.minSize = CGSizeMake(135.f, 135.f);
    self.progressbar.mode = MBProgressHUDModeIndeterminate;
    self.progressbar.progress = 0.0;
    [self.progressbar show:YES];

    // std::string respath( [ documentsPath UTF8String ] ) ;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        allignmentObj = new ProgressiveAlignment("",seqfile,"",(__bridge void *)self);
    });
    
    


    
}

- (void)deleteOutputFileIfExists{
    NSString *fastFileName = @"output.best.fas.best.fas";
    NSString *xmlFileName = @"output.best.fas.best.xml";
    [PHUtility clearFilewithNamefromTempDirectory:fastFileName];
    [PHUtility clearFilewithNamefromTempDirectory:xmlFileName];
    
}

- (void)dealloc {
    
    seqfile = "";
    outfile = "output";
    delete allignmentObj;
    delete hmm;
}


// C "trampoline" function to invoke Objective-C method
int MyObjectDoProgressUpdateWith (void *myObjectInstance, int aParameter, string str)
{
    NSString *allignmentIteration = nil;
    if ( !str.empty()) {
        allignmentIteration = [NSString stringWithUTF8String:str.c_str()];
    }
    // Call the Objective-C method using Objective-C syntax
    return [(__bridge id) myObjectInstance doSomethingWith:aParameter andString:allignmentIteration];
}

int MyObjectDoInformTheCompletion (void *myObjectInstance )
{
     return [(__bridge id) myObjectInstance allignmentCompleted];
    
}

// The Objective-C member function you want to call from C++
- (int) doSomethingWith:(int)aParameter andString:(NSString *)strng{
    
    NSLog(@" Allignment of %@ and percentage %d",strng,aParameter);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressbar.mode = MBProgressHUDModeDeterminateHorizontalBar;
        self.progressbar.progress = aParameter/100;
        self.progressbar.labelText = strng;
        self.progressbar.detailsLabelText = [NSString stringWithFormat:@"%d/100 allignment completed",aParameter];
    });
    

   // self.progressbar sh
    return 0;
}
- (int)allignmentCompleted{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressbar.hidden = YES;
        
    });
    
    return 0;
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [self.progressbar removeFromSuperview];

}

@end
