//
//  RWStoryViewController.m
//  TroutTrip
//
//  Created by Charlie Fulton on 2/26/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorials. All rights reserved.
//

#import "RWStoryUploadTaskViewController.h"

#warning THIS IS WHERE YOU SET YOUR PARSE.COM API KEYS
// see : http://www.raywenderlich.com/19341/how-to-easily-create-a-web-backend-for-your-apps-with-parse
// https://parse.com/tutorials
static NSString const *kAppId = @"YOUR_APP_KEY";
static NSString const *kRestApiKey = @"YOUR_REST_API_KEY";

@interface RWStoryUploadTaskViewController ()
@property (weak, nonatomic) IBOutlet UITextField *story;

@end

@implementation RWStoryUploadTaskViewController


#pragma mark Private

- (IBAction)postStory:(id)sender {
	
	// 1
	NSURL *url = [NSURL URLWithString:@"https://api.parse.com/1/classes/FishStory"];
	NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

	// Parse requires HTTP headers for authentication. Set them before creating your NSURLSession
  [config setHTTPAdditionalHeaders:@{@"X-Parse-Application-Id":kAppId,
                                     @"X-Parse-REST-API-Key":kRestApiKey,
                                     @"Content-Type": @"application/json"}];
	
	NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

  
	// 2
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	request.HTTPMethod = @"POST";

  
  // 3
	NSDictionary *dictionary = @{@"story": self.story.text};
	NSError *error = nil;
	NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
	  options:kNilOptions error:&error];
	
	if (!error) {
		// 4
		NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
      fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
			
        // Check to make sure the server didn't respond with a "Not Authorized"
        if ([response respondsToSelector:@selector(statusCode)]) {
          if ([(NSHTTPURLResponse *) response statusCode] == 401) {
            dispatch_async(dispatch_get_main_queue(), ^{
              // Remind the user to update the API Key
              UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"API Key Needed"
                                                               message:@"Check the Parse App and Rest API keys in RWStoryUploadTaskViewController.m"
                                                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
              [alert show];
              return;
            });
          }
        }
        
        if (!error) {
          // Data was created, we leave it to you to display all of those tall tales!
          dispatch_async(dispatch_get_main_queue(), ^{
            self.story.text = @"";
          });
          
        } else {
          NSLog(@"DOH");
        }
		}];
		
    // 5
		[uploadTask resume];
	}
}


@end
