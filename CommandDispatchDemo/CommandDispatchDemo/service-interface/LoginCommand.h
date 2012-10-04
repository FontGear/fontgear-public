//
//  LoginCommand.h
//  GDM-Prototype
//
//  Created by Jack Cox on 8/5/11.
//  Copyright 2011 CapTech Ventures, Inc.. All rights reserved.
//

#import "BaseCommand.h"

@interface LoginCommand : BaseCommand {
    NSString *user;
    NSString *pwd;
}

@property (retain, nonatomic) NSString * user;
@property (retain, nonatomic) NSString * pwd;
@end
