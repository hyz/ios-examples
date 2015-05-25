//
//  RWLocationViewController.m
//  TroutTrip
//
//  Created by Charlie Fulton on 2/28/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorials. All rights reserved.
//

#import "RWLocationDownloadTaskViewController.h"

@interface RWLocationDownloadTaskViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *locationPhoto;
@property (weak, nonatomic) IBOutlet UIView *pleaseWait;

@end

@implementation RWLocationDownloadTaskViewController


- (void)viewDidLoad {
  [super viewDidLoad];
	
	self.pleaseWait.hidden = NO;
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
  // 1
	NSURL *url = [NSURL URLWithString:
    @"http://upload.wikimedia.org/wikipedia/commons/7/7f/Williams_River-27527.jpg"];
	
  // 2
	NSURLSessionDownloadTask *downloadPhotoTask =[[NSURLSession sharedSession]
    downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
      
      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      self.pleaseWait.hidden = YES;
      
      // 3
      UIImage *downloadedImage = [UIImage imageWithData:
        [NSData dataWithContentsOfURL:location]];
      
      // Handle the downloaded image

      // Save the image to your Photo Album
      UIImageWriteToSavedPhotosAlbum(downloadedImage, nil, nil, nil);
      
      dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"updating UIImageView");
        self.locationPhoto.image = downloadedImage;
      });
    }];
	
  // 4
	[downloadPhotoTask resume];
}


@end
