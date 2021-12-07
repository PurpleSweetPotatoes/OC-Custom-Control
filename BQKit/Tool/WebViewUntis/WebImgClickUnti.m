// *******************************************
//  File Name:      WebImgClickUnti.m       
//  Author:         MrBai
//  Created Date:   2021/12/7 10:28 AM
//    
//  Copyright © 2021 Rainy
//  All rights reserved
// *******************************************
    

#import "WebImgClickUnti.h"

#import "BQPhotoBrowserView.h"

@interface WebImgClickUnti ()
<
BQPhotoBrowserViewDelegate
>

@end

@implementation WebImgClickUnti

- (NSInteger)numberOfBrowser {
    return self.imgUrls.count;
}

- (void)browserConfigImgV:(BQPhotoView *)photoV index:(NSInteger)index {
#if __has_include("UIImageView+WebCache.h")
    [photoV.imgV sd_setImageWithURL:[NSURL URLWithString:self.imgUrls[index]]];
#endif
}

- (void)imgClickEvent {
    NSLog(@"点击图片:%@",self.msg.body);
    BQPhotoBrowserView * browserV = [BQPhotoBrowserView showWithDelegate:self];
    [browserV scrollToIndex:[self.msg.body integerValue]];
}

- (NSDictionary *)jsHandleInfos {
    return @{@"webImgClick":@"imgClickEvent"};
}

@end
