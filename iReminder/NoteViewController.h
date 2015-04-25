//
//  NoteViewController.h
//  iReminder
//
//  Created by Yuntian liu on 11/30/13.
//  Copyright (c) 2013 Bojun Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Note.h"

@interface NoteViewController : UIViewController<MKMapViewDelegate>

@property (strong, nonatomic)Note* note;
@property(strong, nonatomic)NSManagedObjectContext* context;

@end
