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

        }
            break;
    }

}

#pragma mark - Navigation

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    
    
}

@end
