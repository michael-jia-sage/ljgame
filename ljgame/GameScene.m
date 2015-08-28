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

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor whiteColor];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    [self resetView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if (gameStatus == 0) {
        gameStatus = 1;
        // remove label
        [[self childNodeWithName: @"myLabel"] removeFromParent];
        //game start
        
        //add player
        SKSpriteNode *player = [SKSpriteNode spriteNodeWithImageNamed:@"Brick"];
        player.position = CGPointMake(50.0f, 50.0f);
        [self addChild:player];
        
        //add enemies
        SKSpriteNode *enemy1 = [SKSpriteNode spriteNodeWithImageNamed:@"Brick"];
        enemy1.position = CGPointMake(350.0f, 50.0f);
        [self addChild:enemy1];
        
        //add ball
        SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"Ball"];
        ball.position = CGPointMake(200.0f, 380.0f);
        
        // Add a VOLUME based physics body to the ball
        ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
        // make it more bouncy than normal
        ball.physicsBody.restitution = 0.5f;
        
        [self addChild:ball];
        
        // now give it a push
        [ball.physicsBody applyImpulse:CGVectorMake(25,0)];
    } else {
        gameStatus = 0;
        // add label
        [self resetView];
    }
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)resetView {
    [self removeAllChildren];
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Tap to begin ...";
    myLabel.fontColor = [SKColor grayColor];
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
