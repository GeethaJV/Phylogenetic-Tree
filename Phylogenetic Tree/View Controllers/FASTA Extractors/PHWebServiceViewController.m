//
//  PHWebServiceViewController.m
//  Phylogenetic Tree
//
//  Created by Siddalingamurthy Gangadharappa on 30/05/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import "PHWebServiceViewController.h"

@interface PHWebServiceViewController ()
@property (weak, nonatomic) IBOutlet UIButton *typeSelectorBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameSelectorTextField;
- (IBAction)searchAction:(id)sender;

@end

@implementation PHWebServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)searchAction:(id)sender {
}
@end
