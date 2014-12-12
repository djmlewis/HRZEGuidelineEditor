//
//  Document.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 02/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GuidelineViewController;

@interface GuidelineDocument : NSDocument


@property (strong)  GuidelineViewController *myGuidelineDisplayingViewController;

@property (strong) NSMutableDictionary *dictionaryGuideline;




@end

