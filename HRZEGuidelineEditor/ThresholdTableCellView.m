//
//  ThresholdTableCellView.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 06/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "ThresholdTableCellView.h"
#import "DrugEditingViewController.h"
#import "HandyRoutines.h"


@implementation ThresholdTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (IBAction)settingsHaveChanged:(id)sender
{
    [self updateDrugFromView];
}

-(void)updateDrugFromView
{
    if (self.callingRow<self.myDrugEditingViewController.arrayThresholdBooleans.count) {
        [self.myDrugEditingViewController.arrayThresholdBooleans replaceObjectAtIndex:self.callingRow withObject:[NSNumber numberWithInteger:self.segmentThresholdBoolean.selectedSegment]];
        [self.myDrugEditingViewController.arrayThresholdDoseForms replaceObjectAtIndex:self.callingRow withObject:[HandyRoutines stringFromStringTakingAccountOfNull:[self.textFieldThresholdDosageForm stringValue]]];
        [self.myDrugEditingViewController.arrayThresholdDoses replaceObjectAtIndex:self.callingRow withObject:[HandyRoutines stringFromStringTakingAccountOfNull:[self.textFieldThresholdDose stringValue]]];
        [self.myDrugEditingViewController.arrayThresholdWeights replaceObjectAtIndex:self.callingRow withObject:[NSNumber numberWithInteger:[self.textFieldThresholdWeight integerValue]]];
        [self.myDrugEditingViewController updateDrugFromViewAndUpdateCallingIndication:YES];
    }

}

-(void)zeroTheCalculationFields
{
    [self.textFieldThresholdDosageForm setStringValue:@""];
    [self.textFieldThresholdDose setStringValue:@""];
    [self.textFieldThresholdWeight setStringValue:@""];
    [self.segmentThresholdBoolean setSelectedSegment:0];
    
}



-(void)setupCellFromDrugEditingViewController:(DrugEditingViewController *)theDrugEditingViewController forArrayRow:(NSInteger)arrayRow
{
    self.myDrugEditingViewController = theDrugEditingViewController;
    self.callingRow = arrayRow;
    [self zeroTheCalculationFields];
    
    [self.textFieldThresholdWeight setIntegerValue:[(NSNumber *)[self.myDrugEditingViewController.arrayThresholdWeights objectAtIndex:arrayRow] integerValue]];
    [self.textFieldThresholdDose setStringValue:[self.myDrugEditingViewController.arrayThresholdDoses objectAtIndex:arrayRow]];
    [self.textFieldThresholdDosageForm setStringValue:[self.myDrugEditingViewController.arrayThresholdDoseForms objectAtIndex:arrayRow]];
    [self.segmentThresholdBoolean setSelectedSegment:[(NSNumber *)[self.myDrugEditingViewController.arrayThresholdBooleans objectAtIndex:arrayRow] integerValue]];

}

#pragma mark - NSTextFieldDelegate
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    [self updateDrugFromView];
    
    return YES;
}


@end
