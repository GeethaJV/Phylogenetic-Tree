//
//  ViewController.m
//  Phylogenetic Tree
//
//  Created by Sid on 09/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import "PHFilechooserViewController.h"
#import "PHiTunesFASTATableViewController.h"
#import "PHFileChoserProtocols.h"
#import "PHFASTAParser.h"
#import "PHUtility.h"
#include "progressivealignment.h"
#import <QuartzCore/QuartzCore.h>

@interface PHFilechooserViewController ()<PHFileChoserProtocols>{
    dispatch_queue_t writerqueue;
}
@property (strong,nonatomic)UIBarButtonItem *allignmentButton;
@property (strong,nonatomic)NSMutableArray *selectedFileURlsforAllignment;
@property (copy,nonatomic)NSString *pathOfFASTAfileForAllignment;
typedef void(^fileConstructed)(NSString *);

@end

@implementation PHFilechooserViewController


#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pasteButton.layer.borderWidth = 1.0f;
    self.database.layer.borderWidth = 1.0f;
    self.PC.layer.borderWidth = 1.0f;
    self.pasteButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.database.layer.borderColor = [UIColor blueColor].CGColor;
    self.PC.layer.borderColor = [UIColor blueColor].CGColor;
    self.pasteButton.layer.cornerRadius = 4.0f;
    self.database.layer.cornerRadius = 4.0f;
    self.PC.layer.cornerRadius = 4.0f;
    
    self.statusLabel.text = @"";
    
    if(! self.allignmentButton){
        self.allignmentButton = [[UIBarButtonItem alloc] initWithTitle:@"Allignment" style:UIBarButtonItemStylePlain target:self action:@selector(gotoAllignment:)];
        self.navigationItem.rightBarButtonItem = self.allignmentButton;
    }

    if(!writerqueue)
    {
        writerqueue = dispatch_queue_create("yourOwnQueueName", NULL);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
//    if(writerqueue){
//        dispatch_release(writerqueue);
//    }
}

#pragma mark -
#pragma Action Methods
- (IBAction)pasteSequenceAction:(id)sender {
    
    NSLog(@"Paste Action %@",sender);
}

- (IBAction)fromDatabaseSequenceAction:(id)sender {
    NSLog(@"Database Action %@",sender);
}

- (IBAction)pcSequenceAction:(id)sender {
    NSLog(@"PC Action %@",sender);
}

#pragma mark -
#pragma mark Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"iTunesFilesViewerController"]){
        
        PHiTunesFASTATableViewController *viewController = [segue destinationViewController];
        viewController.fileChooserDelegate = self;
    }
    
}

- (void)gotoAllignment:sender{
    
    //NSURL *fileURL  = [[NSBundle mainBundle] URLForResource:@"sequence-2" withExtension:@"fasta"];
   // NSString *pathForSequenceFile = [fileURL path];
    
    [self constructFASTAReferenceFilefromFilesAtPath:self.selectedFileURlsforAllignment
                                 withCompletionBlock:^(NSString * inFileName) {
                                     NSLog(@"inFileName %@",inFileName);
                                     if(inFileName){
                                         std::string seq = *new std::string([inFileName UTF8String]);
                                         seqfile = seq;
                                         NSString *documentsPath = [NSString stringWithFormat:@"%@/%@",[PHUtility applicationDocumentsDirectory],@"output"];
                                         
                                         std::string outputfilepath = *new std::string([documentsPath UTF8String]);
                                         outfile = outputfilepath;
                                         
                                         std::string respath( [ documentsPath UTF8String ] ) ;
                                         ProgressiveAlignment pa = ProgressiveAlignment("",seqfile, "");
                                     }
                                 }];
#if 0
    std::string seq = *new std::string([pathForSequenceFile UTF8String]);
    seqfile = seq;

    
    NSString *documentsPath = [NSString stringWithFormat:@"%@/%@",[PHUtility applicationDocumentsDirectory],@"output"];
    
    std::string outputfilepath = *new std::string([documentsPath UTF8String]);
    outfile = outputfilepath;
    
    std::string respath( [ documentsPath UTF8String ] ) ;
   // std::string *sequence = new std::string([pathForSequenceFile UTF8String]);
    //std::printf(@"%s",*seq);
    //const char *seq = [pathForSequenceFile cStringUsingEncoding:NSUTF8StringEncoding];
    //std::string *sequencestd::string str(seq);
    ProgressiveAlignment pa = ProgressiveAlignment("",seqfile, "");
    PHFASTAParser *parser = [[PHFASTAParser alloc]init];
    //[parser openFASTAwithfileURL:fileURL];
    //[parser readFASTAFilewithCompletionBlock:^(NSString *sequence, NSString *name, NSUInteger length) {
        
      //  NSLog(@"Sequence %@ Name %@",sequence,name);
    //}];
        
#endif
    
    
}



#pragma mark -
#pragma mark Delegates
- (void)selectedFileReferenceArray:(NSMutableArray *)inSelectedFileArray{
    if(nil == self.selectedFileURlsforAllignment){
        self.selectedFileURlsforAllignment = [[NSMutableArray alloc]initWithArray:inSelectedFileArray];
    }else{
        self.selectedFileURlsforAllignment = inSelectedFileArray;
    }
    NSInteger selectedFilesCount = [self.selectedFileURlsforAllignment count];
    self.navigationItem.rightBarButtonItem = nil;
    self.statusLabel.text = @"";
    if(selectedFilesCount > 0){
        if(selectedFilesCount == 1){
            self.statusLabel.text = @"You have taken 1 file for processing";
        }else if(selectedFilesCount > 1){
            self.navigationItem.rightBarButtonItem = self.allignmentButton;
            
            self.statusLabel.text = [NSString stringWithFormat:@"You have taken %ld files for processing",(long)selectedFilesCount];
        }
    }
}

#pragma mark -
#pragma mark Private Methods
- (void)constructFASTAReferenceFilefromFilesAtPath:(NSMutableArray *)inFilePaths withCompletionBlock:(fileConstructed)inCompletionBlock{
    
    if(inFilePaths.count >= 2){
        self.pathOfFASTAfileForAllignment = [self FASTAInupfile];
        if(self.pathOfFASTAfileForAllignment){
            NSFileHandle *fileHandle_Writer = [NSFileHandle fileHandleForWritingAtPath:self.pathOfFASTAfileForAllignment];
            
            for(NSURL *fileName in inFilePaths){
                PHFASTAParser *parser = [PHFASTAParser new];
                NSFileHandle *fileHandle_Reader = [NSFileHandle fileHandleForReadingFromURL:fileName error:nil];
                [parser readALineOfFASTAFileContenforFileHandle:fileHandle_Reader
                                            withCompletionBlock:^(NSData *sequenceData, NSUInteger length) {
                                                
                                                __block NSUInteger sequenceDataLength = length;
                                                __block NSData *sequenceLineData = sequenceData;
                                    
                                                while (sequenceDataLength > 0) {
                                                   [fileHandle_Writer seekToEndOfFile];
                                                   [fileHandle_Writer writeData:sequenceLineData];
                                                    [parser readALineOfFASTAFileContenforFileHandle:fileHandle_Reader withCompletionBlock:^(NSData *sequenceData, NSUInteger length) {
                                                        sequenceDataLength = length;
                                                        sequenceLineData = sequenceData;
                                                    }];
                                                    
                                                }
                                            }];
                [fileHandle_Reader closeFile];
            }
            [fileHandle_Writer closeFile];
            inCompletionBlock(self.pathOfFASTAfileForAllignment);
        }
        
        
    }else{
        inCompletionBlock(nil);
    }
   
}
- (NSString *)FASTAInupfile{
    
    NSString *fastaDir = [PHUtility FASTAFileManipulationDirectory];
    NSString *fastaInputFileName = [NSString stringWithFormat:@"%@/%@",fastaDir,@"InputFASTA.fasta"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: fastaInputFileName] == YES){
        NSLog(@"File exists");
    }else {
        NSLog (@"File not found, file will be created");
        if ([fileManager createFileAtPath:fastaInputFileName contents:nil attributes:nil]){
            return fastaInputFileName;
        }else{
             NSLog(@"Create file returned NO");
            return nil;
        }
    }
    
    return fastaInputFileName;
}
@end