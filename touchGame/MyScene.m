//
//  MyScene.m
//  touchGame
//
//  Created by Luke Sadler on 21/03/2014.
//  Copyright (c) 2014 Luke Sadler. All rights reserved.
//

#import "MyScene.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

@implementation MyScene
{
    SKNode *_player;
}
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        menuOpen = FALSE;
        
        self.backgroundColor = [SKColor blackColor];
        
        NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"sparks" ofType:@"sks"];
        sparks = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
        [self.scene addChild:sparks];
        sOrigin.x = (self.scene.frame.size.width)/2;
        sOrigin.y = (self.scene.frame.size.height)/2;
        sparks.position = sOrigin;
        createMenu = YES;
        device = [UIDevice currentDevice].model;
        
        screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        
        
        [self performSelector:@selector(starterView) withObject:nil afterDelay:0.5];
    }
    introHeight = 200;
    return self;
}

-(void)starterView{
    
    UIAlertView *startAlert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:@"Use this app for creating lovely particle effects. Control all variables through the menu, which can be accessed by tapping two fingers anywhere on this screen. Tap with two fingers again to remove the menu. Have fun" delegate:self cancelButtonTitle:@"Thanks!" otherButtonTitles:nil];
    [startAlert show];
    
}

-(void)remove{
    
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    startView.frame = CGRectMake(1500, (self.view.frame.size.height)/2 +50 ,300,introHeight);
    [UIView commitAnimations];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (createMenu == YES) {
        [self makeMenu];
        createMenu = NO;
        [self performSelector:@selector(remove) withObject:nil afterDelay:0.5];
        
    }
    
    
    sparks.targetNode = self.scene;
    
    
    if ([[event touchesForView:self.view] count] > 1) {
        
        if (!menuOpen) {
            
            [self performSelector:@selector(openMenu) withObject:nil afterDelay:0.1];
        }
        
        if (menuOpen) {
            
            [self performSelector:@selector(closeMenu) withObject:nil afterDelay:0.1];
        }
        
    }
}

-(void)openMenu{
    
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    menu.frame = CGRectMake(20, 20, (self.scene.frame.size.width)-40, menuHeight);
    [UIView commitAnimations];
    
    [self performSelector:@selector(sparksToOrigin) withObject:nil afterDelay:0.75];
    NSLog(@"menu open");
    menuOpen = TRUE;
}

-(void)closeMenu{
    
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    menu.frame = CGRectMake((self.scene.frame.size.width)*-1, 20, (self.scene.frame.size.width)-40, menuHeight);
    [UIView commitAnimations];
    [self sparksToRealOrigin];
    
    NSLog(@"close menu");
    menuOpen = FALSE;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [sparks runAction:[SKAction moveTo:[[touches anyObject] locationInNode:self] duration:0.1]];
}

-(void)sparksToOrigin{
    if ([device hasPrefix:@"iPad"]) {
        CGPoint goTo = CGPointMake(sOrigin.x,130);
        SKAction *originMove = [SKAction moveTo:goTo duration:0.3];
        [sparks runAction:originMove];
    }else{
        
        CGPoint goTo = CGPointMake(sOrigin.x, 50);
        SKAction *originMove = [SKAction moveTo:goTo duration:0.3];
        [sparks runAction:originMove];
    }
    
}

-(void)sparksToRealOrigin{
    SKAction *origin = [SKAction moveTo:sOrigin duration:0.3];
    [sparks runAction:origin];
}

-(void)makeMenu{
    
    //    Menu Window
    
    if ([device hasPrefix:@"iPad"]) {
        menuHeight = 800;
    }else{
        menuHeight = screenHeight - 120;
    }
    
    menu = [[UIScrollView alloc] initWithFrame:CGRectMake((self.scene.frame.size.width)*-1, 20, (self.scene.frame.size.width)-40, menuHeight)];
    menu.backgroundColor = [UIColor whiteColor];
    menu.alpha = 0.9;
    [self.view addSubview:menu];
    
    menu.layer.cornerRadius = 6;
    
    if ([device hasPrefix:@"iPad"]) {
    }
    else
    {
        menu.contentSize = CGSizeMake(screenWidth - 40, 830);
    }
    
    //    Birth Rate
    
    CGRect birthLFrame = CGRectMake(40, 20, 100, 20);
    birthLabel = [[UILabel alloc] initWithFrame:birthLFrame];
    birthLabel.text = @"Birth rate";
    [menu addSubview:birthLabel];
    
    CGRect birthFrame = CGRectMake(20, 40, (menu.frame.size.width)-50, 30.0);
    birthRate = [[UISlider alloc] initWithFrame:birthFrame];
    [birthRate addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [birthRate setBackgroundColor:[UIColor clearColor]];
    birthRate.minimumValue = 5;
    birthRate.maximumValue = 3000.0;
    birthRate.continuous = YES;
    birthRate.value = 700.0;
    [menu addSubview:birthRate];
    
    //    Width
    
    CGRect posRLabel = CGRectMake(40, 80, 100, 20);
    pRLabel = [[UILabel alloc] initWithFrame:posRLabel];
    pRLabel.text = @"Width";
    [menu addSubview:pRLabel];
    
    CGRect posRSlider = CGRectMake(20, 100, (menu.frame.size.width)-50, 30.0);
    pRSlider = [[UISlider alloc] initWithFrame:posRSlider];
    [pRSlider addTarget:self action:@selector(pRSlider:) forControlEvents:UIControlEventValueChanged];
    [pRSlider setBackgroundColor:[UIColor clearColor]];
    pRSlider.minimumValue = 0.0;
    pRSlider.maximumValue = screenWidth;
    pRSlider.continuous = YES;
    pRSlider.value = 0.0;
    [menu addSubview:pRSlider];
    
    //    Height
    
    CGRect posRLabelHighL = CGRectMake(40, 140, 100, 20);
    pRlabelHeight = [[UILabel alloc] initWithFrame:posRLabelHighL];
    pRlabelHeight.text = @"Height";
    [menu addSubview:pRlabelHeight];
    
    CGRect posRSliderHigh = CGRectMake(20, 160, (menu.frame.size.width)-50, 30.0);
    prSliderHeight = [[UISlider alloc] initWithFrame:posRSliderHigh];
    [prSliderHeight addTarget:self action:@selector(pRSlider:) forControlEvents:UIControlEventValueChanged];
    [prSliderHeight setBackgroundColor:[UIColor clearColor]];
    prSliderHeight.minimumValue = 0.0;
    prSliderHeight.maximumValue = screenHeight+100;
    prSliderHeight.continuous = YES;
    prSliderHeight.value = 0.0;
    [menu addSubview:prSliderHeight];
    
    //    Fall X
    
    CGRect fallXRect = CGRectMake(40, 200, 100, 20);
    fallX = [[UILabel alloc] initWithFrame:fallXRect];
    fallX.text = @"X Direction";
    [menu addSubview:fallX];
    
    CGRect fallXRectS = CGRectMake(20, 220, (menu.frame.size.width)-50, 30.0);
    fallXSlider = [[UISlider alloc] initWithFrame:fallXRectS];
    [fallXSlider addTarget:self action:@selector(fall:) forControlEvents:UIControlEventValueChanged];
    [fallXSlider setBackgroundColor:[UIColor clearColor]];
    fallXSlider.minimumValue = -700;
    fallXSlider.maximumValue = 700;
    fallXSlider.continuous = YES;
    fallXSlider.value = 0.0;
    [menu addSubview:fallXSlider];
    
    //    Fall Y
    
    CGRect fallYRect = CGRectMake(40, 260, 100, 20);
    fallY = [[UILabel alloc] initWithFrame:fallYRect];
    fallY.text = @"Y Direction";
    [menu addSubview:fallY];
    
    CGRect fallYRectS = CGRectMake(20, 280, (menu.frame.size.width)-50, 30.0);
    fallYSlider = [[UISlider alloc] initWithFrame:fallYRectS];
    [fallYSlider addTarget:self action:@selector(fall:) forControlEvents:UIControlEventValueChanged];
    [fallYSlider setBackgroundColor:[UIColor clearColor]];
    fallYSlider.minimumValue = -700;
    fallYSlider.maximumValue = 700;
    fallYSlider.continuous = YES;
    fallYSlider.value = 0.0;
    [menu addSubview:fallYSlider];
    
    //    Life Span
    
    CGRect lifeRect = CGRectMake(40, 320, 100, 20);
    lifeSpanL = [[UILabel alloc] initWithFrame:lifeRect];
    lifeSpanL.text = @"Life Span";
    [menu addSubview:lifeSpanL];
    
    CGRect lifeRectS = CGRectMake(20, 340, (menu.frame.size.width)-50, 30.0);
    lifeSpan = [[UISlider alloc] initWithFrame:lifeRectS];
    [lifeSpan addTarget:self action:@selector(lifeSpanner:) forControlEvents:UIControlEventValueChanged];
    [lifeSpan setBackgroundColor:[UIColor clearColor]];
    lifeSpan.minimumValue = 0.1;
    lifeSpan.maximumValue = 1;
    lifeSpan.continuous = YES;
    lifeSpan.value = 0.55;
    [menu addSubview:lifeSpan];
    
    
    
    //        Speed
    CGRect speedRect = CGRectMake(40, 380, 100, 20);
    speedLabel = [[UILabel alloc] initWithFrame:speedRect];
    speedLabel.text = @"Speed";
    [menu addSubview:speedLabel];
    
    CGRect speedSliderRect = CGRectMake(20, 400, (menu.frame.size.width)-50, 30.0);
    speedSlider = [[UISlider alloc] initWithFrame:speedSliderRect];
    [speedSlider addTarget:self action:@selector(speed:) forControlEvents:UIControlEventValueChanged];
    [speedSlider setBackgroundColor:[UIColor clearColor]];
    speedSlider.minimumValue = 10;
    speedSlider.maximumValue = 1000;
    speedSlider.continuous = YES;
    speedSlider.value = 90;
    [menu addSubview:speedSlider];
    
    //        Red
    
    CGRect colourRect = CGRectMake(40, 440, 300, 20);
    colour = [[UILabel alloc] initWithFrame:colourRect];
    colour.text = @"Particle's Colour Mixer";
    [menu addSubview:colour];
    
    CGRect redRect = CGRectMake(40, 480, 100, 20);
    redLabel = [[UILabel alloc] initWithFrame:redRect];
    redLabel.text = @"Red";
    [menu addSubview:redLabel];
    
    CGRect redSliderRect = CGRectMake(20, 500, (menu.frame.size.width)-50, 30.0);
    red = [[UISlider alloc] initWithFrame:redSliderRect];
    [red addTarget:self action:@selector(colour:) forControlEvents:UIControlEventValueChanged];
    [red setBackgroundColor:[UIColor clearColor]];
    red.minimumValue = 0;
    red.maximumValue = 1;
    red.continuous = YES;
    red.value = 0;
    [menu addSubview:red];
    
    //        Green
    
    CGRect greenRect = CGRectMake(40, 540, 100, 20);
    greenLabel = [[UILabel alloc] initWithFrame:greenRect];
    greenLabel.text = @"Green";
    [menu addSubview:greenLabel];
    
    CGRect greenSliderRect = CGRectMake(20, 560, (menu.frame.size.width)-50, 30.0);
    green = [[UISlider alloc] initWithFrame:greenSliderRect];
    [green addTarget:self action:@selector(colour:) forControlEvents:UIControlEventValueChanged];
    [green setBackgroundColor:[UIColor clearColor]];
    green.minimumValue = 0;
    green.maximumValue = 1;
    green.continuous = YES;
    green.value = 0;
    [menu addSubview:green];
    
    //        Blue
    
    CGRect blueRect = CGRectMake(40, 600, 100, 20);
    blueLabel = [[UILabel alloc] initWithFrame:blueRect];
    blueLabel.text = @"Blue";
    [menu addSubview:blueLabel];
    
    CGRect blueSliderRect = CGRectMake(20, 620, (menu.frame.size.width)-50, 30.0);
    blue = [[UISlider alloc] initWithFrame:blueSliderRect];
    [blue addTarget:self action:@selector(colour:) forControlEvents:UIControlEventValueChanged];
    [blue setBackgroundColor:[UIColor clearColor]];
    blue.minimumValue = 0;
    blue.maximumValue = 1;
    blue.continuous = YES;
    blue.value = 0;
    [menu addSubview:blue];
    
    //        Segmented View
    
    CGRect backgroundColourRect = CGRectMake(40, 660, 250, 20);
    backgroundColourLabel = [[UILabel alloc] initWithFrame:backgroundColourRect];
    backgroundColourLabel.text = @"Background Colour";
    [menu addSubview:backgroundColourLabel];
    
    if ([device hasPrefix:@"iPad"]) {
        
        NSArray *itemArray = [NSArray arrayWithObjects: @"Red", @"Orange", @"Black", @"Green", @"Blue", @"Indigo", @"Violet", nil];
        seg = [[UISegmentedControl alloc] initWithItems:itemArray];
        seg.frame = CGRectMake(20, 700, (menu.frame.size.width)-50, 50);
        [seg addTarget:self action:@selector(segControl:) forControlEvents:UIControlEventValueChanged];
        seg.selectedSegmentIndex = 2;
        [menu addSubview:seg];
    }else{
        
        NSArray *itemArray1 = [NSArray arrayWithObjects: @"Red", @"Orange", @"Black", @"Green", nil];
        NSArray *itemArray2 = [NSArray arrayWithObjects: @"Blue", @"Indego", @"Violet", nil];
        
        seg1 = [[UISegmentedControl alloc] initWithItems:itemArray1];
        seg2 = [[UISegmentedControl alloc] initWithItems:itemArray2];
        
        seg1.frame = CGRectMake(20, 700, (menu.frame.size.width)-50, 50);
        seg2.frame = CGRectMake(20, seg1.center.y + 30, (menu.frame.size.width)-50, 50);
        
        [seg1 addTarget:self action:@selector(seg1Control:) forControlEvents:UIControlEventValueChanged];
        [seg2 addTarget:self action:@selector(seg2Control:) forControlEvents:UIControlEventValueChanged];

        seg1.selectedSegmentIndex = 2;

        
        [menu addSubview:seg1];
        [menu addSubview:seg2];
        
    }
}

-(IBAction)seg1Control:(UISegmentedControl *)segment{
    
    seg2.selectedSegmentIndex = -1;

    switch (segment.selectedSegmentIndex) {
        case 0:{
            self.scene.backgroundColor = [UIColor redColor];
            break;}
            
        case 1:{
            self.scene.backgroundColor = [UIColor orangeColor];
            break;}
            
        case 2:{
            self.scene.backgroundColor = [UIColor blackColor];
            break;}
            
        case 3:{
            self.scene.backgroundColor = [UIColor greenColor];
            break;}
            
    }
    
    
}

-(IBAction)seg2Control:(UISegmentedControl *)segment{
    
    seg1.selectedSegmentIndex = -1;
    
    switch (segment.selectedSegmentIndex) {
        case 0:{
            self.scene.backgroundColor = [SKColor colorWithRed:0.25 green:0.41 blue:1 alpha:1];
            break;}
            
        case 1:{
            self.scene.backgroundColor = [SKColor colorWithRed:0.29 green:0 blue:0.51 alpha:1];
            break;}
            
        case 2:{
            self.scene.backgroundColor = [SKColor colorWithRed:0.56 green:0 blue:1 alpha:1];
            break;}
        
    }
}

    
    -(IBAction)speed:(id)sender{
        sparks.particleSpeed = speedSlider.value;
    }
    
    -(IBAction)segControl:(UISegmentedControl *)segment
    {
        switch (segment.selectedSegmentIndex) {
            case 0:{
                self.scene.backgroundColor = [UIColor redColor];
                break;}
                
            case 1:{
                self.scene.backgroundColor = [UIColor orangeColor];
                break;}
                
            case 2:{
                self.scene.backgroundColor = [UIColor blackColor];
                break;}
                
            case 3:{
                self.scene.backgroundColor = [UIColor greenColor];
                break;}
                
            case 4:{
                self.scene.backgroundColor = [SKColor colorWithRed:0.25 green:0.41 blue:1 alpha:1];
                break;}
                
            case 5:{
                self.scene.backgroundColor = [SKColor colorWithRed:0.29 green:0 blue:0.51 alpha:1];
                break;}
                
            case 6:{
                self.scene.backgroundColor = [SKColor colorWithRed:0.56 green:0 blue:1 alpha:1];
                break;}
        }
        
    }
    
    
    -(IBAction)colour:(id)sender{
        
        sparks.particleColorSequence = nil;
        sparks.particleColorBlendFactor = 1.0;
        
        sparks.particleColor = [SKColor colorWithRed:red.value green:green.value blue:blue.value alpha:1.0];
    }
    
    -(IBAction)lifeSpanner:(id)sender{
        sparks.particleLifetime = lifeSpan.value;
    }
    
    -(IBAction)pRSlider:(id)sender{
        sparks.particlePositionRange = CGVectorMake(pRSlider.value, prSliderHeight.value);
    }
    
    -(IBAction)fall:(id)sender{
        sparks.xAcceleration = fallXSlider.value;
        sparks.yAcceleration = fallYSlider.value;
    }
    
    -(IBAction)sliderAction:(id)sender{
        sparks.particleBirthRate = birthRate.value;
    }
    
    
    @end
