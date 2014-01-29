//
//  ViewController.m
//  NCIChartConfigurations
//
//  Created by Ira on 12/20/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import "ViewController.h"
#import "NCIChartView.h"

@interface ViewController (){
    NCISimpleChartView *simpleChart;
    
    float horisontalIndent;
    float verticalIndent;
    
    
    bool isShowingLandscapeView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        horisontalIndent = 20;
        verticalIndent = 40;
    } else {
        horisontalIndent = 10;
        verticalIndent = 20;
    }
    
    
    
    //    nciChart = [[NCIChartView alloc] initWithFrame:
    //                CGRectZero andOptions:@{nciBottomGraphOptions:@{nciHasSelection: @(NO)}}];
    
    
    
    simpleChart = [[NCISimpleChartView alloc] initWithFrame:CGRectZero
                                                 andOptions:@{nciIsFill: @(NO),
                                                              nciLineColors : @[[UIColor greenColor]],
                                                              nciLineWidths : @[@(2)],
                                                              nciSelPointImages : @[@"star"],
                                                              nciSelPointSizes: @[@20],
                                                              nciXLabelsFont: [UIFont fontWithName:@"MarkerFelt-Thin" size:12],
                                                              nciYLabelsFont: [UIFont fontWithName:@"MarkerFelt-Thin" size:12],
                                                              nciSelPointFont: [UIFont fontWithName:@"MarkerFelt-Thin" size:14],
                                                              nciYLabelsDistance: @(50),
                                                              nciXLabelsDistance: @(80),
                                                              nciXLabelRenderer:  ^(double argument){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MMM-dd"];
        return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:argument]]];
    },
                                                              nciYLabelRenderer: ^(double value){
        return [NSString stringWithFormat:@"%.1fK", value];
    },
                                                              nciTapGridAction: ^(double argument, double value){
        NSLog(@"custom bg tap test");
    },
                                                              nciSelPointTextRenderer: ^(double argument, NSArray* values){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM-dd HH:mm:ss"];
        return [NSString stringWithFormat:@"Test: %@ %@", values[0],
                [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:argument]]];
    }
                                                              }];
    
    [self.view addSubview: simpleChart];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    isShowingLandscapeView = NO;
    
    [self generateDemoData];
    
    [self layoutSubviews];
    
}


- (void)layoutSubviews{
    float width;
    float heigth;
    if (!isShowingLandscapeView){
        width = self.view.frame.size.width;
        heigth = self.view.frame.size.height;
    } else {
        width = self.view.frame.size.height;
        heigth = self.view.frame.size.width;
    }
    
    simpleChart.frame = CGRectMake(horisontalIndent, verticalIndent,
                                   width - 2*horisontalIndent,
                                   heigth - verticalIndent);
    
    
    
}

- (void)generateDemoData{
    float halfYearPeriod = 60*60*24*30*6;
    float demoDatePeriod = halfYearPeriod;
    float numOfPoints = 40;
    float step = demoDatePeriod/(numOfPoints - 1);
    int trendMiddle = 6;
    int trendStepCounter = 0;
    int ind;
    for (ind = 0; ind < numOfPoints; ind ++){
        if (trendStepCounter > 20){
            trendStepCounter = 0;
            trendMiddle += 1;
        }
        trendStepCounter += 1;
        int value = trendMiddle + arc4random() % 5;
        //NSDate *date = [[NSDate date] dateByAddingTimeInterval: (-demoDatePeriod + step*ind)];
        double time = [[NSDate date] timeIntervalSince1970] - demoDatePeriod + step*ind;
        if (trendStepCounter > 4 && trendStepCounter < 7){
            [simpleChart addPoint:time val: @[[NSNull null]]];
        } else {
            [simpleChart addPoint:time val: @[@(value)]];
        }
    }
    
    
}

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) &&
        !isShowingLandscapeView)
    {
        isShowingLandscapeView = YES;
        [self layoutSubviews];
    }
    else if (isShowingLandscapeView &&
             ((UIDeviceOrientationPortrait == deviceOrientation && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ||
              (UIDeviceOrientationIsPortrait(deviceOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)))
    {
        isShowingLandscapeView = NO;
        [self layoutSubviews];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
