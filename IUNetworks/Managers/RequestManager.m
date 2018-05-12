//
//  RequestManager.m
//  IUNetworks Task
//
//  Created by Artashes Ghazaryan on 5/11/18.
//  Copyright © 2018 Artashes Ghazaryan. All rights reserved.
//

#import "RequestManager.h"
#import "JSON.h"
#import "XMLConverter.h"

static NSString *apiUrlWithJSON = @"https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=97ba815035ae4381b223377b2df975ab";
static NSString *apiUrlWithXML = @"http://feeds.bbci.co.uk/news/video_and_audio/technology/rss.xml";

@implementation RequestManager


#pragma mark - Get JSON URL

+ (void)getInfoWithJSONCompletion:( void (^) (id response, NSError *error))handler {
    
    NSMutableURLRequest *request = [self requestForGetMethodJSON];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self executeRequest:request withCompletion:handler];
}

#pragma mark - Get XML URL

+ (void)getInfoWithXMLCompletion:( void (^) (id response, NSError *error))handler {
    
    NSMutableURLRequest *request = [self requestForGetMethodXML];
    [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    [self executeRequestXML:request withCompletion:handler];
}


#pragma mark - Request helpers

+ (void)executeRequestXML:(NSURLRequest*)request withCompletion:( void (^) (id response, NSError *error))handler  {
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [XMLConverter convertXMLData:data completion:^(BOOL success, NSMutableDictionary *dictionary, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                handler(dictionary, error);
            });
         }];

      
    }] resume];
}

+ (void)executeRequest:(NSURLRequest*)request withCompletion:( void (^) (id response, NSError *error))handler  {

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            handler([data objectFromJSONData], error);
        });
    }] resume];
}


+ (NSMutableURLRequest *)requestForGetMethodJSON {
    
    NSString* url = [NSString stringWithFormat:@"%@", apiUrlWithJSON];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    [request setHTTPMethod:@"GET"];
    
    return request;
}

+ (NSMutableURLRequest *)requestForGetMethodXML {
    
    NSString* url = [NSString stringWithFormat:@"%@", apiUrlWithXML];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    [request setHTTPMethod:@"GET"];
    
    return request;
}

@end
