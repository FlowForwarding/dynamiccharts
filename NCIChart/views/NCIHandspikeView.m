//
//  NCIHandspikeView.m
//  Tapestry
//
//  Created by Infoblox Inc on 11/19/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//  Licensed under the Apache License, Version 2.0 
//  http://www.apache.org/licenses/LICENSE-2.0
//

#import "NCIHandspikeView.h"

@interface NCIHandspikeView(){
    UIView *border;
}
@end

@implementation NCIHandspikeView

- (id)initWithImageName:(NSString *)imageName{
    UIImageView *rangeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    self = [super initWithFrame:rangeImage.frame];
    if (self) {
        [self addSubview:rangeImage];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        border = [[UIView alloc] initWithFrame:CGRectZero];
        border.backgroundColor = [UIColor blackColor];
        [self addSubview:border];
    }
    return self;
}

-(void)layoutSubviews{
    border.frame = CGRectMake(self.frame.size.width/2 - 1, 0, 2, self.frame.size.height);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
