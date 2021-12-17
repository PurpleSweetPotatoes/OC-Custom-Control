//
//  BQSudokuView.h
//  tianyaTest
//
//  Created by baiqiang on 2019/4/15.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BQSudokuView;

@protocol BQSudokuViewDelegate <NSObject>

- (NSInteger)numOfImgsInSudokuView:(BQSudokuView *)sudokuView;

- (void)sudokuView:(BQSudokuView *)sudokuView
        configImgV:(UIImageView *)imageView
             index:(NSInteger)index;

@optional
- (void)sudokuView:(BQSudokuView *)sudokuView clickIndex:(NSInteger)index;

@end

@interface BQSudokuView : UIView

@property (nonatomic, weak) id<BQSudokuViewDelegate>  delegate;

- (instancetype)initWithOrigin:(CGPoint)origin
                    itemHeight:(CGFloat)height
                     itemSpace:(CGFloat)itemSpace NS_DESIGNATED_INITIALIZER;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
