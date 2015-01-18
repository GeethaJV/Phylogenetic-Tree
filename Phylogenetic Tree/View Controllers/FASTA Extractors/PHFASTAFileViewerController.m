//
//  PHFASTAFileViewerController.m
//  Phylogenetic Tree
//
//  Created by Sid on 18/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import "PHFASTAFileViewerController.h"

@interface PHFASTAFileViewerController ()


@end

@implementation PHFASTAFileViewerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonAction:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    NSLog(@"self.fileName %@",self.fileName);
    self.navigationItem.title = self.fileName;
    
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
@end
