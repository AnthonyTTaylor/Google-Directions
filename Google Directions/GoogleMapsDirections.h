//
//  GoogleMapsDirections.h
//  OnTime Mockup
//
//  Created by Anthony Taylor on 2013-04-24.
//  Copyright (c) 2013 404Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>



@interface GoogleMapsDirections : NSObject 

- (NSMutableArray *)requestDirectionsFrom:(NSString *)comingFrom destination:(NSString *)destination atTime:(NSString *)time;
- (GMSMutablePath *)decodePolylineWithEncodedString:(NSString *)encodedString;

@property (nonatomic, strong) NSArray *results;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *arrivalTime;
@property (nonatomic, copy) NSString *departureTime;
@property (nonatomic, copy) NSArray *end_location;
@property (nonatomic, copy) NSArray *start_location;
@property (nonatomic, copy) NSArray *stepsTitle;
@property (nonatomic, copy) NSString *polyline_points;
@property (nonatomic, strong) NSString *polyline_overview;
@property (nonatomic, copy) NSString *html_instructions;

@end
