//
//  HandyRoutines.m
//  HRZE UK
//
//  Created by David Lewis on 25/08/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "HandyRoutines.h"
#import "PrefixHeader.pch"
#import <AppKit/AppKit.h>

@implementation HandyRoutines

+(NSString *)pathToDocsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dirpath = [paths objectAtIndex:0];
    return dirpath;
    
}

+(NSString *)pathToCachesDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *dirpath = [paths objectAtIndex:0];
    return dirpath;
}

+(NSMutableDictionary *)newEmptyTabletsDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *arrayOfTabs = [NSMutableArray array];
    [dict setObject:arrayOfTabs forKey:kKey_Tablet_Array];
    [dict setObject:kKey_TabletsDB_TBAppIdentifier forKey:kKey_GuidelineTBAppIdentifier];
    return dict;
}

+(NSMutableDictionary *)newEmptyTablet
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"" forKey:kKey_Tablet_Name];
    [dict setObject:[NSData data] forKey:kKey_Tablet_photo];
    return dict;
}


+(NSMutableDictionary *)newEmptyGuideline
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *indications = [NSMutableArray arrayWithCapacity:1];
    [dict setObject:indications forKey:kKey_GuidelineArrayOfIndications];
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:1];
    [dict setObject:infos forKey:kKey_GuidelineArrayOfInformation];
    [dict setObject:@" " forKey:kKey_GuidelineName];
    [dict setObject:kKey_GuidelineTBAppIdentifier forKey:kKey_GuidelineTBAppIdentifier];
    [dict setObject:[HandyRoutines dataForDescriptionAttributedString:[[NSAttributedString alloc] initWithString:@" "]] forKey:kKey_GuidelineDescription];
    
    return dict;
}

+(NSMutableDictionary *)newEmptyDrugInfoWithName:(NSString *)infoName
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:infoName forKey:kKey_DrugInfoName];
    [dict setObject:[HandyRoutines dataForDescriptionAttributedString:[[NSAttributedString alloc] initWithString:@" "]] forKey:kKey_DrugInfoDescription];
    
    return dict;
}

+(NSMutableDictionary *)dictionaryFromPropertyListData:(NSData *)data
{
    return (NSMutableDictionary *)[NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
}

+(NSData *)serializedDictionaryDataFromDictionary:(id)guideline
{
    NSError *error = nil;
    NSData *serializedData = [NSPropertyListSerialization dataWithPropertyList:guideline format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    if (error == noErr) {
        return serializedData;
    }
    return nil;
}


+(NSMutableArray *)arrayTakingAccountOfNullFromArray:(NSMutableArray *)arrayToCheck
{
    if (arrayToCheck == nil) {
        return [NSMutableArray array];
    }
    return arrayToCheck;
}

+(NSMutableArray *)mutableArrayFromArrayOfIntegers:(NSArray *)array
{
    NSMutableArray *marray = [NSMutableArray arrayWithCapacity:array.count];
    for (int i = 0; i<array.count; i++)
    {
        NSNumber *object = [array objectAtIndex:i];
        [marray addObject:[NSNumber numberWithInteger:[object integerValue]]];
    }
    return marray;
}

+(NSMutableDictionary *)mutableDictionaryCopyFromDictionary:(NSMutableDictionary *)dictToCopy
{
    return  (NSMutableDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:dictToCopy]];
}

+(NSMutableDictionary *)newEmptyIndicationWithName:(NSString *)indicationName
{
    NSMutableDictionary *indication = [NSMutableDictionary dictionary];
    [indication setObject:indicationName forKey:kKey_IndicationName];
    [indication setObject:@"" forKey:kKey_IndicationComments];
    [indication setObject:[NSNumber numberWithBool:NO] forKey:kKey_Indication_HideComments];
    [indication setObject:[NSNumber numberWithInteger:kIndicationColourWhiteTag] forKey:kKey_IndicationColour];
    [indication setObject:[NSNumber numberWithInteger:kColourDefaultLightSaturationInteger] forKey:kKey_IndicationPageColourSaturation];
    [indication setObject:[NSMutableArray array] forKey:kKey_ArrayOfDrugs];
    return indication;
}



+(NSMutableDictionary *)newEmptyDrugDictWithCalculationType:(NSInteger)calculationType
{
    NSMutableDictionary *drugDict = [NSMutableDictionary dictionary];
    [drugDict setObject:kAlertTitle_NewDrug forKey:kKey_DrugDisplayName];
    [drugDict setObject:[NSNumber numberWithInteger:calculationType]   forKey:kKey_DoseCalculationType];
    [drugDict setObject:[NSNumber numberWithBool:YES]   forKey:kKey_DrugShowInList];
    
    
    switch (calculationType) {
        case kDoseCalculationBy_MgKg_Adjustable:
        case kDoseCalculationBy_MgKg:
            [drugDict setObject:[NSNumber numberWithInteger:0] forKey:kKey_DosageMgKg];
            [drugDict setObject:[NSNumber numberWithInteger:0] forKey:kKey_DosageMgKgMaximum];
            [drugDict setObject:[NSNumber numberWithInteger:0] forKey:kKey_DosageMgKgMinimum];
            [drugDict setObject:@"mg" forKey:kKey_DoseUnits];
            [drugDict setObject:[NSNumber numberWithInteger:0] forKey:kKey_MaxDose];
            [drugDict setObject:[NSNumber numberWithInteger:kRounding_Up] forKey:kKey_RoundingUpDown];
            [drugDict setObject:[NSNumber numberWithInteger:1] forKey:kKey_ValueOfRounding];
            break;
        case kDoseCalculationBy_Threshold:
            [drugDict setObject:[NSMutableArray array] forKey:kKey_Threshold_doses];
            [drugDict setObject:[NSMutableArray array] forKey:kKey_Threshold_Weights];
            [drugDict setObject:[NSMutableArray array] forKey:kKey_Threshold_Booleans];
            [drugDict setObject:[NSMutableArray array] forKey:kKey_Threshold_DoseForms];
            [drugDict setObject:[NSNumber numberWithDouble:0.0f] forKey:kKey_Threshold_MinWeight];
            break;
        case kDoseCalculationBy_SingleDose:
            [drugDict setObject:@"" forKey:kKey_SingleDoseInstructions];
            
            
            break;
    }
    return drugDict;
}


+(void)swapRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath inArray:(NSMutableArray *)arrayToSwap
{

}

+(NSData *)dataForDescriptionAttributedString:(NSAttributedString *)attributedString
{
    if (attributedString.length == 0) {
        attributedString = [[NSAttributedString alloc] initWithString:@" "];
    }
    NSError *error = nil;
    NSRange range = NSMakeRange(0, attributedString.length);
    NSDictionary *dict = [NSDictionary dictionaryWithObject:NSRTFTextDocumentType forKey:NSDocumentTypeDocumentAttribute];
    NSData *data = [attributedString dataFromRange:range documentAttributes:dict error:&error];
    if (data == nil) {
        data = [NSData data];
    }
    return data;
}

+(NSAttributedString *)attributedStringFromDescriptionData:(NSData *)data
{
    if (data == nil || data.length == 0) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    NSDictionary *options = [NSDictionary dictionary];
    NSDictionary *attribs = [NSDictionary dictionary];
    NSError *error = nil;
    NSAttributedString *str = [[NSAttributedString alloc] initWithData:data options:options documentAttributes:&attribs error:&error];
    return str;
}

+(NSString *)stringFromStringTakingAccountOfNull:(NSString *)string
{
    if (string == nil) {
        string = @" ";
    }
    return string;
}

+(NSNumberFormatter *)roundingFromRoundUpDownValue:(NSNumber *)updownKey andRoundingValue:(NSNumber *)roundVal
{
    NSNumberFormatter *numformat = [[NSNumberFormatter alloc] init];
    numformat.roundingIncrement = roundVal;
    
    if ([updownKey integerValue] == kRounding_Up) {
        numformat.roundingMode = kCFNumberFormatterRoundUp;
    }
    else
    {
        numformat.roundingMode = kCFNumberFormatterRoundDown;
    }
    return numformat;
}

+(NSString *)roundingStringFromRoundUpDownValue:(NSNumber *)updownKey
{
    if ([updownKey integerValue] == kRounding_Up) {
        return @"up";
    }

    return @"down";
}

+(BOOL)leftSide:(CGFloat)leftSide is:(NSInteger)predicate thanRightSide:(CGFloat)rightSide
{
    switch (predicate) {
        case 0:
            return leftSide < rightSide;
            break;
        case 1:
            return leftSide <= rightSide;
            break;
        case 2:
            return leftSide == rightSide;
            break;
        case 3:
            return leftSide >= rightSide;
            break;
        case 4:
            return leftSide > rightSide;
            break;
    }
    return NO;
}

+(NSString *)predecateStringForPredicate:(NSNumber *)predicate
{
    switch ([predicate integerValue]) {
        case 0:
            return @"<";
            break;
        case 1:
            return @"<=";
            break;
        case 2:
            return @"=";
            break;
        case 3:
            return @">=";
            break;
        case 4:
            return @">";
            break;
    }
    return @"";
}

@end
