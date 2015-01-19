//
//  FASTAFile.h
//  Phylogenetic Tree
//
//  Created by Sid on 19/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import <Realm/Realm.h>

@interface FASTAFile : RLMObject

@end

// This protocol enables typed collections. i.e.:
// RLMArray<FASTAFile>
RLM_ARRAY_TYPE(FASTAFile)
