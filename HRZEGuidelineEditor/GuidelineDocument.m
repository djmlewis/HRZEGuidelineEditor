//
//  Document.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 02/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "GuidelineDocument.h"
#import "HandyRoutines.h"
#import "GuidelineViewController.h"
#import "PrefixHeader.pch"

@interface GuidelineDocument ()

@end

@implementation GuidelineDocument

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        self.guideline = [HandyRoutines newEmptyGuideline];

    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    // *** NOT CALLED FROM STORYBOPARD? ??
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (void)makeWindowControllers {
    // Override to return the Storyboard file name of the document.
    [self addWindowController:[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"Document Window Controller"]];
    
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    //[NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    
    //NSLog(@"dataOfType: %@",typeName);
    
    [self.myGuidelineDisplayingViewController alignGuidelineWithView];

    return [HandyRoutines serializedDictionaryDataFromDictionary:self.guideline];

    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    //[NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    
    //NSLog(@"dataOfType: %@",typeName);
    
    self.guideline = [HandyRoutines dictionaryFromPropertyListData:data];

    return self.guideline != nil;
}



@end
