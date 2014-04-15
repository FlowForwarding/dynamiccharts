//
//  NCIAxis.h
//  NCIChart
//
//  Created by Ira on 4/15/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCILine.h"

@interface NCIAxis : NCILine

- (id)initWithOptions:(NSDictionary *)options;
@property(nonatomic)bool xPos;
@property(nonatomic)bool yPos;
@property(nonatomic)bool invertedLabes;

@end
