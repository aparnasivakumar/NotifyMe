//
//  ViewController.m
//  Notify App
//
//  Created by Naren B on 10/26/14.
//  Copyright (c) 2014 Naren B. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

NSString * message;
NSString * recipients;

@interface ViewController ()

@end

@implementation ViewController {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
@synthesize addressArea;
@synthesize infoRequest;


- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Press:(id)sender {
    
    NSLog(@"Pressed");
    
    locationManager.delegate = self;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSLog(@"received");
        
        [locationManager stopUpdatingLocation];
        
        NSLog(@"Resolving the Address");

        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0) {
                placemark = [placemarks lastObject];
                message = [NSString stringWithFormat:@"%@ %@\n%@\n%@",
                                     placemark.postalCode, placemark.locality,
                                     placemark.administrativeArea,
                                     placemark.country];

                
                AppDelegate *appDelegate =
                [[UIApplication sharedApplication] delegate];
                
                NSManagedObjectContext *context =
                [appDelegate managedObjectContext];
                
                NSEntityDescription *entityDesc =
                [NSEntityDescription entityForName:@"Notify"
                            inManagedObjectContext:context];
                
                NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Notify"];
                [request setEntity:entityDesc];
                
                
                NSError *error;
                NSArray *objects = [context executeFetchRequest:request
                                                          error:&error];
                
                
                for (NSManagedObject *info in objects) {
                    
                   recipients = [info valueForKey:@"phoneNo"];
                }
                
              if(![MFMessageComposeViewController canSendText]) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device cannot send text messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    return;
                };
    
              
                MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
                messageController.messageComposeDelegate = self;
                [messageController setRecipients:recipients];
                [messageController setBody:message];
                
                // Present message view controller on screen
                [self presentViewController:messageController animated:YES completion:nil];

            } else {
                NSLog(@"%@", error.debugDescription);
            }
        } ];
        
    }
}


#pragma mark - MFMailComposeViewControllerDelegate methods
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    switch (result) {
        case MessageComposeResultCancelled: break;
            
        case MessageComposeResultFailed:{
        
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oups, error while sendind SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent: break;
            
        default: break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
