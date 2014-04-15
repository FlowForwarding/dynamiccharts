//
//  NCIBarGridView.m
//  NCIChart
//
//  Created by Ira on 3/11/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import "NCIBarGridView.h"
#import "NCIBar.h"

@implementation NCIBarGridView

- (void)drawGraphLine:(NSArray *)firstLast{
    for (UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
    float selfHeight = self.frame.size.height;
    for (long ind = [firstLast[0] integerValue]; ind < [firstLast[1] integerValue]; ind++){
        NSArray *points = self.graph.chart.chartData[ind];
        for (int i = 0; i< ((NSArray *)points[1]).count; i++){
            id val = points[1][i];
            CGPoint pointP = [self.graph pointByValueInGrid:@[points[0], val]];
            UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(pointP.x - 10, selfHeight - pointP.y, 20, pointP.y)];
            bar.backgroundColor = [self getColor:i];
            [self addSubview:bar];
        }
    }

}

@end
