//
//  DWNetworkCenter.m
//  Weather
//
//  Created by Scott Storkel on 3/28/15.
//  Copyright (c) 2015 Scott Storkel. All rights reserved.
//

#import "DWNetworkCenter.h"
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>


//static const NSString* APPID = @"58abcad7dc09bfcd9d42b1f7a0e02e96";
static const NSString* APPID = @"";

static const NSUInteger CACHE_SIZE_LIMIT = 10;  // cache weather for 10 locations at most


@interface DWCacheObject : NSObject
@property (nonatomic, strong) id       response;
@property (nonatomic, copy)   NSDate*  downloadTime;
@end

@implementation DWCacheObject
@end



@interface DWNetworkCenter ()
{
    AFHTTPRequestOperation* currentRequest;
    
    // Cache containing responses to API calls
    NSCache* cache;
}
@end


@implementation DWNetworkCenter

+ (instancetype)sharedInstance
{
    static DWNetworkCenter* theInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        theInstance = [self new];
    });
    
    return theInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        cache = [NSCache new];
        cache.countLimit = CACHE_SIZE_LIMIT;
    }
    return self;
}

- (void)getWeatherFromURL:(NSString*)url completion:(DWNetworkCompletionBlock)completionBlock
{
#ifdef DEBUG
    NSLog(@"%@", url);
#endif
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (currentRequest) {
        // Our simple weather app can only have one open network request at a time,
        // so if the user initiates a second request (ex: because the first request
        // is taking forever), we should cancel the existing request
        //
        [currentRequest cancel];
    }
    
    // Check to see if URL has been cached:
    DWCacheObject* obj = [cache objectForKey:url];
    if (obj) {
        if ([obj.downloadTime timeIntervalSinceNow] > -10 * 60) {
#ifdef DEBUG
            NSLog(@"Cache hit!");
#endif
            // cached response is still valid; pass it to the completion block
            // and exit
            completionBlock(obj.response, nil);
            return;
            
        }
    }
    
    currentRequest = [manager GET:url
                       parameters:nil
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              self->currentRequest = nil;
                              
                              // Cache response
                              DWCacheObject* co = [DWCacheObject new];
                              co.response = responseObject;
                              co.downloadTime = [NSDate new];
                              [self->cache setObject:co forKey:url];
                              
                              completionBlock(responseObject, nil);
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              self->currentRequest = nil;
                              completionBlock(nil, error);
                          }];
}

// Normalize city strings in an effort to improve cache efficiency. Ideally,
// we want "Mountain View,US" and "  mountain view , us  " to hash to the same
// cache entry. We separate the string into components using ',' as the divider,
// trim whitespace from the beginning and ends of the components, lowercase the
// strings, then reassemble.
//
// NOTE: we don't currently collapse spaces that appear between words in a single
// component. So, for example, "Mountain View" and "Mountain    View" are normalized
// to two different strings
//
- (NSString*)normalizeString:(NSString*)str
{
    NSArray* components = [str componentsSeparatedByString:@","];
    if (components.count == 0) {
        return str.lowercaseString;
    } else if (components.count == 1) {
        NSString* s = components[0];
        s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return s.lowercaseString;
    } else {
        NSMutableString* result = [NSMutableString new];
        
        for (int i=0; i < components.count-1; ++i) {
            NSString* s = components[i];
            s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [result appendString:s.lowercaseString];
            if (s.length > 0)
                [result appendString:@","];
        }
        
        NSString* s = components[components.count-1];
        s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [result appendString:s.lowercaseString];
        
        return result;
    }
}

- (void)getWeatherForCity:(NSString*)city completion:(DWNetworkCompletionBlock)completionBlock
{
    NSString* normalizedCity = [self normalizeString:city];
    NSString* encodedCity = [normalizedCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&APPID=%@&units=imperial", encodedCity, APPID];
    [self getWeatherFromURL:url completion:completionBlock];
}

- (void)getWeatherForLocation:(CLLocation*)location completion:(DWNetworkCompletionBlock)completionBlock
{
    NSString* url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=%@&units=imperial", location.coordinate.latitude, location.coordinate.longitude, APPID];
    [self getWeatherFromURL:url completion:completionBlock];
}


@end
