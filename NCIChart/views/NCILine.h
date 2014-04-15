//
//  NCILine.h
//  NCIChart
//
//  Created by Ira on 1/15/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCILine : NSObject

- (id)initWithOptions:(NSDictionary *)options;

- (void)setUpLine:(CGContextRef) currentContext;

@property(nonatomic)float width;
@property(nonatomic, strong)UIColor* color;
@property(nonatomic, strong)NSArray* dashes;

@end
