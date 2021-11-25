// *******************************************
//  File Name:      BQRecorder.m       
//  Author:         MrBai
//  Created Date:   2020/7/23 11:07 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import "BQRecorder.h"

#import "lame.h"
#import <AVFoundation/AVFoundation.h>

@interface BQRecorder ()
<
AVAudioRecorderDelegate
>
@property (nonatomic, weak  ) id<BQRecorderDelegate>    delegate;
@property (nonatomic, strong) AVAudioRecorder           * recorder;
@property (nonatomic, strong) NSDictionary              * recordParams;
@end

@implementation BQRecorder

#pragma mark - public Method

+ (void)start:(id<BQRecorderDelegate>)delegate {
    BQRecorder * coder = [BQRecorder coder];
    coder.delegate = delegate;
    NSFileManager * fileM = [NSFileManager defaultManager];
    NSString * filePath = [coder recordPath];
    
    if ([fileM fileExistsAtPath:filePath]) {
        [fileM removeItemAtURL:[NSURL fileURLWithPath:filePath] error:nil];
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryRecord error:&sessionError];
    
    if ( session == nil) {
        [delegate recordFail:sessionError.localizedDescription];
        return;
    }
      
    [session setActive:YES error:nil];
    
    coder.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:filePath] settings:coder.recordParams error:&sessionError];
    
    if (sessionError) {
        [delegate recordFail:sessionError.localizedDescription];
        return;
    }
    
    coder.recorder.delegate = coder;
    if ([coder.recorder prepareToRecord]) {
        [coder.recorder record];
        [delegate recordStart];
    }
}

+ (void)pause {
    BQRecorder * coder = [BQRecorder coder];
    if (coder.recorder && [coder.recorder isRecording]) {
        [coder.recorder pause];
    }
}

+ (void)resume {
    BQRecorder * coder = [BQRecorder coder];
    if (coder.recorder && ![coder.recorder isRecording]) {
        [coder.recorder record];
    }
}

+ (void)stop {
    BQRecorder * coder = [BQRecorder coder];
    if (coder.recorder && [coder.recorder isRecording]) {
        [coder.recorder stop];
    }
}

+ (instancetype)coder {
    static BQRecorder * objc;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc = [[self alloc] init];
    });
    return objc;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        [self pcmToMp3];
    }
    self.recorder = nil;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    [self.delegate recordFail:[error localizedDescription]];
    [recorder stop];
    
    self.recorder = nil;
}

#pragma mark - instance Method

- (void)pcmToMp3 {
    
    NSString * cafFilePath = [self recordPath];
    NSString * mp3FilePath = [self mp3Path];
    
    NSFileManager * fileM = [NSFileManager defaultManager];
    
    if ([fileM fileExistsAtPath:mp3FilePath]) {
        [fileM removeItemAtURL:[NSURL fileURLWithPath:mp3FilePath] error:nil];
    }
    
    NSString * msg = @"";
    
    @try {
        int read, write;
        
        FILE * pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE * mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
        msg = [exception description];
    }
    @finally {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
        if (msg.length > 0) {
            [self.delegate recordFail:msg];
        } else {
            [self.delegate recordSuccess:mp3FilePath];
        }
    }
}

- (void)appResignActive {
    [BQRecorder stop];
}

- (NSString *)recordPath {
    NSString * doucoment = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [doucoment stringByAppendingPathComponent:@"bq_record_info.caf"];
}

- (NSString *)mp3Path {
    NSString * doucoment = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [doucoment stringByAppendingPathComponent:@"bq_record_info.mp3"];
}

- (NSDictionary *)recordParams {
    NSMutableDictionary * audioSetting = [NSMutableDictionary dictionary];
    
    [audioSetting setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    
    // 设置录音采样率，8000 44100 96000
    [audioSetting setObject:@(11025.0) forKey:AVSampleRateKey];
    
    // 设置通道 1 2
    [audioSetting setObject:@(2) forKey:AVNumberOfChannelsKey];
    
    // 每个采样点位数,分为8、16、24、32
    [audioSetting setObject:@(16) forKey:AVLinearPCMBitDepthKey];
    
    // 是否使用浮点数采样 如果不是MP3需要用Lame转码为mp3的一定记得设置NO！(不然转码之后的声音一直都是杂音)
//    [audioSetting setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    
    // 录音质量
    [audioSetting setObject:@(AVAudioQualityMin) forKey:AVEncoderAudioQualityKey];
    
    return [audioSetting copy];
}

@end
