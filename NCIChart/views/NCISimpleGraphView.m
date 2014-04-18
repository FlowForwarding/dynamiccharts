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
    
    _gridHeigth = self.frame.size.height - self.chart.nciGridBottomMargin;
    _gridWidth = self.frame.size.width - self.chart.nciGridLeftMargin - self.chart.nciGridRightMargin;
    
    if (_chart.chartData.count > 0){
        _minXVal = [_chart.chartData[0][0] doubleValue];
        _maxXVal = [[_chart.chartData lastObject][0] doubleValue];
        if (_maxXVal == _minXVal){
            _minXVal = _minXVal - 1;
            _maxXVal = _maxXVal + 1;
        }
        [self detectRanges];
        [self.chart.yAxis redrawYLabels:_gridHeigth];
        _xStep = _gridWidth/(_maxXVal - _minXVal);
        [self.chart.xAxis redrawXLabels:_gridWidth min:_minXVal max:_maxXVal];
    }
    _grid.frame = CGRectMake(self.chart.nciGridLeftMargin, 0, _gridWidth, _gridHeigth);
   [_grid setNeedsDisplay];
}

- (void)detectRanges{
    NSArray *yVals = [_chart getBoundaryValues];
    _minYVal = [yVals[0] floatValue];
    _maxYVal = [yVals[1] floatValue];
    _yStep = _gridHeigth/(_maxYVal - _minYVal);
}

- (double)getArgumentByX:(float) pointX{
    return (_minXVal + (pointX)/_xStep);
}

- (float )getValByY:(float) pointY{
    return _minYVal + (pointY)/_yStep;
}
//TODO for points
- (CGPoint)pointByValueInGrid:(NSArray *)data{
    double argument = [data[0] doubleValue];
    if ([data[1] isKindOfClass:[NSNull class]] )
        return CGPointMake(NAN, NAN);
    float yVal = self.frame.size.height - (([data[1] floatValue] - _minYVal)*_yStep) - self.chart.nciGridBottomMargin;
    float xVal = [self getXByArgument: argument];
    return CGPointMake(xVal, yVal);
}

- (float)getXByArgument:(double )arg{
    return (arg  - _minXVal)*_xStep;
}

@end
