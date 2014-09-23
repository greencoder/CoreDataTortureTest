//
//  DataManager.h
//  CoreDataConcurencyTest
//
//  Created by Scott Newman on 9/23/14.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (DataManager *)sharedManager;

- (void)loadDataWithCompletion:(void(^)(NSError *error))completion;

@end
