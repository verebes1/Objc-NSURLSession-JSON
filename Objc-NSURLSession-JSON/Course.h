//
//  Course.h
//  Objc-NSURLSession-JSON
//
//  Created by verebes on 25/03/2019.
//  Copyright © 2019 A&D Progress. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Course : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *numberOfLessons;

@end

NS_ASSUME_NONNULL_END
