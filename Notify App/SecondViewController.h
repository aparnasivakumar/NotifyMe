//
//  SecondViewController.h
//  Notify App
//
//  Created by Naren B on 10/26/14.
//  Copyright (c) 2014 Naren B. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SecondViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *number;
@property (strong, nonatomic) IBOutlet UIButton *reg;
@property (strong, nonatomic) IBOutlet UIButton *reset;

- (IBAction)save:(id)sender;

- (IBAction)reset:(id)sender;

@end
