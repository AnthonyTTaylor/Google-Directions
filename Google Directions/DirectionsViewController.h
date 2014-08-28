//
//  DirectionsViewController.h
//  OnTime Mockup
//
//  Created by Daniel Martyn on 04-20-2013.
//  Copyright (c) 2013 404Mobile. All rights reserved.
//


#import "NiftySearchView.h"

@interface DirectionsViewController : UIViewController <NiftySearchViewDelegate>

@property (strong, nonatomic) NSArray *results;
@property (nonatomic, strong) NiftySearchView *searchView;

@end
