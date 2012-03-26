//
//  GMModel.h
//
//  Created by Gersham Meharg on 11-12-08.
//  Copyright (c) 2011 Gersham Meharg. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <objc/runtime.h>

@interface GMModel : NSObject

@property (nonatomic, strong) NSMutableDictionary *values;
@property (nonatomic, strong) NSString *uuid;

+ (GMModel *)objectWithValues:(NSDictionary *)values createIfNotFound:(BOOL)create;
+ (NSArray *)objectArrayFromArray:(NSArray *)array;
+ (NSString *)uuidFromValues:(NSDictionary *)values;

- (void)updateWithValues:(NSDictionary *)values;
- (void)setValue:(id)value forKey:(NSString *)key;
- (id)valueForKey:(NSString *)key;
- (id)valueForKeyPath:(NSString *)keyPath;
- (NSArray *)parseValuesFromArray:(NSArray *)array;

@end

