//
//  SNContact.h
//  CoreDataConcurencyTest
//
//  Created by Scott Newman on 9/23/14.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SNGroup;

@interface SNContact : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSNumber * uniqueID;
@property (nonatomic, retain) NSSet *groups;
@end

@interface SNContact (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(SNGroup *)value;
- (void)removeGroupsObject:(SNGroup *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

@end
