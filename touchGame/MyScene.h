//
//  MyScene.h
//  touchGame
//

//  Copyright (c) 2014 Luke Sadler. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class MyScene;
@interface MyScene : SKScene{

    UIView *startView;
    SKEmitterNode *sparks;
    UIScrollView *menu;
    BOOL menuOpen;
    int introHeight;
    CGFloat menuHeight;
    BOOL createMenu;
    UILabel *birthLabel;
    UILabel *pRLabel;
    UILabel *pRlabelHeight;
    UILabel *fallX;
    UILabel *fallY;
    UISlider *fallXSlider;
    UISlider *fallYSlider;
    UISlider *birthRate;
    UISlider *pRSlider;
    UISlider *prSliderHeight;
    CGPoint sOrigin;
    UISlider *lifeSpan;
    UILabel *lifeSpanL;
    NSString *device;
    
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    UISlider *red;
    UISlider *green;
    UISlider *blue;
    UISlider *speedSlider;
    
    UISegmentedControl *seg;
    UISegmentedControl *seg1;
    UISegmentedControl *seg2;
    
    UILabel *speedLabel;
    UILabel *colour;
    UILabel *redLabel;
    UILabel *greenLabel;
    UILabel *blueLabel;
    UILabel *backgroundColourLabel;
}

-(void)starterView;

@end
