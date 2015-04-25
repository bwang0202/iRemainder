//
//  Note.h
//  iReminder
//
//  Created by Yuntian liu on 11/30/13.
//  Copyright (c) 2013 Bojun Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * locationLa;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSNumber * progress;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSNumber * locationLo;

@end
