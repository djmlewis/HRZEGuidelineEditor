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

- (IBAction)checkBoxAlloDosageAdjustmentChanged:(NSButton *)sender
{
    self.containerViewAdjustDosage.hidden = (sender.state == NSOffState);
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
            [self.textFieldmgkgDoseage setStringValue:[[drug objectForKey:kKey_DosageMgKg] stringValue]];
            [self.textFieldMaximumFinalDose setStringValue:[[drug objectForKey:kKey_MaxDose] stringValue]];
            [self.textFieldRoundingValue setStringValue:[[drug objectForKey:kKey_ValueOfRounding] stringValue]];
            
            [self.checkboxAllowAdjustment setState:(calcType == kDoseCalculationBy_MgKg_Adjustable)];
            [self.segmentRoundingDirection setSelectedSegment:[[self.drugDisplayed objectForKey:kKey_RoundingUpDown] integerValue]];

            if (calcType == kDoseCalculationBy_MgKg_Adjustable) {
                [self.textFieldMaxDosage setStringValue:[[drug objectForKey:kKey_DosageMgKgMaximum] stringValue]];
                [self.textFieldMinDosage setStringValue:[[drug objectForKey:kKey_DosageMgKgMinimum] stringValue]];
            }

            break;
        case kDoseCalculationBy_Threshold:
        {
            [self.tabViewCalculationType selectTabViewItemAtIndex:1];
            [self.textFieldmgkgDoseage setStringValue:[[drug objectForKey:kKey_Threshold_MinWeight] stringValue]];
            self.arrayThresholdBooleans = (NSMutableArray *)[drug objectForKey:kKey_Threshold_Booleans];
            self.arrayThresholdWeights = (NSMutableArray *)[drug objectForKey:kKey_Threshold_values];
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
    [self.tableViewThresholds reloadData];
    if (saveSelection &&  row>=0) {
        [self.tableViewThresholds selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    NSInteger count=0;
    if (self.arrayThresholdBooleans)
        count=[self.arrayThresholdBooleans count];
    return count;
}


- (NSView *)tableView:(NSTableView *)tableView   viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
    ThresholdTableCellView *result = (ThresholdTableCellView *)[tableView makeViewWithIdentifier:@"ThresholdTableCellView" owner:self];
    [result.textFieldThresholdWeight setStringValue:[(NSNumber *)[self.arrayThresholdWeights objectAtIndex:row] stringValue]];
    [result.textFieldThresholdDose setStringValue:[self.arrayThresholdDoses objectAtIndex:row]];
    [result.textFieldThresholdDosageForm setStringValue:[self.arrayThresholdDoseForms objectAtIndex:row]];
    [result.segmentThresholdBoolean setSelectedSegment:[(NSNumber *)[self.arrayThresholdBooleans objectAtIndex:row] integerValue]];
    // Return the result
    return result;
}




#pragma mark - Navigation

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    
    
}

@end
