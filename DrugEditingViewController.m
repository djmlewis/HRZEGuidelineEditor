//
//  DrugEditingViewController.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 04/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "DrugEditingViewController.h"
#import "IndicationEditViewController.h"
#import "PrefixHeader.pch"
#import "HandyRoutines.h"
#import "ThresholdTableCellView.h"


@interface DrugEditingViewController ()

@end

@implementation DrugEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    if (self.drugDisplayed == nil) {
        self.drugDisplayed = [NSMutableDictionary dictionary];
    }
}


#pragma mark - Calculation Fields

- (IBAction)checkBoxAllowDosageAdjustmentChanged:(NSButton *)sender
{
    self.containerViewAdjustDosage.hidden = (sender.state == NSOffState);
    [self updateDrugFromViewAndUpdateCallingIndication:YES];
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
    self.arrayThresholdBooleans = [NSMutableArray array];
    self.arrayThresholdWeights = [NSMutableArray array];
    self.arrayThresholdDoses = [NSMutableArray array];
    self.arrayThresholdDoseForms = [NSMutableArray array];
    
    
}

-(void)updateDrugFromViewAndUpdateCallingIndication:(BOOL)updateCallingIndication
{
    //clean it out --
    [self.drugDisplayed removeAllObjects];
    
    [self.drugDisplayed setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldDrugName.stringValue] forKey:kKey_DrugDisplayName];
    [self.drugDisplayed setObject:[HandyRoutines dataForDescriptionAttributedString:self.textViewDrugDescription.attributedString]  forKey:kKey_DrugInfoDescription];
    
    NSInteger calcType = [self.tabViewCalculationType indexOfTabViewItem:[self.tabViewCalculationType selectedTabViewItem]];
    switch (calcType)
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
            [self.drugDisplayed setObject:[HandyRoutines arrayTakingAccountOfNullFromArray:self.arrayThresholdBooleans] forKey:kKey_Threshold_Booleans];
            [self.drugDisplayed setObject:[HandyRoutines arrayTakingAccountOfNullFromArray:self.arrayThresholdWeights] forKey:kKey_Threshold_Weights];
            [self.drugDisplayed setObject:[HandyRoutines arrayTakingAccountOfNullFromArray:self.arrayThresholdDoses] forKey:kKey_Threshold_doses];
            [self.drugDisplayed setObject:[HandyRoutines arrayTakingAccountOfNullFromArray:self.arrayThresholdDoseForms] forKey:kKey_Threshold_DoseForms];

        }
            break;
        case 2:
        {
            [self.drugDisplayed setObject:[NSNumber numberWithInteger:kDoseCalculationBy_SingleDose] forKey:kKey_DoseCalculationType];
            [self.drugDisplayed setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldmgkgDoseage.stringValue] forKey:kKey_SingleDoseInstructions];

        }
            break;
    }
    
    if (updateCallingIndication) {
        [self.myIndicationEditViewController updateIndicationFromView];
    }
    
}

-(void)displayDrugInfo:(NSMutableDictionary *)drug
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
            self.arrayThresholdBooleans = (NSMutableArray *)[drug objectForKey:kKey_Threshold_Booleans];
            self.arrayThresholdWeights = (NSMutableArray *)[drug objectForKey:kKey_Threshold_Weights];
            self.arrayThresholdDoses = (NSMutableArray *)[drug objectForKey:kKey_Threshold_doses];
            self.arrayThresholdDoseForms = (NSMutableArray *)[drug objectForKey:kKey_Threshold_DoseForms];
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
        if (self.arrayThresholdBooleans)
            count=[self.arrayThresholdBooleans count];
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
        if (row != -1 && row<self.arrayThresholdBooleans.count) {
            [[tableView viewAtColumn:0 row:row makeIfNecessary:NO] updateDrugFromView];
        }
    }
}

-(void)forceUpdateOfThresholdCells
{
    [self.tableViewThresholds enumerateAvailableRowViewsUsingBlock:^(NSTableRowView *rowView, NSInteger row) {
        [(ThresholdTableCellView *)[rowView viewAtColumn:0] updateDrugFromView];
    }];
}

#pragma mark - Navigation

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    
    
}

@end
