//
//  ViewController.m
//  NCIChartConfigurations
//
//  Created by Ira on 12/20/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import "ViewController.h"
#import "NCIBarChartView.h"
#import "NCIChartView.h"

@interface ViewController (){
    NCIChartView *simpleChart;
    
    float horisontalIndent;
    float verticalIndent;
    
    
    bool isShowingLandscapeView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        horisontalIndent = 20;
        verticalIndent = 40;
    } else {
        horisontalIndent = 10;
        verticalIndent = 20;
    }
    
    
    simpleChart = [[NCIChartView alloc]
                   initWithFrame:CGRectMake(50, 30, 400, 250)
                   andOptions: @{
                                 
                                 nciIsFill: @[@(NO), @(NO), @(NO)],
                                 nciLineColors: @[[UIColor orangeColor], [NSNull null]],
                                 nciLineWidths: @[@2, [NSNull null]],
                                 nciHasSelection: @YES,
                                 nciSelPointColors: @[[UIColor redColor]],
                                 nciSelPointImages: @[[NSNull null], @"star"],
                                 nciSelPointTextRenderer: ^(double argument, NSArray* values){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MMM-dd HH:mm:ss"];
        return [[NSAttributedString alloc] initWithString:
                [NSString stringWithFormat:@"y: %.0f,%.0f  x:%@",
                 [values[0] floatValue],
                 [values[1] floatValue],
                 [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970: argument]]]
                                               attributes: @{NSForegroundColorAttributeName: [UIColor redColor],
                                                             NSFontAttributeName: [UIFont fontWithName:@"MarkerFelt-Thin" size:12]}];
    },
                                 
                                 nciSelPointSizes: @[@10, [NSNull null]],
                                 nciXLabelsFont: [UIFont fontWithName:@"MarkerFelt-Thin" size:12],
                                 nciXLabelsColor: [UIColor blueColor],
                                 nciYLabelsFont: [UIFont fontWithName:@"MarkerFelt-Thin" size:12],
                                 nciYLabelsColor: [UIColor brownColor],
                                 nciXLabelsDistance: @150,
                                 nciYLabelsDistance: @30,
                                 nciYLabelRenderer: ^(double value){
        return [NSString stringWithFormat:@"%.1f$", value];
    },
                                 //                                               nciTapGridAction: ^(double argument, double value, float xInGrid, float yInGrid){
                                 //
                                 //    },
                                 nciShowPoints : @YES,
                                 nciUseDateFormatter: @YES,//nciXLabelRenderer
                                 nciBoundaryVertical: [[NCILine alloc] initWithWidth:1 color:[UIColor blackColor] andDashes:@[@2,@2]],
                                 nciBoundaryHorizontal: [[NCILine alloc] initWithWidth:2 color:[UIColor redColor] andDashes:nil],
                                 nciGridVertical: [[NCILine alloc] initWithWidth:1 color:[UIColor purpleColor] andDashes:nil],
                                 nciGridHorizontal: [[NCILine alloc] initWithWidth:2 color:[UIColor greenColor] andDashes:@[@2,@2]],
                                 nciGridColor: [[UIColor yellowColor] colorWithAlphaComponent:0.2],
                                 nciGridLeftMargin: @50,
                                 nciGridTopMargin: @50,
                                 nciGridBottomMargin: @40
                                 }];
    
    simpleChart.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:simpleChart];
    
    
    //    int numOfPoints = 10;
    //    for (int ind = 0; ind < numOfPoints; ind ++){
    //        [simpleChart addPoint:ind val:@[@(arc4random() % 5)]];
    //    }
    ////  chart.minRangeVal = 5;
    //    chart.maxRangeVal = 8;
    
    
    [self generateDemoData];
    
    
}


- (void)generateDemoData{
    float halfYearPeriod = 60*60*24*30*6;
    float demoDatePeriod = halfYearPeriod;
    float numOfPoints = 15;
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
        //        if (trendStepCounter > 4 && trendStepCounter < 7){
        //            [simpleChart addPoint:time val: @[[NSNull null]]];
        //        } else {
        [simpleChart addPoint:time val: @[@(value), @(trendMiddle + arc4random() % 5)]];
        // }
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
