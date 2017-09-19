//
//  HBCityStore.m
//  CleanWeather
//
//  Created by SWRD on 9/5/17.
//  Copyright © 2017 Roy. All rights reserved.
//

#import "HBCityStore.h"
#import "HBWeatherInfo.h"

@interface HBCityStore ()

@property (nonatomic) NSMutableArray *privateCitys;

@end

@implementation HBCityStore

+ (instancetype)sharedStore{
    static HBCityStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)initPrivate{
    self = [super init];
    
    if (self) {
        NSString *path = [self cityFilePath];
        NSLog(@"savedCityPath = %@",path);
        _privateCitys = [NSMutableArray arrayWithContentsOfFile:path];
        
        if (!_privateCitys) {
            _privateCitys = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}

- (BOOL)addNewCity:(NSString *)city{
    [self.privateCitys addObject:city];
    
    NSString *path = [self cityFilePath];
    
    return [self.privateCitys writeToFile:path atomically:YES];
}

- (BOOL)removeCity:(NSString *)city{
    [self.privateCitys removeObjectIdenticalTo:city];
    
    NSString *path = [self cityFilePath];
    
    return [self.privateCitys writeToFile:path atomically:YES];
}

- (NSArray *)allCitys{
    return self.privateCitys;
}

- (NSString *)cityFilePath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"SavedCitys.plist"];
}

- (NSString *)singleCityWeatherPath:(NSString *)city{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:city];
}

@end
