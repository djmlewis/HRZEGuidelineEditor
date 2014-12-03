//
//  HandyRoutines.h
//  HRZE UK
//
//  Created by David Lewis on 25/08/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import <Foundation/Foundation.h>

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

+(NSNumberFormatter *)roundingFromRoundUpDownValue:(NSNumber *)updownKey andRoundingValue:(NSNumber *)roundVal;
+(NSString *)roundingStringFromRoundUpDownValue:(NSNumber *)updownKey;

+(NSString *)predecateStringForPredicate:(NSNumber *)predicate;
+(BOOL)leftSide:(CGFloat)leftSide is:(NSInteger)predicate thanRightSide:(CGFloat)rightSide;

+(NSMutableDictionary *)createNewIndicationWithName:(NSString *)indicationName;
+(NSMutableDictionary *)newEmptyGuideline;
+(NSMutableDictionary *)newEmptyTablet;
+(NSMutableDictionary *)newEmptyTabletsDictionary;
+(NSMutableDictionary *)newEmptyDrugDictWithCalculationType:(NSInteger)calculationType;
+(NSMutableDictionary *)newEmptyDrugInfoWithName:(NSString *)infoName;

@end
