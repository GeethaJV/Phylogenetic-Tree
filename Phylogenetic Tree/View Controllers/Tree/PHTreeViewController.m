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

typedef enum : NSUInteger {
    TreeTypeChart,
    TreeTypeCircular,
} TReeType;

@interface PHTreeViewController ()<UIAlertViewDelegate>{
    xmlTextReaderPtr xmlreader;
}
@property (nonatomic,strong) NSDictionary *newickDictionary;
@property (nonatomic,copy) NSString *pathOfHTMLFile;
@property (weak, nonatomic) IBOutlet UIWebView *treeViewerWebView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segmentControlTapped:(id)sender;

@end

@implementation PHTreeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isFromQuickPreview = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save File" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self parseData];
    [self generateHTMLFilefortType:TreeTypeChart];
   
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
    
    
    NSString *path = nil;
    
    if (self.isFromQuickPreview) {
         path = [NSString stringWithFormat:@"%@/%@",[PHUtility allignedXMLDirectory],self.xmlFileName];
    } else {
        self.xmlFileName = @"output.best.fas.best.xml";
        path = [NSString stringWithFormat:@"%@/%@",[PHUtility applicationTempDirectory],self.xmlFileName];
    }
    
    
    
    xmlTextReaderPtr reader = xmlReaderForFile([path cStringUsingEncoding:NSUTF8StringEncoding], "utf-8", (XML_PARSE_NOBLANKS | XML_PARSE_NOCDATA | XML_PARSE_NOERROR | XML_PARSE_NOWARNING));

    if (!reader) {
        NSLog(@"Failed to load xmlreader");
        return;
    }
    
    NSString *currentTagName = nil;
    NSString *currentTagValue = nil;
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
                    self.newickDictionary = [NSMutableDictionary new];
                }
                break;
            case XML_READER_TYPE_TEXT:

                temp = (char*)xmlTextReaderConstValue(reader);
                currentTagValue = [NSString stringWithCString:temp
                                                     encoding:NSUTF8StringEncoding];
                if (!self.newickDictionary) return;
                [self.newickDictionary setValue:currentTagValue forKey:currentTagName];
                currentTagValue = nil;
                currentTagName = nil;
                break;
            default: break;
        }
    }
}

- (void)generateHTMLFilefortType:(TReeType)treeType{
    
#if 0
    <html>
    <head>	<script type="text/javascript" src="raphael-min.js" ></script>
    <script type="text/javascript" src="jsphylosvg-min.js"></script>
    </head>
    <script type="text/javascript">
    window.onload = function(){
        var dataObject = { newick: '(((Espresso:2,(Milk Foam:2,Espresso Macchiato:5,((Steamed Milk:2,Cappuccino:2,(Whipped Cream:1,Chocolate Syrup:1,Cafe Mocha:3):5):5,Flat White:2):5):5):1,Coffee arabica:0.1,(Columbian:1.5,((Medium Roast:1,Viennese Roast:3,American Roast:5,Instant Coffee:9):2,Heavy Roast:0.1,French Roast:0.2,European Roast:1):5,Brazilian:0.1):1):1,Americano:10,Water:1);' };
        phylocanvas = new Smits.PhyloCanvas(
                                            dataObject,
                                            'svgCanvas',
                                            500, 500
                                            );
    };
    </script>
    <body>
    <div id="svgCanvas"> </div>
    </body>
    </html>
    
#endif
    
    NSString *newickString = [self.newickDictionary objectForKey:@"newick"];
    NSString *html = nil;
    
    if (treeType == TreeTypeCircular) {
        
       html =  [NSString stringWithFormat:@"<html> \n"
         "<head> \n"
         "<script type=\"text/javascript\" src=\"raphael-min.js\" ></script> \n"
         "<script type=\"text/javascript\" src=\"jsphylosvg-min.js\"></script> \n"
         "<script type=\"text/javascript\"> \n"
         "window.onload = function(){ \n"
         "var dataObject = { newick:'%@'}; \n"
         "phylocanvas = new Smits.PhyloCanvas(dataObject,'svgCanvas',%f, %f,'circular'); };\n"
         "</script> \n"
         "</body> \n"
         "<div id=\"svgCanvas\"> </div> \n"
         "</body> \n"
         "</html>",newickString,self.treeViewerWebView.frame.size.width,self.treeViewerWebView.frame.size.height];
    }else{
        
        html = [NSString stringWithFormat:@"<html> \n"
         "<head> \n"
         "<script type=\"text/javascript\" src=\"raphael-min.js\" ></script> \n"
         "<script type=\"text/javascript\" src=\"jsphylosvg-min.js\"></script> \n"
         "<script type=\"text/javascript\"> \n"
         "window.onload = function(){ \n"
         "var dataObject = { newick:'%@'}; \n"
         "phylocanvas = new Smits.PhyloCanvas(dataObject,'svgCanvas',%f, %f); };\n"
         "</script> \n"
         "</body> \n"
         "<div id=\"svgCanvas\"> </div> \n"
         "</body> \n"
         "</html>",newickString,self.treeViewerWebView.frame.size.width,self.treeViewerWebView.frame.size.height];
    }
    
    
    
    if(nil == self.pathOfHTMLFile){
        self.pathOfHTMLFile = [PHUtility CreateTreeDataSourceHTMLFilewithData: [html dataUsingEncoding:NSUTF8StringEncoding]];
    }else{
        [PHUtility RemoveHTMLTreeDataSource];
        self.pathOfHTMLFile = [PHUtility CreateTreeDataSourceHTMLFilewithData:[html dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSURL *urlis = [NSURL fileURLWithPath:self.pathOfHTMLFile];
    [self.treeViewerWebView loadRequest:[NSURLRequest requestWithURL:urlis]];
    
}
- (IBAction)segmentControlTapped:(UISegmentedControl *)sender {
    
    if( [sender selectedSegmentIndex] == 0){
        [self generateHTMLFilefortType:TreeTypeChart];
    } else {
        [self generateHTMLFilefortType:TreeTypeCircular];
    }
}

#pragma mark -
#pragma mark Save Button Action
- (void)saveButtonAction:(id)inSender{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Save output XML"
                                                       message:@"Give unique name without extension to Save the XML file for quick view of Graphs"
                                                      delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Save", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    NSString *nameOfFile = nil; NSString *extension = @".xml";
    
    if (buttonIndex == 1) {
        UITextField *nameTextField = [alertView textFieldAtIndex:0];
        
        
        if (nameTextField) {
            nameOfFile = nameTextField.text;
            
            if (nameOfFile.length != 0) {
                nameOfFile = [NSString stringWithFormat:@"%@%@",nameOfFile,extension];
            } else {
                nameOfFile = @"No Name.xml";
            }
        }
    } else {
        
    }

    if (nameOfFile != nil) {
        
        ;
        if (self.isFromQuickPreview){
            [PHUtility saveXMLFileofName:nameOfFile fromFileofPath:[NSString stringWithFormat:@"%@/%@",[PHUtility allignedXMLDirectory],self.xmlFileName]];
        } else {
            [PHUtility saveXMLFileofName:nameOfFile fromFileofPath:[NSString stringWithFormat:@"%@/output.best.fas.best.xml",[PHUtility applicationTempDirectory]]];
        }
        
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Reset Selection And Controls"
                                                       object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
