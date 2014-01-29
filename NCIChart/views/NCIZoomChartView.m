//
//  NCIZoomChartView.m
//  NCIChart
//
//  Created by Ira on 1/27/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import "NCIZoomChartView.h"
#import "NCIZoomGraphView.h"


@implementation NCIZoomChartView

- (void)addSubviews{
    _minRangeVal = NAN;
    _maxRangeVal = NAN;
    self.graph = [[NCIZoomGraphView alloc] initWithChart:self];
    [self addSubview:self.graph];
}

- (NSArray *)getValsInRanges{
    float minYVal = MAXFLOAT;
    float maxYVal = -MAXFLOAT;
    long firstDataIndex = self.chartData.count;
    long lastChartIndex = 0;
    long index;
    for(index = 1; index < self.chartData.count; index++){
        NSArray *point = self.chartData[index];
        if ([point[1][0] isKindOfClass:[NSNull class]]){
            continue;
        }
        NSArray * prevPoint = self.chartData[index - 1];
        if ([prevPoint[1][0] isKindOfClass:[NSNull class]]){
            prevPoint = @[prevPoint[0], point[1]];
        }
        
        NSArray * nextPoint;
        if (self.chartData.count != (index + 1)){
            nextPoint = self.chartData[index + 1];
            if ([nextPoint[1][0] isKindOfClass:[NSNull class]]){
                nextPoint = @[nextPoint[0], point[1]];
            }
        } else {
            nextPoint = point;
        }
        
        float curMax = [prevPoint[1][0] floatValue];
        float curMin = [prevPoint[1][0] floatValue];
        if ([point[1][0] floatValue] > [prevPoint[1][0] floatValue]){
            curMax = [point[1][0] floatValue];
        } else {
            curMin= [point[1][0] floatValue];
        }
        if ( curMax < [nextPoint[1][0] floatValue]){
            curMax = [nextPoint[1][0] floatValue];
        }
        if ( curMin > [nextPoint[1][0] floatValue]){
            curMin = [nextPoint[1][0] floatValue];
        }
        
        if ( _minRangeVal <= [point[0] doubleValue] &&
            ( minYVal == MAXFLOAT || _maxRangeVal  >= [point[0] doubleValue])){
            
            if (firstDataIndex > (index - 1)){
                firstDataIndex = (index - 1);
            }
            if (lastChartIndex < (index + 1)){
                lastChartIndex = (index + 1);
            }
            if (curMin < minYVal)
                minYVal = curMin;
            if (curMax > maxYVal)
                maxYVal = curMax;
        }
    }
    //TODO if to narrow get MAXFLOAT, rethink logic above ^
    if (minYVal == MAXFLOAT)
        return @[@(0), @(1), @(0), @(self.chartData.count)];
    
    float diff = maxYVal - minYVal;
    if (diff == 0){
        maxYVal = maxYVal + 1;
        minYVal = minYVal - 1;
    } else {
        maxYVal = maxYVal + diff*self.topBottomGridSpace/100;
        minYVal = minYVal - diff*self.topBottomGridSpace/100;
    }
    
    if (lastChartIndex < self.chartData.count)
        lastChartIndex = lastChartIndex + 1;
    
    return @[@(minYVal),
             @(maxYVal),
             @(firstDataIndex),
             @(lastChartIndex)];
}

- (double)getScaleIndex{
    if (_minRangeVal != _minRangeVal || _maxRangeVal != _maxRangeVal)
        return 1;
    double rangeDiff = [self getRangesPeriod];
    if (rangeDiff == 0){
        return  1;
    } else {
        return [self getTimePeriod]/rangeDiff;
    }
}

-(double)getTimePeriod{
    if (self.chartData.count == 0)
        return 0;
    return [[self.chartData lastObject][0] doubleValue] - [self.chartData[0][0] doubleValue];
}

-(double)getRangesPeriod{
    return self.maxRangeVal - self.minRangeVal;
}


@end
