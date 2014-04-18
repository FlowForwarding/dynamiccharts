//
//  NCIAxis.m
//  NCIChart
//
//  Created by Ira on 4/15/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import "NCIAxis.h"
#import "NCIChartOptions.h"
#import "NCISimpleGraphView.h"

@interface NCIAxis()

@property(nonatomic)bool xPos;
@property(nonatomic)bool yPos;
@property(nonatomic)bool invertedLabes;
@property(nonatomic, strong)UIFont* labelsFont;
@property(nonatomic, strong)UIColor* labelsColor;
@property (nonatomic, copy) NSString* (^labelRenderer)(double);
@property (nonatomic)bool nciUseDateFormatter;
@property(nonatomic)float labelsDistance;

@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic) float step;

@end

@implementation NCIAxis

- (id)initWithOptions:(NSDictionary *)options{
    if (self = [super initWithOptions:options]){
        _dateFormatter = [[NSDateFormatter alloc] init];
        _labels = [[NSMutableArray alloc] init];
        
        if ([options objectForKey:nciInvertedLabes])
            _invertedLabes = [[options objectForKey:nciInvertedLabes] boolValue];
        
        if ([options objectForKey:nciUseDateFormatter])
            _nciUseDateFormatter = [[options objectForKey:nciUseDateFormatter] boolValue];
        
        if ([options objectForKey:nciLabelRenderer])
            _labelRenderer = [options objectForKey:nciLabelRenderer] ;
        
        if ([options objectForKey:nciLabelsFont]){
            _labelsFont = [options objectForKey:nciLabelsFont];
        } else {
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
               _labelsFont = [UIFont italicSystemFontOfSize:14];
             } else {
                _labelsFont = [UIFont italicSystemFontOfSize:10];
             }
        }
        
        if ([options objectForKey:nciLabelsColor]){
            _labelsColor = [options objectForKey:nciLabelsColor];
        } else {
            _labelsColor = [UIColor blackColor];
        }
        
        if ([options objectForKey:nciLabelsDistance]){
            _labelsDistance = [[options objectForKey:nciLabelsDistance] floatValue];
        } else {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                 _labelsDistance = 150;
            } else {
                 _labelsDistance = 60;
            }
        }
    }
    return self;
}

- (void)redrawYLabels:(float)length{
    for (UILabel *label in _labels){
        [label removeFromSuperview];
    }
    [_labels removeAllObjects];
    
    for(int i = 0; i<= length/_labelsDistance; i++){
        UILabel *label = [[UILabel alloc] initWithFrame:
                          CGRectMake(0, length - i*_labelsDistance - _labelsDistance/2, self.chart.nciGridLeftMargin, _labelsDistance)];
        double curVal = [self.chart.graph getValByY: ( _labelsDistance*i)];
        label.textAlignment = NSTextAlignmentRight;
        [self makeUpLabel:label val:curVal];
    }
}

- (void)redrawXLabels:(float)length min:(double)min max:(double)max{
    for (UILabel *label in _labels){
        [label removeFromSuperview];
    }
     [_labels removeAllObjects];
     _step = length/(max - min);
     [self formatDateForDistance];
    
    for(int i = 0; i< (length - _labelsDistance/2)/_labelsDistance; i++){
        float xPos = self.chart.nciGridLeftMargin + _labelsDistance *i;
        UILabel *label = [[UILabel alloc] initWithFrame:
                          CGRectMake(xPos,
                                     self.chart.graph.frame.size.height - self.chart.nciGridBottomMargin, _labelsDistance,
                                     self.chart.nciGridBottomMargin)];
        double curVal = [self.chart.graph getArgumentByX: (_labelsDistance *i + _labelsDistance/2)];
        label.textAlignment = NSTextAlignmentCenter;
        [self makeUpLabel:label val:curVal];
    }
}

- (void)makeUpLabel:(UILabel *)label val:(double) curVal{
    label.textColor = _labelsColor;
    label.font = _labelsFont;
    if (_labelRenderer){
        label.text = _labelRenderer(curVal);
    } else if (self.nciUseDateFormatter){
        label.text = [_dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:curVal]];
    } else {
        label.text =   [NSString stringWithFormat:@"%0.1f", curVal];
    }
    [self.labels addObject:label];
    [self.chart.graph addSubview:label];
    
}

- (void)formatDateForDistance{
    if ((1/_step * _labelsDistance) < 60*60*24){
        [_dateFormatter setDateFormat:@"yyyy-MMM-dd HH:mm"];
    } else if ((1/_step * _labelsDistance) < 60*60*24*30){
        [_dateFormatter setDateFormat:@"yyyy-MMM-dd"];
    } else {
        [_dateFormatter setDateFormat:@"yyyy-MMM"];
    }
}



@end
