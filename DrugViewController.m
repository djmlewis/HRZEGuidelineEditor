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
}

#pragma mark - NSTextFieldDelegate
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    if ([control.identifier isEqualToString:@"textFieldDrugName"] && (fieldEditor.string.length == 0))
    {
        return NO;
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


- (IBAction)settingsChanged:(id)sender {
    [self alignDrugWithView];
}

-(void)saveGuideline
{
    [self.myIndicationEditViewController saveGuideline];
}

#pragma mark - Calculation Fields

- (IBAction)checkBoxAllowDosageAdjustmentChanged:(NSButton *)sender
{
    self.containerViewAdjustDosage.hidden = (sender.state == NSOffState);
    [self alignDrugWithView];
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
    self.containerViewAdjustDosage.hidden = YES;
    [self.segmentRoundingDirection setSelectedSegment:0];
    //single
    [self.textFieldSingleDosagedescription setStringValue:@""];
    //thresh
    [self.textFieldThresholdMinimumWeightAllowed setStringValue:@""];
    
    
}

-(void)alignDrugWithView
{
    
    [self.drugDisplayed setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldDrugName.stringValue] forKey:kKey_DrugDisplayName];
    [self.drugDisplayed setObject:[HandyRoutines dataForDescriptionAttributedString:self.textViewDrugDescription.attributedString]  forKey:kKey_DrugInfoDescription];
    
    switch ([self.tabViewCalculationType indexOfTabViewItem:[self.tabViewCalculationType selectedTabViewItem]])
    {
        case 0:
            [self.drugDisplayed setObject:[NSNumber numberWithInteger:kDoseCalculationBy_MgKg] forKey:kKey_DoseCalculationType];
            
            [self.drugDisplayed setObject:[NSNumber numberWithInteger:self.textFieldmgkgDoseage.integerValue] forKey:kKey_DosageMgKg];
            [self.drugDisplayed setObject:[NSNumber numberWithInteger:self.textFieldMaximumFinalDose.integerValue] forKey:kKey_MaxDose];

            [self.drugDisplayed setObject:[NSNumber numberWithInteger:self.segmentRoundingDirection.selectedSegment] forKey:kKey_RoundingUpDown];
            [self.drugDisplayed setObject:[NSNumber numberWithInteger:self.textFieldRoundingValue.integerValue] forKey:kKey_ValueOfRounding];

            if (self.checkboxAllowAdjustment.state == NSOnState) {
                [self.drugDisplayed setObject:[NSNumber numberWithInteger:kDoseCalculationBy_MgKg_Adjustable] forKey:kKey_DoseCalculationType];

                [self.drugDisplayed setObject:[NSNumber numberWithInteger:self.textFieldMaxDosage.integerValue] forKey:kKey_DosageMgKgMaximum];
                [self.drugDisplayed setObject:[NSNumber numberWithInteger:self.textFieldMinDosage.integerValue] forKey:kKey_DosageMgKgMinimum];

            }
            
            break;
        case 1:
        {
            [self.drugDisplayed setObject:[NSNumber numberWithInteger:kDoseCalculationBy_Threshold] forKey:kKey_DoseCalculationType];
            [self.drugDisplayed setObject:[NSNumber numberWithInteger:self.textFieldThresholdMinimumWeightAllowed.integerValue] forKey:kKey_Threshold_MinWeight];
            [self reloadTableViewSavingSelection:YES];
        }
            break;
        case 2:
        {
            [self.drugDisplayed setObject:[NSNumber numberWithInteger:kDoseCalculationBy_SingleDose] forKey:kKey_DoseCalculationType];
            [self.drugDisplayed setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldmgkgDoseage.stringValue] forKey:kKey_SingleDoseInstructions];

        }
            break;
    }
    
    [self saveGuideline];
    
}

-(void)alignViewWithDrug:(NSMutableDictionary *)drug
{
    self.drugDisplayed = drug;
    
    [self.textFieldDrugName setStringValue:[HandyRoutines stringFromStringTakingAccountOfNull: [drug objectForKey:kKey_DrugDisplayName]]];
    [[self.textViewDrugDescription textStorage] setAttributedString:[HandyRoutines attributedStringFromDescriptionData:[drug objectForKey:kKey_DrugInfoDescription]]];

    [self zeroTheCalculationFields];
    
    NSInteger calcType = [[self.drugDisplayed objectForKey:kKey_DoseCalculationType] integerValue];
    switch (calcType)
    {
        case kDoseCalculationBy_MgKg:
        case kDoseCalculationBy_MgKg_Adjustable:
            [self.tabViewCalculationType selectTabViewItemAtIndex:0];
            [self.textFieldmgkgDoseage setIntegerValue:[[drug objectForKey:kKey_DosageMgKg] integerValue]];
            [self.textFieldMaximumFinalDose setIntegerValue:[[drug objectForKey:kKey_MaxDose] integerValue]];
            [self.segmentRoundingDirection setSelectedSegment:[[self.drugDisplayed objectForKey:kKey_RoundingUpDown] integerValue]];
            [self.textFieldRoundingValue setIntegerValue:[[drug objectForKey:kKey_ValueOfRounding] integerValue]];
            
            if (calcType == kDoseCalculationBy_MgKg_Adjustable) {
                [self.checkboxAllowAdjustment setState:NSOnState];
                self.containerViewAdjustDosage.hidden = NO;
                [self.textFieldMaxDosage setIntegerValue:[[drug objectForKey:kKey_DosageMgKgMaximum] integerValue]];
                [self.textFieldMinDosage setIntegerValue:[[drug objectForKey:kKey_DosageMgKgMinimum] integerValue]];
            }

            break;
        case kDoseCalculationBy_Threshold:
        {
            [self.tabViewCalculationType selectTabViewItemAtIndex:1];
            [self.textFieldThresholdMinimumWeightAllowed  setIntegerValue:[[drug objectForKey:kKey_Threshold_MinWeight] integerValue]];
            [self reloadTableViewSavingSelection:NO];
        }
            break;
        case kDoseCalculationBy_SingleDose:
        {
            [self.tabViewCalculationType selectTabViewItemAtIndex:2];
            [self.textFieldmgkgDoseage setStringValue:[[drug objectForKey:kKey_SingleDoseInstructions] stringValue]];
        }
            break;
    }

}


#pragma mark - TableView DataSource & Delegate

-(void)reloadTableViewSavingSelection:(BOOL)saveSelection
{
    NSInteger row = [self.tableViewThresholds selectedRow];
    [self forceUpdateOfThresholdCells];
    [self.tableViewThresholds reloadData];
    if (saveSelection &&  row>=0) {
        [self.tableViewThresholds selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    if ([aTableView.identifier isEqualToString:@"tableViewThresholds"]) {
        NSInteger count=0;
        if ((NSMutableArray *)[self.drugDisplayed objectForKey:kKey_Threshold_Booleans])
            count=[(NSMutableArray *)[self.drugDisplayed objectForKey:kKey_Threshold_Booleans] count];
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
        [result setupCellFromDrugEditingViewController:self forArrayRow:row];
        return result;
    }
    return [[NSView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 1.0f, 1.0f)];
}

#pragma mark - Row Updating

- (void)tableView:(NSTableView *)tableView  didRemoveRowView:(NSTableRowView *)rowView  forRow:(NSInteger)row
{
    if ([tableView.identifier isEqualToString:@"tableViewThresholds"]) {
        if (row != -1 //being moved off screen and not deleted
            && row<[(NSMutableArray *)[self.drugDisplayed objectForKey:kKey_Threshold_Booleans] count]) {
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

#pragma mark - Navigation

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    
    
}

@end
