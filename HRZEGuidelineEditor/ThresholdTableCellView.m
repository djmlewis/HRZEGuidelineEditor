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
    if (self.allowUpdatesFromView)
    {
        [self.threshold setObject:[NSNumber numberWithInteger:self.textFieldThresholdWeight.integerValue] forKey:kKey_Threshold_Weights];
        [self.threshold setObject:[NSNumber numberWithInteger:self.segmentThresholdBoolean.selectedSegment] forKey:kKey_Threshold_Booleans];
        [self.threshold setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldThresholdDose.stringValue] forKey:kKey_Threshold_doses];
        [self.threshold setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldThresholdDosageForm.stringValue] forKey:kKey_Threshold_DoseForms];
        
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

-(void)setupCellFromDrugEditingViewController:(DrugViewController *)theDrugEditingViewController withThreshold:(NSMutableDictionary *)threshold
{
    self.allowUpdatesFromView = NO;
    self.myDrugEditingViewController = theDrugEditingViewController;
    self.threshold = threshold;
    [self zeroThresholdFields];
    [self.textFieldThresholdWeight setIntegerValue:[(NSNumber *)[threshold objectForKey:kKey_Threshold_Weights] integerValue]];
    [self.textFieldThresholdDose setStringValue:[threshold objectForKey:kKey_Threshold_doses]];
    [self.textFieldThresholdDosageForm setStringValue:[threshold objectForKey:kKey_Threshold_DoseForms]];
    [self.segmentThresholdBoolean setSelectedSegment:[(NSNumber *)[threshold objectForKey:kKey_Threshold_Booleans] integerValue]];
    self.allowUpdatesFromView = YES;

}

#pragma mark - NSTextFieldDelegate
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    [self alignThresholdWithView];
    
    return YES;
}


@end
