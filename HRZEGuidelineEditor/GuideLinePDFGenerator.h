//
//  GuideLineTextGenerator.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 28/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface GuideLinePDFGenerator : NSObject

@property (strong) NSMutableDictionary *guideline;
@property (strong) NSString *guidelineName;


-(id)initWithGuideline:(NSMutableDictionary *)guideline withName:(NSString *)guidelineName;

-(void)createPDFAtURL:(NSURL *)url withPrintInfo:(NSPrintInfo *)printInfo;
-(NSData *)createPDFDataUsingLayoutWithPrintInfo:(NSPrintInfo *)printInfo;

@end
