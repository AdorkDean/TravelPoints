//
//  QDSegmentControl.m
//  QDINFI
//
//  Created by ZengTark on 2017/12/15.
//  Copyright © 2017年 quantdo. All rights reserved.
//

#import "QDSegmentControl.h"

@implementation QDSegmentControl

- (instancetype)init
{
    if (self = [super init]) {
        [self setupSegmentControl];
    }
    return self;
}

- (id)initWithSectionTitles:(NSArray<NSString *> *)sectiontitles
{
    if (self = [super initWithSectionTitles:sectiontitles]) {
        [self setupSegmentControl];
    }
    return self;
}

- (void)setupSegmentControl
{
    self.selectionIndicatorHeight = 3.0f;
    self.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#9B9B9B"], NSFontAttributeName: QDFont(15)};
    self.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    QDWeakSelf(self);
    [self setThemeChangeBlock:^{
        weakself.backgroundColor = [UIColor colorWithHexString:[QDColorTheme shareColorTheme].hover_background];
        weakself.selectedTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:[QDColorTheme shareColorTheme].active_text], NSFontAttributeName: QDFont(15)};
        weakself.selectionIndicatorColor = [UIColor colorWithHexString:[QDColorTheme shareColorTheme].active_text];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
