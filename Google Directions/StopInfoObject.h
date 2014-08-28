//
//  StopInfoObject.h
//  OnTime Mockup
//
//  Created by Anthony Taylor on 2013-05-15.
//  Copyright (c) 2013 404Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface StopInfoObject : NSObject


@property (nonatomic, copy) NSString *polyline_points;
@property (nonatomic, copy) NSString *html_instructions;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, readwrite) NSString *duration;
@property (nonatomic, readwrite) CLLocationCoordinate2D end_location;
@property (nonatomic, readwrite) CLLocationCoordinate2D start_location;
@property (nonatomic, copy) NSString *travel_mode;

@end
