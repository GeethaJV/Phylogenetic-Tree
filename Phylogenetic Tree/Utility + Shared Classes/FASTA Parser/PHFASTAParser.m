//
//  PHFASTAParser.m
//  Phylogenetic Tree
//
//  Created by Sid on 25/01/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import "PHFASTAParser.h"

@interface PHFASTAParser ()
//@property(strong,nonatomic) NSFileHandle *fastaFileHandle;
@end

@implementation PHFASTAParser



- (void)readALineOfFASTAFileContenforFileHandle:(NSFileHandle *)inReadFileHandle withCompletionBlock:(void (^)(NSData *sequenceData, NSUInteger length)) SequenceParser{
    
    NSData *sequunceData = [self readLineWithDelimiter:@"\n" andReadFileHandle:inReadFileHandle];
    SequenceParser(sequunceData,[sequunceData length]);
}

#if 0
- (void)readFASTAFilewithCompletionBlock:(void (^)(NSString *sequence, NSString *name, NSUInteger length)) SequenceParser{
    
    //unsigned long long currentPosition = [inFileHandle offsetInFile];
    
    NSData *firstLineData = [self readLineWithDelimiter:@"\n"];
    const char *buffer = [firstLineData bytes];
    if(buffer[0] != '>'){
        
        SequenceParser(nil,nil,-1);
    }else{
        //Looks to be valid format
        
        /* Parse out the name: the first non-whitespace token after the >
         */
        
        NSString *name = [[NSString alloc]initWithUTF8String:buffer];
        
       // NSArray *components = [firstLine componentsSeparatedByString:@" \t\n"];
        //NSLog(@"Array is %@",components);
        
        NSData *sequunceData = [self readLineWithDelimiter:@"\n"];
        NSMutableString *sequenceString = [[NSMutableString alloc] initWithData:sequunceData encoding:NSUTF8StringEncoding] ;
        NSInteger sequenceLength = [sequenceString length];
        
        while ([sequunceData length] >0) {
            sequunceData = [self readLineWithDelimiter:@"\n"];
            
            NSString *lineSequence = [[NSString alloc] initWithData:sequunceData encoding:NSUTF8StringEncoding];
            [sequenceString  appendString:lineSequence];
            sequenceLength += [sequunceData length];
        }
        
       SequenceParser(sequenceString,name,sequenceLength);
    
    }
    
    
    
    
    
}
# endif
#pragma mark -
#pragma mark Private Methods
- (NSData *)readLineWithDelimiter:(NSString *)theDelimiter andReadFileHandle:(NSFileHandle *)inFileHandle
{
    NSUInteger bufferSize = 1024; // Set our buffer size
    
    // Read the delimiter string into a C string
    NSData *delimiterData = [theDelimiter dataUsingEncoding:NSASCIIStringEncoding];
    const char *delimiter = [delimiterData bytes];
    
    NSUInteger delimiterIndex = 0;
    
    NSData *lineData; // Our buffer of data
    
    unsigned long long currentPosition = [inFileHandle offsetInFile];
    NSUInteger positionOffset = 0;
    
    BOOL hasData = YES;
    BOOL lineBreakFound = NO;
    
    while (lineBreakFound == NO && hasData == YES)
    {
        // Fill our buffer with data
        lineData = [inFileHandle readDataOfLength:bufferSize];
        
        // If our buffer gets some data, proceed
        if ([lineData length] > 0)
        {
            // Get a pointer to our buffer's raw data
            const char *buffer = [lineData bytes];
            
            // Loop over the raw data, byte-by-byte
            for (int i = 0; i < [lineData length]; i++)
            {
                // If the current character matches a character in the delimiter sequence...
                if (buffer[i] == delimiter[delimiterIndex])
                {
                    delimiterIndex++; // Move to the next char of the delimiter sequence
                    
                    if (delimiterIndex >= [delimiterData length])
                    {
                        // If we've found all of the delimiter characters, break out of the loop
                        lineBreakFound = YES;
                        positionOffset += i + 1;
                        break;
                    }
                }
                else
                {
                    // Otherwise, reset the current delimiter character offset
                    delimiterIndex = 0;
                }
            }
            
            if (lineBreakFound == NO)
            {
                positionOffset += [lineData length];
            }
        }
        else
        {
            hasData = NO;
            break;
        }
    }
    
    // Use positionOffset to determine the string to return...
    
    // Return to the start of this line
    [inFileHandle seekToFileOffset:currentPosition];
    
    NSData *returnData = [inFileHandle readDataOfLength:positionOffset];
    
    if ([returnData length] > 0)
    {
       // [returnData retain];
        return returnData;
    }
    else
    {
        return nil;
    }
}


@end
