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


-(void)displayDrugInfo:(NSMutableDictionary *)drug
{
    self.drugDisplayed = drug;
    
    [self.textFieldDrugName setStringValue:[HandyRoutines stringFromStringTakingAccountOfNull: [drug objectForKey:kKey_DrugDisplayName]]];
    [[self.textViewDrugDescription textStorage] setAttributedString:[HandyRoutines attributedStringFromDescriptionData:[drug objectForKey:kKey_DrugInfoDescription]]];

}


-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    
    
}

@end
