//
//  PHWebServiceViewController.m
//  Phylogenetic Tree
//
//  Created by Siddalingamurthy Gangadharappa on 30/05/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import "PHWebServiceViewController.h"
#import "Reachability.h"
#import "PHUtility.h"
#import "MBProgressHUD.h"
#import "DirectoryWatcher.h"
#import "PHFilechooserViewController.h"
#import "PHFASTAFileViewerController.h"
#import "PHAllignmentViewController.h"
#import <QuickLook/QuickLook.h>

#define kRowHeight 58.0f

static NSInteger IS_FIRST_TIME_VC = 1;
@interface PHWebServiceViewController ()<NSURLSessionDelegate,UIPickerViewDataSource,UIPickerViewDelegate,MBProgressHUDDelegate,DirectoryWatcherDelegate,UIDocumentInteractionControllerDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *typeSelectorTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameSelectorTextField;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic,copy) NSString *errorMessage;
@property (nonatomic,copy) NSString *hostName;
@property (nonatomic,strong) NSURLSession *urlSession;
@property (weak, nonatomic) IBOutlet UIPickerView *fileSeclectorPicker;
@property (nonatomic,strong) NSMutableArray *pickerDataSourceArray;
@property (strong,nonatomic) MBProgressHUD *progressbar;

@property (nonatomic, strong) DirectoryWatcher *docWatcher;
@property (nonatomic, strong) NSMutableArray *documentURLs;
@property (nonatomic, strong) NSMutableArray *selectedDocumentsURL;
@property (nonatomic,strong)  NSMutableArray *xmlFileDataSourceArray;
@property (nonatomic,copy) NSString *selectedFileName;

@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)searchAction:(id)sender;

@end

@implementation PHWebServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.fileSeclectorPicker removeFromSuperview];
    
    
    if ([self.fileChooserDelegate respondsToSelector:@selector(isAppInQuickTreeViewMode)] && [self.fileChooserDelegate isAppInQuickTreeViewMode]){
        
        NSArray *sampleFiles = [[NSFileManager defaultManager]
                                contentsOfDirectoryAtPath:[PHUtility webServiceFASTADirectory] error:nil];
        if (sampleFiles.count > 0){
            self.xmlFileDataSourceArray = [[NSMutableArray alloc]initWithArray:sampleFiles];
        } else {
            self.xmlFileDataSourceArray = [NSMutableArray new];
        }
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonAction:)];
        self.navigationItem.rightBarButtonItem = saveButton;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        
    } else {
        
        self.docWatcher = [DirectoryWatcher watchFolderWithPath:[PHUtility webServiceFASTADirectory]delegate:self];
        self.documentURLs = [NSMutableArray array];
        self.selectedDocumentsURL = [NSMutableArray new];
        [self directoryDidChange:self.docWatcher];
    }

    
    self.pickerDataSourceArray = [NSMutableArray arrayWithObjects:@"",@"nucleotide",@"protein",nil];
    self.typeSelectorTextField.inputView = self.fileSeclectorPicker;
    // Do any additional setup after loading the view.
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    //[self.internetReachability startNotifier];
    
    NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
    
    self.hostName = @"http://togows.org/";
    NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    if (netStatus == NotReachable) {
        self.errorMessage = [NSString stringWithFormat:@"Could Not Reach %@. Plese check Internet Connection",[NSString stringWithFormat:remoteHostLabelFormatString, self.hostName]];
    }


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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    self.documentURLs = nil;
    self.docWatcher = nil;
    self.selectedDocumentsURL = nil;
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* reachability = [note object];
    NSParameterAssert([reachability isKindOfClass:[Reachability class]]);
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
        NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    if (netStatus == NotReachable) {
        self.errorMessage = [NSString stringWithFormat:@"Could Not Reach %@. Plese check Internet Connection",[NSString stringWithFormat:remoteHostLabelFormatString, self.hostName]];
    } else {
        
    }
    
    
}


- (IBAction)searchAction:(id)sender {
    
    [self.typeSelectorTextField resignFirstResponder];
    [self.nameSelectorTextField resignFirstResponder];
    
    NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
    
    NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    if (netStatus == NotReachable) {
        self.errorMessage = [NSString stringWithFormat:@"Could Not Reach %@. Plese check Internet Connection",[NSString stringWithFormat:remoteHostLabelFormatString, self.hostName]];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Network Error" message:self.errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.progressbar = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:self.progressbar];
        [self.progressbar removeFromSuperViewOnHide];
        self.progressbar.delegate = self;
        self.progressbar.labelText = @"Downloading File…";
        self.progressbar.minSize = CGSizeMake(135.f, 135.f);
        self.progressbar.mode = MBProgressHUDModeIndeterminate;
        self.progressbar.progress = 0.0;
        [self.progressbar show:YES];
        
        NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSString *fastaFileName = [self.nameSelectorTextField text];
        NSString *fastaFileType = [self.typeSelectorTextField text];
        
        if (fastaFileName.length !=0 && fastaFileType.length !=0) {
            
            //NSString *fileName = @"J00231";
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://togows.org/entry/%@/%@.fasta",fastaFileType,fastaFileName]];
            
            NSURLSession *session =
            [NSURLSession sessionWithConfiguration:urlSessionConfig
                                          delegate:self
                                     delegateQueue:nil];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            request.HTTPMethod = @"GET";
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                self.progressbar.hidden = YES;
                                                                
                                                            });

                                                            
                                                            if (error == nil) {
                                                                NSLog(@"Complete Data %@",data);
                                                                
                                                                NSString *filePath = [NSString stringWithFormat:@"%@/%@.fasta",[PHUtility webServiceFASTADirectory],fastaFileName];
                                                                
                                                                NSFileManager *fileManager = [NSFileManager defaultManager];
                                                                BOOL isDirectory = NO;
                                                                if ([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory]) {
                                                                   
                                                                    [fileManager removeItemAtPath:filePath error:nil];
                                                                    [fileManager createFileAtPath:filePath
                                                                                         contents:data attributes:nil];
                                                                    
                                                                } else {
                                                                    
                                                                    [fileManager createFileAtPath:filePath
                                                                                         contents:data attributes:nil];
                                                                    
                                                                }
                                                                
                                                            }
                                                            
                                                        }];
            [dataTask resume];
        } else {
            
            NSLog(@"Invalid Input");
            
        }
        
    }
    

}

#pragma mark -
#pragma mark Delegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    
    NSLog(@"Data %@",data);
}

#pragma mark -
#pragma mark Picker Data Source
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [self.pickerDataSourceArray objectAtIndex:row];
}
#pragma mark -
#pragma mark Picker Delegates

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    [self.typeSelectorTextField setText:[self.pickerDataSourceArray objectAtIndex:row]];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.fileChooserDelegate respondsToSelector:@selector(isAppInQuickTreeViewMode)] && [self.fileChooserDelegate isAppInQuickTreeViewMode]) {
        return self.xmlFileDataSourceArray.count;
    } else {
        return self.documentURLs.count;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    
    if ([self.fileChooserDelegate respondsToSelector:@selector(isAppInQuickTreeViewMode)] && [self.fileChooserDelegate isAppInQuickTreeViewMode]) {
        
        if (self.xmlFileDataSourceArray.count > 0){
            
            title = @"XML Files";
        }
        
    } else {
        
        if (self.documentURLs.count > 0)
            title = @"Documents folder";
    }
    
    
    return title;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([self.fileChooserDelegate respondsToSelector:@selector(isAppInQuickTreeViewMode)] && [self.fileChooserDelegate isAppInQuickTreeViewMode]) {
        
        tableView.allowsSelection = YES;
        tableView.allowsMultipleSelection = NO;
        NSString *filePath = [self.xmlFileDataSourceArray objectAtIndex:indexPath.row];
        cell.textLabel.text = filePath;
        
        NSURL *fileURL = [NSURL fileURLWithPath:[[NSString stringWithFormat:@"%@/%@",[PHUtility allignedXMLDirectory],filePath]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self setupDocumentControllerWithURL:fileURL];
        NSInteger iconCount = [self.docInteractionController.icons count];
        if (iconCount > 0)
        {
            cell.imageView.image = [self.docInteractionController.icons objectAtIndex:iconCount - 1];
        }
        
        
    } else {
        
        tableView.allowsMultipleSelection = YES;
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
        cell.imageView.userInteractionEnabled = YES;    // this is by default NO, so we need to turn it on
    }
    
    UILongPressGestureRecognizer *longPressGesture =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [cell.contentView addGestureRecognizer:longPressGesture];
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}


#pragma mark - UITableViewDelegate


- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateBegan){
        NSIndexPath *cellIndexPath = [self.tableView indexPathForRowAtPoint:[longPressGesture locationInView:self.tableView]];
        
        NSURL *fileURL = nil;
        if ([self.fileChooserDelegate respondsToSelector:@selector(isAppInQuickTreeViewMode)] && [self.fileChooserDelegate isAppInQuickTreeViewMode]) {
            fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[PHUtility allignedXMLDirectory],[self.xmlFileDataSourceArray objectAtIndex:cellIndexPath.row]]];
        } else {
            fileURL = [self.documentURLs objectAtIndex:cellIndexPath.row];
        }
        
        
        if(fileURL){
            
            PHFASTAFileViewerController * fastafileviewerController = (PHFASTAFileViewerController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PHFASTAFileViewerController"];
            fastafileviewerController.fileURL = fileURL;
            fastafileviewerController.fileChooserDelegate = (PHFilechooserViewController *)self.fileChooserDelegate;
            [fastafileviewerController view];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fastafileviewerController];
            [self.navigationController presentViewController:navigationController
                                                    animated:YES
                                                  completion:^{
                                                  }];
        }
    }
}


- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    //checks if docInteractionController has been initialized with the URL
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
        self.docInteractionController.URL = url;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected Index path %@",indexPath);
    if ([self.fileChooserDelegate respondsToSelector:@selector(isAppInQuickTreeViewMode)] && [self.fileChooserDelegate isAppInQuickTreeViewMode]){
        
        self.selectedFileName = [self.xmlFileDataSourceArray objectAtIndex:indexPath.row];
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        
        [self.selectedDocumentsURL addObject:[self.documentURLs objectAtIndex:indexPath.row]];
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.fileChooserDelegate respondsToSelector:@selector(isAppInQuickTreeViewMode)] && [self.fileChooserDelegate isAppInQuickTreeViewMode]) {
        
        self.selectedFileName = nil;
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        
    } else {
        
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
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    
    if ([self.fileChooserDelegate respondsToSelector:@selector(isAppInQuickTreeViewMode)] && [self.fileChooserDelegate isAppInQuickTreeViewMode]) {
        
        return NO;
        
    } else {
        
        return YES;
        
    }
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
                    NSURL *filePathobj = [self.documentURLs objectAtIndex:indexPath.row];
                    
                    if([self.selectedDocumentsURL containsObject:filePathobj]){
                        
                        [self.selectedDocumentsURL removeObject:filePathobj];
                        //[self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
                        selectedCell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    
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
        if([self.fileChooserDelegate respondsToSelector:@selector(selectedFileReferenceArray:)]){
            [self.fileChooserDelegate selectedFileReferenceArray:self.selectedDocumentsURL];
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



#pragma mark -
#pragma mark Directory Watcher Delegate
- (void)directoryDidChange:(DirectoryWatcher *)folderWatcher{
    
    [self.documentURLs removeAllObjects];    // clear out the old docs and start over
    
    NSString *documentsDirectoryPath = [PHUtility webServiceFASTADirectory];
    
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
//    
//    if(IS_FIRST_TIME_VC && [self.documentURLs count]){
//        [self performSelector:@selector(showToastView:) withObject:nil afterDelay:2.0];
//        IS_FIRST_TIME_VC = 0;
//    }
    
    [self.tableView reloadData];
    
}

//- (void)showToastView:sender{
//    [ALToastView toastInView:self.view withText:@"Tap and Hold for few seconds to view the file"];
//}


#pragma mark -
#pragma mark Action Methods
- (void)doneButtonAction:(id)inSender{
    
    if (nil != self.selectedFileName) {
        if ([self.fileChooserDelegate respondsToSelector:@selector(isAppInQuickTreeViewMode)] && [self.fileChooserDelegate isAppInQuickTreeViewMode]) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle:nil];
            PHAllignmentViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"AllignmentViewController"];
            viewController.fileChooserDelegate = self.fileChooserDelegate;
            viewController.quickTreeFileName = self.selectedFileName;
            [self.navigationController pushViewController:viewController animated:YES];
            
            
        } else {
            
        }
        
    }
}


@end
