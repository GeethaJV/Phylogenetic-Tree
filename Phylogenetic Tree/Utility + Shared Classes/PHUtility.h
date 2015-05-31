//
//  PHUtility.h
//  Phylogenetic Tree
//
//  Created by Sid on 11/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHUtility : NSObject
+ (NSString *)applicationDocumentsDirectory;
+ (NSString *)applicationTempDirectory;
+ (NSString *)FASTAFileManipulationDirectory;
+ (void)clearFilewithNamefromTempDirectory:(NSString *)fileName;
+ (NSString *)CreateTreeDataSourceHTMLFilewithData:(NSData *)inHTMLData;
+ (void)RemoveHTMLTreeDataSource;
+ (void)SaveSupportingFilesDoesNotExists;
+ (void)RemoveSupportingFiles;
+ (NSString *)allignedXMLDirectory;
+ (void)saveXMLFileofName:(NSString *)xmlFileName fromFileofPath:(NSString *)path;
+ (NSString *)webServiceFASTADirectory;
@end
