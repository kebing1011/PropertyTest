//
//  TTObject.m
//  PropertyTest
//
//  Created by mao on 7/15/15.
//  Copyright (c) 2015 mao. All rights reserved.
//

#import "TTObject.h"

@implementation TTObject

- (void)setString1:(NSString *)string1 {
	if (_string1 != string1) {
		_string1 = string1;
	}
}
- (void)setString2:(NSString *)string2 {
	if (_string2 != string2) {
		_string2 = [string2 copy];
	}
}


- (void)setString3:(NSString *)string3 {
	if (_string3 != string3) {
		__weak NSString* string = string3;
		_string3 = string;
	}
}

- (void)setString4:(NSString *)string4 {
	if (_string4 !=string4) {
		__unsafe_unretained NSString* string = string4;
		_string4 = string;
	}
}


@end
