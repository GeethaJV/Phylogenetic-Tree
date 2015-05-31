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

+ (NSString *)CreateTreeDataSourceHTMLFilewithData:(NSData *)inHTMLData{
    
    NSString *cachesDirectoryDirectory = [PHUtility applicationTempDirectory];
    NSString *treeFilePath = [cachesDirectoryDirectory stringByAppendingPathComponent:@"/TreeDataSource.html"];
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    if(![fileManager fileExistsAtPath:treeFilePath isDirectory:&isDir]){
        if([fileManager createFileAtPath:treeFilePath contents:inHTMLData attributes:nil]){
            NSLog(@"File Created");
            return  treeFilePath;
        }else{
            NSLog(@"File Creation Failed");
            return nil;
        }
    }
    else{
        NSLog(@"Directory Already Exist");
        [fileManager removeItemAtPath:treeFilePath error:nil];
        if([fileManager createFileAtPath:treeFilePath contents:inHTMLData attributes:nil]){
            NSLog(@"File Created");
            return  treeFilePath;
        }else{
            NSLog(@"File Creation Failed");
            return nil;
        }
        return  treeFilePath;
    }

    return nil;
}

+ (void)RemoveHTMLTreeDataSource{
    
    NSString *cachesDirectoryDirectory = [PHUtility applicationTempDirectory];
    NSString *filepath = [cachesDirectoryDirectory stringByAppendingPathComponent:@"/TreeDataSource.html"];
    
    if (filepath) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:filepath isDirectory:&isDir]) {
            [fileManager removeItemAtPath:filepath error:nil];
        }
    }
}

+ (void)SaveSupportingFilesDoesNotExists{
    
     NSString *cachesDirectoryDirectory = [PHUtility applicationTempDirectory];
     BOOL isDir = NO;
     NSFileManager *fileManager = [NSFileManager defaultManager];
     NSString *phyloSVGPath = [cachesDirectoryDirectory stringByAppendingPathComponent:@"/jsphylosvg-min.js"];
     NSString *raphaelminPath = [cachesDirectoryDirectory stringByAppendingPathComponent:@"/raphael-min.js"];
    
    if(![fileManager fileExistsAtPath:phyloSVGPath isDirectory:&isDir]){
        NSString *pathinstring = [[NSBundle mainBundle]pathForResource:@"jsphylosvg-min" ofType:@"js"];
        NSError *error = nil;
        if (![fileManager copyItemAtPath:pathinstring toPath:phyloSVGPath error:&error]) {
            NSLog(@"Failed to copythe file %@ and Error is %@",pathinstring,error);
        }
    }
    
    if(![fileManager fileExistsAtPath:raphaelminPath isDirectory:&isDir]){
        NSString *pathinstring = [[NSBundle mainBundle]pathForResource:@"raphael-min" ofType:@"js"];
        NSError *error = nil;
        if (![fileManager copyItemAtPath:pathinstring toPath:raphaelminPath error:&error]) {
            NSLog(@"Failed to copythe file %@ and Error is %@",pathinstring,error);
        }
        
    }
    
    NSString *XMLDirectory = [[self class]allignedXMLDirectory];
    NSString *sampleXMLPath = [XMLDirectory stringByAppendingPathComponent:@"/Sample.xml"];
    if(![fileManager fileExistsAtPath:sampleXMLPath isDirectory:&isDir]){
        NSString *pathinstring = [[NSBundle mainBundle]pathForResource:@"Sample" ofType:@"xml"];
        NSError *error = nil;
        if (![fileManager copyItemAtPath:pathinstring toPath:sampleXMLPath error:&error]) {
            NSLog(@"Failed to copythe file %@ and Error is %@",pathinstring,error);
        }
    }

    
}

+ (void)RemoveSupportingFiles{
    NSString *cachesDirectoryDirectory = [PHUtility applicationTempDirectory];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *phyloSVGPath = [cachesDirectoryDirectory stringByAppendingPathComponent:@"/jsphylosvg-min.js"];
    NSString *raphaelminPath = [cachesDirectoryDirectory stringByAppendingPathComponent:@"/raphael-min.js"];
    
    if([fileManager fileExistsAtPath:phyloSVGPath isDirectory:&isDir]){
        [fileManager removeItemAtPath:phyloSVGPath error:nil];
    }
    
    if(![fileManager fileExistsAtPath:raphaelminPath isDirectory:&isDir]){
        [fileManager removeItemAtPath:raphaelminPath error:nil];
    }
    
    NSString *XMLDirectory = [[self class]allignedXMLDirectory];
    NSString *sampleXMLPath = [XMLDirectory stringByAppendingPathComponent:@"/Sample.xml"];
    if(![fileManager fileExistsAtPath:sampleXMLPath isDirectory:&isDir]){
        [fileManager removeItemAtPath:sampleXMLPath error:nil];
    }
}

+ (NSString *)allignedXMLDirectory{
    NSString *tempDirectory = [PHUtility applicationTempDirectory];
    
    NSString *savedAllignmentDirectory = [tempDirectory stringByAppendingPathComponent:@"Saved Allignments"];
    
    BOOL isDir = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:savedAllignmentDirectory isDirectory:&isDir]){
        if([fileManager createDirectoryAtPath:savedAllignmentDirectory withIntermediateDirectories:YES attributes:nil error:nil]){
            NSLog(@"Saved Directory Created");
        }else{
            NSLog(@"Saved Directory Creation Failed");
            return nil;
        }
        
    }
    else{
        NSLog(@"Directory Already Exist");
    }
    
    return savedAllignmentDirectory;
}

+ (void)saveXMLFileofName:(NSString *)xmlFileName fromFileofPath:(NSString *)path{
    
    if(xmlFileName != nil){
        
        NSString *XMLDirectoryPath = [[self class]allignedXMLDirectory];
        
        if (XMLDirectoryPath) {
            NSString *proposedPath = [NSString stringWithFormat:@"%@/%@",XMLDirectoryPath,xmlFileName];
            
            BOOL isDirectory = NO;
            if ([[NSFileManager defaultManager]fileExistsAtPath:proposedPath isDirectory:&isDirectory]) {
                
                NSError *filemangerError = nil;
                NSString *outPutXMLFilePath = path;
                if ([[NSFileManager defaultManager]removeItemAtPath:proposedPath error:&filemangerError]){
                    
                    if ([[NSFileManager defaultManager]copyItemAtPath:outPutXMLFilePath
                                                               toPath:proposedPath error:&filemangerError]) {
                        NSLog(@"File copied sucessfully");
                    } else {
                        NSLog(@"Could not able to copy File. Save Failed");
                    }
                    
                } else {
                    
                    NSLog(@"Could Not Remove File. Save Failed");
                }
                
            } else {
                
                NSError *filemangerError = nil;
                NSString *outPutXMLFilePath = path;
                
                if ([[NSFileManager defaultManager]copyItemAtPath:outPutXMLFilePath
                                                           toPath:proposedPath error:&filemangerError]) {
                    NSLog(@"File copied sucessfully");
                } else {
                    NSLog(@"Could not able to copy File. Save Failed");
                }
            }
        }else{
            NSLog(@"Directory Not Exists");
        }
    } else {
        NSLog(@"No File Name Given");
    }
}

+ (NSString *)webServiceFASTADirectory{
    NSString *tempDirectory = [PHUtility applicationTempDirectory];
    
    NSString *savedAllignmentDirectory = [tempDirectory stringByAppendingPathComponent:@"Web Service"];
    
    BOOL isDir = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:savedAllignmentDirectory isDirectory:&isDir]){
        if([fileManager createDirectoryAtPath:savedAllignmentDirectory withIntermediateDirectories:YES attributes:nil error:nil]){
            NSLog(@"Web Service Directory Created");
        }else{
            NSLog(@"Web Service Directory Creation Failed");
            return nil;
        }
        
    }
    else{
        NSLog(@"Web Service Directory Already Exist");
    }
    
    return savedAllignmentDirectory;
}


@end
