//
//  HandyRoutines.h
//  HRZE UK
//
//  Created by David Lewis on 25/08/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>



@interface HandyRoutines : NSObject

+(NSString *)pathToDocsDirectory;
+(NSString *)pathToCachesDirectory;

+(NSMutableArray *)mutableArrayFromArrayOfIntegers:(NSArray *)array;
+(NSMutableDictionary *)mutableDictionaryCopyFromDictionary:(NSMutableDictionary *)dictToCopy;

+(NSData *)serializedDictionaryDataFromDictionary:(id)guidelineData;
+(NSMutableDictionary *)dictionaryFromPropertyListData:(NSData *)data;

+(NSData *)dataForDescriptionAttributedString:(NSAttributedString *)attributedString;
+(NSAttributedString *)attributedStringFromDescriptionData:(NSData *)data;

+(NSString *)stringFromStringTakingAccountOfNull:(NSString *)string;
+(NSMutableArray *)arrayTakingAccountOfNullFromArray:(NSMutableArray *)arrayToCheck;

+(NSNumberFormatter *)roundingFromRoundUpDownValue:(NSNumber *)updownKey andRoundingValue:(NSNumber *)roundVal;
+(NSString *)roundingStringFromRoundUpDownValue:(NSNumber *)updownKey;

+(NSString *)predecateStringForPredicate:(NSNumber *)predicate;
+(BOOL)leftSide:(CGFloat)leftSide is:(NSInteger)predicate thanRightSide:(CGFloat)rightSide;

+(NSMutableDictionary *)newEmptyGuideline;
+(NSMutableDictionary *)newEmptyIndicationWithName:(NSString *)indicationName;
+(NSMutableDictionary *)newEmptyDrugWithCalculationType:(NSInteger)calculationType;
+(NSMutableDictionary *)newEmptyThreshold;
+(NSMutableDictionary *)newEmptyTablet;
+(NSMutableDictionary *)newEmptyTabletsDictionary;
+(NSMutableDictionary *)newEmptyDrugInfoWithName:(NSString *)infoName;

+(NSColor *)textColourForHue:(NSNumber *)hue;
+(NSColor *)colourFromHue:(NSNumber *)hue;
+(NSColor *)colourFromHueMadeFaint:(NSNumber *)hue;
+(NSColor *)colourFromHueMadeFaintBySaturationValue:(NSNumber *)hue withSaturation:(NSNumber *)sat;//madefaint by tag
+(NSColor *)reverseTextColourForHue:(NSNumber *)hue;
+(NSColor *)colourFromHueMadeDarker:(NSNumber *)hue;
+(CGFloat)brightnessForBlackTagHue;



@end
