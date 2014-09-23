//
//  SNCoreDataStack.h
//  CoreDataConcurencyTest
//
//  Created by Scott Newman on 9/23/14.
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
