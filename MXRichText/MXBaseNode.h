//
//  MXBaseNode.h
//  MXCoreText
//
//  Created by Max on 16/3/2.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

CGFloat ascentCallback(void *ref);
CGFloat descentCallback(void *ref);
CGFloat widthCallback(void* ref);
void deallocCallback(void* ref);

@interface MXBaseNode : NSObject
@property (nonatomic, strong)id content;
@property (nonatomic, assign)CGSize size;
@property (nonatomic, assign)CGFloat ascent;
@property (nonatomic, assign)CGFloat descent;
@property (nonatomic, assign)CGPoint inset;
@property (nonatomic, assign)CGFloat lineSpace;

- (id)initWithContent:(UIView *)content;

@end
