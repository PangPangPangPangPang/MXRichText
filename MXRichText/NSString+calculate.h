//
//  NSString+calculate.h
//  MXCoreText
//
//  Created by Max on 16/1/5.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (calculate)

+ (CGSize)calculateSize:(UIFont *)font
              lineSpace:(CGFloat)lineSpace
            constraints:(CGSize)size
          numberOfLines:(NSInteger)count;
@end
