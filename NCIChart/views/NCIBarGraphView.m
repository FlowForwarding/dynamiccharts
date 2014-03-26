//
//  NCIBarGraphView.m
//  NCIChart
//
//  Created by Ira on 3/11/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import "NCIBarGraphView.h"
#import "NCIBarGridView.h"

@implementation NCIBarGraphView

- (void)addSubviews{
    self.grid = [[NCIBarGridView alloc] initWithGraph:self];
    [self addSubview:self.grid];
}

@end

