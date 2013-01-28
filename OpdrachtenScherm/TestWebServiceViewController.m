//
//  TestWebServiceViewController.m
//  OpdrachtenScherm
//
//  Created by Sven Timmermans on 28/01/13.
//  Copyright (c) 2013 Sven Timmermans. All rights reserved.
//


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //defines the background queue
#define webserviceURL [NSURL URLWithString:@"http://webservice.citygamephl.be/CityGameWS/resources/generic/getLatestTask/1/Prooi"] //Defines the URL for the tasks (will be changed so it is relevant to the current user


#import "TestWebServiceViewController.h"

@interface TestWebServiceViewController ()

@end

@implementation TestWebServiceViewController

NSMutableArray *taskArray = nil;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSTimer *interval = [NSTimer scheduledTimerWithTimeInterval:10 target:self
                                                       selector:@selector(tick) userInfo:nil repeats:YES];
}

-(void)tick{
    // makes the background queue and calls the fetched data function for the tasks
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        webserviceURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     
                     options:kNilOptions
                     error:&error];
    
    // Gets the values of the prey (there should only be one, so the for loop shouldn't be necessary

    NSString* location = [json objectForKey:@"location"];
    NSNumber* description = [json objectForKey:@"description"];
    NSNumber* longitude = [json objectForKey:@"longitude"];
    NSNumber* latitude = [json objectForKey:@"latitude"];
        // logs the data
    NSString *tempString;
    tempString = [NSString stringWithFormat: @"Task: %@ at %@: longitude: %@ and latitude: %@", description, location, longitude, latitude];
    NSLog(@"Task: %@ at %@: longitude: %@ and latitude: %@", description, location, longitude, latitude);
    if ([taskArray lastObject]!=tempString){
        [taskArray addObject: tempString];
    }
    NSLog(@"b");
    for (NSString *test in taskArray) {
        NSLog(@"lalalala");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
