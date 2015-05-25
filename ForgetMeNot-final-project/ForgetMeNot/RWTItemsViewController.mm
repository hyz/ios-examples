//
//  RWTItemsViewController.m
//  ForgetMeNot
//
//  Created by Chris Wagner on 1/28/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "RWTItemsViewController.h"
#import "RWTAddItemViewController.h"
#import "RWTItem.h"
#import "RWTItemCell.h"

NSString * const kRWTStoredItemsKey = @"storedItems";

///@interface RWTItemsViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
///
///@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
///@property (strong, nonatomic) NSMutableArray *items;
///@property (strong, nonatomic) CLLocationManager *locationManager;
///
///@end
///
///@implementation RWTItemsViewController
///
///- (void)viewDidLoad {
///    [super viewDidLoad];
///
///    self.locationManager = [[CLLocationManager alloc] init];
///    self.locationManager.delegate = self;
///
///    [self loadItems];
///}
///
///- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
///    if ([segue.identifier isEqualToString:@"Add"]) {
///        UINavigationController *navController = segue.destinationViewController;
///        RWTAddItemViewController *addItemViewController = (RWTAddItemViewController *)navController.topViewController;
///        [addItemViewController setItemAddedCompletion:^(RWTItem *newItem) {
///            [self.items addObject:newItem];
///            [self.itemsTableView beginUpdates];
///            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.items.count-1 inSection:0];
///            [self.itemsTableView insertRowsAtIndexPaths:@[newIndexPath]
///                                       withRowAnimation:UITableViewRowAnimationAutomatic];
///            [self.itemsTableView endUpdates];
///            [self startMonitoringItem:newItem];
///            [self persistItems];
///        }];
///    }
///}
///
///- (void)loadItems {
///    NSArray *storedItems = [[NSUserDefaults standardUserDefaults] arrayForKey:kRWTStoredItemsKey];
///    self.items = [NSMutableArray array];
///    if (storedItems) {
///        for (NSData *itemData in storedItems) {
///            RWTItem *item = [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
///            [self.items addObject:item];
///            [self startMonitoringItem:item];
///        }
///    }
///    if ([self.items count] == 0) {
///        NSString* uuidStr = @"890A44B4-20BF-44D7-8B3C-F5679A0779E3";
///        CLBeaconMajorValue major = 60019;
///        CLBeaconMajorValue minor = 26214;
///        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString: uuidStr];
///        RWTItem *item = [[RWTItem alloc] initWithName:uuidStr
///                                                    uuid:uuid
///                                                   major:major
///                                                   minor:minor];
///        [self.items addObject:item];
///        [self startMonitoringItem:item];
///    }
///}
///
///- (void)persistItems {
///    NSMutableArray *itemsDataArray = [NSMutableArray array];
///    for (RWTItem *item in self.items) {
///        NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:item];
///        [itemsDataArray addObject:itemData];
///    }
///    [[NSUserDefaults standardUserDefaults] setObject:itemsDataArray forKey:kRWTStoredItemsKey];
///}
///
///- (CLBeaconRegion *)beaconRegionWithItem:(RWTItem *)item {
///    CLBeaconRegion* region = [CLBeaconRegion alloc];
///    if (item.majorValue && item.minorValue) {
///        region = [region initWithProximityUUID:item.uuid major:item.majorValue minor:item.minorValue identifier:item.name];
///    } else {
///        region = [region initWithProximityUUID:item.uuid identifier:item.name];
///    }
///    return region;
///}
///
///- (void)startMonitoringItem:(RWTItem *)item {
///    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
///    NSLog(@"%@", beaconRegion);
///    [self.locationManager startMonitoringForRegion:beaconRegion];
///    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
///}
///
///- (void)stopMonitoringItem:(RWTItem *)item {
///    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
///    NSLog(@"%@", beaconRegion);
///    [self.locationManager stopMonitoringForRegion:beaconRegion];
///    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
///}
///
///#pragma mark - UITableViewDataSource 
///
///- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
///    return self.items.count;
///}
///
///- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
///    RWTItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item" forIndexPath:indexPath];
///    RWTItem *item = self.items[indexPath.row];
///    cell.item = item;
///    
///    return cell;
///}
///
///- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
///    return YES;
///}
///
///- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
///    if (editingStyle == UITableViewCellEditingStyleDelete) {
///        RWTItem *itemToRemove = [self.items objectAtIndex:indexPath.row];
///        [self stopMonitoringItem:itemToRemove];
///
///        [tableView beginUpdates];
///        [self.items removeObjectAtIndex:indexPath.row];
///        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
///        [tableView endUpdates];
///        [self persistItems];
///    }
///}
///
///#pragma mark - UITableViewDelegate
///
///- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
///    [tableView deselectRowAtIndexPath:indexPath animated:YES];
///    RWTItem *item = [self.items objectAtIndex:indexPath.row];
///    NSString *detailMessage = [NSString stringWithFormat:@"UUID: %@\nMajor: %d\nMinor: %d", item.uuid.UUIDString, item.majorValue, item.minorValue];
///    UIAlertView *detailAlert = [[UIAlertView alloc] initWithTitle:@"Details" message:detailMessage delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
///    [detailAlert show];
///}
///
///#pragma mark - CLLocationManagerDelegate
///
///- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region
///              withError:(NSError *)error {
///    NSLog(@"Failed monitoring region: %@", error);
///}
///
///- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
///    NSLog(@"Location manager failed: %@", error);
///}
///
///- (void)locationManager:(CLLocationManager *)manager
///        didRangeBeacons:(NSArray *)beacons
///               inRegion:(CLBeaconRegion *)region
///{
///    NSLog(@"%@", region);
///    for (CLBeacon *beacon in beacons) {
///        NSLog(@"%@", beacon);
///        for (RWTItem *item in self.items) {
///            if ([item isEqualToCLBeacon:beacon]) {
///                item.lastSeenBeacon = beacon;
///            }
///        }
///    }
///}
///
///
///@end

///////////// ///////////// ///////////// ///////////// ///////////// /////////////
//
/////////////
#import "CoreLocation/CoreLocation.h"
#import "CoreBluetooth/CoreBluetooth.h"

@interface ItemsTableViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>
{
    BOOL bStarted_;
    BOOL bAlert0_;
    unsigned short nRanged_;
}

//@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ItemsTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"ItemsTableViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ItemsTableViewController viewDidLoad");
    
    //self.tableView.dataSource = self;
    //self.tableView.delegate = self;
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"CLLocationManager locationServicesEnabled: NO");
        bAlert0_ = 1;
        return;
    }
    
    CLAuthorizationStatus astatus = [CLLocationManager authorizationStatus];
    if (astatus == kCLAuthorizationStatusAuthorizedAlways) {
        [self beacon_start];
        return;
    }
    if (astatus == kCLAuthorizationStatusNotDetermined) {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            NSLog(@"requestAlwaysAuthorization kCLAuthorizationStatusNotDetermined");
            [self.locationManager requestAlwaysAuthorization]; // didChangeAuthorizationStatus
        } else {
            //if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            //    [self.locationManager requestWhenInUseAuthorization];
            //}
            [self beacon_start];
        }
    } else /*if (astatus != kCLAuthorizationStatusAuthorizedAlways)*/ {
        // (astatus==kCLAuthorizationStatusDenied || astatus==kCLAuthorizationStatusAuthorizedWhenInUse)
        NSLog(@"kCLAuthorizationStatusAuthorizedAlways: NO, AlertView");
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Location Access(Always) required"
                                                     message:@"Click Settings to update Location Access."
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Settings", nil];
        [av show]; // didDismissWithButtonIndex:
    }
}

- (void)beacon_start {
    if (bStarted_) {
        NSLog(@"already started");
        return;
    }
    bStarted_ = YES;
    NSAssert(self.locationManager, @"locationManager nil");
    
    BOOL rangingAvail = [CLLocationManager isRangingAvailable];
    BOOL monitoringAvail = [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]];
    if (!rangingAvail) {
        NSLog(@"CLLocationManager isRangingAvailable: NO");
    }
    if (!monitoringAvail) {
        NSLog(@"CLLocationManager isMonitoringAvailableForClass: NO");
        //return;
    }
    
    [self loadItems];
    if ([self.items count] == 0) {
        [self makeNewItem:@"890A44B4-20BF-44D7-8B3C-F5679A0779E3" :0 :0];
    }
    
    for (RWTItem* it in self.items) {
        //[self startMonitoringItem:it];
        if (!it.majorValue) {
            CLBeaconRegion *region = [self beaconRegionWithItem:it];
            region.notifyEntryStateOnDisplay = YES;
            [self.locationManager startRangingBeaconsInRegion:region];
        }
    }
    
    [self.tableView reloadData];
    
    //NSString* kUUID = @"";
    //NSString* kIdentifier = @"";
    //
    //CLBeaconRegion *beaconRegion;
    //NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:kUUID];
    //beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:kIdentifier];
    //beaconRegion.notifyEntryStateOnDisplay = YES;
    //
    //[self.locationManager startMonitoringForRegion: beaconRegion];
    //[self.locationManager stopMonitoringForRegion: beaconRegion];
    //
    //[self.locationManager startRangingBeaconsInRegion: beaconRegion];
    //
    //for (id region in self.locationManager.rangedRegions) {
    //    [self.locationManager stopRangingBeaconsInRegion: region];
    //}
    
    //NSLog(@"rangedRegions.count: %d", (int)self.locationManager.rangedRegions.count);
}

- (RWTItem*)makeNewItem:(NSString*)uuidStr :(CLBeaconMajorValue)major :(CLBeaconMajorValue)minor {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString: uuidStr];
    RWTItem *item = [[RWTItem alloc] initWithName:uuidStr uuid:uuid major:major minor:minor];
    //[self.items addObject:item]; //[self startMonitoringItem:item];
    [self.items insertObject:item atIndex:0];
    return item;
}

- (void)startMonitoringItem:(RWTItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    // NSLog(@"startMonitoringForRegion %@", fmt(beaconRegion));
    [self.locationManager startMonitoringForRegion:beaconRegion];
    //[self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

- (void)stopMonitoringItem:(RWTItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    NSLog(@"%@", beaconRegion);
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
}

- (CLBeaconRegion *)beaconRegionWithItem:(RWTItem *)item {
    CLBeaconRegion* region = [CLBeaconRegion alloc];
    if (item.majorValue && item.minorValue) {
        region = [region initWithProximityUUID:item.uuid major:item.majorValue minor:item.minorValue identifier:item.name];
    } else {
        region = [region initWithProximityUUID:item.uuid identifier:item.name];
    }
        //region = [region initWithProximityUUID:item.uuid identifier:item.name];
    region.notifyEntryStateOnDisplay = YES;
    return region;
}

#pragma mark - Alert view delegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    bAlert0_;
    if (buttonIndex > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - Location manager delegate methods
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSAssert(CLLocationManager.authorizationStatus==status, @"authorizationStatus==status");
    NSLog(@"didChangeAuthorizationStatus: %d", status);
    //CLAuthorizationStatus astatus = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self beacon_start];
        return;
    }
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"monitoringDidFailForRegion:withError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count == 0)
        NSLog(@"didRangeBeacons:inRegion %@: %d", fmt(region), (int)beacons.count);
    
    int nnew = 0;
    for (CLBeacon *beacon in beacons) {
        [self.tableView beginUpdates];
        RWTItem *item = nil;
        int rowN = 0;
        while (rowN < self.items.count) {
            if ([self.items[rowN] isEqualToCLBeacon:beacon]) {
                item = self.items[rowN];
        //item.lastSeenBeacon = beacon;
                [self.items removeObjectAtIndex:rowN];
                NSIndexPath* idxp = [NSIndexPath indexPathForRow:rowN inSection:0];
                [self.tableView deleteRowsAtIndexPaths:@[idxp] withRowAnimation:UITableViewRowAnimationMiddle];
                break;
            }
            ++rowN;
        }
        if (!item)/*(rowN == self.items.count)*/ {
            rowN = -1;
            item = [[RWTItem alloc] initWithName:beacon.proximityUUID.UUIDString
                                            uuid:beacon.proximityUUID
                                           major:beacon.major.unsignedShortValue
                                           minor:beacon.minor.unsignedShortValue];
            //item = [self makeNewItem:beacon.proximityUUID.UUIDString :beacon.major.unsignedShortValue :beacon.minor.unsignedShortValue];
            ++nnew;
        }
        item.lastSeenBeacon = beacon;
        
        [self.items insertObject:item atIndex:0];
        NSIndexPath* idxp = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[idxp] withRowAnimation:UITableViewRowAnimationMiddle];
        
        [self.tableView endUpdates];
        
        if (rowN < 0) {
            [self startMonitoringItem:item];
        }
        NSLog(@"beacon: %@%s", fmt(beacon), rowN<0?" :New":"");
    }
    if (nnew > 0) {
        //[self.tableView reloadData];
    }
    //int oldcnt = (int)beacons.count;
    //beacons = [self filteredBeacons:beacons];
    //NSLog(@"Beacon(s):found %d/%d :%@", (int)beacons.count, oldcnt, region.proximityUUID.UUIDString);
}


- (void)locationManager:(CLLocationManager*)manager didStartMonitoringForRegion:(CLBeaconRegion*)region
{
    NSLog(@"didStartMonitoringForRegion %@", fmt(region));
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    //NSLog(@"Entered region: %@", region);
    [self infoMe:(CLBeaconRegion *)region :@"Enter"];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    //NSLog(@"Exited region: %@", region);
    [self infoMe:(CLBeaconRegion *)region :@"Exit"];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    double timeRemain = [[UIApplication sharedApplication] backgroundTimeRemaining];
    if (timeRemain > 60*60*4)
        timeRemain = -1;
    NSString* s = [NSString stringWithFormat:@"didDetermineState:%@ t-remain:%.2f", fmt(state), timeRemain];
    [self infoMe:(CLBeaconRegion *)region :s];
}

#pragma mark - Local notifications
- (void)infoMe:(CLBeaconRegion *)region :(NSString*)evt
{
    UILocalNotification *notification = [UILocalNotification new];
    
    // Notification details
    // Major and minor are not available at the monitoring stage
    notification.alertBody = [NSString stringWithFormat:@"%@ :%@", evt, region.proximityUUID.UUIDString];
    notification.alertAction = NSLocalizedString(@"View Details", nil);
    notification.soundName = UILocalNotificationDefaultSoundName;
    // [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    NSLog(@"%@: %@", fmt(region), evt);
}

NSString* fmt(CLRegionState state)
{
    NSString *stateString = @"";
    switch (state) {
        case CLRegionStateInside:
            stateString = @"Inside";
            break;
        case CLRegionStateOutside:
            stateString = @"Outside";
            break;
        case CLRegionStateUnknown:
            stateString = @"Unknown";
            break;
    }
    return stateString;
}
NSString* fmt(CLBeacon *b)
{
    const char* proximity="Unknown";
    switch (b.proximity) {
        case CLProximityUnknown:
            break;
        case CLProximityImmediate:
            proximity="Immediate";
            break;
        case CLProximityNear:
            proximity="Near";
            break;
        case CLProximityFar:
            proximity="Far";
            break;
        default:
            break;
    }
    return [NSString stringWithFormat: @"%@ %@:%@ %s %.2f %d", b.proximityUUID.UUIDString, b.major, b.minor, proximity, b.accuracy, b.rssi];
}
NSString* fmt(CLBeaconRegion *region)
{
    if (region.major) {
        return [NSString stringWithFormat: @"%@ %@:%@", region.proximityUUID.UUIDString, region.major, region.minor];
    }
    return [NSString stringWithFormat: @"%@", region.proximityUUID.UUIDString];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Add"]) {
        //UINavigationController *navController = segue.destinationViewController;
        //RWTAddItemViewController *addItemViewController = (RWTAddItemViewController *)navController.topViewController;
        RWTAddItemViewController *addItemViewController = segue.destinationViewController;
        [addItemViewController setItemAddedCompletion:^(RWTItem *newItem) {
            [self.items addObject:newItem];
            [self.tableView beginUpdates];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.items.count-1 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            [self startMonitoringItem:newItem];
            [self persistItems];
        }];
    }
}

- (void)loadItems {
    self.items = [NSMutableArray array];
    NSArray *storedItems = [[NSUserDefaults standardUserDefaults] arrayForKey:kRWTStoredItemsKey];
    if (storedItems) {
        for (NSData *itemData in storedItems) {
            RWTItem *item = [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
            [self.items addObject:item];
        }
    }
}

- (void)persistItems {
    NSMutableArray *itemsDataArray = [NSMutableArray array];
    for (RWTItem *item in self.items) {
        NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:item];
        [itemsDataArray addObject:itemData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:itemsDataArray forKey:kRWTStoredItemsKey];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

//tableView:cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RWTItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item" forIndexPath:indexPath];
    // RWTItem *item = self.items[indexPath.row];
    RWTItem *item = [self.items objectAtIndex:indexPath.row];
    cell.item = item;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RWTItem *itemToRemove = [self.items objectAtIndex:indexPath.row];
        [self stopMonitoringItem:itemToRemove];

        [tableView beginUpdates];
        [self.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        [self persistItems];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RWTItem *item = [self.items objectAtIndex:indexPath.row];
    NSString *detailMessage = [NSString stringWithFormat:@"UUID: %@\nMajor: %d\nMinor: %d", item.uuid.UUIDString, item.majorValue, item.minorValue];
    UIAlertView *detailAlert = [[UIAlertView alloc] initWithTitle:@"Details" message:detailMessage delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [detailAlert show];
}


@end
