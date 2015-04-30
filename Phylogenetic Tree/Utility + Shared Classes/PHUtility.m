//
//  PHUtility.m
//  Phylogenetic Tree
//
//  Created by Sid on 11/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import "PHUtility.h"

@implementation PHUtility
+ (NSString *)applicationDocumentsDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)applicationTempDirectory{
     return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)dataFilePathforDocumentName:(NSString *)inDocumentName{
    NSString *documentPath = [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],inDocumentName];

    return documentPath;
}

+ (NSString *)FASTAFileManipulationDirectory{
    
    NSString *documentDirectory = [PHUtility applicationTempDirectory];
    
    NSString *FASTADirName = [documentDirectory stringByAppendingPathComponent:@"FASTA Manipulations"];
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:FASTADirName isDirectory:&isDir]){
        if([fileManager createDirectoryAtPath:FASTADirName withIntermediateDirectories:YES attributes:nil error:nil]){
             NSLog(@"Directory Created");
        }else{
            NSLog(@"Directory Creation Failed");
            return nil;
        }
        
    }
    else{
         NSLog(@"Directory Already Exist");
    }
    
    return FASTADirName;
}

+ (void)clearFilewithNamefromTempDirectory:(NSString *)fileName{
    
    if (fileName) {
        NSString *cachesDirectoryDirectory = [PHUtility applicationTempDirectory];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fastafileName = [cachesDirectoryDirectory stringByAppendingPathComponent:fileName];
        
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:fastafileName isDirectory:&isDir]) {
            [fileManager removeItemAtPath:fastafileName error:nil];
        }
    }
    
}
@end
