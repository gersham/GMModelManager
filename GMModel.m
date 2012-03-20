//
//  GMModel.m
//
//  Created by Gersham Meharg on 11-12-08.
//  Copyright (c) 2011 Gersham Meharg. All rights reserved.
//

#import "GMModel.h"

@implementation GMModel
@synthesize values = _values;
@synthesize uuid = _uuid;

+ (NSString *)uuidFromValues:(NSDictionary *)values {
    if ([values valueForKey:@"id"]) {
        return [values valueForKey:@"id"];
    } else if ([values valueForKey:@"uuid"]) {
        return [values valueForKey:@"uuid"];
    } else {
        return nil;
    }
}

- (NSMutableDictionary *)values {
    if (_values == nil) 
        _values = [NSMutableDictionary dictionary];
    return _values;
}

- (void)updateWithValues:(NSDictionary *)values {
    self.values = [NSMutableDictionary dictionaryWithDictionary:values];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [_values setValue:value forKey:key];
}

- (id)valueForKey:(NSString *)key {
    return [_values valueForKey:key];
}

- (id)valueForKeyPath:(NSString *)keyPath {
    return [_values valueForKeyPath:keyPath];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ETModel %@", self.uuid];
}

# pragma mark - Dynamic Properties

- (id)dictionaryValueForKey:(NSString *) key {
    return [self.values objectForKey:key];
}

static NSString *accessorGetter(id self, SEL _cmd) {
    return [self dictionaryValueForKey:NSStringFromSelector(_cmd)];
}

- (void)setDictionaryValue:(id)value forKey:(NSString *)key {
    [self.values setValue:value forKey:key];
}

static void accessorSetter(id self, SEL _cmd, id newValue)
{
    NSString *method = NSStringFromSelector(_cmd);
    NSString *anID = [[[method stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""] lowercaseString] stringByReplacingOccurrencesOfString:@":" withString:@""];
    [self setDictionaryValue:newValue forKey:anID];
}

+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
    NSString *method = NSStringFromSelector(aSEL);
    
    if ([method hasPrefix:@"set"]) {
        class_addMethod([self class], aSEL, (IMP) accessorSetter, "v@:@");
        return YES;
    } else {
        class_addMethod([self class], aSEL, (IMP) accessorGetter, "@@:");
        return YES;
    }
    return [super resolveInstanceMethod:aSEL];
}

@end

