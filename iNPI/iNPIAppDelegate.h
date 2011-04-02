//
//  iNPIAppDelegate.h
//  iNPI
//
//  Created by Vladislav on 26.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iNPIAppDelegate : NSObject <UIApplicationDelegate> {

}
- (IBAction)refreshList:(id)sender;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
