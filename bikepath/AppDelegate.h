//
//  AppDelegate.h
//  bikepath
//
//  Created by Vivek George, Molly Huerster, Farheen Malik and Armen Vartan on 8/14/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSURLCache *citiBikeCache;
@property (nonatomic, retain) NSArray *stationJSON;
//@property (strong, nonatomic) id<UIApplicationDelegate>delegate;
-(NSArray*)loadCitiBikeData;

@end
