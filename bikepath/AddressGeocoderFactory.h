//
//  AddressGeocoderFactory.h
//  bikepath
//
//  Created by Farheen Malik on 8/19/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPGooglePlacesAutocomplete.h"
#import <UIKit/UIKit.h>

@interface AddressGeocoderFactory : NSObject


+ (NSString*)translateAddresstoUrl:(NSString*)addressString;

+ (NSMutableDictionary*)translateUrlToGeocodedObject:(NSString*)url;

@end
