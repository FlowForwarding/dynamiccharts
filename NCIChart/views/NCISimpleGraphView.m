//
//  NCISimpleGraphView.m
//  NCIChart
//
//  Created by Ira on 12/20/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import "NCISimpleGraphView.h"
#import "NCISimpleGridView.h"

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
        _yLabelShift = 15;
        
        _yAxisLabels = [[NSMutableArray alloc] init];
        _xAxisLabels = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
        _dateFormatter = [[NSDateFormatter alloc] init];
        [self addSubviews];
    
    }
    return  self;
}

- (void)layoutSubviews{
    for (UILabel *label in _yAxisLabels){
        [label removeFromSuperview];
    }
    for (UILabel *label in _xAxisLabels){
        [label removeFromSuperview];
    }
    [_yAxisLabels removeAllObjects];
    [_xAxisLabels removeAllObjects];
    
    _gridHeigth = self.frame.size.height- self.chart.nciGridBottomMargin;
    _gridWidth = self.frame.size.width - self.chart.nciGridLeftMargin;
    float yLabelsDistance = self.chart.nciYLabelsDistance;
    
    if (_chart.chartData.count > 0){
        _minXVal = [_chart.chartData[0][0] doubleValue];
        _maxXVal = [[_chart.chartData lastObject][0] doubleValue];
        if (_maxXVal == _minXVal){
            _minXVal = _minXVal - 1;
            _maxXVal = _maxXVal + 1;
        }
        _xStep = _gridWidth/(_maxXVal - _minXVal);
        [self detectRanges];
       
        for(int i = 0; i<= _gridHeigth/yLabelsDistance; i++){
            UILabel *label = [[UILabel alloc] initWithFrame:
                              CGRectMake(0, self.frame.size.height - i*yLabelsDistance -
                                         self.chart.nciGridBottomMargin - _yLabelShift, self.chart.nciGridLeftMargin, 20)];
            label.font =  self.chart.nciYLabelsFont;
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = self.chart.nciYLabelsColor;
            if (self.chart.hasYLabels){
                double curVal = [self getValByY: (self.chart.nciGridBottomMargin + yLabelsDistance*i)];
                if (self.chart.nciYLabelRenderer){
                    label.text = self.chart.nciYLabelRenderer(curVal);
                } else {
                    label.text = [NSString stringWithFormat:@"%0.1f", curVal];
                }
            }
            [_yAxisLabels addObject:label];
            [self addSubview:label];
        }
       
        [self redrawXLabels];
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

- (void)redrawXLabels{
    float xLabelsDistance = self.chart.nciXLabelsDistance;
    [self formatDateForDistance:xLabelsDistance];
    
    for(int i = 0; i<= (_gridWidth - self.chart.nciGridLeftMargin)/xLabelsDistance; i++){
        UILabel *label = [[UILabel alloc] initWithFrame:
                          CGRectMake(self.chart.nciGridLeftMargin + xLabelsDistance *i,
                                     self.frame.size.height - self.chart.nciGridBottomMargin, xLabelsDistance,
                                     self.chart.nciGridBottomMargin)];
        label.textColor = self.chart.nciXLabelsColor;
        label.font =  self.chart.nciXLabelsFont;
        double curVal = [self getArgumentByX: (self.chart.nciGridLeftMargin + xLabelsDistance *i - xLabelsDistance/2)];
        [self makeUpXLabel:label val:curVal];
    }
}

- (void)formatDateForDistance:(double) distance{
    if ((1/_xStep * distance) < 60*60*24){
        [_dateFormatter setDateFormat:@"yyyy-MMM-dd HH:mm"];
    } else if ((1/_xStep * distance) < 60*60*24*30){
        [_dateFormatter setDateFormat:@"yyyy-MMM-dd"];
    } else {
        [_dateFormatter setDateFormat:@"yyyy-MMM"];
    }
}

- (void)makeUpXLabel:(UILabel *)label val:(double) curVal{
    label.textAlignment = NSTextAlignmentCenter;
    label.font = self.chart.nciXLabelsFont;
    if (self.chart.nciXLabelRenderer){
        label.text = self.chart.nciXLabelRenderer(curVal);
    } else if (self.chart.nciUseDateFormatter){
        label.text = [_dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:curVal]];
    } else {
        label.text =   [NSString stringWithFormat:@"%0.1f", curVal];
    }
    [_xAxisLabels addObject:label];
    [self addSubview:label];

}

- (double)getArgumentByX:(float) pointX{
    return (_minXVal + (pointX)/_xStep);
}

- (float )getValByY:(float) pointY{
    return _minYVal + (pointY - self.chart.nciGridBottomMargin)/_yStep;
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
