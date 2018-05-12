//
//  RequestManager.h
//  IUNetworks Task
//
//  Created by Artashes Ghazaryan on 5/11/18.
//  Copyright © 2018 Artashes Ghazaryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestManager : NSObject
+ (void)getInfoWithJSONCompletion:( void (^) (id response, NSError *error))handler;
+ (void)getInfoWithXMLCompletion:( void (^) (id response, NSError *error))handler;
@end
