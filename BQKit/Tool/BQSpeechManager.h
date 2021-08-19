// *******************************************
//  File Name:      BQSpeechManager.h       
//  Author:         MrBai
//  Created Date:   2021/8/18 4:14 PM
//    
//  Copyright © 2021 Rainy
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BQSpeechManagerDelegate <NSObject>
- (void)startSpeak;
- (void)pauseSpeak;
- (void)endSpeadk;
@end

@interface BQSpeechManager : NSObject

+ (void)configSpeechStr:(NSString *)str delegate:(id<BQSpeechManagerDelegate>)delegate;
+ (void)start;
+ (void)pause;
+ (void)clean;
@end

NS_ASSUME_NONNULL_END
