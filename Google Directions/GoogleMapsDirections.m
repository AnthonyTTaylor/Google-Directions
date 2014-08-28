//
//  GoogleMapsDirections.m
//  OnTime Mockup
//
//  Created by Anthony Taylor on 2013-04-24.
//  Copyright (c) 2013 404Mobile. All rights reserved.
//

#import "GoogleMapsDirections.h"
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "StopInfoObject.h"


@interface GoogleMapsDirections ()
@property (strong, nonatomic) NSURL *baseURL;
@property (strong, nonatomic) NSDictionary *directions;
//@property (strong, nonatomic) NSMutableArray *ReturnedSteps;

@end

@implementation GoogleMapsDirections

- (NSMutableArray *)requestDirectionsFrom:(NSString *)comingFrom destination:(NSString *)destination atTime:(NSString *)time{
    
    NSMutableArray *ReturnedSteps = [[NSMutableArray alloc] init];
    
    if(time == nil){
        time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
        time = [NSString stringWithFormat:@"%ld",unixTime];
    }
    NSString *googleDirectionsURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=Toronto&sensor=false&destination=77+howard+st+toronto&departure_time=1378039071&mode=transit"];
//    NSString *googleDirectionsURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&sensor=false&destination=%@&departure_time=%@&mode=transit",comingFrom, destination, time];
    NSURL *url = [NSURL URLWithString:googleDirectionsURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"URL: %@", url);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                        
        
                                                        
                                                        NSArray *routesArray = [responseObject objectForKey:@"routes"];
                                                        
                                                        if ([routesArray count]>0)
                                                        {
                                                            NSDictionary *routeDictionary = [routesArray objectAtIndex:0];
                                                            
                                                            NSDictionary *polylineDict = [routeDictionary objectForKey:@"overview_polyline"];
                                                            self.polyline_overview = [polylineDict objectForKey:@"points"];
                                                            
                                                            NSArray *legsArray = [routeDictionary objectForKey:@"legs"];
                                                            NSDictionary *legsDictionary = [legsArray objectAtIndex:0];
                                                            
                                                            NSDictionary *distanceDictionary = [legsDictionary objectForKey:@"distance"];
                                                            self.distance = [distanceDictionary objectForKey:@"text"];
                                                            
                                                            NSDictionary *timeDictionary = [legsDictionary objectForKey:@"duration"];
                                                            self.duration = [timeDictionary objectForKey:@"text"];
                                                            
                                                            NSDictionary *arrivalTimeDictionary = [legsDictionary objectForKey:@"arrival_time"];
                                                            self.arrivalTime = [arrivalTimeDictionary objectForKey:@"time"];
                                                            
                                                            NSDictionary *departureTimeDictionary = [legsDictionary objectForKey:@"departure_time"];
                                                            self.departureTime = [departureTimeDictionary objectForKey:@"time"];
                                                            
                                                            NSDictionary *startGPSdict = [legsDictionary objectForKey:@"start_location"];
                                                            [[self.start_location objectAtIndex:0] addObject:[startGPSdict objectForKey:@"lat"]];
                                                            [[self.start_location objectAtIndex:1] addObject:[startGPSdict objectForKey:@"lng"]];
                                                            
                                                            NSDictionary *endGPSdict = [legsDictionary objectForKey:@"end_location"];
                                                            [[self.start_location objectAtIndex:0] addObject:[endGPSdict objectForKey:@"lat"]];
                                                            [[self.start_location objectAtIndex:1] addObject:[endGPSdict objectForKey:@"lng"]];
                                                            
                                                            NSArray *stepsArray = [legsDictionary objectForKey:@"steps"];
                                                            for (int i=0; i<[stepsArray count]; i++)
                                                            {
                                                                NSDictionary *stepsdict = [stepsArray objectAtIndex:i];
                                                                NSArray *insideStepArray = [stepsdict objectForKey:@"steps"];
                                                                for (int i=0; i<[insideStepArray count]; i++) {
                                                                    
                                                                    
//                                                                    NSMutableArray *stepsArray = [NSMutableArray array];
                                                                    
                                                                    NSDictionary *insideStepsDictionary = [insideStepArray objectAtIndex:i];
                                                                    
                                                                    StopInfoObject *stopObject  = [[StopInfoObject alloc] init];
                                                                    
                                                                    stopObject.polyline_points  = [[insideStepsDictionary objectForKey:@"polyline"] objectForKey:@"points"];
                                                                    stopObject.distance         = [[insideStepsDictionary objectForKey:@"distance"] objectForKey:@"text"];
                                                                    stopObject.duration         = [[insideStepsDictionary objectForKey:@"duration"] objectForKey:@"text"];
                                                                    
                                                                    
                                                                    stopObject.end_location = CLLocationCoordinate2DMake([[[insideStepsDictionary objectForKey:@"end_location"] objectForKey:@"lat"] floatValue],
                                                                                                                         [[[insideStepsDictionary objectForKey:@"end_location"] objectForKey:@"lng"] floatValue]);
                                                                    
                                                                    stopObject.start_location = CLLocationCoordinate2DMake([[[insideStepsDictionary objectForKey:@"start_location"] objectForKey:@"lat"] floatValue],
                                                                                                                           [[[insideStepsDictionary objectForKey:@"start_location"] objectForKey:@"lng"] floatValue]);
                                                                    
                                                                    
                                                                    
                                                                    stopObject.travel_mode        = [insideStepsDictionary objectForKey:@"travel_mode"];
                                                                    
                                                                    
                                                                    [ReturnedSteps addObject:stopObject];
                                                                    
                                                                        //NSLog(@"Logging stepsarray %@", ReturnedSteps);
                                                                    
                                                                    self.stepsTitle = [insideStepsDictionary objectForKey:@"html_instructions"];
                                                                    self.polyline_points = [[insideStepsDictionary objectForKey:@"polyline"] objectForKey:@"points"];
                                                                    NSLog(@"StepsArray: %@", self.stepsTitle);
                                                                    //NSLog(@"StepsPoints: %@", self.polyline_points);
                                                                    
                                                                }
                                                                
                                                                NSDictionary *endlattdict = [stepsdict objectForKey:@"end_location"];
                                                                //                                                                float lang1 = [[endlattdict objectForKey:@"lat"] floatValue];
                                                                //                                                                float lng1 = [[endlattdict objectForKey:@"lng"] floatValue];
                                                                
                                                                NSString *instStr = [stepsdict objectForKey:@"html_instructions"];
                                                                //NSLog(@"html_instructions%@",instStr);
                                                                
                                                                
                                                                
                                                             //return ReturnedSteps;
                                                            }
                                                        }else{
                                                            NSLog(@"No Route Returned");
                                                        }
                                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"GoogleMaps Directions API Returned" object:self];
                                                    }
                                     failure:nil];
    // 5
    [operation start];
    
    //return self.directions;
    return ReturnedSteps;
    
}
- (GMSMutablePath *)decodePolylineWithEncodedString:(NSString *)encodedString
{
    GMSMutablePath *path = [GMSMutablePath path];
    NSUInteger length = [encodedString length];
    NSInteger index = 0;
    //NSMutableArray *points = [NSMutableArray array];
    CGFloat lat = 0.0f;
    CGFloat lng = 0.0f;
    
    while (index < length) {
        
        // Temorary variable to hold each ASCII byte.
        int b = 0;
        
        // The encoded polyline consists of a latitude value followed by a
        // longitude value. They should always come in pair. Read the
        // latitude value first.
        int shift = 0;
        int result = 0;
        
        do {
            
            // If index exceded lenght of encoding, finish 'chunk'
            if (index >= length) {
                
                b = 0;
                
            } else {
                
                // The '[encodedPolyline characterAtIndex:index++]' statement resturns the ASCII
                // code for the characted at index. Subtract 63 to get the original
                // value. (63 was added to ensure proper ASCII characters are displayed
                // in the encoded plyline string, wich id 'human' readable)
                b = [encodedString characterAtIndex:index++] - 63;
                
            }
            
            // AND the bits of the byte with 0x1f to get the original 5-bit 'chunk'.
            // Then left shift the bits by the required amount, wich increases
            // by 5 bits each time.
            // OR the value into results, wich sums up the individual 5-bit chunks
            // into the original value. Since the 5-bit chunks were reserved in
            // order during encoding, reading them in this way ensures proper
            // summation.
            result |= (b & 0x1f) << shift;
            shift += 5;
            
        } while (b >= 0x20); // Continue while the read byte is >= 0x20 since the last 'chunk'
        // was nor OR'd with 0x20 during the conversion process. (Signals the end).
        
        // check if negative, and convert. (All negative values have the last bit set)
        CGFloat dlat = (result & 1) ? ~(result >> 1) : (result >> 1);
        
        //Compute actual latitude since value is offset from previous value.
        lat += dlat;
        
        // The next value will correspond to the longitude for this point.
        shift = 0;
        result = 0;
        
        do {
            
            // If index exceded lenght of encoding, finish 'chunk'
            if (index >= length) {
                
                b = 0;
                
            } else {
                
                b = [encodedString characterAtIndex:index++] - 63;
                
            }
            result |= (b & 0x1f) << shift;
            shift += 5;
            
        } while (b >= 0x20);
        
        CGFloat dlng = (result & 1) ? ~(result >> 1) : (result >> 1);
        lng += dlng;
        
        // The actual latitude and longitude values were multiplied by
        // 1e5 before encoding so that they could be converted to a 32-bit
        //integer representation. (With a decimal accuracy of 5 places)
        // Convert back to original value.
        //        [points addObject:[NSString stringWithFormat:@"%f", (lat * 1e-5)]];
        //        [points addObject:[NSString stringWithFormat:@"%f", (lng * 1e-5)]];
        
        [path addCoordinate:CLLocationCoordinate2DMake(lat * 1e-5, lng * 1e-5)];
        
    }
    
    return path;
    
}

@end
