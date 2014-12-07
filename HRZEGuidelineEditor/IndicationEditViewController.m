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
#import "GuidelineDisplayingViewController.h"
#import "DrugEditingViewController.h"   



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
    [self reloadTableViewSavingSelection:NO];
    [self.textFieldIndicationName setStringValue:[HandyRoutines stringFromStringTakingAccountOfNull: [indication objectForKey:kKey_IndicationName]]];
    [self.textFieldDosingInstructions setStringValue:[HandyRoutines stringFromStringTakingAccountOfNull: [indication objectForKey:kKey_IndicationDosingInstructions]]];
    [[self.textViewIndicationComments textStorage] setAttributedString:[HandyRoutines attributedStringFromDescriptionData:[indication objectForKey:kKey_IndicationComments]]];
    [self.checkBoxHideComments setState:[[indication objectForKey:kKey_Indication_HideComments] boolValue]];
}

-(void)updateIndicationFromView
{
    [self.embeddedDrugEditingViewController updateDrugFromViewAndUpdateCallingIndication:NO];
    
    [self.indicationBeingDisplayed setObject:[HandyRoutines arrayTakingAccountOfNullFromArray:self.arrayDrugsInIndication] forKey:kKey_ArrayOfDrugs];
    [self.indicationBeingDisplayed setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldIndicationName.stringValue] forKey:kKey_IndicationName];
    [self.indicationBeingDisplayed setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldDosingInstructions.stringValue] forKey:kKey_IndicationDosingInstructions];
    [self.indicationBeingDisplayed setObject:[HandyRoutines dataForDescriptionAttributedString:self.textViewIndicationComments.attributedString] forKey:kKey_IndicationComments];
    [self.indicationBeingDisplayed setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldDosingInstructions.stringValue] forKey:kKey_IndicationDosingInstructions];
    [self.indicationBeingDisplayed setObject:[NSNumber numberWithBool:self.checkBoxHideComments.state] forKey:kKey_Indication_HideComments];
    
    [self.myGuidelineDisplayingViewController updateDocumentFromView];
}

#pragma mark - NSTextFieldDelegate
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    if ([control.identifier isEqualToString:@"textFieldIndicationName"])
    {
        if (fieldEditor.string.length == 0) {
            return NO;
        }
        [self.indicationBeingDisplayed setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldIndicationName.stringValue] forKey:kKey_IndicationName];
        [self.myGuidelineDisplayingViewController reloadTableViewSavingSelection:YES];
        return YES;
    }
    
    
    return YES;
}

#pragma mark - Drugs

- (IBAction)tableViewDrugsTapped:(NSTableView *)sender
{
    [self displayDrugInfoForRow:[sender selectedRow]];
}

-(void)displayDrugInfoForRow:(NSInteger)row
{
    if (row<self.arrayDrugsInIndication.count)
    {
        [self updateIndicationFromView];
        [self.embeddedDrugEditingViewController displayDrugInfo:[self.arrayDrugsInIndication objectAtIndex:row]];
        self.embeddedDrugEditingViewController.view.hidden = NO;
        [self reloadTableViewSavingSelection:YES];
    }
}

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedDrugEditVC"])
    {
        //comes first before we get a document
        self.embeddedDrugEditingViewController = (DrugEditingViewController *)segue.destinationController;
        self.embeddedDrugEditingViewController.myIndicationEditViewController = self;
        self.embeddedDrugEditingViewController.view.hidden = YES;
    }
    
    
}


#pragma mark - TableView DataSource & Delegate

-(void)reloadTableViewSavingSelection:(BOOL)saveSelection
{
    NSInteger row = [self.tableViewDrugs selectedRow];
    [self.tableViewDrugs reloadData];
    if (saveSelection &&  row>=0) {
        [self.tableViewDrugs selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    NSInteger count=0;
    if (self.arrayDrugsInIndication)
        count=[self.arrayDrugsInIndication count];
    return count;
}


- (NSView *)tableView:(NSTableView *)tableView   viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"drugs" owner:self];
    
    // Set the stringValue of the cell's text field to the nameArray value at row
    NSMutableDictionary *indicationDictAtRow = [self.arrayDrugsInIndication objectAtIndex:row];
    result.textField.stringValue = [HandyRoutines stringFromStringTakingAccountOfNull:[indicationDictAtRow objectForKey:kKey_DrugDisplayName]];
    
    // Return the result
    return result;
}


@end
