//
//  IndicationEditViewController.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 03/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "IndicationEditViewController.h"
#import "PrefixHeader.pch"
#import "HandyRoutines.h"


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
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor lightGrayColor].CGColor;
}


-(void)updateIndicationDisplayForIndication:(NSMutableDictionary *)indication
{
    //first take on board any changes
    [self updateIndicationFromView];
    
    
    self.indicationBeingDisplayed = indication;
    self.arrayDrugsInIndication = [indication objectForKey:kKey_ArrayOfDrugs];
    [self correctForNilObjects];
    [self.browserDrugs reloadColumn:0];
    [self.textFieldIndicationName setStringValue:[indication objectForKey:kKey_IndicationName]];
    [self.textFieldDosingInstructions setStringValue:[indication objectForKey:kKey_IndicationDosingInstructions]];
    [[self.textViewIndicationComments textStorage] setAttributedString:[HandyRoutines attributedStringFromDescriptionData:[indication objectForKey:kKey_IndicationComments]]];
    [self.checkBoxHideComments setState:[[indication objectForKey:kKey_Indication_HideComments] boolValue]];
}

-(void)updateIndicationFromView
{
    [self.indicationBeingDisplayed setObject:self.arrayDrugsInIndication forKey:kKey_ArrayOfDrugs];
    [self.indicationBeingDisplayed setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldIndicationName.stringValue] forKey:kKey_IndicationName];
    [self.indicationBeingDisplayed setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldDosingInstructions.stringValue] forKey:kKey_IndicationDosingInstructions];
    [self.indicationBeingDisplayed setObject:[HandyRoutines dataForDescriptionAttributedString:self.textViewIndicationComments.attributedString] forKey:kKey_IndicationComments];
    [self.indicationBeingDisplayed setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldDosingInstructions.stringValue] forKey:kKey_IndicationDosingInstructions];
    [self.indicationBeingDisplayed setObject:[NSNumber numberWithBool:self.checkBoxHideComments.state] forKey:kKey_Indication_HideComments];
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
