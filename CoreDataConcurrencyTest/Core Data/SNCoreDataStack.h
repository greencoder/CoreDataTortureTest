//
//  CoreDataStack.h
//  Diary
//
//  Created by Scott Newman on 5/20/14.
//  Copyright (c) 2014 Newman Creative. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreData;

@interface SNCoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *mainQueueContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *privateQueueContext;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)defaultStack;

- (NSURL *)applicationDocumentsDirectory;

@end
