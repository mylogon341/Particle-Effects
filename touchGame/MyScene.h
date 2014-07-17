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
    UIView *menu;
    BOOL menuOpen;
    int introHeight;
    int menuHeight;
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
    
    UISlider *red;
    UISlider *green;
    UISlider *blue;
    UISlider *speedSlider;
    
    UISegmentedControl *seg;
    UILabel *speedLabel;
    UILabel *colour;
    UILabel *redLabel;
    UILabel *greenLabel;
    UILabel *blueLabel;
    UILabel *backgroundColourLabel;
}

-(void)starterView;

@end
