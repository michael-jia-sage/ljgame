//
//  GameScene.m
//  ljgame
//
//  Created by Zonggao Jia on 2015-08-26.
//  Copyright (c) 2015 Zonggao Jia. All rights reserved.
//

#import "GameScene.h"

int gameStatus = 0;

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    [self resetView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if (gameStatus == 0) {
        gameStatus = 1;
        // remove label
        [[self childNodeWithName: @"myLabel"] removeFromParent];
    } else {
        gameStatus = 0;
        // add label
        [self resetView];
    }
    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.xScale = 0.5;
//        sprite.yScale = 0.5;
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
//    }
}

-(void)resetView {
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Tap to begin ...";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    [myLabel setName:@"myLabel"];
    [self addChild:myLabel];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
