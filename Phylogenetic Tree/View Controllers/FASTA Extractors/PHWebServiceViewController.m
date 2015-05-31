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

@interface PHWebServiceViewController ()<NSURLSessionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *typeSelectorBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameSelectorTextField;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic,copy) NSString *errorMessage;
@property (nonatomic,copy) NSString *hostName;
@property (nonatomic,strong) NSURLSession *urlSession;
- (IBAction)searchAction:(id)sender;

@end

@implementation PHWebServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    
    NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
    
    NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    if (netStatus == NotReachable) {
        self.errorMessage = [NSString stringWithFormat:@"Could Not Reach %@. Plese check Internet Connection",[NSString stringWithFormat:remoteHostLabelFormatString, self.hostName]];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Network Error" message:self.errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSString *fileName = @"J00231";
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://togows.org/entry/%@/%@.fasta",@"nucleotide",fileName]];
        
        NSURLSession *session =
        [NSURLSession sessionWithConfiguration:urlSessionConfig
                                      delegate:self
                                 delegateQueue:nil];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"GET";
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        
                                                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                        if (error != nil) {
                                                             NSLog(@"Complete Data %@",data);
                                                            
                                                            NSString *filePath = [NSString stringWithFormat:@"%@/%@",[PHUtility webServiceFASTADirectory],fileName];
                                                            
                                                            NSFileManager *fileManager = [NSFileManager defaultManager];
                                                            BOOL isDirectory = NO;
                                                            if ([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory]) {
                                                                
                                                            } else {
                                                                
                                                            }
                                                            
                                                        }
                                                       
                                                    }];
        [dataTask resume];
    }
   

}

#pragma mark -
#pragma mark Delegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    
    NSLog(@"Data %@",data);
}
@end
