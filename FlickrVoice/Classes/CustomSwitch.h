//
//  CustomSwitch.h
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAGradientLayer.h>
#import "SwitchSlider.h"


@protocol CustomSwitchDelegate

- (void)valueChanged:(id)switchSlider:(BOOL)switchValue;

@end

@interface CustomSwitch : UIView {
	UILabel *onLabel;
	UILabel *offLabel;
	BOOL on;
	SwitchSlider *slider;
	id<CustomSwitchDelegate> delegate;
}

@property (nonatomic, retain) id<CustomSwitchDelegate> delegate;
@property BOOL on;

+ (int)margin;

- (id)initWithFrame:(CGRect)frame
		onLabelText:(NSString *)onLabelText
	   offLabelText:(NSString *) offLabelText;

- (id)initWithFrame:(CGRect)frame
		onLabelText:(NSString *)onLabelText
	   offLabelText:(NSString *) offLabelText
onLabelBackgroundColor:(UIColor *)onLabelBackgroundColor
offLabelBackgroundColor:(UIColor *)offLabelBackgroundColor
onLabelTextColor:(UIColor *)onLabelTextColor
offLabelTextColor:(UIColor *)offLabelTextColor
		sliderColor:(UIColor *)sliderColor;

- (void)setOnBackgroundColor:(UIColor *)color;
- (void)setOffBackgroundColor:(UIColor *)color;
- (void)setOnTextColor:(UIColor *)color;
- (void)setOffTextColor:(UIColor *)color;
- (void)setSliderColor:(UIColor *)color;

@end
