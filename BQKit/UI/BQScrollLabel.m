// *******************************************
//  File Name:      BQScorllLabel.m       
//  Author:         MrBai
//  Created Date:   2020/11/18 10:15 AM
//    
//  Copyright © 2020 Rainy
//  All rights reserved
// *******************************************
    

#import "BQScrollLabel.h"

@interface BQScrollLabel()
{
    dispatch_source_t _timer;
}
@property (nonatomic, strong) NSArray * infos;
@property (nonatomic, assign) ScrollDirection  direction;
@property (nonatomic, assign) NSInteger  index;
@property (nonatomic, strong) UILabel * showLab;
@property (nonatomic, strong) UILabel * nextLab;
@end

@implementation BQScrollLabel

+ (BQScrollLabel *)configInfos:(NSArray *)infos direction:(ScrollDirection)direction frame:(CGRect)frame {
    BQScrollLabel * label = [[BQScrollLabel alloc] initWithFrame:frame];
    label.direction = direction;
    label.infos = infos;
    [label configUI];
    label.clipsToBounds = YES;
    return label;
}


- (void)configUI {

    for (NSInteger i = 0; i < 2; i++) {
        UILabel * lab = [[UILabel alloc] initWithFrame:self.bounds];
        lab.font = [UIFont systemFontOfSize:13];
        lab.textColor = [UIColor hex:0x333333];
        lab.textAlignment = NSTextAlignmentRight;
        if (i < self.infos.count) {
            lab.text = self.infos[i];
        }
        if (i == 0) {
            self.showLab = lab;
        } else {
            self.nextLab = lab;
        }
        [self addSubview:lab];
    }
    self.index = 0;
    
    if (self.direction == ScrollDirection_up) {
        self.nextLab.top = self.height;
    } else {
        self.nextLab.left = self.right;
    }
    
    if (self.infos.count > 1) {
        [self creatTimer];
    }
}

- (void)labAnimationChange {
    NSLog(@"进入计时器");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.index = (self.index + 1) % self.infos.count;
        [UIView animateWithDuration:1 animations:^{
            if (self.direction == ScrollDirection_up) {
                self.showLab.top = -self.height;
                self.nextLab.top = 0;
            } else {
                self.showLab.left = -self.width;
                self.nextLab.left = 0;
            }
        } completion:^(BOOL finished) {
            
            if (self.direction == ScrollDirection_up) {
                self.showLab.top = self.height;
            } else {
                self.showLab.left = self.right;
            }
            UILabel * tempLab = self.nextLab;
            self.nextLab = self.showLab;
            self.showLab = tempLab;
            self.nextLab.text = self.infos[(self.index + 1) % self.infos.count];
        }];
    });
}

//创建timer
- (void)creatTimer{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 2 * NSEC_PER_SEC), 3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        [self labAnimationChange];
    });
    dispatch_resume(timer);
    _timer = timer;
}

- (void)dealloc {
    dispatch_source_cancel(_timer);
    _timer = nil;
}

@end
