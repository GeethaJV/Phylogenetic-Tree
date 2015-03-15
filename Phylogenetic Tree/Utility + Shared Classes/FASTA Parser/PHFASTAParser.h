//
//  PHFASTAParser.h
//  Phylogenetic Tree
//
//  Created by Sid on 25/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHFASTAParser : NSObject

- (void)readALineOfFASTAFileContenforFileHandle:(NSFileHandle *)inReadFileHandle withCompletionBlock:(void (^)(NSData *sequenceData, NSUInteger length)) SequenceParser;

@end
