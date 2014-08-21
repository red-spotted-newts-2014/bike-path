//
//  AddressGeocoderFactory.m
//  bikepath
//
//  Created by Farheen Malik on 8/19/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "AddressGeocoderFactory.h"

@implementation AddressGeocoderFactory

+ (NSString*)translateAddresstoUrl:(NSString*)addressString {
    NSArray *addressItems = [addressString componentsSeparatedByString:@" "];
    NSMutableArray *addressCombinedArray = [[NSMutableArray alloc] init];
    for (NSString *addressPart in addressItems){
        [addressCombinedArray addObject:[[NSString alloc] initWithFormat:@"%@+", addressPart]];
    }
    NSString *addressCombinedString = [addressCombinedArray componentsJoinedByString:@""];
    NSString *kGoogleGeocodeApiUrl = @"https://maps.googleapis.com/maps/api/geocode/json?address=";
    NSString *kGoogleGeocodeApiKey = @"AIzaSyAxaqfMyyc-WSrvsWP_jF2IUaTZVjkMlFo";
    NSString *addressForJson = [[NSString alloc] initWithFormat:@"%@%@&key=%@", kGoogleGeocodeApiUrl, addressCombinedString, kGoogleGeocodeApiKey];    
    NSLog(@"address for json: %@", addressForJson);

    return addressForJson;
}

+(NSMutableDictionary *) processTheJson:(NSData*)data {
    NSMutableDictionary *geocodedDictionary = [[NSMutableDictionary alloc] init];

    NSDictionary *addressJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSDictionary *resultsPart = [addressJson objectForKey:@"results"];
    NSArray *addressParts = [resultsPart valueForKey:@"geometry"];
    NSString *formattedAddress = [resultsPart valueForKey:@"formatted_address"];
    
    for(id info in addressParts){
        NSDictionary *addressPartsLocation = (NSDictionary *)[info valueForKey:@"location"];
        NSString *lati = [addressPartsLocation objectForKey:@"lat"];
        NSString *longi = [addressPartsLocation objectForKey:@"lng"];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[lati doubleValue]
                                                          longitude:[longi doubleValue]];
        
        [geocodedDictionary setObject:lati forKey:@"latitude"];
        [geocodedDictionary setObject:longi forKey:@"longitude"];
        [geocodedDictionary setObject:location forKey:@"position"];
        [geocodedDictionary setObject:formattedAddress forKey:@"address"];
    }
    return geocodedDictionary;
}

+ (NSMutableDictionary*)translateUrlToGeocodedObject:(NSString*)addressUrl {
    NSMutableDictionary *geocodedDictionary = NULL;
    NSURL *url = [NSURL URLWithString: addressUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSError *error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: &error];
    geocodedDictionary = [self processTheJson:data];
    return geocodedDictionary;
}

@end
