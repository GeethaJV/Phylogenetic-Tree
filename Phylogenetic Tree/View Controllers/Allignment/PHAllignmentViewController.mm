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


@interface PHAllignmentViewController ()
@property (copy,nonatomic) NSString *outPutAllignedFilePath;
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
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self processAllignmentforFile:self.allignmentFile];
    });

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
    
    
    if(self.outPutAllignedFilePath){
        
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

    // std::string respath( [ documentsPath UTF8String ] ) ;
     ProgressiveAlignment pa = ProgressiveAlignment("",seqfile, "");
}

- (void)deleteOutputFileIfExists{
    NSString *fastFileName = @"output.best.fas.best.fas";
    NSString *xmlFileName = @"output.best.fas.best.xml";
    [PHUtility clearFilewithNamefromTempDirectory:fastFileName];
    [PHUtility clearFilewithNamefromTempDirectory:xmlFileName];
    
}

@end
