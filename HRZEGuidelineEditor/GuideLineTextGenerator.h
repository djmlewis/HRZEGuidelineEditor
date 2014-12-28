//
//  GuideLineTextGenerator.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 28/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuideLineTextGenerator : NSObject

@property (strong) NSMutableDictionary *guideline;
@property (strong) NSString *guidelineName;




-(NSMutableAttributedString *)textForGuideline:(NSMutableDictionary *)guideline withName:(NSString *)guidelineName;

@end
