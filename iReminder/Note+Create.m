//
//  Note+Create.m
//  iReminder
//
//  Created by Yuntian liu on 11/30/13.
//  Copyright (c) 2013 Bojun Wang. All rights reserved.
//

#import "Note+Create.h"

@implementation Note (Create)
+(Note*)noteWithDictionary:(NSDictionary*)noteDictionary inManagedObjectContext:(NSManagedObjectContext*)context ifUpdate:(BOOL)update;
{
    Note* note = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", [noteDictionary[@"name"] description]];
    //execute fetch request
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
        // handle error
        NSLog(@"nil means fetch failed; more than one impossible (unique!)");
    }else if(![matches count]){
       // NSLog(@"no match found, so create a new entity");
        note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
        note.name = [noteDictionary[@"name"] description];
        if (noteDictionary[@"details"]) {
            note.details = [noteDictionary[@"details"] description];
        }else{
            note.details = [NSString stringWithFormat:@" "];
        }
        note.createDate = noteDictionary[@"createDate"];
        note.dueDate = noteDictionary[@"dueDate"];
        note.progress = noteDictionary[@"progress"];
        note.locationLa = noteDictionary[@"locationLa"];
        note.locationLo = noteDictionary[@"locationLo"];
        note.photo = noteDictionary[@"photo"];
      //  NSLog(@"and done");
        
    }else{
      //  NSLog(@"found exactly one match");
        if (update) {
            note = [matches lastObject];
            [context deleteObject:note];
            //found one with exact name and wish to update this one in core data
            Note* note2 = nil;
            note2 = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
            note2.name = [noteDictionary[@"name"] description];
            note2.details = [noteDictionary[@"details"] description];
            note2.createDate = noteDictionary[@"createDate"];
            note2.dueDate = noteDictionary[@"dueDate"];
            note2.progress = noteDictionary[@"progress"];
            note2.locationLa = noteDictionary[@"locationLa"];
            note2.locationLo = noteDictionary[@"locationLo"];
            note2.photo = noteDictionary[@"photo"];
            
        }else{
            note = [matches lastObject];
        }
    }
    
    return note;
}


@end
