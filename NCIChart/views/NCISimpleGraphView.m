//
//  NCISimpleGraphView.m
//  NCIChart
//
//  Created by Ira on 12/20/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import "NCISimpleGraphView.h"
#import "NCISimpleGridView.h"
#import "NCISimpleChartView.h"

@interface NCISimpleGraphView(){
    
}

@end

@implementation NCISimpleGraphView



- (void)addSubviews{
    self.grid = [[NCISimpleGridView alloc] initWithGraph:self];
    [self addSubview:self.grid];
}

- (id)initWithChart: (NCISimpleChartView *)chartHolder{
    self = [self initWithFrame:CGRectZero];
    if (self){
        _chart = chartHolder;
       // _yLabelShift = 15;
    
        self.backgroundColor = [UIColor clearColor];
        [self addSubviews];
    
    }
    return  self;
}

- (void)layoutSubviews{
    _gridHeigth = self.frame.size.height;
    _gridWidth = self.frame.size.width;
    
    if (_chart.chartData.count > 0){
        _minXVal = [_chart.chartData[0][0] doubleValue];
        _maxXVal = [[_chart.chartData lastObject][0] doubleValue];
        if (_maxXVal == _minXVal){
            _minXVal = _minXVal - 1;
            _maxXVal = _maxXVal + 1;
        }
        [self detectRanges];
        _yStep = _gridHeigth/(_maxYVal - _minYVal);
        [self.chart.yAxis redrawLabels:_gridHeigth min:_minYVal max:_maxYVal];
        _xStep = _gridWidth/(_maxXVal - _minXVal);
        [self.chart.xAxis redrawLabels:_gridWidth min:_minXVal max:_maxXVal];
    }
    _grid.frame = CGRectMake(0, 0, _gridWidth, _gridHeigth);
   [_grid setNeedsDisplay];
}

- (void)detectRanges{
    NSArray *yVals = [_chart getBoundaryValues];
    _minYVal = [yVals[0] floatValue];
    _maxYVal = [yVals[1] floatValue];
}


- (CGPoint)pointByValueInGrid:(NSArray *)data{
    double argument = [data[0] doubleValue];
    if ([data[1] isKindOfClass:[NSNull class]] )
        return CGPointMake(NAN, NAN);
    float yVal;
    if (self.chart.yAxis.nciAxisDecreasing){
        yVal = (([data[1] floatValue] - _minYVal)*_yStep);
    } else {
        yVal = _gridHeigth - (([data[1] floatValue] - _minYVal)*_yStep);
    }
    
    float xVal = [self getXByArgument: argument];
    return CGPointMake(xVal, yVal);
}

- (double)getArgumentByX:(float) pointX{
    if (self.chart.xAxis.nciAxisDecreasing){
        return (_maxXVal - (pointX)/_xStep);
    } else {
        return (_minXVal + (pointX)/_xStep);
    }
}

- (float)getXByArgument:(double )arg{
    if (self.chart.xAxis.nciAxisDecreasing){
        return (_maxXVal  - arg)*_xStep;
    } else {
        return (arg  - _minXVal)*_xStep;
    }
}

- (float )getValByY:(float) pointY{
    if (self.chart.yAxis.nciAxisDecreasing){
        return _maxYVal - (pointY)/_yStep;
    } else {
        return _minYVal + (pointY)/_yStep;
    }
}

- (NSArray *)getFirstLast{
    return @[@(0), @(self.chart.chartData.count)];
}

@end
