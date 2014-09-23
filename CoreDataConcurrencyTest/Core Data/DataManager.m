//
//  DataManager.m
//  CoreDataConcurencyTest
//
//  Created by Scott Newman on 9/23/14.
//  Copyright (c) 2014 National Geographic. All rights reserved.
//

#import "DataManager.h"
#import "SNCoreDataStack.h"

#import "SNGroup.h"
#import "SNContact.h"

@implementation DataManager

+ (DataManager *)sharedManager
{
    static DataManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _sharedManager = [[DataManager alloc] init];
    });
    return _sharedManager;
}

- (void)loadDataWithCompletion:(void(^)(NSError *error))completion
{
    NSLog(@"Loading Data");
    
    SNCoreDataStack *coreDataStack = [SNCoreDataStack defaultStack];

    // Apple docs recommend setting the undo manager to nil for bulk inserts
    coreDataStack.privateQueueContext.undoManager = nil;
    
    // This is blocking the UI for some reason
    [coreDataStack.privateQueueContext performBlock:^{
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        NSArray *contacts = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        
        // First go through the data and get all the groups so we
        // can create their managed objects first. This way, we don't
        // have to do a find-or-create pattern for each one
        NSMutableSet *groups = [[NSMutableSet alloc] init];
        for (NSDictionary *contactDict in contacts)
        {
            for (NSString *groupName in contactDict[@"groups"])
            {
                [groups addObject:groupName];
            }
        }
        
        // Now that we have a list of all the groups, create managed object
        // instances for them and index them in a dictionary so we can
        // find them when we are creating contacts
        NSMutableDictionary *groupNames = [[NSMutableDictionary alloc] init];
        
        for (NSString *groupName in groups)
        {
            SNGroup *groupObject = [NSEntityDescription insertNewObjectForEntityForName:@"SNGroup"
                                                                 inManagedObjectContext:coreDataStack.privateQueueContext];
            groupObject.name = groupName;
            // Now save a reference to the object for later
            groupNames[groupName] = groupObject;
        }
        
        // Create a formatter so we can turn our date strings into NSDate objects
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        // Now go through all the contacts again, this time to create
        // managed object instances for the contacts
        for (NSDictionary *contactDict in contacts)
        {
            SNContact *contactObject = [NSEntityDescription insertNewObjectForEntityForName:@"SNContact"
                                                                     inManagedObjectContext:coreDataStack.privateQueueContext];
            
            contactObject.name = contactDict[@"name"];
            contactObject.uniqueID = contactDict[@"id"];
            contactObject.birthday = [formatter dateFromString:contactDict[@"birthdate"]];
            
            // Now loop over the groups and find the managed objects for them
            for (NSString *groupName in contactDict[@"groups"])
            {
                SNGroup *groupObject = groupNames[groupName];
                [contactObject addGroupsObject:groupObject];
            }
            
        }
        
        // Saving to the private context will cause a notification to be
        // sent to the main context
        NSError *error = nil;
        [coreDataStack.privateQueueContext save:&error];
        
        completion(error);
        NSLog(@"Done saving");
        
    }];
    
}


@end
