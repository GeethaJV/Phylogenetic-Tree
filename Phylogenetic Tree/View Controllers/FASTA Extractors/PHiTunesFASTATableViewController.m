//
//  PHiTunesFASTATableViewController.m
//  Phylogenetic Tree
//
//  Created by Sid on 15/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import "PHiTunesFASTATableViewController.h"
#import "PHFASTAFileViewerController.h"
#import "DirectoryWatcher.h"
#import "PHUtility.h"

#define kRowHeight 58.0f

@interface PHiTunesFASTATableViewController ()<DirectoryWatcherDelegate,UIDocumentInteractionControllerDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@property (nonatomic, strong) DirectoryWatcher *docWatcher;
@property (nonatomic, strong) NSMutableArray *documentURLs;
@property (nonatomic, strong) NSMutableArray *selectedDocumentsURL;
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;
@end

@implementation PHiTunesFASTATableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.docWatcher = [DirectoryWatcher watchFolderWithPath:[PHUtility applicationDocumentsDirectory]
                                                       delegate:self];
        self.documentURLs = [NSMutableArray array];
        self.selectedDocumentsURL = [NSMutableArray new];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self directoryDidChange:self.docWatcher];
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)dealloc{
    self.documentURLs = nil;
    self.docWatcher = nil;
    self.selectedDocumentsURL = nil;
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
    return self.documentURLs.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;

        if (self.documentURLs.count > 0)
            title = @"Documents folder";
    
    return title;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
       
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    NSURL *fileURL = [self.documentURLs objectAtIndex:indexPath.row];
    
    [self setupDocumentControllerWithURL:fileURL];
    
    // layout the cell
    cell.textLabel.text = [[fileURL path] lastPathComponent];
    NSInteger iconCount = [self.docInteractionController.icons count];
    if (iconCount > 0)
    {
        cell.imageView.image = [self.docInteractionController.icons objectAtIndex:iconCount - 1];
    }


    
    cell.textLabel.text = [[fileURL path] lastPathComponent];
    
    if([self.selectedDocumentsURL count] > 0){
        if([self.selectedDocumentsURL objectAtIndex:indexPath.row]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.selectionStyle = UITableViewCellAccessoryNone;
        }
    }
    
    NSString *fileURLString = [self.docInteractionController.URL path];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileURLString error:nil];
    NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] intValue];
    NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize
                                                           countStyle:NSByteCountFormatterCountStyleFile];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", fileSizeStr, self.docInteractionController.UTI];
    
    UILongPressGestureRecognizer *longPressGesture =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [cell.contentView addGestureRecognizer:longPressGesture];
    cell.imageView.userInteractionEnabled = YES;    // this is by default NO, so we need to turn it on
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}


#pragma mark - UITableViewDelegate


- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *cellIndexPath = [self.tableView indexPathForRowAtPoint:[longPressGesture locationInView:self.tableView]];
        
        NSURL *fileURL = [self.documentURLs objectAtIndex:cellIndexPath.row];
        
        NSString *filePath = [fileURL path];
        NSError *error;
        if(nil!=filePath){
            NSString *fileContent = [[NSString alloc]initWithContentsOfFile:filePath
                                                                   encoding:NSUTF8StringEncoding
                                                                      error:&error];
            NSLog(@"File Content is %@",fileContent);
            
            PHFASTAFileViewerController * fastafileviewerController = (PHFASTAFileViewerController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PHFASTAFileViewerController"];
            fastafileviewerController.fileName = [filePath lastPathComponent];
            [fastafileviewerController view];
            fastafileviewerController.fileTextViewer.text = fileContent;
            
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fastafileviewerController];
            //navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
            
            [self.navigationController presentViewController:navigationController
                                                    animated:YES
                                                  completion:^{
                                                  }];
            
            
        }
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSLog(@"Selected Index path %@",indexPath);
    [self.selectedDocumentsURL addObject:[self.documentURLs objectAtIndex:indexPath.row]];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
   }

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        
    NSLog(@"Selected Index path %@ and %lu",indexPath,(unsigned long)[self.selectedDocumentsURL count]);
    if([self.documentURLs count] >= indexPath.row){
        
        NSURL *filePathobj = [self.documentURLs objectAtIndex:indexPath.row];
        
        if([self.selectedDocumentsURL containsObject:filePathobj]){
            
            [self.selectedDocumentsURL removeObject:filePathobj];
            //[self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
    }
        
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSError *error;
        NSString *filePath = [(NSURL*)[self.documentURLs objectAtIndex:indexPath.row]path];
        if(filePath){
            if ([[NSFileManager defaultManager]isDeletableFileAtPath:filePath]) {
                BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
                if (!success) {
                    NSLog(@"Error removing file at path: %@", error.localizedDescription);
                }else{
                    [self.documentURLs removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                    
                    
                }
            }
            
        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.fileChooserDelegate respondsToSelector:@selector(numberOfFilesSelectedfromfileChooserOption:)]){
            [self.fileChooserDelegate numberOfFilesSelectedfromfileChooserOption:[self.selectedDocumentsURL count]];
        }
    }
    [super viewWillDisappear:animated];
}
#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}



#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    NSInteger numToPreview = 0;
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath.section == 0)
        numToPreview = self.documentURLs.count;
    
    return numToPreview;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    NSURL *fileURL = nil;
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath.section == 0)
    {
        /*
        NSString *file = [(NSURL*)[self.documentURLs objectAtIndex:idx] path];
        NSString *tmp = [file stringByAppendingPathExtension:@".txt"];
        [[NSFileManager defaultManager]copyItemAtPath:file toPath:tmp error:NULL];
        return [NSURL fileURLWithPath:tmp];
        */
       fileURL = [self.documentURLs objectAtIndex:idx];
    }
    
    return fileURL;
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    //checks if docInteractionController has been initialized with the URL
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}




#pragma mark -
#pragma mark Directory Watcher Delegate
- (void)directoryDidChange:(DirectoryWatcher *)folderWatcher{
    
    [self.documentURLs removeAllObjects];    // clear out the old docs and start over
    
    NSString *documentsDirectoryPath = [PHUtility applicationDocumentsDirectory];
    
    NSArray *documentsDirectoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectoryPath error:NULL];
    
    for (NSString* curFileName in [documentsDirectoryContents objectEnumerator])
    {
        NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:curFileName];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
        BOOL isDirectory;
        [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        // proceed to add the document URL to our list (ignore the "Inbox" folder)
        if (!(isDirectory && [curFileName isEqualToString:@"Inbox"]))
        {
            [self.documentURLs addObject:fileURL];
        }
    }
    
    [self.tableView reloadData];
    
}

#pragma mark -
#pragma Private Methods


@end
