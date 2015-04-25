//
//  CoorAnnotation.m
//  MapFeature
//
//  Created by Yuntian liu on 11/7/13.
//  Copyright (c) 2013 Bojun Wang. All rights reserved.
//

#import "CoorAnnotation.h"

@implementation CoorAnnotation

//designated initializer
-(id)initWithCoordinateLa:(NSNumber*)la andWithLo:(NSNumber*)lo
{
    self = [super init];
    self.la = la;
    self.lo = lo;
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.la doubleValue];
    coordinate.longitude = [self.lo doubleValue];
    return coordinate;
}

@end
