//
//  LoadImageCommand.h
//  CommandDispatchDemo
//
//  Created by Jack Cox on 9/22/11.
//  Copyright 2011 CapTech Ventures. All rights reserved.
//

#import "BaseCommand.h"

@interface LoadImageCommand : BaseCommand {
    NSString *imageUrl;
}

@property (nonatomic, retain) NSString *imageUrl;
@end
