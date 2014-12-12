//
//  ThresholdTableCellView.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 06/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "ThresholdTableCellView.h"
#import "DrugViewController.h"
#import "HandyRoutines.h"
#import "PrefixHeader.pch"

@implementation ThresholdTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (IBAction)settingsHaveChanged:(id)sender
{
    [self alignThresholdWithView];
}

-(void)alignThresholdWithView
{
    if (self.callingRow<[(NSMutableArray *)[self.myDrugEditingViewController.drugDisplayed objectForKey:kKey_Threshold_Booleans] count]) {
        [(NSMutableArray *)[self.myDrugEditingViewController.drugDisplayed objectForKey:kKey_Threshold_Booleans] replaceObjectAtIndex:self.callingRow withObject:[NSNumber numberWithInteger:self.segmentThresholdBoolean.selectedSegment]];
        [(NSMutableArray *)[self.myDrugEditingViewController.drugDisplayed objectForKey:kKey_Threshold_DoseForms] replaceObjectAtIndex:self.callingRow withObject:[HandyRoutines stringFromStringTakingAccountOfNull:[self.textFieldThresholdDosageForm stringValue]]];
        [(NSMutableArray *)[self.myDrugEditingViewController.drugDisplayed objectForKey:kKey_Threshold_doses] replaceObjectAtIndex:self.callingRow withObject:[HandyRoutines stringFromStringTakingAccountOfNull:[self.textFieldThresholdDose stringValue]]];
        [(NSMutableArray *)[self.myDrugEditingViewController.drugDisplayed objectForKey:kKey_Threshold_Weights] replaceObjectAtIndex:self.callingRow withObject:[NSNumber numberWithInteger:[self.textFieldThresholdWeight integerValue]]];
        
        [self.myDrugEditingViewController saveGuideline];
    }

}

-(void)zeroThresholdFields
{
    [self.textFieldThresholdDosageForm setStringValue:@""];
    [self.textFieldThresholdDose setStringValue:@""];
    [self.textFieldThresholdWeight setStringValue:@""];
    [self.segmentThresholdBoolean setSelectedSegment:0];
    
}



-(void)setupCellFromDrugEditingViewController:(DrugViewController *)theDrugEditingViewController forArrayRow:(NSInteger)arrayRow
{
    self.myDrugEditingViewController = theDrugEditingViewController;
    self.callingRow = arrayRow;
    [self zeroThresholdFields];
    
    [self.textFieldThresholdWeight setIntegerValue:[(NSNumber *)[(NSMutableArray *)[self.myDrugEditingViewController.drugDisplayed objectForKey:kKey_Threshold_Weights] objectAtIndex:arrayRow] integerValue]];
    [self.textFieldThresholdDose setStringValue:[(NSMutableArray *)[self.myDrugEditingViewController.drugDisplayed objectForKey:kKey_Threshold_doses] objectAtIndex:arrayRow]];
    [self.textFieldThresholdDosageForm setStringValue:[(NSMutableArray *)[self.myDrugEditingViewController.drugDisplayed objectForKey:kKey_Threshold_DoseForms] objectAtIndex:arrayRow]];
    [self.segmentThresholdBoolean setSelectedSegment:[(NSNumber *)[(NSMutableArray *)[self.myDrugEditingViewController.drugDisplayed objectForKey:kKey_Threshold_Booleans] objectAtIndex:arrayRow] integerValue]];

}

#pragma mark - NSTextFieldDelegate
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    [self alignThresholdWithView];
    
    return YES;
}


@end
