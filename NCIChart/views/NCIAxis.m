//
//  NCIAxis.m
//  NCIChart
//
//  Created by Ira on 4/15/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import "NCIAxis.h"
#import "NCIChartOptions.h"

@interface NCIAxis()

@end

@implementation NCIAxis

- (id)initWithOptions:(NSDictionary *)options{
    if (self = [super initWithOptions:options]){
        if ([options objectForKey:nciInvertedLabes])
            _invertedLabes = [[options objectForKey:nciInvertedLabes] boolValue];
    }
    return self;
}

@end
