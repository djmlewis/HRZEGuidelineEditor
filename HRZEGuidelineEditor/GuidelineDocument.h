//
//  Document.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 02/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GuidelineDisplayingViewController;

@interface GuidelineDocument : NSDocument


@property (strong)  GuidelineDisplayingViewController *myGuidelineDisplayingViewController;

@property (strong) NSMutableDictionary *dictionaryGuideline;




@end

