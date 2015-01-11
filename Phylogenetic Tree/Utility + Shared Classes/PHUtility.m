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

@end
