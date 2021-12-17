// *******************************************
//  File Name:      BQRecorder.h       
//  Author:         MrBai
//  Created Date:   2020/7/23 11:07 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BQRecorderDelegate <NSObject>
- (void)recordStart;
- (void)recordFail:(NSString *)fail;
- (void)recordSuccess:(NSString *)filePath;
@end

@interface BQRecorder : NSObject
+ (void)start:(id<BQRecorderDelegate>)delegate;
+ (void)pause;
+ (void)resume;
+ (void)stop;
@end

NS_ASSUME_NONNULL_END
