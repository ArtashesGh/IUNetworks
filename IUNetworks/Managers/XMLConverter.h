//
//  XMLConverter.h
//  IUNetworks
//
//  Created by Artashes Ghazaryan on 5/11/18.
//  Copyright © 2018 Artashes Ghazaryan. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface XMLConverter : NSObject

typedef void (^OutputBlock)(BOOL success, NSMutableDictionary *dictionary, NSError *error);

+ (void)convertXMLData:(NSData *)data completion:(OutputBlock)completion;

@end
