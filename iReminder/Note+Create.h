//
//  Note+Create.h
//  iReminder
//
//  Created by Yuntian liu on 11/30/13.
//  Copyright (c) 2013 Bojun Wang. All rights reserved.
//

#import "Note.h"

@interface Note (Create)

+(Note*)noteWithDictionary:(NSDictionary*)noteDictionary inManagedObjectContext:(NSManagedObjectContext*)context ifUpdate:(BOOL)update;
@end
