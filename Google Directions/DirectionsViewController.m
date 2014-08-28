//
//  DirectionsViewController.m
//  OnTime Mockup
//
//  Created by Daniel Martyn on 04-20-2013.
//  Copyright (c) 2013 404Mobile. All rights reserved.
//

#import "DirectionsViewController.h"
#import "GoogleMapsDirections.h"
#import <GoogleMaps/GoogleMaps.h>
#import "NiftySearchView.h"

@class GoogleMapsDirections;

@interface DirectionsViewController ()
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) GMSPolyline *polyline;
@property (strong, nonatomic) GoogleMapsDirections *directionsObject;
@property (strong, nonatomic) NSString *startLocation;
@property (strong, nonatomic) NSString *endLocation;
@property (strong, nonatomic) NSMutableArray *route;
@end

@implementation DirectionsViewController{
    GMSMapView *mapView_;
    
}

- (void)loadView {
    [super viewDidLoad];
    

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:43.67130
                                                            longitude:-79.37542000000001
                                                                 zoom:13];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    
    self.searchView = [[NiftySearchView alloc] initWithFrame:CGRectMake(0, -76, 320, 76)];
    self.searchView.delegate = self;
    self.searchView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.searchView];
    
	// Do any additional setup after loading the view.
    
    self.directionsObject = [[GoogleMapsDirections alloc] init];
    [self route];
    
    
    
    
}

- (void) receiveSuccessNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"GoogleMaps Directions API Returned"])
        NSLog (@"Successfully received the GoogleMaps Directions API Returned notification!");
            self.polyline = nil;
    if (!_route.lastObject){
        int x = 0;
        NSString *pathString = [_route[x] objectForKey:@"polyline_points"];
        GMSPath *path = [GMSPath pathFromEncodedPath:pathString];
        self.polyline = [GMSPolyline polylineWithPath:path];//[self.directionsObject decodePolylineWithEncodedString:self.directionsObject.polyline_points]];
        
        self.polyline.map = mapView_;
        self.polyline.strokeWidth = 5.f;
        self.polyline.geodesic = YES;
    }
    
        

}
- (IBAction)showNiftySearchView:(id)sender
{
    if ([self.searchView.startTextField.text isEqualToString:NSLocalizedString(@"Current Location", nil)]) {
        self.searchView.startTextField.textColor = [UIColor blueColor];
    } else {
        self.searchView.startTextField.textColor = [UIColor blackColor];
    }
    if ([self.searchView.finishTextField.text isEqualToString:NSLocalizedString(@"Current Location", nil)]) {
        self.searchView.finishTextField.textColor = [UIColor blueColor];
    } else {
        self.searchView.finishTextField.textColor = [UIColor blackColor];
    }
    
    CGRect searchBarFrame = self.searchView.frame;
    searchBarFrame.origin.y = 65;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.searchView.frame = searchBarFrame;
                     }
                     completion:^(BOOL completion) {
                         [self.searchView.startTextField becomeFirstResponder];
                     }];
}

#pragma mark -
#pragma mark NiftySearchView Delegate Methods

- (void)startBookmarkButtonClicked:(UITextField *)textField
{
    NSLog(@"startBookmarkButtonClicked");
}
- (void)finishBookmarkButtonClicked:(UITextField *)textField
{
    NSLog(@"finishBookmarkButtonClicked");
}

- (void)niftySearchViewResigend
{
    NSLog(@"resignSearchView");
    [self hideSearchBar:self];
}

//- (void)routeButtonClicked:(UITextField *)startTextField finishTextField:(UITextField *)finishTextField
//{
//    NSLog(@"routeButtonClicked");
//    
//    NSString *start = [NSString stringWithFormat:@"%@",startTextField.text];
//    NSString *end = [NSString stringWithFormat:@"%@",finishTextField.text];
//    
//    start = [start stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    end = [end stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    
//    [self.directionsObject requestDirectionsFrom:start destination:end atTime:@"1366581312"];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveSuccessNotification:) name:@"GoogleMaps Directions API Returned" object:nil];
//    
//}

- (NSMutableArray *)route
{
    NSLog(@"routeButtonClicked");
    
    NSString *start = [NSString stringWithFormat:@"777 young st toronto"];
    NSString *end = [NSString stringWithFormat:@"77 Howard St Toronto"];
    
    start = [start stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    end = [end stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    
    _route = [self.directionsObject requestDirectionsFrom:start destination:end atTime:@"1366581312"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveSuccessNotification:) name:@"GoogleMaps Directions API Returned" object:nil];
    
    //NSLog(@"Route Array %@", route);
    return _route;
}


- (IBAction)hideSearchBar:(id)sender
{
    [self.searchView.startTextField resignFirstResponder];
    [self.searchView.finishTextField resignFirstResponder];
    CGRect searchBarFrame = self.searchView.frame;
    searchBarFrame.origin.y = -76;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.searchView.frame = searchBarFrame;
                     }
                     completion:^(BOOL completion){
                         
                     }];
}

     
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
