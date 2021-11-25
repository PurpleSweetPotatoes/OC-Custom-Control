//
//  BQPlayerCtrlView.h
//  tianyaTest
//
//  Created by baiqiang on 2019/6/27.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import "BQSliderView.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol BQPlayerCtrlViewDelegate <NSObject>
- (void)ctrlViewSliderBeginChange:(BQSliderView *)slider;
- (void)ctrlViewSliderEndChange:(BQSliderView *)slider;
- (void)ctrlViewcentBtnAction:(UIButton *)sender;
- (void)ctrlViewFullBtnAction:(UIButton *)sender;
@end
@interface BQPlayerCtrlView : UIView
@property (nonatomic, weak) id<BQPlayerCtrlViewDelegate>  delegate;
@property (nonatomic, copy) NSString * disTitle;
@property (nonatomic, strong) UIButton * centerBtn;
@property (nonatomic, strong) BQSliderView * sliederView;
@property (nonatomic, strong) UIButton * fullBtn;

- (void)disPlayStatusChange;

- (void)hide;

- (void)resetStatus;

@end

NS_ASSUME_NONNULL_END
