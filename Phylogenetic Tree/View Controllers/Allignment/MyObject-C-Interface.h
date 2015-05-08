//
//  MyObject-C-Interface.h
//  Phylogenetic Tree
//
//  Created by Siddalingamurthy Gangadharappa on 07/05/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#ifndef Phylogenetic_Tree_MyObject_C_Interface_h
#define Phylogenetic_Tree_MyObject_C_Interface_h
// This is the C "trampoline" function that will be used
// to invoke a specific Objective-C method FROM C++
int MyObjectDoProgressUpdateWith (void *myObjectInstance, int parameter,std::string str);
int MyObjectDoInformTheCompletion (void *myObjectInstance );
#endif
