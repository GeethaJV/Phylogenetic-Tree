//
//  PHFASTAParser.h
//  Phylogenetic Tree
//
//  Created by Sid on 25/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHFASTAParser : NSObject
- (BOOL)openFASTAwithfileURL:(NSURL *)inFastaURL;
- (void)closeFASTAwithfileURL:(NSURL *)inFastaURL;
- (void)readFASTAFilewithCompletionBlock:(void (^)(NSString *sequence, NSString *name, NSUInteger length)) SequenceParser;

@end
