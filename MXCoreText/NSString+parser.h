//
//  NSString+parser.h
//  MXCoreText
//
//  Created by Max on 16/3/3.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (parser)

- (NSArray *)matchTel;
- (NSMutableArray *)matchAndReplace;

@end
