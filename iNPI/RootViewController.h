//
//  RootViewController.h
//  iNPI
//
//  Created by Vladislav on 26.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController <UIActionSheetDelegate> {
    UIActionSheet *installSheet;
    UIActionSheet *areYouSureSheet;
    NSString *currPkgName;
    UIActionSheet *process;
}
- (void)freshList;
@property (nonatomic,retain) NSString *currPkgName;
@end
