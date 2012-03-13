//
//  GMModelManager.h
//
//  Created by Gersham Meharg on 11-12-08.
//  Copyright (c) 2011 Gersham Meharg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GMModel;

#define SharedModelManager \
((GMModelManager *)[GMModelManager shared])

@interface GMModelManager : NSObject

+ (GMModelManager *)shared;
- (void)cacheModelObject:(GMModel *)object;
- (GMModel *)objectForUUID:(NSString *)uuid;

@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, assign) NSInteger cacheSize;

@end
