//
//  Example.m
//  bikepath
//
//  Created by Armen Vartan on 8/15/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "Example.h"
#import <Foundation/Foundation.h>

@implementation SampleClass

/* method returning the max between two numbers */
- (int)max:(int)num1 andNum2:(int)num2{
    /* local variable declaration */
    int result;
    
    if (num1 > num2)
    {
        result = num1;
    }
    else
    {
        result = num2;
    }
    
    return result;
}

@end


