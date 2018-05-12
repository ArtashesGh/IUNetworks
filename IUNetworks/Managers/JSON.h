//
//  JSON.h
//  IUNetworks Task
//
//  Created by Artashes Ghazaryan on 5/11/18.
//  Copyright © 2018 Artashes Ghazaryan. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Deserializing methods

//@interface NSString (JSONDeserializing)
//
//- (id)objectFromJSONString;
//
//@end

@interface NSData (JSONDeserializing)

- (id)objectFromJSONData;

@end


//#pragma mark Serializing methods
//
//@interface NSString (JSONSerializing)
//- (NSData *)JSONData;
//- (NSString *)JSONString;
//@end
//
//@interface NSArray (JSONSerializing)
//- (NSData *)JSONData;
//- (NSString *)JSONString;
//@end
//
//@interface NSDictionary (JSONSerializing)
//- (NSData *)JSONData;
//- (NSString *)JSONString;
//@end

