//
//  RWWeatherViewController.m
//  TroutTrip
//
//  Created by Charlie Fulton on 2/26/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorials. All rights reserved.
//

#import "RWWeatherDataTaskViewController.h"

#warning THIS IS WHERE YOU SET YOUR FORECAST.IO KEY
// see https://developer.forecast.io/docs/v2 for details
static NSString const *kApiKey = @"861ea1eca5d939d04f42f6d41bbfa15c";

@interface RWWeatherDataTaskViewController ()

@property (nonatomic, strong) NSDictionary *weatherData;


@property (weak, nonatomic) IBOutlet UILabel *currentConditionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@property (weak, nonatomic) IBOutlet UITextView *summary;

@end



@implementation RWWeatherDataTaskViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
	//1
	NSString *dataUrl = [NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/38.936320,-79.223550",kApiKey];
	NSURL *url = [NSURL URLWithString:dataUrl];
	
	// 2
	NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
    dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      
      // Check to make sure the server didn't respond with a "Not Authorized"
      if ([response respondsToSelector:@selector(statusCode)]) {
        if ([(NSHTTPURLResponse *) response statusCode] == 403) {
          dispatch_async(dispatch_get_main_queue(), ^{
            // Remind the user to update the API Key
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"API Key Needed"
                                                             message:@"Check the forecast.io API key in RWWeatherDataTaskViewController.m"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            [alert show];
            return;
          });
        }
      }
      
      // 4: Handle response here
      [self processResponseUsingData:data];
      
  }];
	
	// 3
	[downloadTask setTaskDescription:@"weatherDownload"];
	[downloadTask resume];
}



#pragma mark - Private

// Helper method, maybe just make it a category..
- (void)processResponseUsingData:(NSData*)data {
  NSError *parseJsonError = nil;
  
  NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingAllowFragments error:&parseJsonError];
  if (!parseJsonError) {
    NSLog(@"json data = %@", jsonDict);
		dispatch_async(dispatch_get_main_queue(), ^{
			self.currentConditionsLabel.text = jsonDict[@"currently"][@"summary"];
			self.tempLabel.text = [jsonDict[@"currently"][@"temperature"]stringValue];
			self.summary.text = jsonDict[@"daily"][@"summary"];
		});
  }
}


@end
