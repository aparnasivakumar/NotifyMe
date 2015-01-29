//
//  SecondViewController.m
//  Notify App
//
//  Created by Naren B on 10/26/14.
//  Copyright (c) 2014 Naren B. All rights reserved.
//

#import "SecondViewController.h"
#import "ViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize name,number,reg,reset;

- (void)viewDidLoad {
    
    
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
        
        name.text =[info valueForKey:@"name"];
        number.text = [info valueForKey:@"phoneNo"];
    }
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)save:(id)sender {
    
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    NSManagedObject *newContact;
    newContact = [NSEntityDescription
                  insertNewObjectForEntityForName:@"Notify"
                  inManagedObjectContext:context];
    [newContact setValue: name.text forKey:@"name"];
    [newContact setValue: number.text forKey:@"phoneNo"];

    NSError *error;
    [context save:&error];
    
    [self performSelector:@selector(disableRegButton) withObject:nil afterDelay:2.0];
    [self performSelector:@selector(enableResetButton) withObject:nil afterDelay:2.0];
}

-(void)enableRegButton {
    self.reg.enabled = YES;
    [self.reg setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
}

-(void)enableResetButton {
    self.reset.enabled = YES;
    [self.reset setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
}

-(void)disableRegButton {
    self.reg.enabled = NO;
    [self.reg setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

-(void)disableResetButton {
    self.reset.enabled = NO;
    [self.reset setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (IBAction)reset:(id)sender {
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
        [context deleteObject:info];
    }
    NSError *saveError = nil;
    name.text =  @"";
    number.text =@"";
    
    [context save:&saveError];
    [self performSelector:@selector(disableResetButton) withObject:nil afterDelay:2.0];
    [self performSelector:@selector(enableRegButton) withObject:nil afterDelay:2.0];
  }

@end
