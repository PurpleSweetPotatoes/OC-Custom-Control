// *******************************************
//  File Name:      BQSpeechManager.m       
//  Author:         MrBai
//  Created Date:   2021/8/18 4:14 PM
//    
//  Copyright © 2021 Rainy
//  All rights reserved
// *******************************************
    

#import "BQSpeechManager.h"

#import <AVFoundation/AVFoundation.h>

@interface BQSpeechManager ()
<
AVSpeechSynthesizerDelegate
>
@property (nonatomic, weak  ) id<BQSpeechManagerDelegate> delegate;
@property (nonatomic, copy  ) AVSpeechUtterance       * utter;
@property (nonatomic, strong) AVSpeechSynthesizer     * speech;
@end

static BQSpeechManager * manager = nil;

@implementation BQSpeechManager

+ (void)configSpeechStr:(NSString *)str delegate:(nonnull id<BQSpeechManagerDelegate>)delegate {
    if (manager == nil) {
        manager = [[BQSpeechManager alloc] init];
    }
    
    [self clean];
    
    if ([str isKindOfClass:[NSString class]] && str.length > 0) {
        manager.speech = [[AVSpeechSynthesizer alloc] init];
        manager.speech.delegate = manager;
        manager.utter = [AVSpeechUtterance speechUtteranceWithString:[str filterHtml]];
        manager.delegate = delegate;
    }
}

+ (void)start {
    if (manager.speech.isSpeaking) {
        if (manager.speech.isPaused) {
            [manager.speech continueSpeaking];
        }
    } else {
        [manager.speech speakUtterance:manager.utter];
    }
}

+ (void)pause {
    if (manager.speech.isSpeaking && !manager.speech.isPaused) {
        [manager.speech pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}

+ (void)clean {
    
    if (manager.speech.isSpeaking) {
        [manager.speech stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
    
    manager.speech.delegate = nil;
    manager.speech = nil;
    manager.utter = nil;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
    
    if ([manager.delegate respondsToSelector:@selector(startSpeak)]) {
        [manager.delegate startSpeak];
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    if ([manager.delegate respondsToSelector:@selector(endSpeadk)]) {
        [manager.delegate endSpeadk];
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance {
    if ([manager.delegate respondsToSelector:@selector(pauseSpeak)]) {
        [manager.delegate pauseSpeak];
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance {
    if ([manager.delegate respondsToSelector:@selector(startSpeak)]) {
        [manager.delegate startSpeak];
    }
}

@end
