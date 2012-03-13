//
//  GMModelManager.m
//
//  Created by Gersham Meharg on 11-12-08.
//  Copyright (c) 2011 Gersham Meharg. All rights reserved.
//

#import "GMModelManager.h"
#import "GMModel.h"

@implementation GMModelManager
static GMModelManager *shared = nil;

@synthesize cache = _cache;
@synthesize cacheSize = _cacheSize;

- (void)cacheModelObject:(GMModel *)object {
    if (object.uuid == nil) 
        return;
    if (_cache == nil) {
        self.cache = [[NSCache alloc] init];
        self.cache.countLimit = _cacheSize;
    }    
    [_cache setObject:object forKey:object.uuid];
}

- (GMModel *)objectForUUID:(NSString *)uuid {
    return [_cache objectForKey:uuid];
}

#pragma mark Singleton
+ (id)shared {
	@synchronized(self) {
		if(shared == nil)
			shared = [[super allocWithZone:NULL] init];
	}
	return shared;
}

- (id)init {
	if ((self = [super init])) {
    self.cacheSize = 1000;
	}
	return self;
}

@end
