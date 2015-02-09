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
#import <QuartzCore/QuartzCore.h>

@interface PHFilechooserViewController ()<PHFileChoserProtocols>
@property (strong,nonatomic)UIBarButtonItem *allignmentButton;
@end

@implementation PHFilechooserViewController

#pragma mark -
#pragma mark Designated initializers

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}


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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
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
    
    NSURL *fileURL  = [[NSBundle mainBundle] URLForResource:@"sequence-4" withExtension:@"fasta"];
    
    if(fileURL){
        
        PHFASTAParser *parser = [[PHFASTAParser alloc]init];
        [parser openFASTAwithfileURL:fileURL];
        [parser readFASTAFilewithCompletionBlock:^(NSString *sequence, NSString *name, NSUInteger length) {
            
            NSLog(@"Sequence %@ Name %@",sequence,name);
        }];
    }
    
}

#pragma mark -
#pragma mark Delegates
- (void)numberOfFilesSelectedfromfileChooserOption:(NSInteger)inselectedFiles{
    
    if(inselectedFiles > 0){
        
         self.navigationItem.rightBarButtonItem = self.allignmentButton;
        
        if(inselectedFiles == 1){
            
            self.statusLabel.text = @"You have taken 1 file for processing";
            
        }else{
            
            self.statusLabel.text = [NSString stringWithFormat:@"You have taken %ld files for processing",(long)inselectedFiles];
            
        }
        
    }else{
        
        self.navigationItem.rightBarButtonItem = nil;
        self.statusLabel.text = @"";
        
    }
    
}
@end
