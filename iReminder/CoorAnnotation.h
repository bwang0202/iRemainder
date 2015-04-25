//
//  CoorAnnotation.h
//  MapFeature
//
//  Created by Yuntian liu on 11/7/13.
//  Copyright (c) 2013 Bojun Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CoorAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic)NSNumber* la;
@property (strong, nonatomic)NSNumber* lo;
@property (strong, nonatomic)NSString* title;
@property (strong, nonatomic)NSString* subtitle;

-(id)initWithCoordinateLa: (NSNumber*)la andWithLo : (NSNumber*)lo;


@end
