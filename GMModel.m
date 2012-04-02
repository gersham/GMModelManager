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

static NSMutableDictionary *camelCaseStrings = nil;

+ (NSString *)camelCaseString:(NSString *)string {
    
    if (camelCaseStrings == nil)
        camelCaseStrings = [NSMutableDictionary dictionary];
    
    if ([camelCaseStrings objectForKey:string])
        return [camelCaseStrings objectForKey:string];
    
    NSMutableString *output = [NSMutableString string];
    BOOL makeNextCharacterUpperCase = NO;
    for (NSInteger idx = 0; idx < [string length]; idx += 1) {
        unichar c = [string characterAtIndex:idx];
        if (c == '_') {
            makeNextCharacterUpperCase = YES;
        } else if (makeNextCharacterUpperCase) {
            [output appendString:[[NSString stringWithCharacters:&c length:1] uppercaseString]];
            makeNextCharacterUpperCase = NO;
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    
    [camelCaseStrings setObject:output forKey:string];
    
    return output;
}

+ (GMModel *)objectWithValues:(NSDictionary *)values createIfNotFound:(BOOL)create {
    return nil;
}

+ (NSArray *)objectArrayFromArray:(NSArray *)array {
    return nil;
}

+ (NSString *)uuidFromValues:(NSDictionary *)values {
    if ([values valueForKey:@"id"]) {
        return [values valueForKey:@"id"];
    } else if ([values valueForKey:@"uuid"]) {
        return [values valueForKey:@"uuid"];
    } else {
        return nil;
    }
}

- (void)setValues:(NSMutableDictionary *)values {
    if (_values == nil) 
        _values = [NSMutableDictionary dictionaryWithCapacity:values.count];
    
    if (values == nil)
        return;

    for (NSString *key in values.allKeys) {
        [self setValue:[values valueForKey:key] forKey:key];
    }
}

- (NSMutableDictionary *)values {
    if (_values == nil) 
        _values = [NSMutableDictionary dictionary];
    return _values;
}

- (void)updateWithValues:(NSDictionary *)values {
    if (_values == nil) 
        _values = [NSMutableDictionary dictionaryWithCapacity:values.count];

    if (values == nil)
        return;
    
    for (NSString *key in values.allKeys) {
        [self setValue:[values valueForKey:key] forKey:key];
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
        
    NSString *camelKey = [GMModel camelCaseString:key];
        
    if (_values == nil) 
        _values = [NSMutableDictionary dictionary];

    if (value == nil || [value isEqual:[NSNull null]]) {
        if ([_values objectForKey:camelKey]) {
            [_values removeObjectForKey:camelKey];
        }
        
    } else if ([camelKey isEqualToString:@"id"]) {
        self.uuid = value;
        
    } else if ([camelKey isEqualToString:@"uuid"]) {
        self.uuid = value;
        
    } else if ([value isKindOfClass:[NSArray class]]) {
        [_values setValue:[self parseValuesFromArray:value] forKey:camelKey];
                
    } else {
        [_values setValue:value forKey:camelKey];
    }
}

- (NSArray *)parseValuesFromArray:(NSArray *)array {
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (id item in array) {
        if (![item isKindOfClass:[NSDictionary dictionary]]) {
                        
            NSDictionary *dictionary = [NSMutableDictionary dictionary];
            for (NSString *key in [(NSDictionary *)item allKeys]) {
                
                id value = [(NSDictionary *)item valueForKey:key];
                
                if (value == nil || [value isEqual:[NSNull null]]) 
                    continue;
                
                if ([value isKindOfClass:[NSArray class]]) {
                    [dictionary setValue:[self parseValuesFromArray:value] forKey:key];
                    
                } else {
                    [dictionary setValue:value forKey:key];
                }
            }
            [result addObject:dictionary];
            
        } else {
            [result addObject:item];
        }
    }
    return result;
}

- (id)valueForKey:(NSString *)key {
    return [_values valueForKey:key];
}

- (id)valueForKeyPath:(NSString *)keyPath {
    return [_values valueForKeyPath:keyPath];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"GMModel %@", self.uuid];
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

