//
//  ViewController.h
//  Notify App
//
//  Created by Naren B on 10/26/14.
//  Copyright (c) 2014 Naren B. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"


@interface ViewController : UIViewController <CLLocationManagerDelegate>

- (IBAction)Press:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *addressArea;

@property (strong, nonatomic) id  infoRequest;
@end

