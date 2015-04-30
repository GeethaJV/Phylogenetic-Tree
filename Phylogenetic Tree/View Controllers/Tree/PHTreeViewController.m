//
//  PHTreeViewController.m
//  Phylogenetic Tree
//
//  Created by Siddalingamurthy Gangadharappa on 29/04/15.
//  Copyright (c) 2015 Adroit. All rights reserved.
//

#import "PHTreeViewController.h"
#import "PHUtility.h"
#import <libxml/xmlreader.h>

@interface PHTreeViewController (){
    xmlTextReaderPtr xmlreader;
}
@property (nonatomic,strong) NSString *xmlFileName;

@end

@implementation PHTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.xmlFileName = @"output.best.fas.best.xml";
    [self parseData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)parseData{
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",[PHUtility applicationTempDirectory],self.xmlFileName];
    xmlTextReaderPtr reader = xmlReaderForFile([path cStringUsingEncoding:NSUTF8StringEncoding], "utf-8", (XML_PARSE_NOBLANKS | XML_PARSE_NOCDATA | XML_PARSE_NOERROR | XML_PARSE_NOWARNING));

    if (!reader) {
        NSLog(@"Failed to load xmlreader");
        return;
    }
    
    NSString *currentTagName = nil;
    NSString *currentTagValue = nil;
    NSDictionary *newickDict = nil;
    char* temp;
    while (true) {
        if (!xmlTextReaderRead(reader)) break;
        switch (xmlTextReaderNodeType(reader)) {
            case XML_READER_TYPE_ELEMENT:
                //We are starting an element
                temp =  (char*)xmlTextReaderConstName(reader);
                currentTagName = [NSString stringWithCString:temp
                                                    encoding:NSUTF8StringEncoding];
                if ([currentTagName isEqualToString:@"newick"]) {
                    newickDict = [NSMutableDictionary dictionary];
                }
                break;
            case XML_READER_TYPE_TEXT:

                temp = (char*)xmlTextReaderConstValue(reader);
                currentTagValue = [NSString stringWithCString:temp
                                                     encoding:NSUTF8StringEncoding];
                if (!newickDict) return;
                [newickDict setValue:currentTagValue forKey:currentTagName];
                currentTagValue = nil;
                currentTagName = nil;
                break;
            default: break;
        }
    }
}
@end
