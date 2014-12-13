//
//  IndicationEditViewController.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 03/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "IndicationViewController.h"
#import "PrefixHeader.pch"
#import "HandyRoutines.h"
#import "GuidelineViewController.h"
#import "DrugViewController.h"   



@interface IndicationViewController ()

@end

@implementation IndicationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
    self.allowUpdatesFromView = YES;

}


-(void)viewWillAppear
{
    [super viewWillAppear];
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor lightGrayColor].CGColor;
}

-(void)saveGuideline
{
    [self.myGuidelineDisplayingViewController saveGuideline];
}


-(void)alignDisplayWithIndication:(NSMutableDictionary *)indication
{
    self.indicationInPlay = indication;
    self.allowUpdatesFromView = NO;
    [self reloadTableViewSavingSelection:NO];
    [self.textFieldIndicationName setStringValue:[HandyRoutines stringFromStringTakingAccountOfNull: [indication objectForKey:kKey_IndicationName]]];
    [self.textFieldDosingInstructions setStringValue:[HandyRoutines stringFromStringTakingAccountOfNull: [indication objectForKey:kKey_IndicationDosingInstructions]]];
    [[self.textViewIndicationComments textStorage] setAttributedString:[HandyRoutines attributedStringFromDescriptionData:[indication objectForKey:kKey_IndicationComments]]];
    [self.checkBoxHideComments setState:[[indication objectForKey:kKey_Indication_HideComments] boolValue]];
    self.allowUpdatesFromView = YES;
}

-(void)alignIndicationWithView
{
    if (self.allowUpdatesFromView)
    {
        self.allowUpdatesFromView = NO;
        [self.indicationInPlay setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldIndicationName.stringValue] forKey:kKey_IndicationName];
        [self.indicationInPlay setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldDosingInstructions.stringValue] forKey:kKey_IndicationDosingInstructions];
        [self.indicationInPlay setObject:[HandyRoutines dataForDescriptionAttributedString:self.textViewIndicationComments.attributedString] forKey:kKey_IndicationComments];
        [self.indicationInPlay setObject:[NSNumber numberWithBool:self.checkBoxHideComments.state] forKey:kKey_Indication_HideComments];
        
        [self saveGuideline];
        self.allowUpdatesFromView = YES;
    }

}

#pragma mark - NSTextFieldDelegate
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    if ([control.identifier isEqualToString:@"textFieldIndicationName"] && (fieldEditor.string.length == 0))
    {
            return NO;
    }
    [self alignIndicationWithView];
    return YES;
}

#pragma mark - NSTextViewdelegate
- (void)textDidEndEditing:(NSNotification *)notification
{
    [self alignIndicationWithView];
}

- (void)textViewDidChangeTypingAttributes:(NSNotification *)aNotification
{
    [self alignIndicationWithView];
}

#pragma mark - Drugs

- (IBAction)tableViewDrugsTapped:(NSTableView *)sender
{
    [self displayDrugInfoForRow:[sender selectedRow]];
}

-(void)displayDrugInfoForRow:(NSInteger)row
{
    if (row<[(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] count])
    {
        [self.embeddedDrugEditingViewController alignViewWithDrug:[(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] objectAtIndex:row]];
        self.embeddedDrugEditingViewController.view.hidden = NO;
        [self reloadTableViewSavingSelection:YES];
    }
}

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedDrugEditVC"])
    {
        //comes first before we get a document
        self.embeddedDrugEditingViewController = (DrugViewController *)segue.destinationController;
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
    if ((NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] != nil)
        count=[(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] count];
    return count;
}


- (NSView *)tableView:(NSTableView *)tableView   viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"drugs" owner:self];
    
    // Set the stringValue of the cell's text field to the nameArray value at row
    NSMutableDictionary *indicationDictAtRow = [(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] objectAtIndex:row];
    result.textField.stringValue = [HandyRoutines stringFromStringTakingAccountOfNull:[indicationDictAtRow objectForKey:kKey_DrugDisplayName]];
    
    // Return the result
    return result;
}


@end
