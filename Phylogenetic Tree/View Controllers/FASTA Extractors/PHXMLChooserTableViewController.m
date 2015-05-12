//
//  PHXMLChooserTableViewController.m
//  Phylogenetic Tree
//
//  Created by Siddalingamurthy Gangadharappa on 11/05/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import "PHXMLChooserTableViewController.h"
#import "PHAllignmentViewController.h"
#import "PHUtility.h"

@interface PHXMLChooserTableViewController ()
@property (nonatomic,strong) NSMutableArray *xmlFileDataSourceArray;
@property (nonatomic,copy) NSString *selectedFileName;
@end

@implementation PHXMLChooserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonAction:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSArray *sampleFiles = [[NSFileManager defaultManager]
                           contentsOfDirectoryAtPath:[PHUtility allignedXMLDirectory] error:nil];
    if (sampleFiles.count > 0){
        self.xmlFileDataSourceArray = [[NSMutableArray alloc]initWithArray:sampleFiles];
    } else {
        self.xmlFileDataSourceArray = [NSMutableArray new];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.xmlFileDataSourceArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    
    if (self.xmlFileDataSourceArray.count > 0)
        title = @"XML folder";
    
    return title;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XMLDirIdentifier" forIndexPath:indexPath];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"XMLDirIdentifier"];
        
    }
    NSString *filePath = [self.xmlFileDataSourceArray objectAtIndex:indexPath.row];
    
    // layout the cell
    cell.textLabel.text = filePath;
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Selected Index path %@",indexPath);
    self.selectedFileName = [self.xmlFileDataSourceArray objectAtIndex:indexPath.row];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedFileName = nil;
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.accessoryType = UITableViewCellAccessoryNone;
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//   
//
//}



- (void)doneButtonAction:(id)inSender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    PHAllignmentViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"AllignmentViewController"];
    viewController.isFromQuickPreview = YES;
    viewController.quickTreeFileName = self.selectedFileName;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)dealloc
{
    [self resetFileNameSeletion];
}

- (void)resetFileNameSeletion{
    self.selectedFileName = nil;
}
@end
