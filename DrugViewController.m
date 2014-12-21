//
//  DrugEditingViewController.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 04/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "DrugViewController.h"
#import "IndicationViewController.h"
#import "PrefixHeader.pch"
#import "HandyRoutines.h"
#import "ThresholdTableCellView.h"


@interface DrugViewController ()

@end

@implementation DrugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.allowUpdatesFromView = YES;
}

-(void)saveGuideline
{
    [self.myIndicationEditViewController saveGuideline];
}

-(void)viewWillAppear
{
    [super viewWillAppear];
    self.tabViewCalculationType.layer.backgroundColor = [[NSColor clearColor] CGColor];
    self.view.layer.backgroundColor = [[NSColor blackColor] CGColor];//[[NSColor colorWithCalibratedWhite:0.85f alpha:1.0f] CGColor];
    self.frameView.layer.backgroundColor = [[NSColor colorWithCalibratedWhite:0.90f alpha:1.0f] CGColor];
    //[[NSColor colorWithCalibratedRed:1.0f green:1.0f blue:240.0f/255.0f alpha:1.0f] CGColor];
}

#pragma mark - NSTextFieldDelegate
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    if ([control.identifier isEqualToString:@"textFieldDrugName"])
    {
        if ((fieldEditor.string.length == 0))
        {
            return NO;
        }
        [self.myIndicationEditViewController reloadTableViewSavingSelection:YES];
    }
    [self alignDrugWithView];
    return YES;
}

#pragma mark - NSTextViewdelegate
- (void)textDidEndEditing:(NSNotification *)notification
{
    [self alignDrugWithView];
}

- (void)textViewDidChangeTypingAttributes:(NSNotification *)aNotification
{
    [self alignDrugWithView];
}

#pragma mark - IBAction

- (IBAction)settingsChanged:(id)sender {
    [self alignDrugWithView];
}

- (IBAction)checkBoxAllowDosageAdjustmentChanged:(NSButton *)sender
{
    [self visibilityOfAdjustDoseFieldsIsHidden:(sender.state == NSOffState)];
    [self alignDrugWithView];
}

- (IBAction)popupCalculationTypeChanges:(NSPopUpButton *)sender {
    [self.tabViewCalculationType selectTabViewItemAtIndex:self.popupButtonCalculationType.indexOfSelectedItem];
    [self alignDrugWithView];
}

#pragma mark - Calculation Fields

-(void)visibilityOfAdjustDoseFieldsIsHidden:(BOOL)hidden
{
    self.textFieldLabelMaxMgKg.hidden = hidden;
    self.textFieldLabelMinMgKg.hidden = hidden;
    self.textFieldMaxDosage.hidden = hidden;
    self.textFieldMinDosage.hidden = hidden;
}

-(void)zeroTheCalculationFields
{
    //mg/kg
    [self.textFieldmgkgDoseage setStringValue:@""];
    [self.textFieldMaxDosage setStringValue:@""];
    [self.textFieldMinDosage setStringValue:@""];
    [self.textFieldMaximumFinalDose setStringValue:@""];
    [self.textFieldRoundingValue setStringValue:@""];
    [self.checkboxAllowAdjustment setState:NSOffState];
    [self visibilityOfAdjustDoseFieldsIsHidden:YES];
    [self.segmentRoundingDirection setSelectedSegment:0];
    //single
    [self.textFieldSingleDosagedescription setStringValue:@""];
    //thresh
    [self.textFieldThresholdMinimumWeightAllowed setStringValue:@""];
    
    
}

-(void)alignDrugWithViewAsSelectionIsChanging
{
    [self alignDrugWithView];
}

-(void)alignDrugWithView
{
    if (self.allowUpdatesFromView)
    {
        self.allowUpdatesFromView = NO;

        [self.drugInPlay setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldDrugName.stringValue] forKey:kKey_DrugDisplayName];
        [self.drugInPlay setObject:[HandyRoutines dataForDescriptionAttributedString:self.textViewDrugDescription.attributedString]  forKey:kKey_DrugInfoDescription];
        [self.drugInPlay setObject:[NSNumber numberWithBool:self.checkboxShowDrugInList.state] forKey:kKey_DrugShowInList];

        NSInteger calc = [self.popupButtonCalculationType indexOfSelectedItem];
        switch (calc)
        {
            case 0:
                [self.drugInPlay setObject:[NSNumber numberWithInteger:kDoseCalculationBy_MgKg] forKey:kKey_DoseCalculationType];
                
                [self.drugInPlay setObject:[NSNumber numberWithInteger:self.textFieldmgkgDoseage.integerValue] forKey:kKey_DosageMgKg];
                [self.drugInPlay setObject:[NSNumber numberWithInteger:self.textFieldMaximumFinalDose.integerValue] forKey:kKey_MaxDose];
                
                [self.drugInPlay setObject:[NSNumber numberWithInteger:self.segmentRoundingDirection.selectedSegment] forKey:kKey_RoundingUpDown];
                [self.drugInPlay setObject:[NSNumber numberWithInteger:self.textFieldRoundingValue.integerValue] forKey:kKey_ValueOfRounding];
                
                if (self.checkboxAllowAdjustment.state == NSOnState)
                {
                    [self.drugInPlay setObject:[NSNumber numberWithInteger:kDoseCalculationBy_MgKg_Adjustable] forKey:kKey_DoseCalculationType];
                    
                    [self.drugInPlay setObject:[NSNumber numberWithInteger:self.textFieldMaxDosage.integerValue] forKey:kKey_DosageMgKgMaximum];
                    [self.drugInPlay setObject:[NSNumber numberWithInteger:self.textFieldMinDosage.integerValue] forKey:kKey_DosageMgKgMinimum];
                    
                }
                
                break;
            case 1:
            {
                [self.drugInPlay setObject:[NSNumber numberWithInteger:kDoseCalculationBy_Threshold] forKey:kKey_DoseCalculationType];
                [self.drugInPlay setObject:[NSNumber numberWithInteger:self.textFieldThresholdMinimumWeightAllowed.integerValue] forKey:kKey_Threshold_MinWeight];
                [self addArrayForThresholdsIfNeeded];
                [self reloadTableViewSavingSelection:YES];
            }
                break;
            case 2:
            {
                [self.drugInPlay setObject:[NSNumber numberWithInteger:kDoseCalculationBy_SingleDose] forKey:kKey_DoseCalculationType];
                [self.drugInPlay setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldSingleDosagedescription.stringValue] forKey:kKey_SingleDoseInstructions];
                
            }
                break;
        }
        [self saveGuideline];
        self.allowUpdatesFromView = YES;

    }
    
}

-(void)addArrayForThresholdsIfNeeded
{
    if ([self.drugInPlay objectForKey:kKey_Threshold_Array_Thresholds] == nil) {
        [self.drugInPlay setObject:[NSMutableArray array] forKey:kKey_Threshold_Array_Thresholds];
    }
}


-(void)alignViewWithDrug:(NSMutableDictionary *)drug
{
    self.drugInPlay = drug;
    [self addArrayForThresholdsIfNeeded];
    self.allowUpdatesFromView = NO;
    [self.textFieldDrugName setStringValue:[HandyRoutines stringFromStringTakingAccountOfNull: [drug objectForKey:kKey_DrugDisplayName]]];
    [[self.textViewDrugDescription textStorage] setAttributedString:[HandyRoutines attributedStringFromDescriptionData:[drug objectForKey:kKey_DrugInfoDescription]]];
    [self.checkboxShowDrugInList setState:[(NSNumber *)[drug objectForKey:kKey_DrugShowInList] boolValue]];

    [self zeroTheCalculationFields];
    
    NSInteger calcType = [[self.drugInPlay objectForKey:kKey_DoseCalculationType] integerValue];
    
    switch (calcType)
    {
        case kDoseCalculationBy_MgKg:
        case kDoseCalculationBy_MgKg_Adjustable:
            [self.tabViewCalculationType selectTabViewItemAtIndex:0];
            [self.popupButtonCalculationType selectItemAtIndex:0];
            [self.checkboxAllowAdjustment setState:NSOffState];
           [self.textFieldmgkgDoseage setIntegerValue:[[drug objectForKey:kKey_DosageMgKg] integerValue]];
            [self.textFieldMaximumFinalDose setIntegerValue:[[drug objectForKey:kKey_MaxDose] integerValue]];
            [self.segmentRoundingDirection setSelectedSegment:[[self.drugInPlay objectForKey:kKey_RoundingUpDown] integerValue]];
            [self.textFieldRoundingValue setIntegerValue:[[drug objectForKey:kKey_ValueOfRounding] integerValue]];
            
            if (calcType == kDoseCalculationBy_MgKg_Adjustable) {
                [self.checkboxAllowAdjustment setState:NSOnState];
                [self visibilityOfAdjustDoseFieldsIsHidden:NO];
                [self.textFieldMaxDosage setIntegerValue:[[drug objectForKey:kKey_DosageMgKgMaximum] integerValue]];
                [self.textFieldMinDosage setIntegerValue:[[drug objectForKey:kKey_DosageMgKgMinimum] integerValue]];
            }
            
            break;
        case kDoseCalculationBy_Threshold:
        {
            [self.tabViewCalculationType selectTabViewItemAtIndex:1];
            [self.popupButtonCalculationType selectItemAtIndex:1];
            [self.textFieldThresholdMinimumWeightAllowed  setIntegerValue:[[drug objectForKey:kKey_Threshold_MinWeight] integerValue]];
            [self reloadTableViewSavingSelection:NO];
        }
            break;
        case kDoseCalculationBy_SingleDose:
        {
            [self.tabViewCalculationType selectTabViewItemAtIndex:2];
            [self.popupButtonCalculationType selectItemAtIndex:2];
            [self.textFieldSingleDosagedescription setStringValue:[HandyRoutines stringFromStringTakingAccountOfNull:[[drug objectForKey:kKey_SingleDoseInstructions] stringValue]]];
        }
            break;
    }
    self.allowUpdatesFromView = YES;
}


#pragma mark - TableView DataSource & Delegate

-(void)reloadTableViewSavingSelection:(BOOL)saveSelection
{
    NSInteger row = [self.tableViewThresholds selectedRow];
    [self.tableViewThresholds reloadData];
    if (saveSelection &&  row>=0) {
        [self.tableViewThresholds selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    if ([aTableView.identifier isEqualToString:@"tableViewThresholds"]) {
        NSInteger count=0;
        if ((NSMutableArray *)[self.drugInPlay objectForKey:kKey_Threshold_Array_Thresholds])
        {
            count=[(NSMutableArray *)[self.drugInPlay objectForKey:kKey_Threshold_Array_Thresholds] count];
        }
        else
        {
            [self addArrayForThresholdsIfNeeded];
        }
        return count;
    }
    return 0;
}


- (NSView *)tableView:(NSTableView *)tableView   viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
    
    if ([tableView.identifier isEqualToString:@"tableViewThresholds"]) {
        ThresholdTableCellView *result = (ThresholdTableCellView *)[tableView makeViewWithIdentifier:@"ThresholdTableCellView" owner:self];
        // Return the result
        [result setupCellFromDrugEditingViewController:self withThreshold:[(NSMutableArray *)[self.drugInPlay objectForKey:kKey_Threshold_Array_Thresholds] objectAtIndex:row]];
        return result;
    }
    return [[NSView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 1.0f, 1.0f)];
}

#pragma mark - Row Updating

- (void)tableView:(NSTableView *)tableView  didRemoveRowView:(NSTableRowView *)rowView  forRow:(NSInteger)row
{
    if ([tableView.identifier isEqualToString:@"tableViewThresholds"]) {
        if (row != -1 //being moved off screen and not deleted
            && row<[(NSMutableArray *)[self.drugInPlay objectForKey:kKey_Threshold_Array_Thresholds] count]) {
            [(ThresholdTableCellView *)[tableView viewAtColumn:0 row:row makeIfNecessary:NO] alignThresholdWithView];
        }
    }
}

-(void)forceUpdateOfThresholdCells
{
    [self.tableViewThresholds enumerateAvailableRowViewsUsingBlock:^(NSTableRowView *rowView, NSInteger row) {
        //[(ThresholdTableCellView *)[rowView viewAtColumn:0] alignThresholdWithView];
    }];
}

- (IBAction)segmentAddRemoveThresholdTapped:(NSSegmentedControl *)sender
{
    switch (sender.selectedSegment) {
        case 0:
            [self addNewThreshold];
            break;
        case 1:
        {
            [self deleteSelectedThreshold];
        }
            break;
    }
}

-(void)addNewThreshold
{
    NSMutableDictionary *threshold = [HandyRoutines newEmptyThreshold];
    [(NSMutableArray *)[self.drugInPlay objectForKey:kKey_Threshold_Array_Thresholds] addObject:threshold];
    [self reloadTableViewSavingSelection:NO];
    [self saveGuideline];
}

-(void)deleteSelectedThreshold
{
    NSInteger row = [self.tableViewThresholds selectedRow];
    if (row >=0 && row<[(NSMutableArray *)[self.drugInPlay objectForKey:kKey_Threshold_Array_Thresholds] count])
    {
        [(NSMutableArray *)[self.drugInPlay objectForKey:kKey_Threshold_Array_Thresholds] removeObjectAtIndex:row];
        [self reloadTableViewSavingSelection:NO];
        [self saveGuideline];
    }
}





#pragma mark - Navigation

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    
    
}

@end
