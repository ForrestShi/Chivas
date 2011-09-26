#import "HUDLayer.h"
#import "GameLayerScene.h"
#import "ChivasAppDelegate.h"

@implementation HUDLayer
@synthesize game;
@synthesize score_label;

-(id) init
{
    if( (self=[super init] )) {
        isTouchEnabled = YES;
        CGSize window_size = [[CCDirector sharedDirector] winSize];
		
       // CCSprite *sprite = [CCSprite spriteWithFile:@"shuffle-cards.png"];
//        sprite.position = ccp(window_size.width /2, 60);
//        shuffle_rect = CGRectMake(sprite.position.x - (sprite.position.x /2), sprite.position.y - (sprite.position.y / 2), 200, 50);
//        //shuffle_rect = CGRectMake(0, 0, window_size.width, window_size.height);
//		[self addChild: sprite];
        
        //[self writeScore:@"Select A Card"];        
    }
    return self;
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch   = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
	CGPoint cLoc = [[CCDirector sharedDirector] convertToGL:location];
   // CGPoint cLoc     = [[CCDirector sharedDirector] convertCoordinate: location];

    if ([game inMatch]) 
    {
        //return kEventHandled;
		return;
    }
    
    //The HUD layer gets first crack at touches.
    //this simply checks if the Shuffle sprite was touched.
  //  if (CGRectContainsPoint(shuffle_rect, cLoc))
//    {
//        [game shuffleDeck];
//        [game dealDeck];
//        //return kEventHandled;
//		//send msg to quit 
//		// it works 
//		//ChivasAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
////		[appDelegate endMatchCardGame];
//
//		return;
//	} else {
//		//return kEventIgnored;
//		return;
//	}
}

- (void)setScore:(int)score
{
    [self writeScore:[NSString stringWithFormat:@"TURNS %i", score]];    
}

- (void)writeScore:(NSString *)scoreString
{
    [self removeChild:score_label cleanup:YES];
    score_label = [CCLabel labelWithString:scoreString fontName:@"Helvetica" fontSize:13]; //must check if Menlo is available on iPhone yet.
    CGSize size = [[CCDirector sharedDirector] winSize];    
    score_label.position =  ccp( size.width /2 , size.height - 20 );
    
    [self addChild: score_label];
}

@end
