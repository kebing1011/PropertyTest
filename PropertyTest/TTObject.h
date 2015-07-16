//
//  TTObject.h
//  PropertyTest
//
//  Created by mao on 7/15/15.
//  Copyright (c) 2015 mao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTObject : NSObject
@property (nonatomic, strong) NSString* string1;
@property (nonatomic, copy) NSString* string2;
@property (nonatomic, weak) NSString* string3;
@property (nonatomic, assign) NSString* string4;

@property (nonatomic, strong) NSArray* array1;
@property (nonatomic, copy) NSArray* array2;
@property (nonatomic, weak) NSArray* array3;
@property (nonatomic, assign) NSArray* array4;

@end
