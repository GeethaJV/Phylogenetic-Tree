//
//  PHFASTAFileViewerController.m
//  Phylogenetic Tree
//
//  Created by Sid on 18/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import "PHFASTAFileViewerController.h"
#import "PHUtility.h"

@interface PHFASTAFileViewerController ()

@property (copy,nonatomic)NSString *modifiedFilePath;

- (NSString *)moveFile:(NSString *)filePath toDirectory:(NSString *)tempDir andRenameFormat:(NSString *)UTIformatforWeb;
@end

@implementation PHFASTAFileViewerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonAction:)];
    self.navigationItem.rightBarButtonItem = doneButton;
//    self.navigationItem.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:133.0/255.0 blue:243.0/255.0 alpha:1.0];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    if(self.fileURL){
        self.navigationItem.title = [[self.fileURL path]lastPathComponent];
    }
    
    self.modifiedFilePath = [self moveFile:self.fileURL.path toDirectory:[PHUtility applicationTempDirectory] andRenameFormat:@"txt"];
    
    NSURL *fileURLis = [[NSURL alloc] initFileURLWithPath: self.modifiedFilePath isDirectory:NO];
    NSURLRequest *rulRequestis = [NSURLRequest requestWithURL:fileURLis];
    
    [self.fileTextwebViewer loadRequest:rulRequestis];
    
}

- (void)dealloc
{
    self.fileTextwebViewer = nil;
    NSError *removeError = nil;
    if(![[NSFileManager defaultManager]removeItemAtPath:self.modifiedFilePath error:&removeError]){
        NSLog(@"removeError %@",removeError);
    }
    self.modifiedFilePath = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)doneButtonAction:inSender{
    
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:^{
                                                      
                                                  }];
}

#pragma mark -
#pragma mark Private Methods
- (NSString *)moveFile:(NSString *)filePath toDirectory:(NSString *)tempDir andRenameFormat:(NSString *)UTIformatforWeb{
    
    NSString *renamedFilePath = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]){
        
        NSError *fileCopyError = nil;
        NSString *fileName = [filePath lastPathComponent];
        NSString *fileNameWithoutExtension = [fileName stringByDeletingPathExtension];
        NSString *fileNameWithNewExtension = [fileNameWithoutExtension stringByAppendingPathExtension:UTIformatforWeb];
        renamedFilePath = [tempDir stringByAppendingString:[NSString stringWithFormat:@"/%@",fileNameWithNewExtension]];
        
        if([fileManager copyItemAtPath:filePath toPath:renamedFilePath error:&fileCopyError]){
            
        }else{
            NSLog(@"File Copy Error is %@",fileCopyError);
        }
        
    }
    
    return renamedFilePath;
    
}
@end
