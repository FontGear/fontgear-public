//
//  LoadImageCommand.m
//  CommandDispatchDemo
//
//  Created by Jack Cox on 9/22/11.
//  Copyright 2011 CapTech Ventures. All rights reserved.
//

#import "LoadImageCommand.h"

@implementation LoadImageCommand
@synthesize imageUrl;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (void) dealloc {
    [imageUrl release];
    [super dealloc];
}

/**
 Retrieve an image from the internet and send a notification when that image is retrieved
 **/
- (void)main {
    NSLog(@"Starting LoadImage operation %@", self.imageUrl);
    
    NSError *error = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl] options:0 error:&error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([self isNoError:error]) {
        UIImage *image = [UIImage imageWithData:data];
        if (image == nil) {
            self.status = kFailure;
            self.reason = @"Invalid image format";
            [self sendNetworkErrorNotification];
            return;
        }
        self.results = [NSDictionary dictionaryWithObjectsAndKeys:image, @"image", nil];
        self.status = kSuccess;
        [self sendCompletionNotification];
    }
    return;
    
}
- (id) copyWithZone:(NSZone *)zone {
    LoadImageCommand *newOp = [super copyWithZone:zone];
    newOp.imageUrl = imageUrl;
    return newOp;
}
@end
