//
//  Allignment.h
//  Phylogenetic Tree
//
//  Created by Sid on 19/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import <Realm/Realm.h>

@interface Allignment : RLMObject

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Allignment>
RLM_ARRAY_TYPE(Allignment)
