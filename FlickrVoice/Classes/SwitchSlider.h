//
//  SwitchSlider.h
//
//

#import <UIKit/UIKit.h>


@interface SwitchSlider : UIView {
	UIColor *color;
}

@property (nonatomic,retain) UIColor * color;

- (id)initWithFrame:(CGRect)frame color:(UIColor*)color;
@end
