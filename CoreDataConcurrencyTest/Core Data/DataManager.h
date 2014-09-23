//
//  DataManager.h
//  CoreDataConcurencyTest
//
//  Created by Scott Newman on 9/23/14.
//  Copyright (c) 2014 National Geographic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (DataManager *)sharedManager;

- (void)loadDataWithCompletion:(void(^)(NSError *error))completion;

@end
