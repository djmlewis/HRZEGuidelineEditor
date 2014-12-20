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

#pragma mark - Paths

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


#pragma mark - New

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


+(NSMutableDictionary *)newEmptyIndicationWithName:(NSString *)indicationName
{
    NSMutableDictionary *indication = [NSMutableDictionary dictionary];
    [indication setObject:indicationName forKey:kKey_IndicationName];
    [indication setObject:@"" forKey:kKey_IndicationComments];
    [indication setObject:[NSNumber numberWithBool:NO] forKey:kKey_Indication_HideComments];
    [indication setObject:[HandyRoutines stringFromNSColor:[NSColor blackColor]] forKey:kKey_IndicationColour_Header];
    [indication setObject:[HandyRoutines stringFromNSColor:[NSColor whiteColor]] forKey:kKey_IndicationColour_Page];
    [indication setObject:[NSMutableArray array] forKey:kKey_ArrayOfDrugs];
    return indication;
}



+(NSMutableDictionary *)newEmptyDrugWithCalculationType:(NSInteger)calculationType
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
            [drugDict setObject:[NSMutableArray array] forKey:kKey_Threshold_Array_Thresholds];
            [drugDict setObject:[NSNumber numberWithDouble:0.0f] forKey:kKey_Threshold_MinWeight];
            break;
        case kDoseCalculationBy_SingleDose:
            [drugDict setObject:@"" forKey:kKey_SingleDoseInstructions];
            
            
            break;
    }
    return drugDict;
}

+(NSMutableDictionary *)newEmptyThreshold
{
    NSMutableDictionary *threshold = [NSMutableDictionary dictionary];
    [threshold setObject:[NSNumber numberWithDouble:1.0f] forKey:kKey_Threshold_Weights];
    [threshold setObject:[NSNumber numberWithInteger:4] forKey:kKey_Threshold_Booleans];
    [threshold setObject:@"" forKey:kKey_Threshold_doses];
    [threshold setObject:@"" forKey:kKey_Threshold_DoseForms];
    
    return threshold;
}

+(NSMutableDictionary *)newEmptyDrugInfoWithName:(NSString *)infoName
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:infoName forKey:kKey_DrugInfoName];
    [dict setObject:[HandyRoutines dataForDescriptionAttributedString:[[NSAttributedString alloc] initWithString:@" "]] forKey:kKey_DrugInfoDescription];
    
    return dict;
}

#pragma mark - Serialisation

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

#pragma mark - Array Dict Swaps

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

+(void)swapRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath inArray:(NSMutableArray *)arrayToSwap
{

}

#pragma mark - Strings


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

#pragma mark - Rounding and Predicates


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

#pragma mark - Colours

+(NSString *)stringFromNSColor:(NSColor*)colour
{
    CIColor * cic = [CIColor colorWithCGColor:colour.CGColor];
    NSString *string = [NSString stringWithFormat:@"%@",[cic stringRepresentation]];
    return string;
}

+(NSColor *)colourFromString:(NSString*)string
{
    if (string == nil)
    {
        return [NSColor blackColor];
    }
    CIColor * cic = [CIColor colorWithString:string];
    NSColor *colour =  [NSColor colorWithCIColor:cic];
    if (colour != nil) {
        return colour;
    }
    return [NSColor blackColor];
}

+(NSColor *)colourFromColourMadeFaint:(NSColor *)colour
{
    CGFloat h;
    CGFloat s;
    CGFloat b;
    CGFloat a;
    [colour getHue:&h saturation:&s brightness:&b alpha:&a];
    if (h==0 && s == 0)
    {
        return [NSColor colorWithHue:h saturation:s brightness:0.95f alpha:1.0f];
    }
    return [NSColor colorWithHue:h saturation:kColourDefaultLightSaturation brightness:1.0f alpha:1.0f];
}

+(NSColor *)colourFromHueMadeFaint:(NSNumber *)hue
{
    if (hue == nil) {
        return [NSColor colorWithHue:0.00f saturation:0.0f brightness:0.95f alpha:1.0f];//grey
    }
    if ([hue integerValue] == kIndicationColourBlackTag) {
        return [NSColor colorWithHue:0.00f saturation:0.0f brightness:0.95f alpha:1.0f];//grey
    }
    if ([hue integerValue] == kIndicationColourWhiteTag) {
        return [NSColor whiteColor];
    }
    return [NSColor colorWithHue:[hue floatValue] saturation:kColourDefaultLightSaturation brightness:1.0f alpha:1.0f];
    
}


+(NSColor *)colourFromHue:(NSNumber *)hue
{
    if (hue == nil) {
        return [NSColor blackColor];
    }
    if ([hue integerValue] == kIndicationColourBlackTag) {
        return [NSColor blackColor];
    }
    if ([hue integerValue] == kIndicationColourWhiteTag) {
        return [NSColor whiteColor];
    }
    return [NSColor colorWithHue:[hue floatValue] saturation:1.0f brightness:kColourDefaultBrightness alpha:1.0f];
}

+(NSColor *)colourFromHueMadeDarker:(NSNumber *)hue
{
    if (hue == nil) {
        return [NSColor blackColor];
    }
    if ([hue integerValue] == kIndicationColourBlackTag) {
        return [NSColor blackColor];
    }
    if ([hue integerValue] == kIndicationColourWhiteTag) {
        return [NSColor whiteColor];
    }
    return [NSColor colorWithHue:[hue floatValue] saturation:1.0f brightness:kColourDefaultBrightnessDarker alpha:1.0f];
    
}

+(CGFloat)brightnessForBlackTagHue
{
    return 1.0f-kColourDefaultLightSaturation;
}

+(NSColor *)colourFromHueMadeFaintBySaturationValue:(NSNumber *)hue withSaturation:(NSNumber *)sat
{
    if (sat == nil) {
        sat = [NSNumber numberWithFloat:kColourDefaultLightSaturation];
    }
    if (hue == nil) {
        return [NSColor colorWithHue:0.0f saturation:0.0f brightness:[self brightnessForBlackTagHue] alpha:1.0f];
    }
    if ([hue integerValue] == kIndicationColourBlackTag) {
        return [NSColor colorWithHue:0.0f saturation:0.0f brightness:[self brightnessForBlackTagHue] alpha:1.0f];
    }
    if ([hue integerValue] == kIndicationColourWhiteTag) {
        return [NSColor whiteColor];
    }
    
    CGFloat satCorrected = [sat floatValue]/100.0f;
    return [NSColor colorWithHue:[hue floatValue] saturation:satCorrected brightness:1.0f alpha:1.0f];
    
}

+(NSColor *)reverseTextColourForHue:(NSNumber *)hue//used inside colourboxes
{
    if (hue == nil) {
        return [NSColor whiteColor];
    }
    if ([hue integerValue] == kIndicationColourWhiteTag) {
        return [NSColor blackColor];
    }
    return [NSColor whiteColor];
}

+(NSColor *)textColourForHue:(NSNumber *)hue//used in lists
{
    if (hue == nil) {
        return [NSColor blackColor];
    }
    if ([hue floatValue] < 0.0f)
    {
        return [NSColor blackColor];
    }
    return [HandyRoutines colourFromHueMadeDarker:hue];
}




@end
