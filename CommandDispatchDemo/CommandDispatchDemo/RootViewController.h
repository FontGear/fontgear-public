//
//  RootViewController.h
//  CommandDispatchDemo
//
//  Created by Jack Cox on 9/10/11.
//  Copyright 2011 CapTech Ventures, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
    NSMutableDictionary    *feed;
    
}
@property (nonatomic, retain)  NSMutableDictionary    *feed;

- (void)requestVideoFeed;
- (IBAction)refresh:(id)sender;

@end
