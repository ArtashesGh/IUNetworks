//
//  Item.h
//  IUNetworks
//
//  Created by Artashes Ghazaryan on 5/12/18.
//  Copyright © 2018 Artashes Ghazaryan. All rights reserved.
//

#import "JSONModel.h"
@protocol Item
@end
@interface Item : JSONModel

@property (nonatomic) NSString<Optional> *desc;
@property (nonatomic) NSString<Optional> *title;
@property (nonatomic) NSDate<Optional> *createdDate;
@property (nonatomic) NSString<Optional> *link;
@property (nonatomic) NSString<Optional> *imageUrl;

@end
