//
//  CustomSwitch.m
//
//

#import "CustomSwitch.h"

static int margin = -4;

@implementation CustomSwitch

@synthesize delegate, on;

+ (int)margin {
	return margin;
}

- (void)setOn:(BOOL)switchValue {
	if (on != switchValue) {
		on = switchValue;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];
		if (on) {
			CGRect tmpFrame;
			tmpFrame = onLabel.frame;
			tmpFrame.origin.x = 0+5;
			onLabel.frame = tmpFrame;
		
			tmpFrame = slider.frame;
			tmpFrame.origin.x = onLabel.frame.size.width - margin+21;
			slider.frame = tmpFrame;
		
			tmpFrame = offLabel.frame;
			tmpFrame.origin.x = slider.frame.origin.x + slider.frame.size.width - margin;
			offLabel.frame = tmpFrame;
		
		} else {
			CGRect tmpFrame = onLabel.frame;
			tmpFrame.origin.x = -tmpFrame.size.width + margin+5;
			onLabel.frame = tmpFrame;
		
			tmpFrame = slider.frame;
			tmpFrame.origin.x = 0;
			slider.frame = tmpFrame;
		
			tmpFrame = offLabel.frame;
			tmpFrame.origin.x = slider.frame.origin.x + slider.frame.size.width - margin+14;
			offLabel.frame = tmpFrame;
		
		}
        [delegate valueChanged:self :on];

		[UIView commitAnimations];
	}
}

- (id)initWithFrame:(CGRect)frame {
	return [self initWithFrame:frame onLabelText:@"ON" offLabelText:@"OFF"];
}
//R: 255 G:174  B: 0 color for ON
- (id)initWithFrame:(CGRect)frame
		onLabelText:(NSString *)onLabelText
	   offLabelText:(NSString *) offLabelText {
    float colorCode = 185/255.0;
    
	return [self initWithFrame:frame
				   onLabelText:onLabelText
				  offLabelText:offLabelText
		onLabelBackgroundColor:[UIColor clearColor]
	   offLabelBackgroundColor:[UIColor clearColor]
			  onLabelTextColor:[UIColor colorWithRed:1.0 green:174/255.0 blue:0 alpha:1.0]
			 offLabelTextColor:[UIColor colorWithRed:colorCode green:colorCode blue:colorCode alpha:1.0]
				   sliderColor:[UIColor clearColor]];
}

- (id)initWithFrame:(CGRect)frame
		onLabelText:(NSString *)onLabelText
	   offLabelText:(NSString *) offLabelText
onLabelBackgroundColor:(UIColor *)onLabelBackgroundColor
offLabelBackgroundColor:(UIColor *)offLabelBackgroundColor
   onLabelTextColor:(UIColor *)onLabelTextColor
  offLabelTextColor:(UIColor *)offLabelTextColor
		sliderColor:(UIColor *)sliderColor {
    
	//onLabelBackgroundColor = [UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1.0];
    //offLabelBackgroundColor = [UIColor clearColor];
    
	if (self = [super initWithFrame:frame]) {
        
		//NSLog(@"self frame %f,%f,%f,%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
        
        UIImageView *bgimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        bgimgView.image = [UIImage imageNamed:@"bg_visibilty_on_off.png"];
        [self addSubview:bgimgView];
		// Initialization code
		UIFont *font = [UIFont fontWithName:@"Gotham-Medium" size:14];//[UIFont boldSystemFontOfSize:16];
		int labelWidth = 10 + MAX([onLabelText sizeWithFont:font].width, [offLabelText sizeWithFont:font].width);
		int height  = 27;
		
		slider = [[SwitchSlider alloc] initWithFrame:CGRectMake(0, -1, 36, 35)];
		slider.color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"visibilty_knob.png"]];//sliderColor;
        slider.backgroundColor = [UIColor clearColor];
        
        // slider.clipsToBounds = NO;
        [self addSubview:slider];
        self.backgroundColor = [UIColor clearColor];
    
		int yCord = 3;
		onLabel = [[UILabel alloc]
				   initWithFrame:CGRectMake(-labelWidth + margin, yCord, labelWidth, height)];
		onLabel.backgroundColor = onLabelBackgroundColor;
		onLabel.textColor = onLabelTextColor;
		onLabel.font = font;
		onLabel.textAlignment = UITextAlignmentCenter;
		onLabel.text = onLabelText;
		[self addSubview:onLabel];
		
		offLabel = [[UILabel alloc]
					initWithFrame:CGRectMake(slider.frame.size.width+14 - margin, yCord,
											 labelWidth, height)]; 
		offLabel.backgroundColor = offLabelBackgroundColor;
		offLabel.textColor = offLabelTextColor;
		offLabel.text = offLabelText;
		offLabel.textAlignment = UITextAlignmentCenter;
		offLabel.font = font;
		[self addSubview:offLabel];
		
         //[self addSubview:slider];
		
		// Setup the view frame and attributes
		CGRect tmpFrame = self.frame;
		tmpFrame.size.width = labelWidth + slider.frame.size.width - margin+20;
		tmpFrame.size.height = height+5;
		self.frame = tmpFrame;
		//self.clipsToBounds = YES;
		//self.layer.cornerRadius = 2 * margin;
        self.backgroundColor = [UIColor clearColor];
		
		tmpFrame.origin.x = 0;
		tmpFrame.origin.y = 0;
		//self.backgroundColor = [UIColor grayColor];
		[self setClipsToBounds:YES];
		
    }
    return self;
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	// Does nothing, just to consume the event.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	self.on = !self.on;
}


- (void)setOnBackgroundColor:(UIColor *)color {
	onLabel.backgroundColor = color;
	[onLabel setNeedsDisplay];
}

- (void)setOffBackgroundColor:(UIColor *)color {
	offLabel.backgroundColor = color;
	[offLabel setNeedsDisplay];
}

- (void)setOnTextColor:(UIColor *)color {
	onLabel.textColor = color;
	[onLabel setNeedsDisplay];
}

- (void)setOffTextColor:(UIColor *)color {
	offLabel.textColor = color;
	[offLabel setNeedsDisplay];
}

- (void)setSliderColor:(UIColor *)color {
	slider.color = color;
	[slider setNeedsDisplay];
}



@end
