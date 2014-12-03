//
//  IndicationEditViewController.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 03/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "IndicationEditViewController.h"
#import "PrefixHeader.pch"



@interface IndicationEditViewController ()

@end

@implementation IndicationEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
    [self correctForNilObjects];
}

-(void)correctForNilObjects
{
    if (self.arrayDrugsInIndication == nil)
    {
        self.arrayDrugsInIndication = [NSMutableArray array];
    }
    if (self.indicationBeingDisplayed == nil)
    {
        self.indicationBeingDisplayed = [NSMutableDictionary dictionary];
    }
}

-(void)viewWillAppear
{
    [super viewWillAppear];

}


-(void)updateIndicationDisplayForIndication:(NSMutableDictionary *)indication
{
    self.indicationBeingDisplayed = indication;
    self.arrayDrugsInIndication = [indication objectForKey:kKey_ArrayOfDrugs];
    [self correctForNilObjects];
    [self.browserDrugs reloadColumn:0];
    [self.textFieldIndicationName setStringValue:[indication objectForKey:kKey_IndicationName]];
    
}


#pragma mark - BrowserDelegate
// Non-item based API example. This code will work on all systems, but applications targeting SnowLeopard and higher should use the new item-based API.

- (NSInteger)browser:(NSBrowser *)sender numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return self.arrayDrugsInIndication.count;
    }
    return 0;
}

- (void)browser:(NSBrowser *)sender willDisplayCell:(NSBrowserCell *)cell atRow:(NSInteger)row column:(NSInteger)column {
    // Lazily setup the cell's properties in this method
    NSMutableDictionary *indicationDictAtRow = [self.arrayDrugsInIndication objectAtIndex:row];
    [cell setTitle: [indicationDictAtRow objectForKey:kKey_DrugDisplayName]];
    [cell setLeaf:YES];
}



@end
