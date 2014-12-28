//
//  GuideLineTextGenerator.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 28/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "GuideLineTextGenerator.h"
#import "HandyRoutines.h"
#import "PrefixHeader.pch"





@implementation GuideLineTextGenerator

#pragma Mark - Generic
-(NSAttributedString *)astringForPlainText:(NSString *)name
{
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setHeadIndent:40.0f];
    [ps setFirstLineHeadIndent:40.0f];
    NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont systemFontOfSize:12.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName, nil];
    NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
    return astring;
}

-(NSAttributedString *)astringForPlainTextExtraIndent:(NSString *)name
{
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setHeadIndent:50.0f];
    [ps setFirstLineHeadIndent:50.0f];
    NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont systemFontOfSize:12.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName, nil];
    NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
    return astring;
}

-(NSAttributedString *)astringForSmallPlainText:(NSString *)name
{
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setHeadIndent:40.0f];
    [ps setFirstLineHeadIndent:40.0f];
    NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont systemFontOfSize:10.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName, nil];
    NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
    return astring;
}


#pragma Mark - Guideline


-(void)addStringForGuideline:(NSMutableArray *)arrayOfDescriptionLines
{
    [self addStringForGuidelineName:arrayOfDescriptionLines];
    [self addStringForGuidelineDescription:arrayOfDescriptionLines];
}

-(void)addStringForGuidelineName:(NSMutableArray *)arrayOfDescriptionLines
{
    if (self.guidelineName.length>0)
    {
        NSString *name = [NSString stringWithFormat:@"\n%@\n",self.guidelineName];
        NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSFont boldSystemFontOfSize:14.0f], NSFontAttributeName,
                                 nil];
        [arrayOfDescriptionLines addObject:[[NSAttributedString alloc] initWithString:name attributes:attribs]];
        
    }
}
-(void)addStringForGuidelineDescription:(NSMutableArray *)stringsArray
{
    if ([[[HandyRoutines attributedStringFromDescriptionData:[self.guideline objectForKey:kKey_GuidelineDescription]] string] length]>0) {
        NSMutableAttributedString *desc = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        [desc appendAttributedString:[HandyRoutines attributedStringFromDescriptionData:[self.guideline objectForKey:kKey_GuidelineDescription]]];
        [desc appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        [stringsArray addObject:desc];
    }
}

#pragma Mark - Indication
-(void)addStringForIndication:(NSMutableDictionary *)indication arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    [self addStringForIndicationName:indication arrayOfDescriptionLines:arrayOfDescriptionLines];
    [self addStringForIndicationDosingInstructions:indication arrayOfDescriptionLines:arrayOfDescriptionLines];
    [self addStringForIndicationComments:indication arrayOfDescriptionLines:arrayOfDescriptionLines];
}

-(void)addStringForIndicationName:(NSMutableDictionary *)indication arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    if ([[indication objectForKey:kKey_IndicationName] length]>0)
    {
        NSString *name = [NSString stringWithFormat:@"\n%@\n",[HandyRoutines stringFromStringTakingAccountOfNull:[indication objectForKey:kKey_IndicationName]]];
        NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSFont boldSystemFontOfSize:14.0f], NSFontAttributeName,
                                 [[HandyRoutines colourForHeaderInIndication:indication]CGColor], kCTForegroundColorAttributeName,
                                 nil];
        NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
        [arrayOfDescriptionLines addObject:astring];
    }
}

-(void)addStringForIndicationDosingInstructions:(NSMutableDictionary *)indication arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    if ([[indication objectForKey:kKey_IndicationDosingInstructions] length]>0)
    {
        NSString *name = [NSString stringWithFormat:@"%@\n",[HandyRoutines stringFromStringTakingAccountOfNull:[indication objectForKey:kKey_IndicationDosingInstructions]]];
        NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSFont systemFontOfSize:12.0f], NSFontAttributeName,
                                 nil];
        NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
        [arrayOfDescriptionLines addObject:astring];
    }
}

-(void)addStringForIndicationComments:(NSMutableDictionary *)indication arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    if ([[indication objectForKey:kKey_IndicationComments] length]>0)
    {
        NSString *initiHidden = @"(Comments initially hidden)";
        if ([[indication objectForKey:kKey_Indication_HideComments] boolValue] == NO) {
            initiHidden = @"(Comments initially shown)";
        }
        NSString *name = [NSString stringWithFormat:@"%@\n%@\n",[HandyRoutines stringFromStringTakingAccountOfNull:[indication objectForKey:kKey_IndicationComments]],initiHidden];
        NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSFont systemFontOfSize:10.0f], NSFontAttributeName,
                                 nil];
        NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
        [arrayOfDescriptionLines addObject:astring];
    }
}

#pragma Mark - Drug
-(void)addStringForDrugName:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    if ([[drug objectForKey:kKey_DrugDisplayName] length]>0)
    {
        NSString *name = [NSString stringWithFormat:@"\n%@\n",[HandyRoutines stringFromStringTakingAccountOfNull:[drug objectForKey:kKey_DrugDisplayName]]];
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        [ps setHeadIndent:20.0f];
        [ps setFirstLineHeadIndent:20.0f];
        NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont boldSystemFontOfSize:12.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName, nil];
        NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
        [arrayOfDescriptionLines addObject:astring];
    }
}

-(void)addStringForDrug_MgKgDoseMaximumAndRounding:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    [arrayOfDescriptionLines addObject:[self astringForPlainText:[NSString stringWithFormat:@"Maximum recommended dose: %li %@\n",(long)[[drug objectForKey:kKey_MaxDose] integerValue],[drug objectForKey:kKey_DoseUnits]]]];
    
    [arrayOfDescriptionLines addObject:[self astringForPlainText:[NSString stringWithFormat:@"Round %@ to nearest %ld %@\n",[HandyRoutines roundingStringFromRoundUpDownValue:[drug objectForKey:kKey_RoundingUpDown]],(long)[[drug objectForKey:kKey_ValueOfRounding] integerValue],[drug objectForKey:kKey_DoseUnits]]]];
    
}
-(void)addStringForDrug_MgKgdose:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    [arrayOfDescriptionLines addObject:[self astringForPlainText:[NSString stringWithFormat:@"Dose @ %li %@/Kg\nDoes not allow adjustment of dose factor.\n",(long)[[drug objectForKey:kKey_DosageMgKg] integerValue],[drug objectForKey:kKey_DoseUnits]]]];
    [self addStringForDrug_MgKgDoseMaximumAndRounding:drug arrayOfDescriptionLines:arrayOfDescriptionLines];
}

-(void)addStringForDrug_MgKgdoseAdjustable:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    [arrayOfDescriptionLines addObject:[self astringForPlainText:[NSString stringWithFormat:@"Dose @ %li %@/Kg\nAllows adjustment of dose factor within range:\n",(long)[[drug objectForKey:kKey_DosageMgKg] integerValue],[drug objectForKey:kKey_DoseUnits]]]];
    [arrayOfDescriptionLines addObject:[self astringForPlainTextExtraIndent:[NSString stringWithFormat:@"Maximum: %li %@/Kg\n",(long)[[drug objectForKey:kKey_DosageMgKgMaximum] integerValue],[drug objectForKey:kKey_DoseUnits]]]];
    [arrayOfDescriptionLines addObject:[self astringForPlainTextExtraIndent:[NSString stringWithFormat:@"Minimum: %li %@/Kg\n",(long)[[drug objectForKey:kKey_DosageMgKgMinimum] integerValue],[drug objectForKey:kKey_DoseUnits]]]];
    [self addStringForDrug_MgKgDoseMaximumAndRounding:drug arrayOfDescriptionLines:arrayOfDescriptionLines];
}

-(NSAttributedString *)astringForDrugName:(NSString *)name
{
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setHeadIndent:20.0f];
    [ps setFirstLineHeadIndent:20.0f];
    NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont boldSystemFontOfSize:12.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName, nil];
    NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
    return astring;
}

#pragma Mark - Creation

-(NSMutableAttributedString *)createDescriptionFromGuideline
{
    NSMutableArray *arrayOfDescriptionLines = [NSMutableArray array];
    if (self.guideline != nil)
    {
        [self addStringForGuideline:arrayOfDescriptionLines];
        
        NSMutableArray *indications = (NSMutableArray *)[self.guideline objectForKey:kKey_GuidelineArrayOfIndications];
        for (NSMutableDictionary *indication in indications)
        {
            [self addStringForIndication:indication arrayOfDescriptionLines:arrayOfDescriptionLines];
            
            for (NSMutableDictionary *drug in [indication objectForKey:kKey_ArrayOfDrugs]) {
                [self addStringForDrugName:drug arrayOfDescriptionLines:arrayOfDescriptionLines];
                
                switch ([[drug objectForKey:kKey_DoseCalculationType] integerValue]) {
                    case kDoseCalculationBy_MgKg:
                        [self addStringForDrug_MgKgdose:drug arrayOfDescriptionLines:arrayOfDescriptionLines];
                        break;
                    case kDoseCalculationBy_MgKg_Adjustable:
                        [self addStringForDrug_MgKgdoseAdjustable:drug arrayOfDescriptionLines:arrayOfDescriptionLines];
                        break;
                    case kDoseCalculationBy_Threshold:
                    {
                        if ([[drug objectForKey:kKey_Threshold_MinWeight] integerValue]>1)
                        {
                            [arrayOfDescriptionLines addObject:[self astringForPlainText:[NSString stringWithFormat:@"Do not prescribe if body weight is < %@ Kg\n",[[drug objectForKey:kKey_Threshold_MinWeight] stringValue]]]];
                        }
                        else
                        {
                            [arrayOfDescriptionLines addObject:[self astringForPlainText:[NSString stringWithFormat:@"No minimum body weight restriction.\n"]]];
                        }
                        NSArray *thresholdsArray = (NSArray *)[drug objectForKey:kKey_Threshold_Array_Thresholds];
                        for (int i = 0; i<[thresholdsArray count]; i++)
                        {
                            NSMutableDictionary *threshold = [thresholdsArray objectAtIndex:i];
                            NSString *str = [NSString stringWithFormat:@"If body weight %@ %@ Kg: give %@ %@\n",
                                             [HandyRoutines predecateStringForPredicate:[threshold objectForKey:kKey_Threshold_Booleans]],
                                             [threshold objectForKey:kKey_Threshold_Weights],
                                             [threshold objectForKey:kKey_Threshold_doses],
                                             [threshold objectForKey:kKey_Threshold_DoseForms]];
                            [arrayOfDescriptionLines addObject:[self astringForPlainText:str]];
                        }
                        
                    }
                        break;
                    case kDoseCalculationBy_SingleDose:
                        [arrayOfDescriptionLines addObject:[self astringForPlainText:[NSString stringWithFormat:@"%@\n",[drug objectForKey:kKey_SingleDoseInstructions]]]];
                        break;
                }
            }
        }
    }
    
    NSMutableAttributedString *desc = [[NSMutableAttributedString alloc] initWithString:@""];
    for (NSAttributedString *as in arrayOfDescriptionLines) {
        [desc appendAttributedString:as];
    }
    return desc;
}

-(NSMutableAttributedString *)textForGuideline:(NSMutableDictionary *)guideline withName:(NSString *)guidelineName
{
    self.guideline = guideline;
    self.guidelineName = guidelineName;
    return [self createDescriptionFromGuideline];
}





@end
